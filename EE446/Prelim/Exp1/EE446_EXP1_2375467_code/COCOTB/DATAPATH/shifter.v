module shifter #(parameter W = 4) (
	input [W-1:0] IN,
	input [4:0] SHAMT,//shift amount
   input [1:0] CTRL,
   output reg [W-1:0] OUT
);

always @(*) begin
   case(CTRL)
        2'b00: OUT = IN << SHAMT;//LSL
        2'b01: OUT = IN >> SHAMT;//LSR
		  2'b10: OUT = IN >>> SHAMT;//ASR
		  2'b11: OUT = {IN << SHAMT,IN >> SHAMT};//RR
    endcase
end

endmodule