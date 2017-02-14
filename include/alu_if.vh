`ifndef ALU_IF_VH
`define ALU_IF_VH

`include "cpu_types_pkg.vh"

interface alu_if;
   import cpu_types_pkg::*;

   aluop_t ops;
   word_t portA, portB, portOut;
   logic negativeFlag, zeroFlag, overflowFlag;

   modport alu
     (
      input portA, portB, ops,
      output portOut, negativeFlag, zeroFlag, overflowFlag
      );
   
   modport tb
     (
      input portOut, negativeFlag, zeroFlag, overflowFlag,
      output portA, portB, ops
      );
endinterface

`endif //ALU_IF_VH
