`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface control_unit_if;
   
   import cpu_types_pkg::*;

   logic [FUNC_W-1:0] funct;
   logic [OP_W-1:0]   instructionOp;
   //logic 	      ihit,dhit;
   aluop_t aluCtrl;
   logic [1:0] 	      aluSrc;
   logic 	      regWrite;
   logic [1:0] 	      regDst;
   logic [1:0] 	      extension;
   logic 	      beqFlag, bneFlag, jumpFlag, jrFlag, halt;
   logic 	      dread, iread, dwrite;
   logic [2:0] 	      wbSel;
   logic 	      datomic;
   
   modport cu
     (
      input  instructionOp, funct,// ihit, dhit,
      output aluCtrl, aluSrc, regWrite, regDst, extension, beqFlag, bneFlag, jumpFlag, jrFlag, halt, dread, iread, dwrite, wbSel, datomic
      );
endinterface

`endif //CONTROL_UNIT_IF_VH
