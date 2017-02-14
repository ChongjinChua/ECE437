/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
//`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module request_unit_tb;

   parameter PERIOD = 10;

   logic CLK = 0, nRST;
   logic iread,dread,dwrite;
   logic ihit,dhit;
   logic iren,dren,dwen;

   // test vars
   int 	 v1 = 1;
   int 	 v2 = 4721;
   int 	 v3 = 25119;

   // clock
   always #(PERIOD/2) CLK++;

   // interface
   // register_file_if rfif ();
   // test program
   test PROG
     (
      CLK,nRST,
      iread,dread,dwrite,
      ihit,dhit,
      iren,dren,dwen
      );
   
   // DUT
`ifndef MAPPED
   request_unit DUT
     (CLK,nRST,
      iread,dread,dwrite,
      ihit,dhit,
      iren,dren,dwen      
      );
`endif
	
endmodule

program test
  (
   input logic CLK,
   output logic nRST,
   output logic iread,dread,dwrite,
   output logic ihit,dhit,
   input logic iren,dren,dwen
   );

   int 	 testcase;
   string command = "";

   initial
     begin
	nRST = 0;
	iread = 1; //always high
	
	testcase = 1;
	command = "iread";
	dread = 0;
	dwrite = 0;
	ihit = 0;
	dhit = 0;
	@(posedge CLK);
	nRST = 1;
	@(posedge CLK);
	ihit = 1;
	@(posedge CLK);

	testcase = 2;
	command = "iread and dread";
	dread = 1;
	dwrite = 0;
	ihit = 0;
	dhit = 0;
	@(posedge CLK);
	dhit = 1;
	@(posedge CLK);
	dhit = 0;
	ihit = 1;
	@(posedge CLK);	
		
	testcase = 3;
	command = "iread and dwrite";
	dread = 0;
	dwrite = 1;
	ihit = 0;
	dhit = 0;
	@(posedge CLK);
	@(posedge CLK);	
	dhit = 1;
	@(posedge CLK);
	ihit = 1;
	@(posedge CLK);
	
     end
endprogram
