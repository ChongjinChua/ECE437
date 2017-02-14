/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control
  (
   input CLK, nRST,
   cache_control_if.cc ccif
   );
   // type import
   import cpu_types_pkg::*;

   // number of cpus for cc
   parameter CPUS = 2;

   typedef enum bit[2:0] {IDLE, SNOOP1, SNOOP2, DATA, INSTR} state_t;
   state_t state, nextstate;

   logic 	target,nexttarget;
   logic        itarget,nextitarget;
   logic 	ccwrite;
   logic [31:0] daddr;
      
   always_ff @(posedge CLK, negedge nRST) begin
      if(~nRST) begin
	 state <= IDLE;
	 target <= 0;
	 itarget <= 0;
	 ccwrite <= 0;
	 daddr <= '0;
      end else begin
	 state <= nextstate;
	 target <= nexttarget;
	 itarget <= nextitarget;
	 if(state == IDLE) begin
	    ccwrite <= ccif.ccwrite[nexttarget];
	    daddr <= ccif.daddr[nexttarget];
	 end
      end
   end


   always_comb begin
      nexttarget = target;
      nextstate = state;
      nextitarget = itarget;
      ccif.ccinv = 0;
      ccif.ccwait = 0;
      
      ccif.ramWEN = 0;
      ccif.ramREN = 0;
      ccif.ramaddr = 0;
      ccif.ramstore = 0;

      ccif.dload = 0;
      ccif.iload = 0;
      ccif.dwait = 2'b11;
      ccif.iwait = 2'b11;

      ccif.ccsnoopaddr[0] = ccif.daddr[1];
      ccif.ccsnoopaddr[1] = ccif.daddr[0];   

      case(nextstate)
	IDLE: begin

	   if(ccif.cctrans[0]) begin
	      nexttarget = 0;
	      nextstate = SNOOP1;
	   end else if(ccif.cctrans[1]) begin
	      nexttarget = 1;
	      nextstate = SNOOP1;
	   end else if(ccif.iREN[itarget]) begin
	      nextstate = INSTR;
	   end else if(ccif.iREN[~itarget]) begin
	      nextstate = INSTR;
	      nextitarget = ~itarget;
	   end

	   
	   
	end
	SNOOP1: begin
	   ccif.ccinv[~target] = ccwrite;
	   ccif.ccwait[~target] = 1;
	   ccif.ccsnoopaddr[~target] = daddr;
	   nextstate = SNOOP2;
	end
	SNOOP2: begin
	   ccif.ccinv[~target] = ccwrite;
	   ccif.ccwait[~target] = 1;
	   ccif.ccsnoopaddr[~target] = daddr;
	   nextstate = DATA;
	end
	DATA: begin
	   
	   if(ccif.dWEN[target]) begin //c->m write
	      ccif.ramstore = ccif.dstore[target];
	      ccif.ramWEN = ccif.dWEN[target];
	      ccif.dwait[target] = ccif.ramstate != ACCESS;
	      ccif.ramaddr = ccif.daddr[target];	      	      
	   end else begin
	      if(ccif.dREN[target] & ccif.dWEN[~target]) begin //c->c and c->m transfer
		 ccif.dload[target] = ccif.dstore[~target];
		 ccif.ramstore = ccif.dstore[~target];
		 ccif.ramWEN = ccif.dWEN[~target];
		 ccif.dwait[target] = ccif.ramstate != ACCESS;
		 ccif.dwait[~target] = ccif.ramstate != ACCESS;
		 ccif.ramaddr = ccif.daddr[~target];
	      end else if(ccif.dREN[target]) begin //m->c transfer
		 ccif.dload[target] = ccif.ramload;
		 ccif.ramREN = ccif.dREN[target];
		 ccif.dwait[target] = ccif.ramstate != ACCESS;
		 ccif.ramaddr = ccif.daddr[target];	      
	      end

	      if(~(ccif.dREN[target])) begin// | ccif.dWEN[target])) begin
		 nextstate = IDLE;
	      end
	   end
	end
	INSTR: begin
	   ccif.iload[itarget] = ccif.ramload;
	   ccif.ramREN = ccif.iREN[itarget];
	   ccif.iwait[itarget] = (ccif.ramstate != ACCESS);
	   ccif.ramaddr = ccif.iaddr[itarget];

	   if(~ccif.iwait[itarget]) begin
	      nextstate = IDLE;
	      nextitarget = ~itarget;
	   end

	end
      endcase
   end


/*
   if(ccif.dWEN) begin
      ccif.ramWEN = 1'd1;
      ccif.ramREN = 1'd0;
      ccif.ramaddr = ccif.daddr;
      ccif.ramstore = ccif.dstore;
   end else if (ccif.dREN) begin
      ccif.ramWEN = 1'd0;
      ccif.ramREN = 1'd1;	 
      ccif.ramaddr = ccif.daddr;
   end else if (ccif.iREN) begin
      ccif.ramWEN = 1'd0;
      ccif.ramREN = 1'd1;
      ccif.ramaddr = ccif.iaddr;
   end
*/

endmodule
