module datapath #(parameter WIDTH=32)
(
  input clk, reset,
  input PCSrcW,ALUSrcE,RegWriteW,MemtoRegW,MemWriteM,
  input [1:0] ImmSrcD,
  input [1:0] RegSrcD,
  input [3:0] ALUControlE,
  input [3:0] Debug_Source_select,
  input Write_Z_ENABLE,StallF,StallD,FlushD,FlushE,BranchTakenE,
  input [1:0] ForwardAE,ForwardBE,
  
  output [3:0] Cond,
  output [1:0] Op,
  output [5:0] Funct,
  output [WIDTH-1:0] PCFetch,
  output Z_FLAG,
  output [WIDTH-1:0] Debug_out,
  output [3:0] Rd,
  	//For Hazard unit
  output [3:0] RA1D,RA2D,RA1E,RA2E,WA3E,WA3M,WA3W
);


wire [WIDTH-1:0] ALUResultE,PC_NEXT,PC_NEXT_NEXT,InstructionF,InstructionD,InstructionE,PCPlus4F,PCPlus8D,PCPlus4D, RD1, RD2,REG_FILE_DATA,SrcBEData;
wire [WIDTH-1:0] RD1E,RD2E,ExtImmD,ExtImmE,ALUOutM,ALUOutW,SrcAE,SrcB,SrcBE,WriteDataM,ReadDataM,ReadDataW,ResultW; 
wire [WIDTH-1:0] SHIFT_DATA,SHIFTED_DATA;
wire Z_OUT;

wire [1:0] SHIFT_CONTROL;
wire [4:0] SHIFT_SHAMT;
wire [7:0] ROT_VALUE ;
wire I;
wire L;
wire BX;

wire [3:0] Rn,Rm,DestSelect;
wire [23:0] Inst;

assign ROT_VALUE = {InstructionE[11:8],InstructionE[11:8]}<< 1;
assign L = InstructionD[24] & InstructionD[27] &  (~InstructionD[26]) ;
assign BX = (InstructionE[24:21] == 4'b1001);

assign PCPlus8D = PCPlus4F;
assign Cond = InstructionD[31:28];
assign Op = InstructionD[27:26];
assign Funct = InstructionD[25:20];

assign Rd = InstructionD[15:12];
assign Rn = InstructionD[19:16];
assign Rm = InstructionD[3:0];
assign Inst = InstructionD[23:0];

Mux_2to1 #(32) PC_MUX_1 (
    .input_0(PCPlus4F),
    .input_1(ResultW),
    .select(PCSrcW),
    .output_value(PC_NEXT)
);
Mux_2to1 #(32) PC_MUX_2 (
    .input_0(PC_NEXT),
    .input_1(ALUResultE),
    .select(BranchTakenE),
    .output_value(PC_NEXT_NEXT)
);
Register_rsten #(32) Fetch_Register(
	.clk(clk),
	.reset(reset),
	.we(~StallF),
	.DATA(PC_NEXT_NEXT),
	.OUT(PCFetch)
);
Adder PC_PLUS_4(
	.DATA_A(PCFetch),
	.DATA_B(4),
	.OUT(PCPlus4F)
);
Instruction_memory INST_MEMORY(
	.ADDR(PCFetch),
	.RD(InstructionF)
);
Register_rsten #(32) Decode_Register(
	.clk(clk),
	.reset(FlushD | reset),
	.we(~StallD),
	.DATA(InstructionF),
	.OUT(InstructionD)
);
Register_rsten #(32) Decode_PCPlus4D(
	.clk(clk),
	.reset(FlushD | reset),
	.we(~StallD),
	.DATA(PCPlus4F),
	.OUT(PCPlus4D)
);
Mux_2to1 RA1_MUX (
    .input_0(Rn),
    .input_1(4'b1111),
    .select(RegSrcD[0]),
    .output_value(RA1D)
);

Mux_2to1 RA2_MUX (
    .input_0(Rm),
    .input_1(Rd),
    .select(RegSrcD[1]),
    .output_value(RA2D)
);
Register_file #(WIDTH) reg_file_dp(
	.clk(~clk),
	.write_enable(RegWriteW | L),//L
	.reset(reset),
	.Source_select_0(RA1D),//A1
	.Source_select_1(RA2D),//A2
	.Destination_select(DestSelect),//A3
	.out_0(RD1),
	.out_1(RD2),
	.Debug_out(Debug_out),//?
	.DATA(REG_FILE_DATA),//WD3
	.Reg_15(PCPlus8D),
	.Debug_Source_select(Debug_Source_select)//?
);
Mux_2to1 #(WIDTH) WD3_MUX (
    .input_0(ResultW/*RD2E*/),//sh VALUE
    .input_1(PCPlus4D),//imm8
    .select(L),//L VALUE
    .output_value(REG_FILE_DATA)
);
Mux_2to1 #(4) WA3W_MUX (
    .input_0(WA3W/*RD2E*/),//sh VALUE
    .input_1(4'b1110),//14
    .select(L),//L VALUE
    .output_value(DestSelect)
);
Extender EXTEND(
	.select(ImmSrcD),
	.Extended_data(ExtImmD),
	.DATA(Inst)
);

Register_reset #(32) Execute_Register_RD1(
	.clk(clk),
	.reset(FlushE | reset),
	.DATA(RD1),
	.OUT(RD1E)
);

Register_reset #(32) Execute_Instruction(
	.clk(clk),
	.reset(FlushE | reset),
	.DATA(InstructionD),
	.OUT(InstructionE)
);


Mux_2to1 #(2) SHIFT_MUX_CONTROL (
    .input_0(InstructionE[6:5]),//sh VALUE
    .input_1(2'b11),//RR
    .select(InstructionE[25]),//I VALUE
    .output_value(SHIFT_CONTROL)
);
Mux_2to1 #(WIDTH) SHIFT_MUX_DATA (
    .input_0(SrcB/*RD2E*/),//sh VALUE
    .input_1({24'b0,InstructionE[7:0]}),//imm8
    .select(InstructionE[25]),//I VALUE
    .output_value(SHIFT_DATA)
);
Mux_2to1 #(5) SHIFT_MUX_SHAMT(
    .input_0(InstructionE[11:7]),//sh VALUE
    .input_1(ROT_VALUE[4:0] ),//ROT*2
    .select(InstructionE[25]),//I VALUE
    .output_value(SHIFT_SHAMT)
);

shifter #(32) SHIFT(
	.control(SHIFT_CONTROL),
	.shamt(SHIFT_SHAMT),
	.DATA(SHIFT_DATA),
	.OUT(SHIFTED_DATA)
);
Mux_2to1 #(WIDTH) SRCBE_PRE_MUX (
    .input_0(SHIFTED_DATA/*RD2E*/),//sh VALUE
    .input_1(RD2E),//imm8
    .select(BX),//I VALUE
    .output_value(SrcBEData)
);
Register_reset #(32) Execute_Register_RD2(
	.clk(clk),
	.reset(FlushE | reset),
	.DATA(RD2),
	.OUT(RD2E)
);
Register_reset #(4) Execute_Register_RA1E(
	.clk(clk),
	.reset(FlushE | reset),
	.DATA(RA1D),
	.OUT(RA1E)
);
Register_reset #(4) Execute_Register_RA2E(
	.clk(clk),
	.reset(FlushE | reset),
	.DATA(RA2D),
	.OUT(RA2E)
);
Register_reset #(4) Execute_Register_WA3D(
	.clk(clk),
	.reset(FlushE | reset),
	.DATA(Rd),
	.OUT(WA3E)
);
Register_reset #(32) Execute_Register_Extend(
	.clk(clk),
	.reset(reset | reset),
	.DATA(ExtImmD),
	.OUT(ExtImmE)
);

Mux_4to1 #(32) SRCAE_MUX(
    .input_0( RD1E),
    .input_1( ResultW),
	 .input_2( ALUOutM),
	 .input_3( 0),
    .select(ForwardAE),
    .output_value(SrcAE)
);
Mux_4to1 #(32) SRCBE_MUX(
    .input_0( RD2E/*SHIFTED_DATA*/),
    .input_1( ResultW),
	 .input_2( ALUOutM),
	 .input_3( 0),
    .select(ForwardBE),
    .output_value(SrcB)
);
Mux_2to1 #(32) SRCBE_MUX_2(
    .input_0( SrcBEData),
    .input_1( ExtImmE),
    .select(ALUSrcE),
    .output_value(SrcBE)
);
ALU #(WIDTH) ALU(
	.control(ALUControlE),
	.DATA_A(SrcAE),
	.DATA_B(SrcBE),
	.OUT(ALUResultE), 
	.Z(Z_OUT)
);
Register_en #(1) reg_z(
	.clk(clk),
	.DATA(Z_OUT),
	.OUT(Z_FLAG),
   .en(Write_Z_ENABLE)
);
Register_reset #(32) Execute_Register_ALUResultE(
	.clk(clk),
	.reset(reset),
	.DATA(ALUResultE),
	.OUT(ALUOutM)
);
Register_reset #(32) Execute_Register_RD2E(
	.clk(clk),
	.reset(reset | reset),
	.DATA(RD2E),//WriteDataE
	.OUT(WriteDataM)
);
Register_reset #(4) Execute_Register_WA3E(
	.clk(clk),
	.reset(reset ),
	.DATA(WA3E),
	.OUT(WA3M)
);
Memory DATA_MEMORY(
	.clk(clk),
	.WE(MemWriteM),
	.ADDR(ALUOutM),
	.WD(WriteDataM),
	.RD(ReadDataM) 
);

Register_reset #(32) Execute_Register_ReadDataM(
	.clk(clk),
	.reset(reset ),
	.DATA(ReadDataM),
	.OUT(ReadDataW)
);
Register_reset #(32) Execute_Register_ALUOutM(
	.clk(clk),
	.reset(reset | reset),
	.DATA(ALUOutM),//WriteDataE
	.OUT(ALUOutW)
);
Register_reset #(4) Execute_Register_WA3M(
	.clk(clk),
	.reset(reset),
	.DATA(WA3M),
	.OUT(WA3W)
);
Mux_2to1 #(32) ResultMuxW(
    .input_0( ALUOutW),
    .input_1( ReadDataW),
    .select(MemtoRegW),
    .output_value(ResultW)
);


endmodule