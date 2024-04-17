module COMPUTER_MODULE#(parameter WIDTH=32)(
	input clk,
	input reset,
	input [3:0] debug_reg_select, 
	output [31:0] debug_reg_out,
	output [31:0] PC
);

	wire 	PCSrc;
	wire  MemtoReg;
	wire  Mem_Write;
	wire [3:0]  ALUControl;
	wire  ALUSrc;
	wire [1:0] ImmSrc;
	wire  RegWrite;
	wire [1:0] RegSrc;
	wire  Cond_EX;
	wire [3:0] Cond;
	wire [1:0] Op;
	wire [5:0] Funct;
	wire [3:0] Rd;
  
	wire [3:0]  RA1, RA2;
	wire [WIDTH-1:0] Rd1,Rd2,ALU_RESULT,Instruction;
	wire  Z_FLAG,Write_Z_ENABLE;
	
	
Controller my_controller(
	.clk(clk),
	.Cond(Cond),
	.Op(Op),
	.Funct(Funct),
	.Rd(Rd),
	.Z_FLAG(Z_FLAG),
	.PCSrc(PCSrc),
	.MemtoReg(MemtoReg),
	.Mem_Write(Mem_Write),
	.ALUControl(ALUControl),
	.ALUSrc(ALUSrc),
	.ImmSrc(ImmSrc),
	.RegWrite(RegWrite),
	.RegSrc(RegSrc),
	.Cond_EX(Cond_EX),
	.Write_Z_ENABLE(Write_Z_ENABLE)
); 

datapath my_datapath(
  .clk(clk), .reset(reset),
  .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite), .PCSrc(PCSrc), .Mem_Write(Mem_Write),
  .ImmSrc(ImmSrc),
  .RegSrc(RegSrc),
  .ALUControl(ALUControl),
  .RA1(RA1), .RA2(RA2), .PC(PC),
  .Rd1(Rd1), .Rd2(Rd2), .ALU_RESULT(ALU_RESULT), .Instruction(Instruction),
  .Z_FLAG(Z_FLAG),
  .Cond(Cond),.Op(Op),.Funct(Funct),.Rd(Rd),
  .Debug_Source_select(debug_reg_select),
  .Debug_out(debug_reg_out),
  .Write_Z_ENABLE(Write_Z_ENABLE)
);

endmodule