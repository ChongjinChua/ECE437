/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

// import types


module control_unit
  import cpu_types_pkg::*;
  (
   input logic [OP_W-1:0]   instructionOp,
   input logic [FUNC_W-1:0] funct,
   input logic 		    overflow_flag, zero_flag,
   input logic 		    ihit,
   output 		    aluop_t aluCtrl,
//   output logic [1:0] aluSrc,
   output logic 	    aluSrc, 
   output logic 	    regWrite,
   output logic [1:0] 	    regDst,
   output logic [1:0] 	    extension,
   output logic 	    pcSrc, jump, jrFlag, halt,
   output logic 	    dread, iread, dwrite,
   output logic [1:0] 	    memToReg
   );

   logic 	      branchFlag;
   logic 	      bne_flag;
   logic 	      write_en;

   //handles add $5,$5,$4
//   assign regWrite = (instructionOp == LW | instructionOp == SW) ? write_en : write_en & ihit;
   assign regWrite = (instructionOp == 6'b100011 | instructionOp == 6'b101011) ? write_en : write_en & ihit;
   //assign regWrite = write_en;
   
   //handles beq and bne
   assign pcSrc = (bne_flag) ? (!zero_flag & branchFlag) : (zero_flag & branchFlag);

   //change memread and memwrite to dread,iread,dwrite
   always_comb begin
      aluCtrl = ALU_SLL;
      aluSrc = 1'b0;
      regDst = 2'b00;
      write_en = 1'b0;
      extension = 2'b00;
      jump = 1'b0;
      jrFlag = 1'b0;
      halt = 1'b0;
      dread = 1'b0;
      iread = 1'b1;
      dwrite = 1'b0;      
      memToReg = 2'b00;
      branchFlag = 1'b0;
      bne_flag = 1'b0;

      casez (instructionOp)
	RTYPE:
	   begin
	      casez (funct)
		SLL:
		   begin
		      //shift by 16 bits immediate?
		      aluCtrl = ALU_SLL;
		      aluSrc = 1'b1;
		      regDst = 2'b01;
		      write_en = 1'b1;
		   end
		SRL:
		   begin
		      //shift by 16 bits immediate?		      
		      aluCtrl = ALU_SRL;
		      aluSrc = 1'b1;
		      regDst = 2'b01;
		      write_en = 1'b1;
		   end
		JR:
		   begin
		      //add a mux for PC, choosing between instruction and regA
		      jump = 1'b1;
		      jrFlag = 1'b1;
		   end
		ADD:
		   begin
		      aluCtrl = ALU_ADD;
		      regDst = 2'b01;
		      write_en = 1'b1;
		   end
		ADDU:
		   begin
		      aluCtrl = ALU_ADD;
		      regDst = 2'b01;
		      write_en = 1'b1;
		   end
		SUB:
		   begin
		      aluCtrl = ALU_SUB;
		      regDst = 2'b01;
		      write_en = 1'b1;
		   end
		SUBU:
		   begin
		      aluCtrl = ALU_SUB;
		      regDst = 2'b01;
		      write_en = 1'b1;
		   end
		AND:
		   begin
		      aluCtrl = ALU_AND;
		      regDst = 2'b01;
		      write_en = 1'b1;
		   end
		OR:
		   begin
		      aluCtrl = ALU_OR;
		      regDst = 2'b01;
		      write_en = 1'b1;
		   end
		XOR:
		   begin
		      aluCtrl = ALU_XOR;
		      regDst = 2'b01;
		      write_en = 1'b1;
		   end
		NOR:
		   begin
		      aluCtrl = ALU_NOR;
		      regDst = 2'b01;
		      write_en = 1'b1;
		   end
		SLT:
		   begin
		      aluCtrl = ALU_SLT;
		      regDst = 2'b01;
		      write_en = 1'b1;
		   end
		SLTU:
		   begin
		      aluCtrl = ALU_SLTU;
		      regDst = 2'b01;
		      write_en = 1'b1;
		   end
	      endcase
	   end
	J:
	   begin
	      //change diagram - jump addr is not from memory // nth wrong here
	      jump = 1'b1;
	   end
	JAL:
	   begin
	      //change diagram - add 5'd31 to regDst, 2'b10 npc to memToReg
	      regDst = 2'b10;
	      write_en = 1'b1;
	      jump = 1'b1;
	      memToReg = 2'b10;
	   end
	BEQ:
	   begin
	      aluCtrl = ALU_SUB;
	      branchFlag = 1'b1;
	   end
	BNE:
	   begin
	      //get rid of and gate controlling pcSrc
	      aluCtrl = ALU_SUB;
	      branchFlag = 1'b1;
	      bne_flag = 1'b1;
	   end
	ADDI:
	   begin
	      aluCtrl = ALU_ADD;
	      aluSrc = 1'b1;
	      write_en = 1'b1;
	      extension = 2'b01;
	   end
	ADDIU:
	   begin
	      aluCtrl = ALU_ADD;
	      aluSrc = 1'b1;
	      write_en = 1'b1;
	      extension = 2'b01;
	   end
	SLTI:
	   begin
	      aluCtrl = ALU_SLT;
	      aluSrc = 1'b1;
	      write_en = 1'b1;
	      extension = 2'b01;
	   end
	SLTIU:
	   begin
	      aluCtrl = ALU_SLTU;
	      aluSrc = 1'b1;
	      write_en = 1'b1;
	      extension = 2'b01;
	   end
	ANDI:
	   begin
	      aluCtrl = ALU_AND;
	      aluSrc = 1'b1;
	      write_en = 1'b1;
	   end
	ORI:
	   begin
	      aluCtrl = ALU_OR;
	      aluSrc = 1'b1;
	      write_en = 1'b1;
	   end
	XORI:
	   begin
	      aluCtrl = ALU_XOR;
	      aluSrc = 1'b1;
	      write_en = 1'b1;
	   end
	LUI:
	   begin
	      //change diagram - add zeroAppend mux to extendor
	      //change diagram - add extendorOut to memToReg 2'b11
	      write_en = 1'b1;
	      extension = 2'b10;
	      memToReg = 2'b11;
	   end
	LW:
	   begin
	      aluCtrl = ALU_ADD;
	      aluSrc = 1'b1;
	      write_en = 1'b1;
	      extension = 2'b01;
	      dread = 1'b1;
	      memToReg = 2'b01;
	   end
	SW:
	   begin
	      aluCtrl = ALU_ADD;
	      aluSrc = 1'b1;
	      extension = 2'b01;
	      dwrite = 1'b1;
	   end
	LL:
	   begin
	      aluCtrl = ALU_ADD;
	      aluSrc = 1'b1;
	      write_en = 1'b1;
	      extension = 2'b01;
	      dread = 1'b1;
	      memToReg = 2'b01;
	   end
	SC:
	   begin
	      aluCtrl = ALU_ADD;
	      aluSrc = 1'b1;
	      extension = 2'b01;
	      dwrite = 1'b1;
	   end
	HALT:
	   begin
	      halt = 1'b1;
	      iread = 1'b0;
	   end
      endcase
   end

endmodule
