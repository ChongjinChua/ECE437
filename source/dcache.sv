/*
  evillase@gmail.com

  this block holds the i and d cache
*/

`include "cpu_types_pkg.vh"
`include "datapath_cache_if.vh"
`include "caches_if.vh"

module dcache (
  input logic CLK, nRST,
  datapath_cache_if.dcache dcif,
  caches_if.dcache cif
);
   import cpu_types_pkg::*;

   logic [7:0] lru;
   logic       nextlru;

   dcache_t dc;
   dcachef_t dcache_addr;
   dcachef_t snoop_addr;
   
   logic [1:0] [31:0] dcache_data;
   logic 	hit0;
   logic 	hit1;
   logic 	snoopHit0;
   logic 	snoopHit1;
   logic 	hit;
   logic 	snoopHit;
   logic [4:0] 	count;		      
   logic [31:0] addr_sw,nextaddr_sw;
   logic [31:0] addr_hit;
   logic [31:0] addr_load;
   logic [31:0] addr_store;
   logic [31:0] addr_flush;
   logic [31:0] addr_snoop;   
   logic [DBLK_W-1:0] asmBlkoff;
   logic [31:0]       hitcount, next_hitcount, misscount, next_misscount;
   logic 	      nextdREN,nextdWEN;
   logic 	      _dhit;
   logic [31:0]       nextLinkReg, linkReg;
   logic 	      nextLinkValid, linkValid;

   typedef enum bit[3:0] {IDLE, SW1, SW2, LW1, LW2, INSP, FLSH1, FLSH2, HITC, HALT, SNOOPDOGG, WB1, WB2} state_t;
   state_t state, nextstate;

   // Address parse
   assign dcache_addr.tag = dcif.dmemaddr[31:31-DTAG_W+1];
   assign dcache_addr.idx = dcif.dmemaddr[31-DTAG_W:DBYT_W+DBLK_W];
   assign dcache_addr.blkoff = dcif.dmemaddr[DBYT_W+DBLK_W-1:DBYT_W];
   assign dcache_addr.bytoff = dcif.dmemaddr[DBYT_W-1:0];
   assign addr_load = {dcache_addr.tag,dcache_addr.idx,asmBlkoff,dcache_addr.bytoff};
   assign addr_hit = {dc.ds[hit1][dcache_addr.idx].tag,dcache_addr.idx,asmBlkoff,dcache_addr.bytoff};
   assign addr_store = {dc.ds[lru[dcache_addr.idx]][dcache_addr.idx].tag,dcache_addr.idx,asmBlkoff,dcache_addr.bytoff};

   assign snoop_addr.tag = cif.ccsnoopaddr[31:31-DTAG_W+1];
   assign snoop_addr.idx = cif.ccsnoopaddr[31-DTAG_W:DBYT_W+DBLK_W];
   assign snoop_addr.blkoff = cif.ccsnoopaddr[DBYT_W+DBLK_W-1:DBYT_W];
   assign snoop_addr.bytoff = cif.ccsnoopaddr[DBYT_W-1:0];
   assign addr_snoop = {snoop_addr.tag,snoop_addr.idx,asmBlkoff,snoop_addr.bytoff};   
      
   assign addr_flush = {dc.ds[count[3]][count[2:0]].tag,count[2:0],asmBlkoff,2'b0};

   assign dcif.dhit = _dhit & ~cif.ccwait;
   assign dcif.scValid = linkValid & (linkReg == dcif.dmemaddr);
   
   // Hit logic
   always_comb begin

      dcache_data[0] = 32'hBAD1BAD1;
      dcache_data[1] = 32'hBAD1BAD1;
   
      //if data valid and tags match
      hit0 = dc.ds[0][dcache_addr.idx].valid & (dc.ds[0][dcache_addr.idx].tag == dcache_addr.tag);
      hit1 = dc.ds[1][dcache_addr.idx].valid & (dc.ds[1][dcache_addr.idx].tag == dcache_addr.tag);
      hit = hit0 | hit1;

      snoopHit0 = dc.ds[0][snoop_addr.idx].valid & (dc.ds[0][snoop_addr.idx].tag == snoop_addr.tag);
      snoopHit1 = dc.ds[1][snoop_addr.idx].valid & (dc.ds[1][snoop_addr.idx].tag == snoop_addr.tag);
      snoopHit = snoopHit0 | snoopHit1;

      dcache_data = dc.ds[hit1][dcache_addr.idx].data;
      
   end

   /*
    dcif
    to caches(from dp)  halt, dmemREN, dmemWEN, dmemstore, dmemaddr
    to dp(from caches)  dhit, dmemload

    cif
    to caches(from mc)  dwait, dload
    to mc(from caches)  dREN, dWEN, daddr, dstore
    */
   
   always_ff @(posedge CLK, negedge nRST) begin

      if(~nRST) begin
	 lru <= '0;
	 dc <= '0;
	 count <= '0;
	 hitcount <= '0;
	 misscount <= '0;
	 cif.dWEN <= 0;
	 cif.dREN <= 0;
	 linkReg <= '0;
	 linkValid <= 0;
	 addr_sw <= '0;
      end else begin
	
	 lru[dcache_addr.idx] <= nextlru;
	 state <= nextstate;
	 cif.dWEN <= nextdWEN;
	 cif.dREN <= nextdREN;
	 hitcount <= next_hitcount;
	 misscount <= next_misscount;
	 linkReg <= nextLinkReg;
	 linkValid <= nextLinkValid;
	 addr_sw <= nextaddr_sw;
	 
	 case(state)
	   IDLE: begin
	      if(~dcif.dmemREN & dcif.dmemWEN & hit & ((dcif.datomic & dcif.scValid)| ~dcif.datomic)) begin //SW and hit
		 dc.ds[hit1][dcache_addr.idx].dirty <= 1;
		 dc.ds[hit1][dcache_addr.idx].data[dcache_addr.blkoff] <= dcif.dmemstore;
	      end
	   end
	   SW1: begin
	      
	   end
	   SW2: begin
	      if(~cif.dwait) begin
		 dc.ds[lru[dcache_addr.idx]][dcache_addr.idx].dirty <= 0;
	      end
	   end
	   LW1: begin
	      if(~cif.dwait) begin
		 dc.ds[lru[dcache_addr.idx]][dcache_addr.idx].data[0] <= cif.dload;
	      end
	   end
	   
	   LW2: begin
	      if(~cif.dwait) begin
		 dc.ds[lru[dcache_addr.idx]][dcache_addr.idx].data[1] <= cif.dload;
		 dc.ds[lru[dcache_addr.idx]][dcache_addr.idx].valid <= 1;
		 dc.ds[lru[dcache_addr.idx]][dcache_addr.idx].tag <= dcache_addr.tag;
	      end
	   end
	   
	   INSP: begin
	      //not valid or clean
	      if(~dc.ds[count[3]][count[2:0]].valid | ~dc.ds[count[3]][count[2:0]].dirty) begin
		 count <= count+1;
	      end
	      dc.ds[count[3]][count[2:0]].valid <= 0;
	      dc.ds[count[3]][count[2:0]].dirty <= 0;	      
	   end
	   FLSH1: begin
	      
	   end
	   FLSH2: begin
	      if(~cif.dwait) begin
		 count <= count + 1;
	      end
	   end
	   SNOOPDOGG: begin
	      if(cif.ccinv & snoopHit & ~dc.ds[snoopHit][snoop_addr.idx].dirty) begin //invalidate S
		 dc.ds[snoopHit1][snoop_addr.idx].valid <= 0;
		 dc.ds[snoopHit1][snoop_addr.idx].dirty <= 0;
	      end
	   end
	   WB1: begin

	   end
	   WB2: begin
	      if(~cif.dwait) begin //invalidate M
		 dc.ds[snoopHit1][snoop_addr.idx].valid <= 0;
		 dc.ds[snoopHit1][snoop_addr.idx].dirty <= 0;
	      end
	   end	   
	   HITC: begin
	      
	   end
	   HALT: begin

	   end
	   default: begin
	      
	   end
	 endcase // case (state)
      end
   end
   
  
   assign next_hitcount = (dcif.dhit && ~dcif.halt) ? hitcount+1 : hitcount;
   
   always_comb begin
      nextdREN = 0;
      nextdWEN = 0;
      cif.daddr = 32'hBAD1BAD1;
      cif.dstore = 32'hBAD1BAD1;
      cif.cctrans = 0;
      cif.ccwrite = dcif.dmemWEN;

      dcif.dmemload = 32'hBAD1BAD1;
      _dhit = 0;
      dcif.flushed = 0;

      nextlru = lru[dcache_addr.idx];
      asmBlkoff = 0;

      next_misscount = misscount;
      nextLinkReg = linkReg;
      nextLinkValid = linkValid;
      nextaddr_sw = addr_sw;

      case(state)
	IDLE: begin
	   nextstate = IDLE;

	   if(dcif.dmemWEN & ~dcif.scValid & dcif.datomic) begin
	      _dhit = 1;
	   end

	   //LL
	   if(dcif.dmemREN & dcif.datomic) begin
	      nextLinkReg = dcif.dmemaddr;
	      nextLinkValid = 1;
	   end

	   if(cif.ccwait) begin
	      nextstate = SNOOPDOGG;
	   end else if(dcif.dmemREN & hit) begin //LW and hit
	      _dhit = 1;
	      dcif.dmemload = dc.ds[hit1][dcache_addr.idx].data[dcache_addr.blkoff];

	      //update RI
	      nextlru = hit0; //inverse
	      
	   end else if(dcif.dmemWEN & hit & ((dcif.datomic & dcif.scValid)| ~dcif.datomic)) begin //SW and hit

	      if(dcif.scValid) begin
		 nextLinkValid = 0;
	      end

	      _dhit = 1;
	      
	      //update RI
	      nextlru = hit0; //inverse

	      if (~dc.ds[hit1][dcache_addr.idx].dirty) begin
		 cif.cctrans = 1;
		 nextaddr_sw = addr_hit;
		 cif.daddr = addr_hit;
	      end
	      
	   end

	   else if(dcif.dmemREN & ~hit) begin //LW and miss

	      if (~dc.ds[lru[dcache_addr.idx]][dcache_addr.idx].dirty) begin //LW & miss & ~dirty
		 nextstate = LW1;
		 nextdREN = 1;
		 //asmBlkoff = 0;
		 cif.daddr = addr_load;
	      end else begin // LW & miss & dirty
		 nextstate = SW1;
		 nextdWEN = 1;
		 //asmBlkoff = 0;
		 nextaddr_sw = addr_store;
		 cif.daddr = addr_store;
	      end
	      
	   end else if(dcif.dmemWEN & ~hit & ((dcif.datomic & dcif.scValid)| ~dcif.datomic)) begin //SW and miss

	      if (~dc.ds[lru[dcache_addr.idx]][dcache_addr.idx].dirty) begin //SW & miss & ~dirty
		 nextstate = LW1;
		 nextdREN = 1;
		 //asmBlkoff = 0;
		 cif.daddr = addr_load;
	      end else begin //SW & miss & dirty
		 nextstate = SW1;
		 nextdWEN = 1;
		 //asmBlkoff = 0;
		 nextaddr_sw = addr_store;
		 cif.daddr = addr_store;
	      end
	   end else if(dcif.halt) begin
	      nextstate = INSP;
	   end
	end // case: IDLE
	SW1: begin
	   nextdWEN = 1;
	   nextstate = SW1;
	   asmBlkoff = 0;
	   cif.daddr = {addr_sw[31:3],asmBlkoff,addr_sw[1:0]};
	   cif.cctrans = 1;
	   cif.dstore = dc.ds[lru[dcache_addr.idx]][dcache_addr.idx].data[0];
	   if(cif.ccwait) begin
	      nextstate = SNOOPDOGG;
	   end else if(~cif.dwait) begin
	      //asmBlkoff = 1;
	      nextstate = SW2;
	   end
	end
	SW2: begin
	   nextdWEN = 1;
	   nextstate = SW2;
	   asmBlkoff = 1;
	   cif.daddr = {addr_sw[31:3],asmBlkoff,addr_sw[1:0]};
	   cif.dstore = dc.ds[lru[dcache_addr.idx]][dcache_addr.idx].data[1];
	   if(~cif.dwait) begin
	      nextdWEN = 0;
	      nextstate = LW1;
	   end
	end
	LW1: begin
	   nextdREN = 1;
	   nextstate = LW1;
	   asmBlkoff = 0;
	   cif.daddr = addr_load;
	   cif.cctrans = 1;
	   if(cif.ccwait) begin
	      nextstate = SNOOPDOGG;
	   end else if(~cif.dwait) begin
//	      asmBlkoff = 1;
	      nextstate = LW2;
	   end
	end
	LW2: begin
	   nextdREN = 1;
	   nextstate = LW2;
	   asmBlkoff = 1;
	   cif.daddr = addr_load;
	   if(~cif.dwait) begin
	      nextdREN = 0;
	      nextstate = IDLE;
	      next_misscount = misscount+1;	      
	   end
	end
	
	INSP: begin
	   nextstate = INSP;
	   nextdWEN = 0;
	   if(dc.ds[count[3]][count[2:0]].valid && dc.ds[count[3]][count[2:0]].dirty) begin
	      cif.cctrans = 1;
	      nextstate = FLSH1;
	      nextdWEN = 1;
	      //asmBlkoff = 0;
	      cif.daddr = addr_flush;
	   end else if(count == 5'h10) begin
	      nextstate = HALT;
	      /*
	      nextdWEN = 1;
	      cif.daddr = 32'h3100;  
	      cif.dstore = hitcount-misscount;
	       */
	   end
	end
	FLSH1: begin
	   nextdWEN = 1;
	   nextstate = FLSH1;
	   asmBlkoff = 0;
	   cif.daddr = addr_flush;
	   cif.dstore = dc.ds[count[3]][count[2:0]].data[0];
	   cif.cctrans = 1;
	   if(~cif.dwait) begin
	      //asmBlkoff = 1;
	      nextstate = FLSH2;
	   end
	end
	FLSH2: begin
	   nextdWEN = 1;
	   nextstate = FLSH2;
	   asmBlkoff = 1;
	   cif.daddr = addr_flush;
	   cif.dstore = dc.ds[count[3]][count[2:0]].data[1];
	   //cif.cctrans = 1;
	   if(~cif.dwait) begin
	      nextdWEN = 0;
	      nextstate = INSP;
	   end
	end
	HITC: begin
	   nextdWEN = 1;
	   nextstate = HITC;
	   cif.daddr = 32'h3100;
	   cif.dstore = hitcount-misscount;
	   if(~cif.dwait) begin
	      nextdWEN = 0;
	      nextstate = HALT;
	   end	   
	end
	HALT: begin
	   dcif.flushed = 1;
	   nextstate = HALT;
	end
	SNOOPDOGG: begin
	   nextdWEN = 0;
	   nextstate = IDLE;
	   if(cif.ccinv & (linkReg == cif.ccsnoopaddr)) begin
	      nextLinkValid = 0;
	   end
	   if(cif.ccinv & snoopHit & ~dc.ds[snoopHit][snoop_addr.idx].dirty) begin //invalidate S
	      cif.cctrans = 1;
	   end
	   if(snoopHit & dc.ds[snoopHit1][snoop_addr.idx].dirty) begin
	      nextdWEN = 1;
	      nextstate = WB1;
	      cif.cctrans = 1;
	   end
	end
	WB1: begin
	   nextdWEN = 1;
	   nextstate = WB1;
	   asmBlkoff = 0;
	   cif.daddr = addr_snoop;
	   cif.dstore = dc.ds[snoopHit1][snoop_addr.idx].data[0];

	   if(~cif.dwait) begin
	      nextstate = WB2;
	   end
	end
	WB2: begin
	   nextdWEN = 1;
	   nextstate = WB2;
	   asmBlkoff = 1;
	   cif.daddr = addr_snoop;
	   cif.dstore = dc.ds[snoopHit1][snoop_addr.idx].data[1];

	   if(~cif.dwait) begin
	      nextdWEN = 0;
	      nextstate = IDLE;
	   end
	end
	default: begin
	   nextstate = IDLE;
	end

      endcase
   end

endmodule
