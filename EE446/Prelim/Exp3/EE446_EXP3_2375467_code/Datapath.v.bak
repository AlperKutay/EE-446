module DATAPATH #(parameter WIDTH=32)
(
  input clk, reset,
  input ALUSrcA, RegWrite, PCWrite, MemWrite,AdrSrc,IRWrite,
  input [1:0] ImmSrc,ALUSrcB,ResultSrc,
  input [1:0] RegSrc,
  input [3:0] ALUControl,
  input [3:0] Debug_Source_select,
  input Write_Z_ENABLE,
  
  output [3:0] Cond,
  output [1:0] Op,
  output [5:0] Funct,
  output [3:0] RA1, RA2,
  output [WIDTH-1:0] Rd1, Rd2, ALU_RESULT, PC, Instruction,Result,SRC_A,SRC_B,
  output Z_FLAG,
  output [WIDTH-1:0] Debug_out,Instr_read,Instr_write
  
);

wire [WIDTH-1:0] Data,ALUOut,Data_A,Data_B,ReadData,EXT_IMM,DATA_MEMORY_RESULT,Adr,PC_NEXT,SHIFT_DATA,SHIFTED_DATA,REG_FILE_DATA;//,BX_DATA; 
wire Z_OUT;
wire [1:0] SHIFT_CONTROL;
wire [4:0] SHIFT_SHAMT;
wire [3:0] Destination_select ;
wire [7:0] ROT_VALUE ;
wire [3:0] Rd ;

assign Instr_read = ReadData;
assign Instr_write = Data_B;
assign ROT_VALUE = {Instruction[11:8],Instruction[11:8]}<< 1;
assign Rd = Instruction[15:12];
assign Cond = Instruction[31:28];
assign Op = Instruction[27:26];
assign Funct = Instruction[25:20];

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
	.Reg_15(Result),
	.Debug_Source_select(Debug_Source_select)//?
	
);
Register_simple #(WIDTH) reg_A(
	.clk(clk),
	.DATA(Rd1),
	.OUT(Data_A)
);
Register_simple #(WIDTH) reg_B(
	.clk(clk),
	.DATA(Rd2),
	.OUT(Data_B)
);
Mux_2to1 #(4) REG_FILE_DEST_SELECT_MUX (//BL
    .input_1(4'b1110),//R14
    .input_0(Rd),//Instruction[15:12]
    .select(Instruction[27]&Instruction[24]),//Op[1]&L
    .output_value(Destination_select)
);
	 
Mux_2to1 #(WIDTH) REG_FILE_DATA_MUX (
    .input_0(Result),//sh VALUE
    .input_1(ALUOut),
    .select(Instruction[27]&Instruction[24]),//Op[1]&L
    .output_value(REG_FILE_DATA)
);
//Mux_2to1 #(WIDTH) BX_DATA_MUX(
//    .input_0(Result),//DATA_MEMORY_RESULT
//    .input_1(Data_B ),//Rd2
//    .select(Instruction[24]&Instruction[21]&(~Instruction[22])&(~Instruction[23])),//Funct value will be 1001 for all BX Instructionuctions 
//    .output_value(BX_DATA)
//);
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
    .input_0(Data_B),//sh VALUE
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


Mux_2to1 #(WIDTH) SRC_A_MUX(
    .input_0(Data_A),
    .input_1(PC),
    .select(ALUSrcA),
    .output_value(SRC_A)
);
Mux_4to1 #(WIDTH) SRC_B_MUX(
    .input_0(SHIFTED_DATA),
    .input_1(EXT_IMM),
	.input_2(4),
	.input_3(Data_B),
    .select(ALUSrcB),
    .output_value(SRC_B)
);
ALU #(WIDTH) ALU(
	.control(ALUControl),
	.DATA_A(SRC_A),
	.DATA_B(SRC_B),
	.OUT(ALU_RESULT), 
	.Z(Z_OUT)
);
Register_simple #(WIDTH) reg_alu_result(
	.clk(clk),
	.DATA(ALU_RESULT),
	.OUT(ALUOut)
);
Mux_4to1 #(WIDTH) ALUOut_MUX(
    .input_0(ALUOut),
    .input_1(Data),//RD
	.input_2(ALU_RESULT),
	.input_3(0),
    .select(ResultSrc),
    .output_value(Result)
);
Register_rsten #(WIDTH) PC_REG(
	.clk(clk),
	.reset(reset),
	.we(PCWrite|(Rd[0]&Rd[1]&Rd[2]&Rd[3]&RegWrite)),
	.DATA(Result),
	.OUT(PC)
);
Mux_2to1 #(WIDTH) PC_MUX (
    .input_0(PC),
    .input_1(Result),
    .select(AdrSrc),
    .output_value(Adr)
);

Memory Instr_data_memory (
	.clk(clk),.WE(MemWrite),
	.ADDR(Adr),
	.WD(Data_B),
	.RD(ReadData) 
);
Register_rsten #(WIDTH) Instr_REG(
	.clk(clk),
	.reset(reset),
	.we(IRWrite),
	.DATA(ReadData),
	.OUT(Instruction)
);

Extender EXTEND(
	.select(ImmSrc),
	.Extended_data(EXT_IMM),
	.DATA(Instruction[23:0])
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

Register_simple #(WIDTH) reg_Data(
	.clk(clk),
	.DATA(ReadData),
	.OUT(Data)
);
Register_en #(1) reg_z(
	.clk(clk),
	.DATA(Z_OUT),
	.OUT(Z_FLAG),
   .en(Write_Z_ENABLE)
);

endmodule