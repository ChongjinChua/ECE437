
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

module request_unit
  (
   input logic CLK,
   input logic nRST,     
   input logic iread,dread,dwrite,
   input logic ihit,dhit,
   output logic iren,dren,dwen
   );

   always_ff @(posedge CLK, negedge nRST) begin
      if (!nRST) begin
	 iren <= 0;
	 dren <= 0;
	 dwen <= 0;
      end else begin
	 iren <= iread; //always high
	 if (ihit) begin //
	    dren <= dread;
	    dwen <= dwrite;
	 end else if (dhit) begin
	    dren <= 0;
	    dwen <= 0;
	 end else begin
	    dren <= dren;
	    dwen <= dwen;
	 end
      end
   end

endmodule
   
