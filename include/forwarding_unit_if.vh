`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface forwarding_unit_if;
   
   import cpu_types_pkg::*;

   logic [1:0] forwardA, forwardB, forwarddmemstore;
   
   modport fu
     (
      output forwardA, forwardB, forwarddmemstore
      );

   modport hu
      (
       input forwardA, forwardB, forwarddmemstore      
       );

   modport tb
      (
       input forwardA, forwardB, forwarddmemstore      
       );
   
   
endinterface

`endif //FORWARDING_UNIT_IF_VH
