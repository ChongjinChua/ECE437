/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/

`include "cpu_types_pkg.vh"
`include "datapath_cache_if.vh"
`include "caches_if.vh"

module icache (
  input logic CLK, nRST,
  datapath_cache_if.icache dcif,
  caches_if.icache cif
);
   import cpu_types_pkg::*;

   icachefr_t icache_ds [16];
   icachef_t icache_addr;

   logic cacheHit;
   
   typedef enum bit {GIV,REQ} state_t;
   state_t state, nextstate;
   
/*
 //cif
 to_cache(from mem_control)   iwait, iload,
 to_mem_control  iREN, iaddr

 //dcif
 to_cache(from datapath)   imemREN, imemaddr,
 to_datapath  ihit, imemload

*/
   always_ff @(posedge CLK, negedge nRST) begin
      if(!nRST) begin
	 integer i;
	 for (i=0; i<16; i=i+1) begin
	    icache_ds[i].valid = 0;
	    icache_ds[i].tag = '0;
	    icache_ds[i].data = '0;
	 end
      end else begin
	 if (state == REQ & ~cif.iwait) begin
	    icache_ds[icache_addr.idx].valid <= 1;
	    icache_ds[icache_addr.idx].tag <= icache_addr.tag;
	    icache_ds[icache_addr.idx].data <= cif.iload;
	 end
      end
   end

   always_ff @(posedge CLK, negedge nRST) begin
      if(!nRST) begin
	 state <= GIV;
      end else begin
	 state <= nextstate;
      end
   end

   assign dcif.ihit = dcif.imemREN & (cacheHit | (state == REQ & ~cif.iwait));

   always_comb begin
      icache_addr.tag = dcif.imemaddr[31:31-ITAG_W+1];
      icache_addr.idx = dcif.imemaddr[31-ITAG_W:IBYT_W];
      icache_addr.bytoff = dcif.imemaddr[IBYT_W-1:0];      

      cif.iaddr = dcif.imemaddr;
      dcif.imemload = icache_ds[icache_addr.idx].data;

      cacheHit = (icache_ds[icache_addr.idx].valid) & (icache_ds[icache_addr.idx].tag == icache_addr.tag);
      cif.iREN = 0;
      
      case(state)
	GIV: begin
	   cif.iREN = 0;
	   nextstate = GIV;

	   if(dcif.imemREN & ~cacheHit) begin
	      nextstate = REQ;
	      cif.iREN = 1;
	   end
	end
	REQ: begin
	   cif.iREN = 1;
	   nextstate = REQ;

	   if(~cif.iwait) begin
	      nextstate = GIV;
	      //cif.iREN = 0;
	      dcif.imemload = cif.iload;
	   end
	end
	default: begin
	   nextstate = GIV;
	end
      endcase


   end


endmodule
