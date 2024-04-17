module mux_4_1 #(parameter W = 4)(
  input wire [W-1:0] DATA_0,
  input wire [W-1:0] DATA_1,
  input wire [W-1:0] DATA_2,
  input wire [W-1:0] DATA_3,
  input wire SELECT,
  output reg[W-1:0] OUT
);

always @(*) begin
	case (SELECT)
		2'b00: OUT = DATA_0;
		2'b01: OUT = DATA_1;
		2'b10: OUT = DATA_2;
		2'b11: OUT = DATA_3;
	endcase
end
endmodule