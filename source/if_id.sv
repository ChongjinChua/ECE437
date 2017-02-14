
// data path interface
`include "if_id_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module if_id
  (
   input logic CLK, nRST,
   if_id_if.latch ifid
   );
   // import types
   import cpu_types_pkg::*;

   // Instr. Fetch
   always_ff @(posedge CLK, negedge nRST) begin
      if(!nRST) begin
	 ifid.PC4_out <= 0;
	 ifid.instr_out <= 0;
      end else if (ifid.flush) begin
	 ifid.PC4_out <= 0;
	 ifid.instr_out <= 0;
      end else if(ifid.EN) begin
	 ifid.PC4_out <= ifid.PC4_in;
	 ifid.instr_out <= ifid.instr_in;
      end else begin
	 ifid.PC4_out <= ifid.PC4_out;
	 ifid.instr_out <= ifid.instr_out;
      end
   end

endmodule
