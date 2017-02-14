`ifndef IF_ID_IF_VH
`define IF_ID_IF_VH

`include "cpu_types_pkg.vh"

interface if_id_if;
   
   import cpu_types_pkg::*;

   logic flush, EN;
   logic [WORD_W-1:0] instr_in, PC4_in;
   logic [WORD_W-1:0] instr_out, PC4_out;
   

   modport latch
     (
      input instr_in, PC4_in, flush, EN,
      output instr_out, PC4_out
      );

endinterface

`endif //IF_ID_IF_VH
