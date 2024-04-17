module datapath #(parameter WIDTH=32)
(
  input clk, reset,
  input ALUSrc, MemtoReg, RegWrite, PCSrc, Mem_Write,
  input [1:0] ImmSrc,
  input [1:0] RegSrc,
  input [3:0] ALUControl,
  input [3:0] Debug_Source_select,
  input Write_Z_ENABLE,
  
  output [3:0] Cond,
  output [1:0] Op,
  output [5:0] Funct,
  output [3:0] Rd,
  output [3:0] RA1, RA2,
  output [WIDTH-1:0] Rd1, Rd2, ALU_RESULT, PC, Instruction,
  output Z_FLAG,
  output [WIDTH-1:0] Debug_out
);

wire [WIDTH-1:0] R15,READ_DATA,EXT_IMM,SRC_B,DATA_MEMORY_RESULT,PC_4,PC_NEXT,SHIFT_DATA,SHIFTED_DATA,REG_FILE_DATA,BX_DATA; 
wire Z_OUT;
wire [1:0] SHIFT_CONTROL;
wire [4:0] SHIFT_SHAMT;
wire [3:0]Destination_select;
wire [7:0] ROT_VALUE ;
assign  ROT_VALUE = {Instruction[11:8],Instruction[11:8]}<< 1;

assign Cond = Instruction[31:28];
assign Op = Instruction[27:26];
assign Funct = Instruction[25:20];
assign Rd = Instruction[15:12];

Register_file #(WIDTH) reg_file_dp(
	.clk(clk),
	.write_enable(RegWrite),
	.reset(reset),
	.Source_select_0(RA1),//A1
	.Source_select_1(RA2),//A2
	.Destination_select(Destination_select),//A3
	.out_0(Rd1),
	.out_1(Rd2),
	.Debug_out(Debug_out),//?
	.DATA(REG_FILE_DATA),//WD3
	.Reg_15(R15),
	.Debug_Source_select(Debug_Source_select)//?
	
);
Mux_2to1 #(4) REG_FILE_DEST_SELECT_MUX (
    .input_1(4'b1110),//R14
    .input_0(Rd),//Instruction[15:12]
    .select(Instruction[27]&Instruction[24]),//Op[1]&L
    .output_value(Destination_select)
);
Mux_2to1 #(WIDTH) REG_FILE_DATA_MUX (
    .input_0(DATA_MEMORY_RESULT),//sh VALUE
    .input_1(PC_4),//imm8
    .select(Instruction[27]&Instruction[24]),//Op[1]&L
    .output_value(REG_FILE_DATA)
);

shifter #(32) SHIFT(
	.control(SHIFT_CONTROL),
	.shamt(SHIFT_SHAMT),
	.DATA(SHIFT_DATA),
	.OUT(SHIFTED_DATA)
);
Mux_2to1 #(2) SHIFT_MUX_CONTROL (
    .input_0(Instruction[6:5]),//sh VALUE
    .input_1(2'b11),//RR
    .select(Instruction[25]),//I VALUE
    .output_value(SHIFT_CONTROL)
);
Mux_2to1 #(WIDTH) SHIFT_MUX_DATA (
    .input_0(Rd2),//sh VALUE
    .input_1({24'b0,Instruction[7:0]}),//imm8
    .select(Instruction[25]),//I VALUE
    .output_value(SHIFT_DATA)
);
Mux_2to1 #(5) SHIFT_MUX_SHAMT(
    .input_0(Instruction[11:7]),//sh VALUE
    .input_1(ROT_VALUE[4:0] ),//ROT*2
    .select(Instruction[25]),//I VALUE
    .output_value(SHIFT_SHAMT)
);

Mux_2to1 #(WIDTH) BX_DATA_MUX(
    .input_0(DATA_MEMORY_RESULT),//DATA_MEMORY_RESULT
    .input_1(Rd2 ),//Rd2
    .select(Instruction[24]&Instruction[21]&(~Instruction[22])&(~Instruction[23])),//Funct value will be 1001 for all BX Instructionuctions 
    .output_value(BX_DATA)
);

Extender EXTEND(
	.select(ImmSrc),
	.Extended_data(EXT_IMM),
	.DATA(Instruction[23:0])
);

Memory DATA_MEMORY(
	.clk(clk),
	.WE(Mem_Write),
	.ADDR(ALU_RESULT),
	.WD(Rd2),
	.RD(READ_DATA) 
);

Mux_2to1 #(WIDTH) SRC_B_MUX(
    .input_0(SHIFTED_DATA),
    .input_1(EXT_IMM),
    .select(ALUSrc),
    .output_value(SRC_B)
);

Mux_2to1 #(WIDTH) DATA_MEMORY_MUX(
    .input_0(ALU_RESULT),
    .input_1(READ_DATA),
    .select(MemtoReg),
    .output_value(DATA_MEMORY_RESULT)
);

ALU #(WIDTH) ALU(
	.control(ALUControl),
	.DATA_A(Rd1),
	.DATA_B(SRC_B),
	.OUT(ALU_RESULT), 
	.Z(Z_OUT)
);

Register_en #(1) reg_z(
	.clk(clk),
	.DATA(Z_OUT),
	.OUT(Z_FLAG),
    .en(Write_Z_ENABLE)
);

Inst_Memory INST_MEMORY(
	.ADDR(PC),
	.RD(Instruction)
);

Mux_2to1 #(32) PC_MUX (
    .input_0(PC_4),
    .input_1(BX_DATA),
    .select(PCSrc),
    .output_value(PC_NEXT)
);

Adder PC_PLUS_4(
	.DATA_A(PC),
	.DATA_B(4),
	.OUT(PC_4)
);

Adder PC_PLUS_8(
	.DATA_A(PC_4),
	.DATA_B(4),
	.OUT(R15)
);

Register_reset #(32) PC_REG(
	.clk(clk),
	.reset(reset),
	.DATA(PC_NEXT),
	.OUT(PC)
);

Mux_2to1 RA1_MUX (
    .input_0(Instruction[19:16]),
    .input_1(4'b1111),
    .select(RegSrc[0]),
    .output_value(RA1)
);

Mux_2to1 RA2_MUX (
    .input_0(Instruction[3:0]),
    .input_1(Instruction[15:12]),
    .select(RegSrc[1]),
    .output_value(RA2)
);

endmodule