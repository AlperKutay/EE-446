module reg_with_reset_and_write #(parameter W=4)(
	input [W-1:0] IN,
	input CLK,
	input RST,
	input WE,//Write Enable	
	output reg [W-1:0] OUT
);

always @(posedge CLK) begin
    if (RST)
      OUT <= 0; // Reset operation
    else if (WE)
      OUT <= IN; // Write operation
   
end
endmodule