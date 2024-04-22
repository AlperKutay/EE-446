module Controller_unit(
	input clk,reset,
	input [1:0] Op,
	input [5:0] Funct,
	input [3:0] Cond,
	input Z_FLAG,
	
	output [1:0] RegSrcD,
	output [1:0] ImmSrcD,
	output ALUSrcE,
	output BranchTakenE,
	output [3:0] ALUControlE,
	output MemWriteM,
	output PCSrcW,
	output RegWriteW,
	output Write_Z_ENABLE
	
);

assign BranchTakenE = BranchE & CondEx;
assign Write_Z_ENABLE = FlagWriteE[0];

wire [3:0] CondE;
wire CondEx;
	
wire PCSrcD;
wire BranchD;
wire RegWriteD;
wire MemWriteD;
wire MemtoRegD;
wire [3:0] ALUControlD;
wire ALUSrcD;
wire [1:0] FlagWriteD;


wire PCSrcE;
wire BranchE;
wire RegWriteE;
wire MemWriteE;
wire MemtoRegE;
wire [1:0] FlagWriteE;

wire PCSrcM;
wire RegWriteM;

wire MemtoRegM;

wire MemtoRegW;
//Controller
Controller my_controller(
	.clk(clk),
	.Op(Op),
	.Funct(Funct),	
	.Z_FLAG(Z_FLAG),
	
	.PCSrcD(PCSrcD),
	.BranchD(BranchD),
	.RegWriteD(RegWriteD),
	.MemWriteD(MemWriteD),
	.MemtoRegD(MemtoRegD),
	.ALUControlD(ALUControlD),
	.ALUSrcD(ALUSrcD),
	.FlagWriteD(FlagWriteD),
	.ImmSrcD(ImmSrcD),
	.RegSrcD(RegSrcD)
);
//Registers D to E
Register_reset #(1) PCSrcD_Reg(
	.clk(clk),
	.reset(reset),
	.DATA(PCSrcD),
	.OUT(PCSrcE)
);
Register_reset #(1) BranchD_Reg(
	.clk(clk),
	.reset(reset),
	.DATA(BranchD),
	.OUT(BranchE)
);
Register_reset #(1) RegWriteE_Reg(
	.clk(clk),
	.reset(reset),
	.DATA(RegWriteD),
	.OUT(RegWriteE)
);
Register_reset #(1) MemWriteE_Reg(
	.clk(clk),
	.reset(reset),
	.DATA(MemWriteD),
	.OUT(MemWriteE)
);
Register_reset #(1) MemtoRegE_Reg(
	.clk(clk),
	.reset(reset),
	.DATA(MemtoRegD),
	.OUT(MemtoRegE)
);
Register_reset #(4) ALUControlE_Reg(
	.clk(clk),
	.reset(reset),
	.DATA(ALUControlD),
	.OUT(ALUControlE)
);
Register_reset #(1) ALUSrcE_Reg(
	.clk(clk),
	.reset(reset),
	.DATA(ALUSrcD),
	.OUT(ALUSrcE)
);
Register_reset #(2) FlagWriteE_Reg(
	.clk(clk),
	.reset(reset),
	.DATA(FlagWriteD),
	.OUT(FlagWriteE)
);
/*Register_reset #(4) Flags_Reg(
	.clk(clk),
	.reset(reset),
	.DATA(Flags),
	.OUT(FlagsE)
);*/
Register_reset #(4) Cond_Reg(
	.clk(clk),
	.reset(reset),
	.DATA(Cond),
	.OUT(CondE)
);

Condition_Check Condition_Check_unit (
	.clk(clk), 
	.reset(reset),
	.CondE(CondE), 
	.FlagsE({3'b000,Z_FLAG}),
	.FlagWriteE(FlagWriteE),
	.CondEx(CondEx)
);

//Registers E to M
Register_reset #(1) PCSrcM_Reg(
	.clk(clk),
	.reset(reset),
	.DATA((PCSrcE & CondEx) | (BranchE & CondEx)),
	.OUT(PCSrcM)
);
Register_reset #(1) RegWriteM_Reg(
	.clk(clk),
	.reset(reset),
	.DATA((RegWriteE & CondEx)),
	.OUT(RegWriteM)
);
Register_reset #(1) MemWriteM_Reg(
	.clk(clk),
	.reset(reset),
	.DATA((MemWriteE & CondEx)),
	.OUT(MemWriteM)
);
Register_reset #(1) MemtoRegM_Reg(
	.clk(clk),
	.reset(reset),
	.DATA(MemtoRegE),
	.OUT(MemtoRegM)
);
//Registers M to W
Register_reset #(1) PCSrcW_Reg(
	.clk(clk),
	.reset(reset),
	.DATA(PCSrcM),
	.OUT(PCSrcW)
);
Register_reset #(1) RegWriteW_Reg(
	.clk(clk),
	.reset(reset),
	.DATA(RegWriteM),
	.OUT(RegWriteW)
);

Register_reset #(1) MemtoRegW_Reg(
	.clk(clk),
	.reset(reset),
	.DATA(MemtoRegM),
	.OUT(MemtoRegW)
);
endmodule