/*
  Eric Villasenor
  evillase@gmail.com

  system test bench, for connected processor (datapath+cache)
  and memory (ram).

*/

// interface

// types
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

// import word type
import cpu_types_pkg::*;

module control_unit_tb;
  // clock period
  parameter PERIOD = 20;

  // signals
  logic CLK = 1, nRST;

  // clock
  always #(PERIOD/2) CLK++;

   logic [OP_W-1:0] instructionOp;
   logic [FUNC_W-1:0] funct;
   logic 	      overflow_flag, zero_flag;
   logic [AOP_W-1:0]  aluCtrl;
   logic 	      aluSrc, regWrite;
   logic [1:0] 	      regDst;
   logic [1:0] 	      extension;
   logic 	      pcSrc, jump, jrFlag, halt;
   logic 	      dread,iread,dwrite;
   logic [1:0] 	      memToReg;

   string instr = "";

   always_comb begin
      casez (aluCtrl)
	    ALU_SLL: instr = "ALU_SLL";
	    ALU_SRL: instr = "ALU_SRL";
	    ALU_ADD: instr = "ALU_ADD";
	    ALU_SUB: instr = "ALU_SUB";
	    ALU_AND: instr = "ALU_AND";
	    ALU_OR: instr = "ALU_OR";
	    ALU_XOR: instr = "ALU_XOR";
	    ALU_NOR: instr = "ALU_NOR";
	    ALU_SLT: instr = "ALU_SLT";
	    ALU_SLTU: instr = "ALU_SLTU";
      endcase
   end
   
  // test program
   test PROG
     (
      CLK,
      nRST,
      instructionOp,funct,overflow_flag,zero_flag,aluCtrl,aluSrc,regWrite,regDst,
      extension,pcSrc,jump,jrFlag,halt,dread,iread,dwrite,memToReg
      );

  // dut
`ifndef MAPPED
   control_unit DUT
     (
      instructionOp,funct,overflow_flag,zero_flag,aluCtrl,aluSrc,regWrite,regDst,
      extension,pcSrc,jump,jrFlag,halt,dread,iread,dwrite,memToReg
      );

`endif
   
endmodule

program test
  (
   input logic CLK,
   output logic nRST,
   output logic [OP_W-1:0] instructionOp,
   output logic [FUNC_W-1:0] funct,
   output logic overflow_flag, zero_flag,
   input logic [AOP_W-1:0] aluCtrl,
   input logic aluSrc, regWrite,
   input logic [1:0] regDst,
   input logic [1:0] extension,
   input logic pcSrc, jump, jrFlag, halt,
   input logic dread, iread, dwrite,
   input logic [1:0] memToReg
   );
   
   int 	testcase = 0;
   string command = "";


   initial begin

      nRST = 0;
      testcase = 1;
      command = "test SLL";
      instructionOp = RTYPE;
      funct = SLL;
      overflow_flag = 0;
      zero_flag = 0;

      @(posedge CLK);
      nRST = 1;
      @(posedge CLK);
      
      testcase = 2;
      command = "test SRL";
      instructionOp = RTYPE;
      funct = SRL;
      overflow_flag = 0;
      zero_flag = 0;

      @(posedge CLK);
      
      testcase = 3;
      command = "test ADD";
      instructionOp = RTYPE;
      funct = ADD;
      overflow_flag = 1;
      zero_flag = 0;

      @(posedge CLK);
      
      testcase = 4;
      command = "test SUB";
      instructionOp = RTYPE;
      funct = SUB;
      overflow_flag = 1;
      zero_flag = 0;

      @(posedge CLK);
      
      testcase = 5;
      command = "test AND";
      instructionOp = RTYPE;
      funct = AND;
      overflow_flag = 0;
      zero_flag = 0;

      @(posedge CLK);
      
      testcase = 6;
      command = "test OR";
      instructionOp = RTYPE;
      funct = OR;
      overflow_flag = 0;
      zero_flag = 0;

      @(posedge CLK);
      
      testcase = 7;
      command = "test XOR";
      instructionOp = RTYPE;
      funct = XOR;
      overflow_flag = 0;
      zero_flag = 0;

      @(posedge CLK);
      
      testcase = 8;
      command = "test NOR";
      instructionOp = RTYPE;
      funct = NOR;
      overflow_flag = 0;
      zero_flag = 0;

      @(posedge CLK);
      
      testcase = 9;
      command = "test SLT";
      instructionOp = RTYPE;
      funct = SLT;
      overflow_flag = 0;
      zero_flag = 0;

      @(posedge CLK);
      
      testcase = 10;
      command = "test SLTU";
      instructionOp = RTYPE;
      funct = SLTU;
      overflow_flag = 0;
      zero_flag = 0;
            
      @(posedge CLK);            

      testcase = 11;
      command = "test ADDU";
      instructionOp = RTYPE;
      funct = ADDU;
      overflow_flag = 1;
      zero_flag = 0;

      @(posedge CLK);
      
      testcase = 12;
      command = "test SUBU";
      instructionOp = RTYPE;
      funct = SUBU;
      overflow_flag = 1;
      zero_flag = 0;

      @(posedge CLK);
      
      testcase = 13;
      command = "test JR";
      instructionOp = RTYPE;
      funct = JR;
      overflow_flag = 0;
      zero_flag = 0;
            
      @(posedge CLK);            

      testcase = 14;
      command = "test J";
      instructionOp = J;
      funct = 0;
      overflow_flag = 0;
      zero_flag = 0;
            
      @(posedge CLK);            

      testcase = 15;
      command = "test JAL";
      instructionOp = JAL;
      funct = 0;
      overflow_flag = 0;
      zero_flag = 0;
            
      @(posedge CLK);                  

      testcase = 16;
      command = "test BEQ";
      instructionOp = BEQ;
      funct = 0;
      overflow_flag = 0;
      zero_flag = 1;
            
      @(posedge CLK);

      testcase = 17;
      command = "test BNE";
      instructionOp = BNE;
      funct = 0;
      overflow_flag = 0;
      zero_flag = 1;
            
      @(posedge CLK);

      testcase = 18;
      command = "test ADDI";
      instructionOp = ADDI;
      funct = 0;
      overflow_flag = 1;
      zero_flag = 0;
            
      @(posedge CLK);

      testcase = 19;
      command = "test ADDIU";
      instructionOp = ADDIU;
      funct = 0;
      overflow_flag = 1;
      zero_flag = 0;
            
      @(posedge CLK);                

      testcase = 20;
      command = "test SLTI";
      instructionOp = SLTI;
      funct = 0;
      overflow_flag = 1;
      zero_flag = 0;
            
      @(posedge CLK);

      testcase = 21;
      command = "test SLTIU";
      instructionOp = SLTIU;
      funct = 0;
      overflow_flag = 1;
      zero_flag = 0;
            
      @(posedge CLK);

      testcase = 22;
      command = "test ANDI";
      instructionOp = ANDI;
      funct = 0;
      overflow_flag = 0;
      zero_flag = 0;
            
      @(posedge CLK);

      testcase = 23;
      command = "test ORI";
      instructionOp = ORI;
      funct = 0;
      overflow_flag = 0;
      zero_flag = 0;
            
      @(posedge CLK);                       

      testcase = 24;
      command = "test XORI";
      instructionOp = XORI;
      funct = 0;
      overflow_flag = 0;
      zero_flag = 0;
            
      @(posedge CLK);

      testcase = 25;
      command = "test LUI";
      instructionOp = LUI;
      funct = 0;
      overflow_flag = 0;
      zero_flag = 0;
            
      @(posedge CLK);

      testcase = 26;
      command = "test LW";
      instructionOp = LW;
      funct = 0;
      overflow_flag = 0;
      zero_flag = 0;
            
      @(posedge CLK);

      testcase = 27;
      command = "test SW";
      instructionOp = SW;
      funct = 0;
      overflow_flag = 0;
      zero_flag = 0;
            
      @(posedge CLK);

      testcase = 28;
      command = "test HALT";
      instructionOp = HALT;
      funct = 0;
      overflow_flag = 0;
      zero_flag = 0;
            
      @(posedge CLK);        
      
  end

endprogram
