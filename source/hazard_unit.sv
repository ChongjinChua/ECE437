`include "hazard_unit_if.vh"

`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

module hazard_unit
  (
   hazard_unit_if.hu huif,
   forwarding_unit_if.hu fuif
   );
   
   
   always_comb begin
      huif.idex_flush = 0;
      huif.ifid_flush = 0;
      huif.ifid_en = 1;
      huif.ahit = 0;
      
      // If we are trying to load and our destination is used in next instr 
      if (huif.idex_dread && (huif.idex_rt == huif.ifid_rs || huif.idex_rt == huif.ifid_rt)) begin
	 huif.idex_flush = 1;
	 huif.ifid_en = 0;
      end

      if ((fuif.forwardA == 2'b01 | fuif.forwardB == 2'b01 | fuif.forwarddmemstore == 2'b01) && (huif.exmem_dread || huif.exmem_dwrite)) begin //handles ld/store in mem and wb to exec at the same time
	 huif.idex_flush = 1;
	 huif.ifid_en = 0;
	 huif.ahit = 1;
      end

      if (huif.branchFlag || huif.jumpFlag) begin
	 huif.ifid_flush = 1;
	 huif.idex_flush = 1;
      end
	      
   end
   
endmodule
   
