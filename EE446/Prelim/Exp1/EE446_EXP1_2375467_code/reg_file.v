module reg_file #(parameter WIDTH=32)(
	input [WIDTH-1:0] IN,//The register file has one data input and two data outputs
	input CLK, RESET, WE,//Finally, a control signal is required to enable write operation, and a synchronous reset signal is required to clear the contents of all registersin the register file.
   input [3:0] DEST_ADDRESS, SOURCE_ADDRESS_1, SOURCE_ADDRESS_2,//Therefore, there should be three address inputs of width 4: one for destination select and two for source select.
	output [WIDTH-1:0] RD1,RD2//The register file has one data input and two data outputs
);
//The sources of the outputs and the destination of the input can be one of the 16 registers in the register file
wire [WIDTH-1:0] REGISTERS [15:0];
wire [15:0] REGISTERS_ENB ;

decoder_4_16 DEC_4_16_1(.IN(DEST_ADDRESS),.OUT(REGISTERS_ENB));

reg_with_reset_and_write #(WIDTH) REG_0  (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[0] & WE),.OUT(REGISTERS[0]));
reg_with_reset_and_write #(WIDTH) REG_1  (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[1] & WE),.OUT(REGISTERS[1]));
reg_with_reset_and_write #(WIDTH) REG_2  (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[2] & WE),.OUT(REGISTERS[2]));
reg_with_reset_and_write #(WIDTH) REG_3  (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[3] & WE),.OUT(REGISTERS[3]));
reg_with_reset_and_write #(WIDTH) REG_4  (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[4] & WE),.OUT(REGISTERS[4]));
reg_with_reset_and_write #(WIDTH) REG_5  (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[5] & WE),.OUT(REGISTERS[5]));
reg_with_reset_and_write #(WIDTH) REG_6  (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[6] & WE),.OUT(REGISTERS[6]));
reg_with_reset_and_write #(WIDTH) REG_7  (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[7] & WE),.OUT(REGISTERS[7]));
reg_with_reset_and_write #(WIDTH) REG_8  (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[8] & WE),.OUT(REGISTERS[8]));
reg_with_reset_and_write #(WIDTH) REG_9  (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[9] & WE),.OUT(REGISTERS[9]));
reg_with_reset_and_write #(WIDTH) REG_10 (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[10] & WE),.OUT(REGISTERS[10]));
reg_with_reset_and_write #(WIDTH) REG_11 (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[11] & WE),.OUT(REGISTERS[11]));
reg_with_reset_and_write #(WIDTH) REG_12 (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[12] & WE),.OUT(REGISTERS[12]));
reg_with_reset_and_write #(WIDTH) REG_13 (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[13] & WE),.OUT(REGISTERS[13]));
reg_with_reset_and_write #(WIDTH) REG_14 (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[14] & WE),.OUT(REGISTERS[14]));
reg_with_reset_and_write #(WIDTH) REG_15 (.IN(IN),.CLK(CLK),.RST(RESET),.WE(REGISTERS_ENB[15] & WE),.OUT(REGISTERS[15]));

mux_16_1 #(WIDTH) MUX_1(
.DATA_0(REGISTERS[0]),
.DATA_1(REGISTERS[1]),
.DATA_2(REGISTERS[2]),
.DATA_3(REGISTERS[3]),
.DATA_4(REGISTERS[4]),
.DATA_5(REGISTERS[5]),
.DATA_6(REGISTERS[6]),
.DATA_7(REGISTERS[7]),
.DATA_8(REGISTERS[8]),
.DATA_9(REGISTERS[9]),
.DATA_10(REGISTERS[10]),
.DATA_11(REGISTERS[11]),
.DATA_12(REGISTERS[12]),
.DATA_13(REGISTERS[13]),
.DATA_14(REGISTERS[14]),
.DATA_15(REGISTERS[15]),
.SELECT(SOURCE_ADDRESS_1),
.OUT(RD1)
);

mux_16_1 #(WIDTH) MUX_2(
.DATA_0(REGISTERS[0]),
.DATA_1(REGISTERS[1]),
.DATA_2(REGISTERS[2]),
.DATA_3(REGISTERS[3]),
.DATA_4(REGISTERS[4]),
.DATA_5(REGISTERS[5]),
.DATA_6(REGISTERS[6]),
.DATA_7(REGISTERS[7]),
.DATA_8(REGISTERS[8]),
.DATA_9(REGISTERS[9]),
.DATA_10(REGISTERS[10]),
.DATA_11(REGISTERS[11]),
.DATA_12(REGISTERS[12]),
.DATA_13(REGISTERS[13]),
.DATA_14(REGISTERS[14]),
.DATA_15(REGISTERS_ENB[15]),
.SELECT(SOURCE_ADDRESS_2),
.OUT(RD2)
);
endmodule