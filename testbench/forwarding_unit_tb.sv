/*
  Michael Malachowski
  mg262
  ECE437
  Forwarding Unit test bench
*/

// mapped needs this
`include "forwarding_unit_if.vh"
`include "cpu_types_pkg.vh"
  
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module forwarding_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST; 
   
   
  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
   hazard_unit_if huif ();
   id_ex_if idex ();
   ex_mem_if exmem ();
   mem_wb_if memwb ();
      
  // test program
  test #(.PERIOD (PERIOD)) PROG (
    .CLK,
    .nRST,
    .fuif,
    .idex,
    .exmem,
    .memwb
  );
   
  // DUT
`ifndef MAPPED
  forwarding_unit DUT(fuif, idex, exmem, memwb);
`else
  request_unit DUT(
    .\fuif.forwardA (fuif.forwardA),
    .\fuif.forwardB (fuif.forwardB),
    .\fuif.forwarddmemstore (fuif.forwarddmemstore),
    .\idex.opCode_out (idex.opCode_out),
    .\idex.funct_out (idex.funct_out),
    .\idex. (idex.),
    .\idex. (idex.),
    .\idex. (idex.),
    .\idex. (idex.),
    .\idex. (idex.),
    .\exmem. (exmem.),
    .\exmem. (exmem.),		   
    .\exmem. (exmem.),		   
    .\exmem. (exmem.),		   
    .\exmem. (exmem.),		   		   
    .\memwb. (memwb.),
    .\memwb. (memwb.),		   
    .\memwb. (memwb.),		   
    .\memwb. (memwb.),		   
    .\memwb. (memwb.)		   
    
  );
`endif

endmodule

program test(
  input logic  CLK,
  output logic nRST,
  hazard_unit_if.tb huif,
  forwarding_unit_if.tb fuif
);
   parameter PERIOD = 10;
     // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;
 import cpu_types_pkg::*;
   
   initial begin

      nRST = 0;
      #(PERIOD)
      #(PERIOD)
      nRST = 1;
            
      huif.idex_dread = 0;
      huif.idex_rt = 0;
      huif.ifid_rs = 1;
      huif.ifid_rt = 2;
      fuif.forwardA = 0;
      fuif.forwardB = 0;
      fuif.forwarddmemstore = 0;
      huif.exmem_dread = 0;
      huif.exmem_dwrite = 0;
      huif.branchFlag = 0;
      huif.jumpFlag = 0;
                  
      #(PERIOD)



      /*
       * Branch/Jump Test
       */
      
      huif.jumpFlag = 0;
      
      #(PERIOD)
      if (huif.ifid_flush == 0 && huif.idex_flush == 0) begin
	 $display("@%00g no jump/no branch test pass!", $time);
      end
      else begin
	 $error("@%00g no jump/no branch test fail!", $time);
      end

      huif.jumpFlag = 1;
      
      #(PERIOD)
      if (huif.ifid_flush == 1 && huif.idex_flush == 1) begin
	 $display("@%00g jumpFlag test pass!", $time);
      end
      else begin
	 $error("@%00g jumpFlag test fail!", $time);
      end

      huif.branchFlag = 1;
      huif.jumpFlag = 0;
      
      #(PERIOD)
      if (huif.ifid_flush == 1 && huif.idex_flush == 1) begin
	 $display("@%00g branchFlag test pass!", $time);
      end
      else begin
	 $error("@%00g branchFlag test fail!", $time);
      end

      huif.jumpFlag = 0;
      huif.branchFlag = 0;



      /*
       * EX Bubble test
       */

      fuif.forwardA = 2'b01;
      fuif.forwardB = 0;
      fuif.forwarddmemstore = 0;
      huif.exmem_dread = 0;
      huif.exmem_dwrite = 1;
            
      #(PERIOD)
      if (huif.idex_flush == 1 && huif.ifid_en == 0 && huif.ahit == 1) begin
	 $display("@%00g EX Bubble on SW and FWD A from WB test pass!", $time);
      end
      else begin
	 $error("@%00g EX Bubble on SW and FWD A from WB test fail!", $time);
      end

      fuif.forwardA = 0;
      fuif.forwardB = 2'b10;
      fuif.forwarddmemstore = 0;
      huif.exmem_dread = 1;
      huif.exmem_dwrite = 0;
            
      #(PERIOD)
      if (huif.idex_flush == 0 && huif.ifid_en == 1 && huif.ahit == 0) begin
	 $display("@%00g No EX Bubble on LW and FWD B from MEM test pass!", $time);
      end
      else begin
	 $error("@%00g No EX Bubble on LW and FWD B from MEM test fail!", $time);
      end

      fuif.forwardA = 0;
      fuif.forwardB = 0;
      fuif.forwarddmemstore = 2'b01;
      huif.exmem_dread = 1;
      huif.exmem_dwrite = 0;
                  
      #(PERIOD)
      if (huif.idex_flush == 1 && huif.ifid_en == 0 && huif.ahit == 1) begin
	 $display("@%00g EX Bubble on LW and FWD dmemstore from WB test pass!", $time);
      end
      else begin
	 $error("@%00g EX Bubble on LW and FWD dmemstore from WB test fail!", $time);
      end

      fuif.forwardA = 2'b10;
      fuif.forwardB = 2'b10;
      fuif.forwarddmemstore = 2'b10;
      huif.exmem_dread = 1;
      huif.exmem_dwrite = 0;
                  
      #(PERIOD)
      if (huif.idex_flush == 0 && huif.ifid_en == 1 && huif.ahit == 0) begin
	 $display("@%00g No EX Bubble on LW and FWD all from MEM test pass!", $time);
      end
      else begin
	 $error("@%00g No EX Bubble on LW and FWD all from MEM test fail!", $time);
      end


      fuif.forwardA = 0;
      fuif.forwardB = 0;
      fuif.forwarddmemstore = 0;
      huif.exmem_dread = 0;
      huif.exmem_dwrite = 0;

      
      /*
       * Load-Use Hazard Test
       */

      huif.idex_dread = 0;
      huif.idex_rt = 0;
      huif.ifid_rs = 1;
      huif.ifid_rt = 2;
                  
      #(PERIOD)
      if (huif.idex_flush == 0 && huif.ifid_en == 1) begin
	 $display("@%00g No LU Hazard test pass!", $time);
      end
      else begin
	 $error("@%00g No LU Hazard test fail!", $time);
      end

      huif.idex_dread = 0;
      huif.idex_rt = 2;
      huif.ifid_rs = 2;
      huif.ifid_rt = 2;
                  
      #(PERIOD)
      if (huif.idex_flush == 0 && huif.ifid_en == 1) begin
	 $display("@%00g No LU Hazard with dependent instr test pass!", $time);
      end
      else begin
	 $error("@%00g No LU Hazard with dependent instr test fail!", $time);
      end
      
      huif.idex_dread = 1;
      huif.idex_rt = 0;
      huif.ifid_rs = 1;
      huif.ifid_rt = 2;
                  
      #(PERIOD)
      if (huif.idex_flush == 0 && huif.ifid_en == 1) begin
	 $display("@%00g No LU hazard - LW with no dependence test pass!", $time);
      end
      else begin
	 $error("@%00g No LU Hazard - LW with no dependence test fail!", $time);
      end

      huif.idex_dread = 1;
      huif.idex_rt = 2;
      huif.ifid_rs = 1;
      huif.ifid_rt = 2;
                  
      #(PERIOD)
      if (huif.idex_flush == 1 && huif.ifid_en == 0) begin
	 $display("@%00g LU Hazard with dependence from rt test pass!", $time);
      end
      else begin
	 $error("@%00g LU hazard with dependence from rt test fail!", $time);
      end

      huif.idex_dread = 1;
      huif.idex_rt = 1;
      huif.ifid_rs = 2;
      huif.ifid_rt = 1;
                  
      #(PERIOD)
      if (huif.idex_flush == 1 && huif.ifid_en == 0) begin
	 $display("@%00g LU Hazard with dependence from rs test pass!", $time);
      end
      else begin
	 $error("@%00g LU hazard with dependence from rs test fail!", $time);
      end

      huif.idex_dread = 1;
      huif.idex_rt = 3;
      huif.ifid_rs = 3;
      huif.ifid_rt = 3;
                  
      #(PERIOD)
      if (huif.idex_flush == 1 && huif.ifid_en == 0) begin
	 $display("@%00g LU Hazard with dependence from rt and rs test pass!", $time);
      end
      else begin
	 $error("@%00g LU hazard with dependence from rt and rs test fail!", $time);
      end

      huif.idex_dread = 0;
      huif.idex_rt = 0;
      huif.ifid_rs = 0;
      huif.ifid_rt = 0;
                  
      #(PERIOD)
      
      $finish;    
   end   
endprogram
