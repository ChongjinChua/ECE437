`ifndef ID_EX_IF_VH
`define ID_EX_IF_VH

`include "cpu_types_pkg.vh"

interface id_ex_if;
   
   import cpu_types_pkg::*;

   logic flush, EN;
   
   logic [WORD_W-1:0] rdat1_in, rdat2_in, immExt_in, PC4_in, shamt_in, jumpAddr_in;
   logic [WORD_W-1:0] rdat1_out, rdat2_out, immExt_out, PC4_out, shamt_out, jumpAddr_out;

   logic [REG_W-1:0]  rt_in, rd_in, rs_in;
   logic [REG_W-1:0]  rt_out, rd_out, rs_out;

   logic 	      regWrite_in, dwrite_in, dread_in, halt_in, jumpFlag_in, beqFlag_in, bneFlag_in;
   logic 	      regWrite_out, dwrite_out, dread_out, halt_out, jumpFlag_out, beqFlag_out, bneFlag_out;
   
   logic [1:0] 	      aluSrc_in, regDst_in;
   logic [2:0] wbSel_in;
   logic [1:0] 	      aluSrc_out, regDst_out;
   logic [2:0] wbSel_out;

   logic 	      datomic_in, datomic_out;

   opcode_t opCode_in;
   opcode_t opCode_out;   
   funct_t funct_in;
   funct_t funct_out;
   
   aluop_t aluOp_in;
   aluop_t aluOp_out;

   modport latch
     (
      input flush, EN, rdat1_in, rdat2_in, immExt_in, PC4_in, shamt_in, jumpAddr_in, rt_in, rd_in, rs_in, regWrite_in, dwrite_in, dread_in, halt_in, aluSrc_in, regDst_in, wbSel_in, aluOp_in, jumpFlag_in, beqFlag_in, bneFlag_in, opCode_in, funct_in, datomic_in,
      output rdat1_out, rdat2_out, immExt_out, PC4_out, shamt_out, jumpAddr_out, rt_out, rd_out, rs_out, regWrite_out, dwrite_out, dread_out, halt_out,aluSrc_out, regDst_out, wbSel_out, aluOp_out, jumpFlag_out, beqFlag_out, bneFlag_out, opCode_out, funct_out, datomic_out
      );

   modport fu
     (
      input rt_out, rs_out, opCode_out, funct_out, rd_out
      );
   
   
endinterface

`endif //ID_EX_IF_VH
