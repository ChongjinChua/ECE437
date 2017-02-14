
// data path interface
`include "ex_mem_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module ex_mem
  (
   input logic CLK, nRST,
   ex_mem_if.latch exmem
   );
   // import types
   import cpu_types_pkg::*;

   // Instr. Fetch
   always_ff @(posedge CLK, negedge nRST) begin
      if(!nRST) begin
	 exmem.regDst_out <= 0;
	 exmem.regWrite_out <= 0;
	 exmem.halt_out <= 0;
	 exmem.wbSel_out <= 0;
	 exmem.beqFlag_out <= 0;
	 exmem.bneFlag_out <= 0;
	 exmem.jumpFlag_out <= 0;
	 exmem.dread_out <= 0;
	 exmem.dwrite_out <= 0;
	 exmem.zeroFlag_out <= 0;
	 exmem.portOut_out <= 0;
	 exmem.jumpAddr_out <= 0;
	 exmem.PC4_out <= 0;
	 exmem.immExt_out <= 0;
	 exmem.rt_out <= 0;
	 exmem.rd_out <= 0;
	 exmem.dmemstore_out <= 0;

	 exmem.opCode_out[OP_W-1:0] <= 0;
	 exmem.funct_out[FUNC_W-1:0] <= 0;
	 exmem.datomic_out <= 0;
      
      end else if(exmem.flush) begin
	 exmem.regDst_out <= 0;
	 exmem.regWrite_out <= 0;
	 exmem.halt_out <= 0;
	 exmem.wbSel_out <= 0;
	 exmem.beqFlag_out <= 0;
	 exmem.bneFlag_out <= 0;
	 exmem.jumpFlag_out <= 0;
	 exmem.dread_out <= 0;
	 exmem.dwrite_out <= 0;
	 exmem.zeroFlag_out <= 0;
	 exmem.portOut_out <= 0;
	 exmem.jumpAddr_out <= 0;
	 exmem.PC4_out <= 0;
	 exmem.immExt_out <= 0;
	 exmem.rt_out <= 0;
	 exmem.rd_out <= 0;
	 exmem.dmemstore_out <= 0;

	 exmem.opCode_out[OP_W-1:0] <= 0;
	 exmem.funct_out[FUNC_W-1:0] <= 0;
	 exmem.datomic_out <= 0;
	 
      end else if(exmem.EN) begin
	 exmem.regDst_out <= exmem.regDst_in;
	 exmem.regWrite_out <= exmem.regWrite_in;
	 exmem.halt_out <= exmem.halt_in;
	 exmem.wbSel_out <= exmem.wbSel_in;
	 exmem.beqFlag_out <= exmem.beqFlag_in;
	 exmem.bneFlag_out <= exmem.bneFlag_in;
	 exmem.jumpFlag_out <= exmem.jumpFlag_in;
	 exmem.dread_out <= exmem.dread_in;
	 exmem.dwrite_out <= exmem.dwrite_in;
	 exmem.zeroFlag_out <= exmem.zeroFlag_in;
	 exmem.portOut_out <= exmem.portOut_in;
	 exmem.jumpAddr_out <= exmem.jumpAddr_in;
	 exmem.PC4_out <= exmem.PC4_in;
	 exmem.immExt_out <= exmem.immExt_in;
	 exmem.rt_out <= exmem.rt_in;
	 exmem.rd_out <= exmem.rd_in;
	 exmem.dmemstore_out <= exmem.dmemstore_in;
	 
	 exmem.opCode_out <= exmem.opCode_in;
	 exmem.funct_out <= exmem.funct_in;
	 exmem.datomic_out <= exmem.datomic_in;
	    
      end else begin // if (exmem.EN)
	 exmem.regDst_out <= exmem.regDst_out;
	 exmem.regWrite_out <= exmem.regWrite_out;
	 exmem.halt_out <= exmem.halt_out;
	 exmem.wbSel_out <= exmem.wbSel_out;
	 exmem.beqFlag_out <= exmem.beqFlag_out;
	 exmem.bneFlag_out <= exmem.bneFlag_out;
	 exmem.jumpFlag_out <= exmem.jumpFlag_out;
	 exmem.dread_out <= exmem.dread_out;
	 exmem.dwrite_out <= exmem.dwrite_out;
	 exmem.zeroFlag_out <= exmem.zeroFlag_out;
	 exmem.portOut_out <= exmem.portOut_out;
	 exmem.jumpAddr_out <= exmem.jumpAddr_out;
	 exmem.PC4_out <= exmem.PC4_out;
	 exmem.immExt_out <= exmem.immExt_out;
	 exmem.rt_out <= exmem.rt_out;
	 exmem.rd_out <= exmem.rd_out;
	 exmem.dmemstore_out <= exmem.dmemstore_out;
	 
	 exmem.opCode_out <= exmem.opCode_out;
	 exmem.funct_out <= exmem.funct_out;
	 exmem.datomic_out <= exmem.datomic_out;
	 
      end
   end
endmodule
