module mux_16_1 #(parameter W = 4)(
  input wire [W-1:0] DATA_0,
  input wire [W-1:0] DATA_1,
  input wire [W-1:0] DATA_2,
  input wire [W-1:0] DATA_3,
  input wire [W-1:0] DATA_4,
  input wire [W-1:0] DATA_5,
  input wire [W-1:0] DATA_6,
  input wire [W-1:0] DATA_7,
  input wire [W-1:0] DATA_8,
  input wire [W-1:0] DATA_9,
  input wire [W-1:0] DATA_10,
  input wire [W-1:0] DATA_11,
  input wire [W-1:0] DATA_12,
  input wire [W-1:0] DATA_13,
  input wire [W-1:0] DATA_14,
  input wire [W-1:0] DATA_15,
  input wire [3:0]   SELECT,
  output reg[W-1:0] OUT
);

always @(*) begin
	case (SELECT)
		4'b0000: OUT = DATA_0;
		4'b0001: OUT = DATA_1;
		4'b0010: OUT = DATA_2;
		4'b0011: OUT = DATA_3;
		4'b0100: OUT = DATA_4;
		4'b0101: OUT = DATA_5;
		4'b0110: OUT = DATA_6;
		4'b0111: OUT = DATA_7;
		4'b1000: OUT = DATA_8;
		4'b1001: OUT = DATA_9;
		4'b1010: OUT = DATA_10;
		4'b1011: OUT = DATA_11;
		4'b1100: OUT = DATA_12;
		4'b1101: OUT = DATA_13;
		4'b1110: OUT = DATA_14;
		4'b1111: OUT = DATA_15;
	endcase
end
endmodule