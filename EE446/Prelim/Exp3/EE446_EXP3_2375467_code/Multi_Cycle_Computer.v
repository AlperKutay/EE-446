module Multi_Cycle_Computer#(parameter WIDTH=32)(
	input clk,
	input reset,
	input [3:0] debug_reg_select, 
	output [31:0] debug_reg_out,
	output [31:0] PC,
	output [3:0] fsm_state
);

	wire PCWrite;
	wire AdrSrc;
	wire MemWrite;
	wire [3:0]  ALUControl;
	wire [1:0] ResultSrc;
	wire [1:0] ImmSrc;
	wire  RegWrite;
	wire [1:0] RegSrc;
	wire  Cond_EX;
	wire [3:0] Cond;
	wire [1:0] Op;
	wire [5:0] Funct;
	//wire [3:0] Rd;
	wire ALUSrcA;
	wire [1:0] ALUSrcB;
	wire [3:0]  RA1, RA2;
	wire [3:0]  State_reg;
	wire [WIDTH-1:0] Rd1,Rd2,ALU_RESULT,Instruction,Result,SRC_A,SRC_B,Instr_read,Instr_write;
	wire  Z_FLAG,Write_Z_ENABLE;
	wire [2:0] Cycle_reg;
	assign fsm_state = {State_reg[3:0]};
	
Controller my_controller(
	.clk(clk),
	.reset(reset),
	.Cond(Cond),
	.Op(Op),
	.Funct(Funct),
	//.Rd(Rd),
	.Z_FLAG(Z_FLAG),
	
	.PCWrite(PCWrite),
	.AdrSrc(AdrSrc),
	.MemWrite(MemWrite),
	.IRWrite(IRWrite),
	.ResultSrc(ResultSrc),
	.ALUControl(ALUControl),
	.ALUSrcA(ALUSrcA),
	.ALUSrcB(ALUSrcB),
	.ImmSrc(ImmSrc),
	.RegWrite(RegWrite),
	.RegSrc(RegSrc),
	.Cond_EX(Cond_EX),
	.Write_Z_ENABLE(Write_Z_ENABLE),
	.Cycle_reg(Cycle_reg),
	.State_reg(State_reg)
); 

DATAPATH my_datapath(
  .clk(clk), 
  .reset(reset),
  .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .RegWrite(RegWrite), .PCWrite(PCWrite), .MemWrite(MemWrite),.ResultSrc(ResultSrc),
  .ImmSrc(ImmSrc),
  .RegSrc(RegSrc),
  .AdrSrc(AdrSrc),
  .IRWrite(IRWrite),
  .ALUControl(ALUControl),
  .RA1(RA1), .RA2(RA2), .PC(PC),.SRC_A(SRC_A),.SRC_B(SRC_B),
  .Rd1(Rd1), .Rd2(Rd2), .ALU_RESULT(ALU_RESULT), .Instruction(Instruction),
  .Z_FLAG(Z_FLAG),
  .Cond(Cond),.Op(Op),.Funct(Funct),//.Rd(Rd),
  .Debug_Source_select(debug_reg_select),
  .Debug_out(debug_reg_out),.Result(Result),
  .Write_Z_ENABLE(Write_Z_ENABLE),.Instr_read(Instr_read),.Instr_write(Instr_write)
);

endmodule