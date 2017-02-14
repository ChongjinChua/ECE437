

// mapped needs this
`include "cpu_types_pkg.vh"
`include "alu_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

import cpu_types_pkg::*;

module alu_tb;

   parameter PERIOD = 10;

   logic CLK = 0, nRST;

   // test vars
   int 	 v1 = 1;
   int 	 v2 = 4721;
   int 	 v3 = 25119;

   // clock
   always #(PERIOD/2) CLK++;

   // interface
   alu_if aluIf ();
   // test program
   test PROG ();
   // DUT
`ifndef MAPPED
   alu DUT(aluIf);
`else
   alu DUT(
    .\aluIf.ops (aluIf.ops),
    .\aluIf.portA (aluIf.portA),
    .\aluIf.portB (aluIf.portB),
    .\aluIf.portOut (aluIf.portOut),
    .\aluIf.negative_flag (aluIf.negative_flag),
    .\aluIf.overflow_flag (aluIf.overflow_flag),
    .\aluIf.zero_flag (aluIf.zero_flag)
   );
`endif
	
endmodule

program test;

   int 	 testcase;

   initial
     begin
	//Test case 1
	testcase = 1;
	alu_tb.nRST = 1'd0;
	@(posedge alu_tb.CLK);
	
	alu_tb.aluIf.portA = 32'h80000001;
	alu_tb.aluIf.portB = 32'd2;
	alu_tb.aluIf.ops = ALU_SLL;
	alu_tb.nRST = 1'd1;
	
	@(posedge alu_tb.CLK);
	testcase = 2;
	alu_tb.aluIf.ops = ALU_SRL;
	
	@(posedge alu_tb.CLK);
	testcase = 3;
	alu_tb.aluIf.portA = 32'hFFFFFFFF;
	alu_tb.aluIf.portB = 32'hFFFFFFFF;
	alu_tb.aluIf.ops = ALU_ADD;

	@(posedge alu_tb.CLK); //overflow
	testcase = 4;
	alu_tb.aluIf.portA = 32'h7FFFFFFF;
	alu_tb.aluIf.portB = 32'h7FFFFFFF;
	alu_tb.aluIf.ops = ALU_ADD;

	@(posedge alu_tb.CLK); //overflow
	testcase = 5;
	alu_tb.aluIf.portA = 32'h80000001;
	alu_tb.aluIf.portB = 32'h80000001;
	alu_tb.aluIf.ops = ALU_ADD;	

	@(posedge alu_tb.CLK);	

	testcase = 6;
	alu_tb.aluIf.portA = 32'h00000000;
	alu_tb.aluIf.portB = 32'h00000000;
	alu_tb.aluIf.ops = ALU_ADD;
	@(posedge alu_tb.CLK); 

	testcase = 7;
	alu_tb.aluIf.portA = 32'hFFFFFFFF;
	alu_tb.aluIf.portB = 32'hFFFFFFFF;
	alu_tb.aluIf.ops = ALU_SUB;
	@(posedge alu_tb.CLK); 

	testcase = 8; //overflow
	alu_tb.aluIf.portA = 32'h7FFFFFFF;
	alu_tb.aluIf.portB = 32'hFFFFFFFF;
	alu_tb.aluIf.ops = ALU_SUB;
	@(posedge alu_tb.CLK);

	testcase = 9; //overflow
	alu_tb.aluIf.portA = 32'h80000000;
	alu_tb.aluIf.portB = 32'h7FFFFF01;
	alu_tb.aluIf.ops = ALU_SUB;	
	@(posedge alu_tb.CLK);	

	//AND CASE
	testcase = 10;
	alu_tb.aluIf.portA = 32'hAAAAAAAA;
	alu_tb.aluIf.portB = 32'h55555555;
	alu_tb.aluIf.ops = ALU_AND;
	@(posedge alu_tb.CLK);

	//OR CASE
	testcase = 11;
	alu_tb.aluIf.portA = 32'hAAAAAAAA;
	alu_tb.aluIf.portB = 32'h55555555;
	alu_tb.aluIf.ops = ALU_OR;
	@(posedge alu_tb.CLK);

	//XOR CASE
	testcase = 12;
	alu_tb.aluIf.portA = 32'hAAAAAAAA;
	alu_tb.aluIf.portB = 32'h55555555;
	alu_tb.aluIf.ops = ALU_XOR;
	@(posedge alu_tb.CLK);

	//NOR CASE
	testcase = 13;
	alu_tb.aluIf.portA = 32'hAAAAAAAA;
	alu_tb.aluIf.portB = 32'h55555555;
	alu_tb.aluIf.ops = ALU_NOR;
	@(posedge alu_tb.CLK);

	//SLT CASE
	testcase = 14;
	alu_tb.aluIf.portA = 32'hFFFFFFFF;
	alu_tb.aluIf.portB = 32'h7FFFFFFF;
	alu_tb.aluIf.ops = ALU_SLT;
	@(posedge alu_tb.CLK);

	//SLT CASE
	testcase = 15;
	alu_tb.aluIf.portA = 32'h00000001;
	alu_tb.aluIf.portB = 32'hFFFFFFFF;
	alu_tb.aluIf.ops = ALU_SLT;
	@(posedge alu_tb.CLK);

	//SLTU CASE
	testcase = 16;
	alu_tb.aluIf.portA = 32'hFFFFFFFF;
	alu_tb.aluIf.portB = 32'h7FFFFFFF;
	alu_tb.aluIf.ops = ALU_SLTU;
	@(posedge alu_tb.CLK);

	//SLTU CASE
	testcase = 17;
	alu_tb.aluIf.portA = 32'h00000001;
	alu_tb.aluIf.portB = 32'hFFFFFFFF;
	alu_tb.aluIf.ops = ALU_SLTU;
	@(posedge alu_tb.CLK);
		
	
     end
endprogram
