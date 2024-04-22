module Pipeline_Computer#(parameter WIDTH=32)(
	input clk,
	input reset,
	input [3:0] debug_reg_select, 
	output [31:0] debug_reg_out,
	output [31:0] PCFetch
);

wire PCSrcW;
wire [1:0] RegSrcD;
wire [1:0] ImmSrcD;
wire ALUSrcE;
wire  RegWriteW;
wire [3:0] ALUControlE;
wire MemWriteM;
wire BranchTakenE;



wire [3:0] Cond;
wire [1:0] Op;
wire [5:0] Funct;

wire [1:0] ALUSrcB;
wire [3:0] RA1, RA2;
wire [3:0] State_reg;
wire [WIDTH-1:0] Rd1,Rd2,ALU_RESULT,Instruction,Result,SRC_A,SRC_B,Instr_read,Instr_write;
wire  Z_FLAG,Write_Z_ENABLE;


Controller_unit my_controller(
	.clk(clk),
	.reset(reset),
	.Op(Op),
	.Funct(Funct),
	.Cond(Cond),
	.Z_FLAG(Z_FLAG),
	
	.RegSrcD(RegSrcD),
	.ImmSrcD(ImmSrcD),
	.ALUSrcE(ALUSrcE),
	.ALUControlE(ALUControlE),
	.MemWriteM(MemWriteM),
	.PCSrcW(PCSrcW),
	.RegWriteW(RegWriteW),
	.Write_Z_ENABLE(Write_Z_ENABLE),
	.BranchTakenE(BranchTakenE)
);


datapath #(32) my_datapath
(
  .clk(clk), .reset(reset),
  .BranchTakenE(BranchTakenE),.PCSrcW(PCSrcW),.ALUSrcE(ALUSrcE),.RegWriteW(RegWriteW),.MemtoRegW(),.MemWriteM(MemWriteM),
  .ImmSrcD(ImmSrcD),
  .RegSrcD(RegSrcD),
  .ALUControlE(ALUControlE),
  .Debug_Source_select(debug_reg_select),
  .Write_Z_ENABLE(Write_Z_ENABLE),.StallF(),.StallD(),.FlushD(),.FlushE(),.ForwardAE(),.ForwardBE(),
  
  .Cond(Cond),
  .Op(Op),
  .Funct(Funct),
  .PCFetch(PCFetch),
  .Z_FLAG(Z_FLAG),
  .Debug_out(debug_reg_out)
);
endmodule