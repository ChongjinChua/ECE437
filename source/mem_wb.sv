
// data path interface
`include "mem_wb_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module mem_wb
  (
   input logic CLK, nRST,
   mem_wb_if.latch memwb
   );
   // import types
   import cpu_types_pkg::*;

   // Instr. Fetch
   always_ff @(posedge CLK, negedge nRST) begin
      if(!nRST) begin
	 memwb.regDst_out <= 0;
	 memwb.regWrite_out <= 0;
	 memwb.halt_out <= 0;
	 memwb.wbSel_out <= 0;

	 memwb.portOut_out <= 0;

	 memwb.PC4_out <= 0;
	 memwb.immExt_out <= 0;
	 memwb.rt_out <= 0;
	 memwb.rd_out <= 0;
	 memwb.dmemload_out <= 0;

	 memwb.opCode_out[OP_W-1:0] <= 0;
	 memwb.funct_out[FUNC_W-1:0] <= 0;
	 memwb.scStatus_out <= 0;

      end else if(memwb.flush) begin
	 memwb.regDst_out <= 0;
	 memwb.regWrite_out <= 0;
	 memwb.halt_out <= 0;
	 memwb.wbSel_out <= 0;

	 memwb.portOut_out <= 0;

	 memwb.PC4_out <= 0;
	 memwb.immExt_out <= 0;
	 memwb.rt_out <= 0;
	 memwb.rd_out <= 0;
	 memwb.dmemload_out <= 0;

	 memwb.opCode_out[OP_W-1:0] <= 0;
	 memwb.funct_out[FUNC_W-1:0] <= 0;
	 memwb.scStatus_out <= 0;
	 
	 end else if(memwb.EN) begin
	    memwb.regDst_out <= memwb.regDst_in;
	    memwb.regWrite_out <= memwb.regWrite_in;
	    memwb.halt_out <= memwb.halt_in;
	    memwb.wbSel_out <= memwb.wbSel_in;

	    memwb.portOut_out <= memwb.portOut_in;

	    memwb.PC4_out <= memwb.PC4_in;
	    memwb.immExt_out <= memwb.immExt_in;
	    memwb.rt_out <= memwb.rt_in;
	    memwb.rd_out <= memwb.rd_in;
	    memwb.dmemload_out <= memwb.dmemload_in;

	    memwb.opCode_out <= memwb.opCode_in;
	    memwb.funct_out <= memwb.funct_in;
	    memwb.scStatus_out <= memwb.scStatus_in;
	    
	 end else begin // if (memwb.EN)
	    memwb.regDst_out <= memwb.regDst_out;
	    memwb.regWrite_out <= memwb.regWrite_out;
	    memwb.halt_out <= memwb.halt_out;
	    memwb.wbSel_out <= memwb.wbSel_out;

	    memwb.portOut_out <= memwb.portOut_out;

	    memwb.PC4_out <= memwb.PC4_out;
	    memwb.immExt_out <= memwb.immExt_out;
	    memwb.rt_out <= memwb.rt_out;
	    memwb.rd_out <= memwb.rd_out;
	    memwb.dmemload_out <= memwb.dmemload_out;

	    memwb.opCode_out <= memwb.opCode_out;
	    memwb.funct_out <= memwb.funct_out;
	    memwb.scStatus_out <= memwb.scStatus_out;
	    
	 end
   end // always_ff @
   
endmodule
