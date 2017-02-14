`ifndef EX_MEM_IF_VH
`define EX_MEM_IF_VH

`include "cpu_types_pkg.vh"

interface ex_mem_if;
   
   import cpu_types_pkg::*;

   logic flush, EN;
   
   //control unit
   logic regWrite_in, halt_in;
   logic beqFlag_in, bneFlag_in, jumpFlag_in, dread_in, dwrite_in;
   logic regWrite_out, halt_out;
   logic beqFlag_out, bneFlag_out, jumpFlag_out, dread_out, dwrite_out;
   logic [2:0] wbSel_in;
   logic [1:0] regDst_in;
   logic [2:0] wbSel_out;
   logic [1:0] regDst_out;
   logic       datomic_in, datomic_out;
   //ALU
   logic zeroFlag_in;
   logic [WORD_W-1:0] portOut_in;
   logic zeroFlag_out;
   logic [WORD_W-1:0] portOut_out;
   //others
   logic [WORD_W-1:0] jumpAddr_in, PC4_in, immExt_in;
   logic [REG_W-1:0]  rt_in,rd_in;
   logic [WORD_W-1:0] dmemstore_in;
   logic [WORD_W-1:0] jumpAddr_out, PC4_out, immExt_out;
   logic [REG_W-1:0]  rt_out,rd_out;
   logic [WORD_W-1:0] dmemstore_out;

   opcode_t opCode_in;
   opcode_t opCode_out;   
   funct_t funct_in;
   funct_t funct_out;

   modport latch
     (
      input  flush, EN, regDst_in, regWrite_in, halt_in, wbSel_in, beqFlag_in, bneFlag_in, jumpFlag_in, dread_in, dwrite_in, zeroFlag_in, portOut_in, jumpAddr_in, PC4_in, immExt_in, rt_in, rd_in, dmemstore_in, opCode_in, funct_in, datomic_in,
      output regDst_out, regWrite_out, halt_out, wbSel_out, beqFlag_out, bneFlag_out, jumpFlag_out, dread_out, dwrite_out, zeroFlag_out, portOut_out, jumpAddr_out, PC4_out, immExt_out, rt_out, rd_out, dmemstore_out, opCode_out, funct_out, datomic_out
      );

   modport fu
     (
      input regWrite_out, rd_out, rt_out, opCode_out, funct_out
      );
   
endinterface

`endif //EX_MEM_IF_VH
