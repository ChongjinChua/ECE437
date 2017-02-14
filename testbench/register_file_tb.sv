/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

   parameter PERIOD = 10;

   logic CLK = 0, nRST;

   // test vars
   int 	 v1 = 1;
   int 	 v2 = 4721;
   int 	 v3 = 25119;

   // clock
   always #(PERIOD/2) CLK++;

   // interface
   register_file_if rfif ();
   // test program
   test PROG ();
   // DUT
`ifndef MAPPED
   register_file DUT(CLK, nRST, rfif);
`else
   register_file DUT(
    .\CLK (CLK),
    .\nRST (nRST),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.WEN (rfif.WEN),
    .\rfif.wsel (rfif.wsel),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.wdat (rfif.wdat)
   );
`endif
	
endmodule

program test;

   int 	 testcase;

   initial
     begin
	//Test case 1
	testcase = 1;
	register_file_tb.nRST = 1'd0;
	@(posedge register_file_tb.CLK);
	
	register_file_tb.rfif.wsel = 5'd1;
	register_file_tb.rfif.wdat = 32'd1;
	register_file_tb.rfif.WEN = 1'd0;
	register_file_tb.rfif.rsel1 = 5'd1;
	register_file_tb.rfif.rsel2 = 5'd1;   
	register_file_tb.nRST = 1'd1;
	
	@(posedge register_file_tb.CLK);
	register_file_tb.rfif.WEN = 1'd1;
	@(posedge register_file_tb.CLK);
	
	register_file_tb.rfif.wsel = 5'd3;
	register_file_tb.rfif.rsel2 = 5'd3;   
	register_file_tb.rfif.wdat = 32'd3;
	
	@(posedge register_file_tb.CLK);
	@(posedge register_file_tb.CLK);	

	testcase = 2;

	register_file_tb.rfif.wsel = 5'd0;
	register_file_tb.rfif.rsel2 = 5'd0;   
	register_file_tb.rfif.wdat = 32'd3;

	@(posedge register_file_tb.CLK);

	testcase = 3;
	register_file_tb.nRST = 1'd0;
	@(posedge register_file_tb.CLK);
	
     end
endprogram
