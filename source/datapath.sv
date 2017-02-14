/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath
  (
   input logic CLK, nRST,
   datapath_cache_if.dp dpif
   );
   // import types
   import cpu_types_pkg::*;

   // pc init
   parameter PC_INIT = 0;

   alu_if aluif();
   register_file_if rfif();
   if_id_if ifid();
   id_ex_if idex();
   ex_mem_if exmem();
   mem_wb_if memwb();
   control_unit_if cuif();
   hazard_unit_if huif();
   forwarding_unit_if fuif();
      
   opcode_t opCode;
   funct_t funct;
   
   logic [REG_W-1:0] rs;
   logic [REG_W-1:0] rt;
   logic [REG_W-1:0] rd;
   logic [IMM_W-1:0] imm;
   logic [SHAM_W-1:0] shamt;
   logic [WORD_W-1:0] PC, PC4, interPC, nextPC, wbData, branchAddr;
   logic [27:0]       jAddr;
   logic 	      branchFlag;

   assign opCode[OP_W-1:0] = ifid.instr_out[31:26];
   assign rs = ifid.instr_out[25:21];
   assign rt = ifid.instr_out[20:16];
   assign rd = ifid.instr_out[15:11];
   assign imm = ifid.instr_out[15:0];
   assign shamt = ifid.instr_out[10:6];
   assign funct[FUNC_W-1:0] = ifid.instr_out[5:0];
   assign jAddr = ifid.instr_out[27:0];

   /*
    * Instruction Fetch Stage
    */

   assign PC4 = PC + 4;
   assign ifid.PC4_in = PC4;
   assign ifid.instr_in = dpif.imemload;
   //assign interPC = (exmem.jumpFlag_out) ? exmem.jumpAddr_out : PC4;
   assign interPC = (idex.jumpFlag_out) ? idex.jumpAddr_out : PC4;
   assign branchAddr = (idex.PC4_out + (idex.immExt_out << 2));
   assign nextPC = (branchFlag) ? branchAddr : interPC;
   assign dpif.imemaddr = PC;
   
   /*
    * Instruction Decode Stage
    */

   assign cuif.instructionOp = opCode;
   assign cuif.funct = funct;
   assign dpif.imemREN = cuif.iread;

   always_comb begin
      casez (cuif.extension)      
	2'b00: idex.immExt_in = {16'h0000,imm};
	2'b01: idex.immExt_in = (imm[15] == 1'b1) ? {16'hFFFF,imm} : {16'h0000,imm};
	2'b10: idex.immExt_in = {imm,16'h0000};
	2'b11: idex.immExt_in = {32'hDEADBEEF}; //error
      endcase
   end
   
   always_comb begin
      casez (memwb.regDst_out)
	2'b00: rfif.wsel = memwb.rt_out;
	2'b01: rfif.wsel = memwb.rd_out;
	2'b10: rfif.wsel = 5'd31;
	2'b11: rfif.wsel = 5'd21; //error
      endcase
   end
   
   assign rfif.WEN = memwb.regWrite_out;
   assign rfif.rsel1 = rs;
   assign rfif.rsel2 = rt;

   assign idex.jumpAddr_in = (cuif.jrFlag) ? rfif.rdat1 : {nextPC[31:28],jAddr << 2};
   assign idex.opCode_in = opCode;
   assign idex.funct_in = funct;
   assign idex.datomic_in = cuif.datomic;
   
   /*
    * Execute Stage
    */

   assign aluif.ops = idex.aluOp_out;

   always_comb begin
      casez (fuif.forwardA)
	2'b00: aluif.portA = idex.rdat1_out;
	2'b01: aluif.portA = wbData;
	2'b10: aluif.portA = exmem.portOut_out;
	default: aluif.portA = 32'hBAD2BAD2;
      endcase
   end

   always_comb begin
      casez (fuif.forwardB)
	2'b00: aluif.portB = (idex.aluSrc_out == 2'b10) ? idex.shamt_out :
			     (idex.aluSrc_out == 2'b01) ? idex.immExt_out :
			     (idex.aluSrc_out == 2'b00) ? idex.rdat2_out :
			     idex.rdat2_out;
	2'b01: aluif.portB = wbData;
	2'b10: aluif.portB = exmem.portOut_out;
	default: aluif.portB = 32'hBAD2BAD2;
      endcase // casez (fuif.forwardB)

      //exmem.dmemstore_in = idex.rdat2_out;
      casez (fuif.forwarddmemstore)
	2'b00: exmem.dmemstore_in = idex.rdat2_out;
	2'b01: exmem.dmemstore_in = wbData;
	2'b10: exmem.dmemstore_in = exmem.portOut_out;
	2'b11: exmem.dmemstore_in = {31'b0,dpif.scValid};
      endcase // casez (fuif.forwarddmemstore)
            
   end
   
   assign exmem.opCode_in = idex.opCode_out;
   assign exmem.funct_in = idex.funct_out;

   assign branchFlag = (idex.bneFlag_out & ~aluif.zeroFlag) | (idex.beqFlag_out & aluif.zeroFlag);

   /*
    * Memory Stage
    */

   assign dpif.dmemaddr = exmem.portOut_out;
   assign dpif.dmemstore = exmem.dmemstore_out;
   assign dpif.dmemREN = exmem.dread_out;
   assign dpif.dmemWEN = exmem.dwrite_out;
   
   assign memwb.opCode_in = exmem.opCode_out;
   assign memwb.funct_in = exmem.funct_out;

   assign dpif.datomic = exmem.datomic_out;
   assign memwb.scStatus_in = dpif.scValid;
   
   /*
    * Write Back Stage
    */

   always_ff @(posedge CLK, negedge nRST) begin
      if(!nRST) begin
	dpif.halt <= 0;
      end else begin
	if(memwb.halt_out) begin
	   dpif.halt <= 1;
	end else begin
	   dpif.halt <= dpif.halt;
	end
      end
   end
   
   always_comb begin
      casez (memwb.wbSel_out)
	3'b000: wbData = memwb.portOut_out;
	3'b001: wbData = memwb.dmemload_out;
	3'b010: wbData = memwb.PC4_out;
	3'b011: wbData = memwb.immExt_out;
	3'b100: wbData = {31'b0,memwb.scStatus_out};
	default:wbData = 32'hBAD1BAD1;
      endcase
   end

   assign rfif.wdat = wbData;
   
   
   always_ff @(posedge CLK, negedge nRST) begin
      if (!nRST) begin
	 PC <= PC_INIT;
      end else if ((dpif.ihit & ~((exmem.dread_out|exmem.dwrite_out)) & huif.ifid_en) | (dpif.ihit & ~((exmem.dread_out|exmem.dwrite_out)) & idex.jumpFlag_out)) begin
	 PC <= nextPC;
      end else begin
	 PC <= PC;
      end
   end

   alu ALU
     (
      aluif
      );

   register_file REGISTER_FILE
     (
      CLK,
      nRST,
      rfif
      );

   control_unit CONTROL_UNIT
     (
      cuif
      );

   if_id IF_ID
     (
      .CLK(CLK),
      .nRST(nRST),
      .ifid(ifid)
      );

   always_comb begin
      ifid.flush = huif.ifid_flush;
      ifid.EN = huif.ifid_en & dpif.ihit & ~((exmem.dread_out|exmem.dwrite_out));
   end
      
   id_ex ID_EX
     (
      .CLK(CLK),
      .nRST(nRST),
      .idex(idex)
      );

   // idex inputs
   always_comb begin
      //don't flush if we are disabled
      idex.flush = (huif.idex_flush & dpif.ihit & ~((exmem.dread_out|exmem.dwrite_out))) | (huif.ahit & dpif.dhit);
      idex.EN = dpif.ihit & ~((exmem.dread_out|exmem.dwrite_out));

      idex.regDst_in = cuif.regDst;
      idex.regWrite_in = cuif.regWrite;
      idex.halt_in = cuif.halt;
      idex.wbSel_in = cuif.wbSel;

      idex.jumpFlag_in = cuif.jumpFlag;
      idex.dwrite_in = cuif.dwrite;
      idex.dread_in = cuif.dread;
      idex.beqFlag_in = cuif.beqFlag;
      idex.bneFlag_in = cuif.bneFlag;

      idex.aluSrc_in = cuif.aluSrc;
      idex.aluOp_in = cuif.aluCtrl;

      //jumpAddr at top
      idex.PC4_in = ifid.PC4_out;
      //immExt handled at top
      idex.rdat1_in = rfif.rdat1;
      idex.rdat2_in = rfif.rdat2;
      idex.shamt_in = {27'b0,shamt};
      idex.rt_in = rt;
      idex.rd_in = rd;
      idex.rs_in = rs;
      
   end // always_comb
   
   
   ex_mem EX_MEM
     (
      .CLK(CLK),
      .nRST(nRST),
      .exmem(exmem)
      );

   // exmem inputs
   always_comb begin
      exmem.flush = dpif.dhit & ~huif.ahit;
      exmem.EN = (dpif.dhit|(dpif.ihit & ~((exmem.dread_out|exmem.dwrite_out)))) | (huif.ahit & dpif.dhit);
      
      exmem.regDst_in = idex.regDst_out;
      exmem.regWrite_in = idex.regWrite_out;
      exmem.halt_in = idex.halt_out;
      exmem.wbSel_in = idex.wbSel_out;
      
      //exmem.jumpFlag_in = idex.jumpFlag_out;
      exmem.dread_in = idex.dread_out;
      exmem.dwrite_in = idex.dwrite_out;
      exmem.beqFlag_in = idex.beqFlag_out;
      exmem.bneFlag_in = idex.bneFlag_out;

      //exmem.jumpAddr_in = idex.jumpAddr_out;
      
      exmem.zeroFlag_in = aluif.zeroFlag;
      exmem.portOut_in = aluif.portOut;

      exmem.PC4_in = idex.PC4_out;
      exmem.immExt_in = idex.immExt_out;

      //exmem.dmemstore_in = idex.rdat2_out;
      
      exmem.rt_in = idex.rt_out;
      exmem.rd_in = idex.rd_out;
      exmem.datomic_in = idex.datomic_out;
      
   end
      
   mem_wb MEM_WB
     (
     .CLK(CLK),
     .nRST(nRST),
     .memwb(memwb)
      );

   always_comb begin
      memwb.EN = ((dpif.ihit & ~((exmem.dread_out|exmem.dwrite_out)))|dpif.dhit) | (huif.ahit & dpif.dhit);
      memwb.flush = 0;

      memwb.regDst_in = exmem.regDst_out;
      memwb.regWrite_in = exmem.regWrite_out;
      memwb.halt_in = exmem.halt_out;
      memwb.wbSel_in = exmem.wbSel_out;
      
      memwb.portOut_in = exmem.portOut_out;
      memwb.dmemload_in = dpif.dmemload;
      memwb.PC4_in = exmem.PC4_out;
      memwb.immExt_in = exmem.immExt_out;
		    
      memwb.rt_in = exmem.rt_out;
      memwb.rd_in = exmem.rd_out;
      
   end // always_comb

   hazard_unit HU
     (
      .huif(huif),
      .fuif(fuif)
      );

   always_comb begin
      huif.idex_dread = idex.dread_out;
      huif.exmem_dread = exmem.dread_out;
      huif.exmem_dwrite = exmem.dwrite_out;      
      huif.idex_rt = idex.rt_out;
      huif.ifid_rs = rs;
      huif.ifid_rt = rt;
      huif.branchFlag = branchFlag;
      huif.jumpFlag = idex.jumpFlag_out;
   end

   forwarding_unit FU
     (
      .fuif(fuif),
      .idex(idex),
      .exmem(exmem),
      .memwb(memwb)
      );

   //fuif comb logic above

endmodule
