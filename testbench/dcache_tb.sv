/*
  dcache test bench
*/

// interface
`include "cache_control_if.vh"
`include "caches_if.vh"
`include "datapath_cache_if.vh"
`include "cpu_ram_if.vh"

// types
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module dcache_tb;
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
   dcache DUT (CLK,nRST,dcif,cif);

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
      cif.dwait = 0;
      cif.dload = 0;
      dcif.dmemREN = 0;
      dcif.dmemWEN = 0;      
      dcif.dmemaddr = 0;
      dcif.dmemstore = 0;      
      dcif.halt = 0;
      
      @(posedge CLK);
      nRST = 1;
      @(posedge CLK);

      testcase++;
      command = "Miss on reset test";
      
      dcif.dmemREN = 1;
      dcif.dmemaddr = 32'hBEEC;
      cif.dload = 32'hBEEF;      
      cif.dwait = 1;
      @(negedge CLK);      

      if (dcif.dhit == 0 && cif.dREN == 1 && cif.daddr == (dcif.dmemaddr & ~(32'h1 << 2))) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);

      testcase++;
      command = "First word load wait test";
      
      @(negedge CLK);
      
      if (dcif.dhit == 0 && cif.dREN == 1 && cif.daddr == (dcif.dmemaddr & ~(32'h1 << 2))) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(posedge CLK);
            
      testcase++;
      command = "Second word load start test";

      cif.dwait = 0;
      cif.dload = 32'hBEEF;

      @(negedge CLK);

      if (dcif.dhit == 0 && cif.dREN == 1 && cif.daddr == (dcif.dmemaddr | (32'h1 << 2))) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      
      @(posedge CLK);
      cif.dwait = 1;

      testcase++;
      command = "Second word load wait test";
      
      @(negedge CLK);
      
      if (dcif.dhit == 0 && cif.dREN == 1 && cif.daddr == (dcif.dmemaddr | (32'h1 << 2))) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(posedge CLK);
      cif.dwait = 0;
      cif.dload = 32'hDEAD;

      testcase++;
      command = "Second word load complete test";
      @(negedge CLK);

      if (dcif.dhit == 0 && cif.dREN == 0) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(posedge CLK);

      testcase++;
      command = "Load hit after miss test";
      
      @(negedge CLK);
      
      if (dcif.dhit == 1 && cif.dREN == 0 && dcif.dmemload == 32'hDEAD) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(posedge CLK);

      testcase++;
      command = "no hit after hit";

      dcif.dmemREN = 0;
            
      @(negedge CLK);
      
      if (dcif.dhit == 0 && cif.dREN == 0) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(posedge CLK);
      @(posedge CLK);

      testcase++;
      command = "Hit after load test";
      
      dcif.dmemREN = 1;
      dcif.dmemaddr = 32'hBEE8;
      cif.dload = 32'hBAD1BAD1;      
      cif.dwait = 0;
      @(negedge CLK);      

      if (dcif.dhit == 1 && cif.dREN == 0 && dcif.dmemload == 32'hBEEF) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(posedge CLK);

      testcase++;
      command = "no hit after hit";

      dcif.dmemREN = 0;
            
      @(negedge CLK);
      
      if (dcif.dhit == 0 && cif.dREN == 0) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(posedge CLK);
      @(posedge CLK);

      testcase++;
      command = "Hit and write to cache test";
      
      dcif.dmemWEN = 1;
      dcif.dmemREN = 0;
      dcif.dmemaddr = 32'hBEEC;
      dcif.dmemstore = 32'h8888;
      cif.dwait = 0;

      @(negedge CLK);      

      if (dcif.dhit == 1 && cif.dWEN == 0) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(posedge CLK);
      
      testcase++;
      command = "Hit and write to cache test 3";
      dcif.dmemWEN = 0;
      
      @(negedge CLK);      

      if (dcif.dhit == 0 && cif.dWEN == 0) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(posedge CLK);

      testcase++;
      command = "Hit and write to cache test";
      
      dcif.dmemWEN = 1;
      dcif.dmemREN = 0;
      dcif.dmemaddr = 32'hBEEC + 32'h40;
      dcif.dmemstore = 32'h4444;
      cif.dwait = 1;

      @(negedge CLK);      

      if (dcif.dhit == 0 && cif.dWEN == 1 && cif.daddr == 32'hBEE8 && cif.dstore == 32'hBEEF) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(posedge CLK);
      cif.dload = 32'hD00D00;
      cif.dwait = 0;
      @(posedge CLK);

      testcase++;
      command = "Hit and write to cache test 2";

      cif.dwait = 1;      
      @(negedge CLK);      

      if (dcif.dhit == 0 && cif.dWEN == 1 && cif.daddr == 32'hBEEC && cif.dstore == 32'h8888) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(posedge CLK);

      cif.dwait = 0;            
      cif.dload = 32'hBADF00D;
      testcase++;
      command = "Hit and write to cache test 2";
      

      @(negedge CLK);      

      if (dcif.dhit == 0 && cif.dWEN == 0 && cif.dREN == 1 && cif.daddr == (32'hBEE8 + 32'h40)) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end      

      @(posedge CLK);      
      cif.dwait = 1;            
      @(posedge CLK);
      cif.dwait = 0;
      cif.dload = 32'hB00B1E5;
      @(posedge CLK);
      cif.dwait = 1;            
      @(posedge CLK);
      cif.dwait = 0;            

      testcase++;
      command = "full cycle test wen and ren should be low";

      @(negedge CLK);      
      if (dcif.dhit == 0 && cif.dWEN == 0 && cif.dREN == 0) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end      

      @(posedge CLK);

      testcase++;
      command = "back to idle";

      @(negedge CLK);      

      if (dcif.dhit == 1 && cif.dWEN == 0 && cif.dREN == 0) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end      

      @(posedge CLK);            

      dcif.dmemWEN = 0;
      
      @(negedge CLK);
      
      if (dcif.dhit == 0 && cif.dWEN == 0 && cif.dREN == 0) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end      

      @(posedge CLK);            
      //this is sparta

      testcase++;
      command = "second write to cache test";
      
      dcif.dmemWEN = 1;
      dcif.dmemREN = 0;
      dcif.dmemaddr = 32'hBEEC + 32'h80;
      dcif.dmemstore = 32'h4444;
      cif.dwait = 1;

      if (dcif.dhit == 0 && cif.dWEN == 1 && cif.daddr == 32'hBEE8 && cif.dstore == 32'hBEEF) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(posedge CLK);
      cif.dload = 32'hD00D00;
      cif.dwait = 0;
      @(posedge CLK);

      testcase++;
      command = "Hit and write to cache test 2";

      cif.dwait = 1;      
      @(negedge CLK);      

      if (dcif.dhit == 0 && cif.dWEN == 1 && cif.daddr == 32'hBEEC && cif.dstore == 32'h8888) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end

      @(posedge CLK);

      cif.dwait = 0;            
      cif.dload = 32'hBADF00D;
      testcase++;
      command = "Hit and write to cache test 2";
      

      @(negedge CLK);      

      if (dcif.dhit == 0 && cif.dWEN == 0 && cif.dREN == 1 && cif.daddr == (32'hBEE8 + 32'h40)) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end      

      @(posedge CLK);      
      cif.dwait = 1;            
      @(posedge CLK);
      cif.dwait = 0;
      cif.dload = 32'hB00B1E5;
      @(posedge CLK);
      cif.dwait = 1;            
      @(posedge CLK);
      cif.dwait = 0;            

      testcase++;
      command = "full cycle test wen and ren should be low";

      @(negedge CLK);      
      if (dcif.dhit == 0 && cif.dWEN == 0 && cif.dREN == 0) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end      

      @(posedge CLK);

      testcase++;
      command = "back to idle";

      @(negedge CLK);      

      if (dcif.dhit == 1 && cif.dWEN == 0 && cif.dREN == 0) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end      

      @(posedge CLK);            
      dcif.dmemWEN = 0;
      
      @(negedge CLK);
      
      if (dcif.dhit == 0 && cif.dWEN == 0 && cif.dREN == 0) begin
	 $display("@%00g test %d: %s pass!", $time, testcase, command);
      end
      else begin
	 $display("@%00g test %d: %s error!", $time, testcase, command);
      end      
      


      @(posedge CLK);
      dcif.halt = 1;
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);            
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);            
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);            
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);            

   end
      
      
endprogram
