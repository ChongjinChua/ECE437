`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface hazard_unit_if;
   
   import cpu_types_pkg::*;

   logic ifid_flush, idex_flush, ifid_en, idex_dread, branchFlag, jumpFlag, exmem_dread, exmem_dwrite;
   logic [REG_W-1:0]  ifid_rt;
   logic [REG_W-1:0]  ifid_rs;
   logic [REG_W-1:0]  idex_rt;
   logic 	      ahit;
   
   modport hu
     (
      input ifid_rt, ifid_rs, idex_rt, idex_dread, branchFlag, jumpFlag, exmem_dread, exmem_dwrite,
      output ifid_flush, idex_flush, ifid_en, ahit
      );

   modport tb
     (
      input  ifid_flush, idex_flush, ifid_en, ahit,
      output ifid_rt, ifid_rs, idex_rt, idex_dread, branchFlag, jumpFlag, exmem_dread, exmem_dwrite
      );
   
   
   
endinterface

`endif //HAZARD_UNIT_IF_VH
