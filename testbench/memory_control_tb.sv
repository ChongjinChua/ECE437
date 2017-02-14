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

module memory_control_tb;
  // clock period
  parameter PERIOD = 20;

  // signals
  logic CLK = 1, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
   caches_if cif0();
   caches_if cif1();
   cache_control_if #(.CPUS(2)) ccif(cif0, cif1);
   cpu_ram_if ramif();

   assign ccif.ramload = ramif.ramload;
   assign ccif.ramstate = ramif.ramstate;
   assign ramif.ramstore = ccif.ramstore;
   assign ramif.ramaddr = ccif.ramaddr;
   assign ramif.ramWEN = ccif.ramWEN;
   assign ramif.ramREN = ccif.ramREN;
   
  // test program
  test                                PROG (CLK,nRST,cif0,cif1);
   ram ramDUT (CLK, nRST, ramif);

  // dut
`ifndef MAPPED
   memory_control mcDUT (CLK,nRST,ccif);

`endif
   
endmodule

program test(input logic CLK, output logic nRST, caches_if cif0, caches_if cif1);
  // import word type
  import cpu_types_pkg::*;
   int 	testcase = 0;
   string command = "";

   initial begin
      nRST = 0;
      cif0.iaddr = 0;
      cif0.daddr = 32'hD09;
      cif0.iREN = 0;
      cif0.dREN = 0;
      cif0.dWEN = 0;
      cif0.dstore = 0;
      cif1.iaddr = 0;
      cif1.daddr = 0;
      cif1.iREN = 0;
      cif1.dREN = 0;
      cif1.dWEN = 0;
      cif1.dstore = 0;

      //ccif.ramstate = BUSY;
      
      @(posedge CLK);
      nRST = 1;
      @(posedge CLK);
      
      testcase = 1;
      command = "cif0 = I, cif1 = M, write to cif0";

      cif0.ccwrite = 1;
      cif0.cctrans = 1;
      cif0.dREN = 1;
      
      cif1.ccwrite = 0;
      cif1.cctrans = 0;
      
      @(posedge CLK);
      cif1.cctrans = 1;
      //ccinv[1] should be high
      
      @(posedge CLK);
      cif1.dWEN = 1;
      //c-c transfer
      //c-m transfer

      while(ccif.ramstate != ACCESS)
	@(posedge CLK);

      @(posedge CLK);      

      while(ccif.ramstate != ACCESS)
	@(posedge CLK);

      @(posedge CLK);

      //dREN[0] and dWEN[1] should be low
      cif1.dWEN = 0;
      cif0.dREN = 0;

      @(posedge CLK);
      @(posedge CLK);
      
      /*
      testcase = 1;
      command = "write 0xABCD to 0x0000";
      cif0.iaddr = 0;
      cif0.daddr = 0;
      cif0.iREN = 0;
      cif0.dREN = 0;
      cif0.dWEN = 1;
      cif0.dstore = 16'hABCD;
      @(negedge cif0.dwait);
      @(posedge CLK);
      #(memory_control_tb.PERIOD);
      cif0.dWEN = 0;
      @(posedge CLK);

      testcase = 2;
      command = "write 0xBEEF to 0x0004";      
      cif0.iaddr = 0;
      cif0.daddr = 4;
      cif0.iREN = 0;
      cif0.dREN = 0;
      cif0.dWEN = 1;
      cif0.dstore = 16'hBEEF;
      @(negedge cif0.dwait);
      @(posedge CLK);
      #(memory_control_tb.PERIOD);
      cif0.dWEN = 0;
      @(posedge CLK);

      testcase = 3;
      command = "read 0xABCD from 0x0000";      
      cif0.iaddr = 0;
      cif0.daddr = 0;
      cif0.iREN = 0;
      cif0.dREN = 1;
      cif0.dWEN = 0;
      cif0.dstore = 16'h0000;
      @(negedge cif0.dwait);
      @(posedge CLK);
      #(memory_control_tb.PERIOD);
      cif0.dREN = 0;
      @(posedge CLK);

      testcase = 4;
      command = "read 0xBEEF from 0x0004";      
      cif0.iaddr = 4;
      cif0.daddr = 0;
      cif0.iREN = 1;
      cif0.dREN = 0;
      cif0.dWEN = 0;
      cif0.dstore = 16'h0000;
      @(negedge cif0.iwait);
      @(posedge CLK);
      #(memory_control_tb.PERIOD);
      cif0.iREN = 0;
      @(posedge CLK);

      testcase = 5;
      command = "write 0xFFFF to 0x0008 and read from 0x0008";      
      cif0.iaddr = 8;
      cif0.daddr = 8;
      cif0.iREN = 1;
      cif0.dREN = 0;
      cif0.dWEN = 1;
      cif0.dstore = 16'hFFFF;
      @(negedge cif0.dwait);
      @(posedge CLK);
      #(memory_control_tb.PERIOD);
      
      cif0.dWEN = 0;
      
      @(negedge cif0.iwait);
      @(posedge CLK);
      #(memory_control_tb.PERIOD);
      cif0.iREN = 0;
      @(posedge CLK);      
      @(posedge CLK);
       */
//      dump_memory();
      

  end

  task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    cif0.daddr = 0;
    cif0.iaddr = 0;     
    cif0.dWEN = 0;
    cif0.iREN = 0;
    cif0.dREN = 0;
     cif0.dstore = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      cif0.daddr = i << 2;
      cif0.dREN = 1;
      repeat (4) @(posedge CLK);
      if (cif0.dload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,cif0.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif0.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
       
    end //for
     $display("Finished memory dump.");
    if (memfd)
    begin
      cif0.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask
      
endprogram
