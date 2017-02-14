// data path interface
`include "id_ex_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module id_ex
  (
   input logic CLK, nRST,
   id_ex_if.latch idex
   );
   
   // import types
   import cpu_types_pkg::*;

   // Instr. Fetch
   always_ff @(posedge CLK, negedge nRST) begin
      if(!nRST) begin
	 
	 idex.regDst_out <= 0;
	 idex.regWrite_out <= 0;
	 idex.halt_out <= 0;
	 idex.wbSel_out <= 0;	 
	 
	 idex.jumpAddr_out <= 0;
	 idex.jumpFlag_out <= 0;	 
	 idex.dwrite_out <= 0;
	 idex.dread_out <= 0;
	 idex.beqFlag_out <= 0;
	 idex.bneFlag_out <= 0;	 
	 idex.PC4_out <= 0;
	 idex.immExt_out <= 0;
	 
	 idex.aluSrc_out <= 0;
	 idex.aluOp_out[AOP_W-1:0] <= 0;
	 
	 idex.rdat1_out <= 0;
	 idex.rdat2_out <= 0;
	 
	 idex.shamt_out <= 0;	 
	 idex.rt_out <= 0;
	 idex.rd_out <= 0;
	 idex.rs_out <= 0;
	 	 
	 idex.opCode_out[OP_W-1:0] <= 0;
	 idex.funct_out[FUNC_W-1:0] <= 0;
	 idex.datomic_out <= 0;

      end else if(idex.flush) begin
	 
	 idex.regDst_out <= 0;
	 idex.regWrite_out <= 0;
	 idex.halt_out <= 0;
	 idex.wbSel_out <= 0;	 
	 
	 idex.jumpAddr_out <= 0;
	 idex.jumpFlag_out <= 0;	 
	 idex.dwrite_out <= 0;
	 idex.dread_out <= 0;
	 idex.beqFlag_out <= 0;
	 idex.bneFlag_out <= 0;	 
	 idex.PC4_out <= 0;
	 idex.immExt_out <= 0;
	 
	 idex.aluSrc_out <= 0;
	 idex.aluOp_out[AOP_W-1:0] <= 0;
	 
	 idex.rdat1_out <= 0;
	 idex.rdat2_out <= 0;
	 
	 idex.shamt_out <= 0;	 
	 idex.rt_out <= 0;
	 idex.rd_out <= 0;
	 idex.rs_out <= 0;
	 	 
	 idex.opCode_out[OP_W-1:0] <= 0;
	 idex.funct_out[FUNC_W-1:0] <= 0;
	 idex.datomic_out <= 0;
	 
      end else begin
	 if(idex.EN) begin
	    
	    idex.regDst_out <= idex.regDst_in;
	    idex.regWrite_out <= idex.regWrite_in;
	    idex.halt_out <= idex.halt_in;
	    idex.wbSel_out <= idex.wbSel_in;

	    idex.jumpAddr_out <= idex.jumpAddr_in;
	    idex.jumpFlag_out <= idex.jumpFlag_in;	 
	    idex.dwrite_out <= idex.dwrite_in;
	    idex.dread_out <= idex.dread_in;
	    idex.beqFlag_out <= idex.beqFlag_in;
	    idex.bneFlag_out <= idex.bneFlag_in;	 
	    idex.PC4_out <= idex.PC4_in;
	    idex.immExt_out <= idex.immExt_in;
	    
	    idex.aluOp_out <= idex.aluOp_in;
	    idex.aluSrc_out <= idex.aluSrc_in;
	      
	    idex.rdat1_out <= idex.rdat1_in;
	    idex.rdat2_out <= idex.rdat2_in;
	    
	    idex.shamt_out <= idex.shamt_in;
	    idex.rt_out <= idex.rt_in;
	    idex.rd_out <= idex.rd_in;
	    idex.rs_out <= idex.rs_in;
	    
	    idex.opCode_out <= idex.opCode_in;
	    idex.funct_out <= idex.funct_in;
	    idex.datomic_out <= idex.datomic_in;

	 end else begin
	    
	    idex.regDst_out <= idex.regDst_out;
	    idex.regWrite_out <= idex.regWrite_out;
	    idex.halt_out <= idex.halt_out;
	    idex.wbSel_out <= idex.wbSel_out;
	    
	    idex.jumpAddr_out <= idex.jumpAddr_out;
	    idex.jumpFlag_out <= idex.jumpFlag_out;	 
	    idex.dwrite_out <= idex.dwrite_out;
	    idex.dread_out <= idex.dread_out;
	    idex.beqFlag_out <= idex.beqFlag_out;
	    idex.bneFlag_out <= idex.bneFlag_out;	 
	    idex.PC4_out <= idex.PC4_out;
	    idex.immExt_out <= idex.immExt_out;
	    
	    idex.aluOp_out <= idex.aluOp_out;
	    idex.aluSrc_out <= idex.aluSrc_out;
	      
	    idex.rdat1_out <= idex.rdat1_out;
	    idex.rdat2_out <= idex.rdat2_out;
	    
	    idex.shamt_out <= idex.shamt_out;
	    idex.rt_out <= idex.rt_out;
	    idex.rd_out <= idex.rd_out;
	    idex.rs_out <= idex.rs_out;
	    
	    idex.opCode_out <= idex.opCode_out;
	    idex.funct_out <= idex.funct_out;

	    idex.datomic_out <= idex.datomic_out;
	    
	 end
      end // else: !if((!nRST) || (idex.flush))
   end // always_ff @
endmodule // id_ex


