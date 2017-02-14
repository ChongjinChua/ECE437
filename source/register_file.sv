
`include "register_file_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

module register_file
  (
   input logic CLK,
   input logic nRST,     
   register_file_if.rf rfif
   );

   logic [31:0][WORD_W-1:0] registers;

   always_ff @(negedge CLK, negedge nRST) begin
      if (!nRST) begin
	 registers <= '{default:'0};
      end else if (rfif.WEN && rfif.wsel) begin
	 registers[rfif.wsel] <= rfif.wdat;
      end
   end

   always_comb begin
      rfif.rdat1 = registers[rfif.rsel1];
      rfif.rdat2 = registers[rfif.rsel2];
   end

endmodule
   
