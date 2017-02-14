`include "forwarding_unit_if.vh"

`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

module forwarding_unit
  (
   forwarding_unit_if.fu fuif,
   id_ex_if.fu idex,
   ex_mem_if.fu exmem,
   mem_wb_if.fu memwb
   );
/*
   opcode_t opCode_inUse;
   logic [FUNC_W-1:0] funct_inUse;
   logic [FUNC_W-1:0] exmem_funct;
   logic [FUNC_W-1:0] memwb_funct;

   logic mem_forwardActive;
   logic wb_forwardActive;   
   logic [REG_W-1:0] reg_rt;
   logic [REG_W-1:0] reg_rs;   
   logic [REG_W-1:0] reg_forward;
*/
   logic 	     rd_dest_mem;
   logic 	     rt_dest_mem;
   logic 	     rd_dest_wb;
   logic 	     rt_dest_wb;
   logic [REG_W-1:0] exmem_dest;
   logic [REG_W-1:0] memwb_dest;
   logic 	     rs_src;
   logic 	     rt_src;
   
   assign rd_dest_mem = (exmem.opCode_out == RTYPE && exmem.regWrite_out && exmem.rd_out != 0);
   assign rt_dest_mem = (exmem.opCode_out != RTYPE && exmem.regWrite_out && exmem.opCode_out != JAL);   
   assign rd_dest_wb = (memwb.opCode_out == RTYPE && memwb.regWrite_out && memwb.rd_out != 0);
   assign rt_dest_wb = (memwb.opCode_out != RTYPE && memwb.regWrite_out && memwb.opCode_out != JAL);
   assign rs_src = ((idex.opCode_out == RTYPE && idex.funct_out == JR) || (idex.opCode_out == RTYPE && idex.funct_out != JR && idex.rd_out != 0) || (idex.opCode_out != RTYPE && idex.opCode_out != LUI && idex.opCode_out != J && idex.opCode_out != JAL)) && idex.rs_out != 0;
   assign rt_src = ((idex.opCode_out == RTYPE && idex.funct_out != JR && idex.funct_out != SLL && idex.funct_out != SRL) || (idex.opCode_out == BEQ || idex.opCode_out == BNE || idex.opCode_out == SW || idex.opCode_out == SC)) && idex.rt_out != 0;
   

   always_comb begin
      exmem_dest = 0;
      memwb_dest = 0;
      fuif.forwardA = 2'b00;
      fuif.forwardB = 2'b00;
      fuif.forwarddmemstore = 2'b00;

      if(rd_dest_mem)
	exmem_dest = exmem.rd_out;
      else if(rt_dest_mem)
	exmem_dest = exmem.rt_out;

      if(rd_dest_wb)
	memwb_dest = memwb.rd_out;
      else if(rt_dest_wb)
	memwb_dest = memwb.rt_out;
    
      if(rt_src) begin
	 if(idex.rt_out == exmem_dest) begin
	   if(idex.opCode_out == SC || idex.opCode_out == SW) begin
	     if(exmem.opCode_out == SC)
	       fuif.forwarddmemstore = 2'b11;
	     else
	       fuif.forwarddmemstore = 2'b10;
	   end else
              fuif.forwardB = 2'b10;
	 end
	else if(idex.rt_out == memwb_dest) begin
          if(idex.opCode_out == SW || idex.opCode_out == SC)
            fuif.forwarddmemstore = 2'b01;
//	  else if(idex.opCode_out == SC)
//            fuif.forwarddmemstore = 2'b11;	     
	  else
            fuif.forwardB = 2'b01;
	end
      end

      if(rs_src) begin
	if(idex.rs_out == exmem_dest) 
          fuif.forwardA = 2'b10;
	else if(idex.rs_out == memwb_dest)
          fuif.forwardA = 2'b01;
      end      

   end
endmodule
   
