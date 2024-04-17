module datapath(//
	input ENABLE,//1
	input [1:0] OPCODE,//2
   input [7:0] IN,//8
	//input SELECT_1,SELECT_2,//2
	//input [3:0] ALU_CTRL,//4
	//input [4:0] SHAMT,//5
	//input [1:0] SHIFTER_CTRL,//2
	output [7:0] OUT,
	output CO,OVF,Z,N
	// less than five clock cycles
);
assign OUT = REGISTER_OUT;
wire [7:0] ALU_OUT,REGISTER_OUT,SHIFTER_OUTPUT,SHIFTER_REGISTER_OUTPUT;
wire [7:0] MUX_1_OUT,MUX_2_OUT;
reg [2:0] CLOCK_CYCLE = 0;
reg WE,WE_SHIFTER_REG;
reg RESET=1;
reg SELECT_1,SELECT_2;
reg [3:0] ALU_CTRL;
reg [4:0] SHAMT;
reg [1:0] SHIFTER_CTRL;
reg_with_reset_and_write #(8) REG_DATAPATH  (.IN(ALU_OUT),.CLK(ENABLE),.RST(RESET),.WE(WE),.OUT(REGISTER_OUT));

mux_2_1 #(8) MUX_2_1_DATAPATH_1(.DATA_0(REGISTER_OUT),.DATA_1(0),.SELECT(SELECT_1),.OUT(MUX_1_OUT));

mux_2_1 #(8) MUX_2_1_DATAPATH_2(.DATA_0(SHIFTER_REGISTER_OUTPUT),.DATA_1(IN),.SELECT(SELECT_2),.OUT(MUX_2_OUT));

alu #(8) ALU_DATAPATH (.SRC_A(MUX_1_OUT),.SRC_B(MUX_2_OUT),.ALU_CTRL(ALU_CTRL),.ALU_RESULT(ALU_OUT),.OVF(OVF),.CO(CO));

shifter #(8) SHIFTER_DATAPATH (.IN(ALU_OUT),.SHAMT(SHAMT),.CTRL(SHIFTER_CTRL),.OUT(SHIFTER_OUTPUT));

reg_with_reset_and_write #(8) SHIFTER_REG_DATAPATH (.IN(SHIFTER_OUTPUT),.CLK(ENABLE),.RST(RESET),.WE(WE_SHIFTER_REG),.OUT(SHIFTER_REGISTER_OUTPUT));

always @(posedge ENABLE)begin
	case(OPCODE)
	0:begin//2’s Complement Load
		case(CLOCK_CYCLE)
		0:begin
			SELECT_1	<= 1;
			SELECT_2	<= 1;
			RESET <= 0;
			ALU_CTRL <= 4'b1111;
			WE <= 1;
			CLOCK_CYCLE <= CLOCK_CYCLE +1;
		end
		1:begin
			WE <= 0;
			SELECT_2 <= 0;
			ALU_CTRL <= 0;
			CLOCK_CYCLE <= 3'b000;
			RESET <= 1;
		end
		endcase
	end	
	1:begin//Multiply by 10
		case(CLOCK_CYCLE)
		0:begin//4 bit shift right, not write to register
			SELECT_1	<= 1;
			SELECT_2	<= 1;
			RESET <= 0;
			WE_SHIFTER_REG <= 1;
			ALU_CTRL <= 4'b1101;//MOVE
			SHIFTER_CTRL <= 2'b00;//LSL
			SHAMT <= 5'b00001;//1
			CLOCK_CYCLE <= CLOCK_CYCLE +1;
		end
		1:begin//4 bit shift right, not write to register
			SELECT_1	<= 1;
			SELECT_2	<= 0;
			ALU_CTRL <= 4'b1101;//MOVE
			SHIFTER_CTRL <= 2'b00;//LSL
			WE_SHIFTER_REG <= 1;
			SHAMT <= 5'b00010;//2
			WE <= 1;
			CLOCK_CYCLE <= CLOCK_CYCLE +1;
		end
		2:begin
			SELECT_1	<= 0;
			SELECT_2	<= 0;
			ALU_CTRL <= 4'b0100;//ADD
			WE_SHIFTER_REG <= 0;
			CLOCK_CYCLE <= CLOCK_CYCLE +1;
		end
		3:begin//You can add default case
			CLOCK_CYCLE <= CLOCK_CYCLE +1;
		end
		4:begin
			WE <= 0;
			WE_SHIFTER_REG <= 0;
			SELECT_2 <= 0;
			SELECT_1 <= 0;
			ALU_CTRL <= 0;
			SHIFTER_CTRL <= 2'b00;
			SHAMT <= 5'b00000;
			CLOCK_CYCLE <= 3'b000;
			RESET <= 1;
		end
		endcase
	end
	2:begin//Duplicate the First 4-bit
		case(CLOCK_CYCLE)
		0:begin
			SELECT_1	<= 1;
			SELECT_2	<= 1;
			RESET <= 0;
			WE_SHIFTER_REG <= 1;
			ALU_CTRL <= 4'b1101;//MOVE
			SHIFTER_CTRL <= 2'b01;//LSR
			SHAMT <= 5'b00100;//4
			CLOCK_CYCLE <= CLOCK_CYCLE +1;
		end
		1:begin
			SELECT_1	<= 1;
			SELECT_2	<= 0;
			ALU_CTRL <= 4'b1101;//MOVE
			SHIFTER_CTRL <= 2'b00;//LSR
			WE_SHIFTER_REG <= 1;
			SHAMT <= 5'b00100;//4
			WE <= 1;
			CLOCK_CYCLE <= CLOCK_CYCLE +1;
		end
		2:begin
			SELECT_1	<= 0;
			SELECT_2	<= 0;
			ALU_CTRL <= 4'b0100;//ADD
			WE_SHIFTER_REG <= 0;
			CLOCK_CYCLE <= CLOCK_CYCLE +1;
		end
		3:begin
			CLOCK_CYCLE <= CLOCK_CYCLE +1;
		end
		4:begin
			WE <= 0;
			WE_SHIFTER_REG <= 0;
			SELECT_2 <= 0;
			SELECT_1 <= 0;
			ALU_CTRL <= 0;
			SHIFTER_CTRL <= 2'b00;
			SHAMT <= 5'b00000;
			CLOCK_CYCLE <= 3'b000;
			RESET <= 1;
		end

		endcase
	end
endcase
end

	

endmodule
	