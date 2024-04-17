module reg_with_reset #(parameter W=4)(
	input [W-1:0] IN,
	input CLK,
	input RST, 
	output reg [W-1:0] OUT
);

always @(posedge CLK) begin
    if (RST)
      OUT <= 0; // Reset operation
    else
      OUT <= IN; // Write operation
   
end
endmodule