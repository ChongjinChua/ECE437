/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "control_unit_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

// import types


module control_unit
  import cpu_types_pkg::*;
  (
   control_unit_if.cu cuif
   );

   logic 	      writeEn;

   //handles add $5,$5,$4
//   assign regWrite = (instructionOp == LW | instructionOp == SW) ? writeEn : writeEn & ihit;
   assign cuif.regWrite = writeEn;
   
			 //(cuif.instructionOp == 6'b100011) ? writeEn;
			  //writeEn & cuif.dhit: writeEn & cuif.ihit;
   //assign regWrite = writeEn;
   
   //change memread and memwrite to dread,iread,dwrite
   always_comb begin
      cuif.aluCtrl = ALU_SLL;
      cuif.aluSrc = 2'b00;
      cuif.regDst = 2'b00;
      writeEn = 1'b0;
      cuif.extension = 2'b00;
      cuif.jumpFlag = 1'b0;
      cuif.jrFlag = 1'b0;
      cuif.halt = 1'b0;
      cuif.dread = 1'b0;
      cuif.iread = 1'b1;
      cuif.dwrite = 1'b0;      
      cuif.wbSel = 3'b000;
      cuif.beqFlag = 1'b0;
      cuif.bneFlag = 1'b0;
      cuif.datomic = 1'b0;

      casez (cuif.instructionOp)
	RTYPE:
	   begin
	      casez (cuif.funct)
		SLL:
		   begin
		      //shift by 16 bits immediate?
		      cuif.aluCtrl = ALU_SLL;
		      cuif.aluSrc = 2'b10;
		      cuif.regDst = 2'b01;
		      writeEn = 1'b1;
		   end
		SRL:
		   begin
		      //shift by 16 bits immediate?		      
		      cuif.aluCtrl = ALU_SRL;
		      cuif.aluSrc = 2'b10;
		      cuif.regDst = 2'b01;
		      writeEn = 1'b1;
		   end
		JR:
		   begin
		      //add a mux for PC, choosing between instruction and regA
		      cuif.jumpFlag = 1'b1;
		      cuif.jrFlag = 1'b1;
		   end
		ADD:
		   begin
		      cuif.aluCtrl = ALU_ADD;
		      cuif.regDst = 2'b01;
		      writeEn = 1'b1;
		   end
		ADDU:
		   begin
		      cuif.aluCtrl = ALU_ADD;
		      cuif.regDst = 2'b01;
		      writeEn = 1'b1;
		   end
		SUB:
		   begin
		      cuif.aluCtrl = ALU_SUB;
		      cuif.regDst = 2'b01;
		      writeEn = 1'b1;
		   end
		SUBU:
		   begin
		      cuif.aluCtrl = ALU_SUB;
		      cuif.regDst = 2'b01;
		      writeEn = 1'b1;
		   end
		AND:
		   begin
		      cuif.aluCtrl = ALU_AND;
		      cuif.regDst = 2'b01;
		      writeEn = 1'b1;
		   end
		OR:
		   begin
		      cuif.aluCtrl = ALU_OR;
		      cuif.regDst = 2'b01;
		      writeEn = 1'b1;
		   end
		XOR:
		   begin
		      cuif.aluCtrl = ALU_XOR;
		      cuif.regDst = 2'b01;
		      writeEn = 1'b1;
		   end
		NOR:
		   begin
		      cuif.aluCtrl = ALU_NOR;
		      cuif.regDst = 2'b01;
		      writeEn = 1'b1;
		   end
		SLT:
		   begin
		      cuif.aluCtrl = ALU_SLT;
		      cuif.regDst = 2'b01;
		      writeEn = 1'b1;
		   end
		SLTU:
		   begin
		      cuif.aluCtrl = ALU_SLTU;
		      cuif.regDst = 2'b01;
		      writeEn = 1'b1;
		   end
		default:
		  begin
		      cuif.aluCtrl = ALU_SLL;
		  end
	      endcase
	   end
	J:
	   begin
	      //change diagram - jump addr is not from memory // nth wrong here
	      cuif.jumpFlag = 1'b1;
	   end
	JAL:
	   begin
	      //change diagram - add 5'd31 to regDst, 2'b10 npc to wbSel
	      cuif.regDst = 2'b10;
	      writeEn = 1'b1;
	      cuif.jumpFlag = 1'b1;
	      cuif.wbSel = 3'b010;
	   end
	BEQ:
	   begin
	      cuif.extension = 2'b01;
	      cuif.aluCtrl = ALU_SUB;
	      cuif.beqFlag = 1'b1;
	   end
	BNE:
	   begin
	      //get rid of and gate controlling pcSrc
	      cuif.extension = 2'b01;
	      cuif.aluCtrl = ALU_SUB;
	      cuif.bneFlag = 1'b1;
	   end
	ADDI:
	   begin
	      cuif.aluCtrl = ALU_ADD;
	      cuif.aluSrc = 2'b01;
	      writeEn = 1'b1;
	      cuif.extension = 2'b01;
	   end
	ADDIU:
	   begin
	      cuif.aluCtrl = ALU_ADD;
	      cuif.aluSrc = 2'b01;
	      writeEn = 1'b1;
	      cuif.extension = 2'b01;
	   end
	SLTI:
	   begin
	      cuif.aluCtrl = ALU_SLT;
	      cuif.aluSrc = 2'b01;
	      writeEn = 1'b1;
	      cuif.extension = 2'b01;
	   end
	SLTIU:
	   begin
	      cuif.aluCtrl = ALU_SLTU;
	      cuif.aluSrc = 2'b01;
	      writeEn = 1'b1;
	      cuif.extension = 2'b01;
	   end
	ANDI:
	   begin
	      cuif.aluCtrl = ALU_AND;
	      cuif.aluSrc = 2'b01;
	      writeEn = 1'b1;
	   end
	ORI:
	   begin
	      cuif.aluCtrl = ALU_OR;
	      cuif.aluSrc = 2'b01;
	      writeEn = 1'b1;
	   end
	XORI:
	   begin
	      cuif.aluCtrl = ALU_XOR;
	      cuif.aluSrc = 2'b01;
	      writeEn = 1'b1;
	   end
	LUI:
	   begin
	      //change diagram - add zeroAppend mux to extendor
	      //change diagram - add extendorOut to wbSel 2'b11
	      writeEn = 1'b1;
	      cuif.extension = 2'b10;
	      cuif.aluCtrl = ALU_OR;	      
	      cuif.aluSrc = 2'b01;
	      cuif.wbSel = 3'b011;
	   end
	LW:
	   begin
	      cuif.aluCtrl = ALU_ADD;
	      cuif.aluSrc = 2'b01;
	      writeEn = 1'b1;
	      cuif.extension = 2'b01;
	      cuif.dread = 1'b1;
	      cuif.wbSel = 3'b001;
	   end
	SW:
	   begin
	      cuif.aluCtrl = ALU_ADD;
	      cuif.aluSrc = 2'b01;
	      cuif.extension = 2'b01;
	      cuif.dwrite = 1'b1;
	   end
	LL:
	   begin
	      cuif.datomic = 1;
	      cuif.aluCtrl = ALU_ADD;
	      cuif.aluSrc = 2'b01;
	      writeEn = 1'b1;
	      cuif.extension = 2'b01;
	      cuif.dread = 1'b1;
	      cuif.wbSel = 3'b001;
	   end
	SC:
	   begin
	      cuif.datomic = 1;
	      cuif.aluCtrl = ALU_ADD;
	      cuif.aluSrc = 2'b01;
	      cuif.extension = 2'b01;
	      cuif.dwrite = 1'b1;
	      writeEn = 1'b1;
	      cuif.regDst = 2'b00;
	      cuif.wbSel = 3'b100;
	   end
	HALT:
	   begin
	      cuif.halt = 1'b1;
	      //cuif.iread = 1'b0;
	   end
	default:
	  begin

	  end
      endcase
   end

endmodule
