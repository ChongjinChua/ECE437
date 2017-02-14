`include "cpu_types_pkg.vh"
`include "alu_if.vh"

import cpu_types_pkg::*;

module alu
  (
   alu_if aluIf
   );

   always_comb begin
      aluIf.overflowFlag = 1'b0;

      casez (aluIf.ops)
	ALU_SLL: aluIf.portOut = aluIf.portA << aluIf.portB;
	ALU_SRL: aluIf.portOut = aluIf.portA >> aluIf.portB;
	ALU_ADD:
	  begin
	   aluIf.portOut = $signed(aluIf.portA) + $signed(aluIf.portB);
	   //(+A)+(+B)=-C
	   //(-A)+(-B)=+C	   
	   if ((!aluIf.portA[31] && !aluIf.portB[31] && aluIf.portOut[31]) ||
	       (aluIf.portA[31] && aluIf.portB[31] && !aluIf.portOut[31]))
	      aluIf.overflowFlag = 1'b1;
	  end
	ALU_SUB:
	  begin
	   aluIf.portOut = $signed(aluIf.portA) - $signed(aluIf.portB);
	   //(+A)-(-B)=-C
	   //(-A)-(+B)=+C	   
	   if ((!aluIf.portA[31] && aluIf.portB[31] && aluIf.portOut[31]) ||
	       (aluIf.portA[31] && !aluIf.portB[31] && !aluIf.portOut[31])) begin
	      aluIf.overflowFlag = 1'b1;
	   end
	  end
	ALU_AND: aluIf.portOut = aluIf.portA & aluIf.portB;
	ALU_OR : aluIf.portOut = aluIf.portA | aluIf.portB;
	ALU_XOR: aluIf.portOut = aluIf.portA ^ aluIf.portB;
	ALU_NOR: aluIf.portOut = ~(aluIf.portA | aluIf.portB);
	ALU_SLT: aluIf.portOut = ($signed(aluIf.portA) < $signed(aluIf.portB)) ? 32'd1 : 32'd0;
	ALU_SLTU: aluIf.portOut = (aluIf.portA < aluIf.portB) ? 32'd1 : 32'd0;
      endcase

      aluIf.negativeFlag = 1'd0;
      aluIf.zeroFlag = 1'd0;

      if (aluIf.portOut[31]) begin
	 aluIf.negativeFlag = 1'd1;
      end else if (aluIf.portOut == 32'd0) begin
	 aluIf.zeroFlag = 1'd1;
      end
      
   end

endmodule
