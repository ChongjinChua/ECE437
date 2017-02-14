/*
  Eric Villasenor
  evillase@gmail.com

  system test bench, for connected processor (datapath+cache)
  and memory (ram).

*/

// interface
`include "cache_control_if.vh"
`include "caches_if.vh"
`include "cpu_ram_if.vh"

// types
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module icache_tb;
  // clock period
  parameter PERIOD = 20;

  // signals
  logic CLK = 1, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
   datapath_cache_if dcif();
   caches_if cif();
   
  // test program
  test PROG (CLK,nRST,dcif,cif);

  // dut
`ifndef MAPPED
   icache DUT (CLK,nRST,dcif,cif);

`endif
   
endmodule

program test(input logic CLK, output logic nRST, datapath_cache_if dcif, caches_if cif);
    parameter PERIOD = 20;
  // import word type
  import cpu_types_pkg::*;
   int 	testcase = 0;
   string command = "";

   initial begin
      nRST = 0;
      cif.iwait = 0;
      cif.iload = 0;
      dcif.imemREN = 0;
      dcif.imemaddr = 0;
      
      @(posedge CLK);
      nRST = 1;
      @(posedge CLK);

      testcase++;
      command = "Miss on reset test";
      
      dcif.imemREN = 1;
      dcif.imemaddr = 32'hBEEF;
      cif.iwait = 1;
      @(negedge CLK);      

      if (dcif.ihit == 0 && cif.iREN == 1 && cif.iaddr == dcif.imemaddr) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);

      testcase++;
      command = "Hit on first write test";

      cif.iwait = 0;
      cif.iload = 32'hDEAD;

      @(negedge CLK);

      if (dcif.ihit == 1 && cif.iREN == 0 && cif.iaddr == dcif.imemaddr && cif.iload == dcif.imemload) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(negedge CLK);
      @(negedge CLK);
      @(negedge CLK);      

      testcase++;
      command = "Miss on overwrite test";

      cif.iwait = 1;
      dcif.imemaddr = 32'hBEEF + 32'h40;      
      cif.iload = 32'hBEAD;

      @(negedge CLK);

      if (dcif.ihit == 0 && cif.iREN == 1 && cif.iaddr == dcif.imemaddr) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(negedge CLK);
      @(negedge CLK);
      @(negedge CLK);

      testcase++;
      command = "Hit after overwrite test";
      cif.iwait = 0;      

       @(negedge CLK);

      if (dcif.ihit == 1 && cif.iREN == 0 && cif.iaddr == dcif.imemaddr  && cif.iload == dcif.imemload) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end
      
      @(negedge CLK);      

   end
      
      
endprogram
