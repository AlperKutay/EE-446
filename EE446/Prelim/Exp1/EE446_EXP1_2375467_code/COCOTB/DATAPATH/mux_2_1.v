module mux_2_1 #(parameter W = 4)(
  input wire [W-1:0] DATA_0,DATA_1,
  input wire SELECT,
  output reg [W-1:0] OUT
);

always @(*) begin
	if (SELECT)
		OUT <= DATA_1;
	else
		OUT <= DATA_0;
end
endmodule