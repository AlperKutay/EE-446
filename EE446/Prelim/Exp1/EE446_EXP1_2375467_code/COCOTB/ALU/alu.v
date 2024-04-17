module alu #(parameter W = 4) (
  input CLK,
  input CIN,//Carry in
	input [3:0] ALU_CTRL,
	input [W-1:0] SRC_A,SRC_B,
  output reg CO,OVF,Z,N,
	output [W-1:0] ALU_RESULT
);
reg [W:0] PRE_RESULT;
assign ALU_RESULT =  PRE_RESULT[W-1:0];
always @(*) begin


  case (ALU_CTRL)
    4'b0000: PRE_RESULT <= SRC_A & SRC_B; // AND
    4'b0001: PRE_RESULT <= SRC_A ^ SRC_B; // EXOR
    4'b0010: PRE_RESULT <= SRC_A - SRC_B; // Subtraction SRC_A - SRC_B
    4'b0011: PRE_RESULT <= SRC_B - SRC_A; // Subtraction SRC_B - SRC_A
    4'b0100: PRE_RESULT <= SRC_A + SRC_B; // Addition SRC_A + SRC_B
    4'b0101: PRE_RESULT <= SRC_A + SRC_B + CIN; // Addition with Carry
    4'b0110: PRE_RESULT <= SRC_A - SRC_B + CIN - 1; // Subtraction SRC_A - SRC_B + Carry - 1
    4'b0111: PRE_RESULT <= SRC_B - SRC_A + CIN - 1; // Subtraction SRC_B - SRC_A + Carry - 1
    4'b1100: PRE_RESULT <= SRC_A | SRC_B; // OR
    4'b1101: PRE_RESULT <= SRC_B; // Move SRC_B
    4'b1110: PRE_RESULT <= SRC_A & ~SRC_B; // Bit Clear SRC_A AND NOT SRC_B
    4'b1111: PRE_RESULT <= ~SRC_B; // Move Not SRC_B
    default: PRE_RESULT <= 0; // Default case
  endcase
  

  CO <= ((~ALU_CTRL[3]) | (ALU_CTRL[2]  & ALU_CTRL[1])) & (PRE_RESULT[W-1] & PRE_RESULT[W]);
  OVF <= ((~ALU_CTRL[3]) | (ALU_CTRL[2]  & ALU_CTRL[1])) ? ((SRC_A[W-1] == SRC_B[W-1]) & (PRE_RESULT[W-1] != SRC_A[W-1])) : 0;
  Z <= (PRE_RESULT == 0);
  N <= PRE_RESULT[W-1];
  

end

endmodule