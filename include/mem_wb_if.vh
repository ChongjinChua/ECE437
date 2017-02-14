`ifndef MEM_WB_IF_VH
`define MEM_WB_IF_VH

`include "cpu_types_pkg.vh"

interface mem_wb_if;
   
   import cpu_types_pkg::*;

   logic flush, EN;
   
   //control unit
   logic regWrite_in, halt_in;
   logic regWrite_out, halt_out;
   logic [1:0] regDst_in, regDst_out;
   logic [2:0] wbSel_in, wbSel_out;
	      
   //ALU
   logic [WORD_W-1:0] portOut_in;
   logic [WORD_W-1:0] portOut_out;
   //others
   logic [WORD_W-1:0] PC4_in, immExt_in;
   logic [REG_W-1:0]  rt_in,rd_in;
   logic [WORD_W-1:0] dmemload_in;
   logic [WORD_W-1:0] PC4_out, immExt_out;
   logic [REG_W-1:0]  rt_out,rd_out;
   logic [WORD_W-1:0] dmemload_out;
   logic 	      scStatus_in, scStatus_out;

   opcode_t opCode_in;
   opcode_t opCode_out;   
   funct_t funct_in;
   funct_t funct_out;

   modport latch
     (
      input  flush, EN, regDst_in, regWrite_in, halt_in, wbSel_in, portOut_in, PC4_in, immExt_in, rt_in, rd_in, dmemload_in, opCode_in, funct_in, scStatus_in,
      output regDst_out, regWrite_out, halt_out, wbSel_out, portOut_out, PC4_out, immExt_out, rt_out, rd_out, dmemload_out, opCode_out, funct_out, scStatus_out
      );

   modport fu
     (
      input regWrite_out, rd_out, rt_out, opCode_out, funct_out
      );
   

   
endinterface

`endif //MEM_WB_IF_VH
