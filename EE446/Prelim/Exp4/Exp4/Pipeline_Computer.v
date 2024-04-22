module Pipeline_Computer#(parameter WIDTH=32)(
	input clk,
	input reset,
	input [3:0] debug_reg_select, 
	output [31:0] debug_reg_out,
	output [31:0] PCFetch
);

wire [1:0] RegSrcD;
wire [1:0] ImmSrcD;
wire ALUSrcE;
wire [3:0] ALUControlE;
wire MemWriteM;
wire BranchTakenE;
wire MemtoRegW;


wire [3:0] RA1D,RA2D,RA1E,RA2E,WA3E,WA3M,WA3W;
wire [3:0] Cond;
wire [1:0] Op;
wire [5:0] Funct;

wire [1:0] ALUSrcB;
wire [3:0] RA1, RA2;
wire [3:0] State_reg;
wire [WIDTH-1:0] Rd1,Rd2,ALU_RESULT,Instruction,Result,SRC_A,SRC_B,Instr_read,Instr_write;
wire  Z_FLAG,Write_Z_ENABLE;

wire MemtoRegE;
wire RegWriteW;
wire RegWriteM;
wire PCSrcD;
wire PCSrcE;
wire PCSrcM;
wire PCSrcW;


wire StallF,StallD,FlushD,FlushE;
wire [1:0]ForwardAE,ForwardBE;

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
	.MemtoRegW(MemtoRegW),
	.Write_Z_ENABLE(Write_Z_ENABLE),
	.BranchTakenE(BranchTakenE),
	
	.MemtoRegE(MemtoRegE),
	.RegWriteW(RegWriteW),
	.RegWriteM(RegWriteM),
	.PCSrcD(PCSrcD),
	.PCSrcE(PCSrcE),
	.PCSrcM(PCSrcM),
	.PCSrcW(PCSrcW)
);


datapath #(32) my_datapath
(
  .clk(clk), .reset(reset),
  .PCSrcW(PCSrcW),.ALUSrcE(ALUSrcE),.RegWriteW(RegWriteW),.MemtoRegW(MemtoRegW),.MemWriteM(MemWriteM),
  .ImmSrcD(ImmSrcD),
  .RegSrcD(RegSrcD),
  .ALUControlE(ALUControlE),
  .Debug_Source_select(debug_reg_select),.BranchTakenE(BranchTakenE),
  .Write_Z_ENABLE(Write_Z_ENABLE),.StallF(StallF),.StallD(StallD),.FlushD(FlushD),.FlushE(FlushE),.ForwardAE(ForwardAE),.ForwardBE(ForwardBE),
  
  .Cond(Cond),
  .Op(Op),
  .Funct(Funct),
  .PCFetch(PCFetch),
  .Z_FLAG(Z_FLAG),
  .Debug_out(debug_reg_out),
  
  .RA1D(RA1D),.RA2D(RA2D),.RA1E(RA1E),.RA2E(RA2E),.WA3E(WA3E),.WA3M(WA3M),.WA3W(WA3W)
);

Hazard_unit my_hazard_unit(
	.MemtoRegE(MemtoRegE),
	
	.RegWriteW(RegWriteW),
	.RegWriteM(RegWriteM),
	
	.PCSrcD(PCSrcD),
	.PCSrcE(PCSrcE),
	.PCSrcM(PCSrcM),
	.PCSrcW(PCSrcW),
	
	.RA1D(RA1D),.RA2D(RA2D),.RA1E(RA1E),.RA2E(RA2E),.WA3E(WA3E),.WA3M(WA3M),.WA3W(WA3W),
	
	.BranchTakenE(BranchTakenE),
	
	.ForwardBE(ForwardBE),
	.ForwardAE(ForwardAE),
	.FlushE(FlushE),
	
	.FlushD(FlushD),
	.StallD(StallD),
	
	.StallF(StallF)
);
endmodule