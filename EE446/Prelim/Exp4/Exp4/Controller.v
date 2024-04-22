module Controller(
	input clk,
	input [1:0] Op,
	input [5:0] Funct,	
	input Z_FLAG,
	
	output reg PCSrcD,
	output reg BranchD,
	output reg RegWriteD,
	output reg MemWriteD,
	output reg MemtoRegD,
	output reg [3:0] ALUControlD,
	output reg ALUSrcD,
	output reg [1:0] FlagWriteD,
	output reg [1:0] ImmSrcD,
	output reg [1:0] RegSrcD

); 

always @(*) begin
	PCSrcD = 0;
	BranchD = 0;
	RegWriteD = 0;
	MemWriteD = 0;
	MemtoRegD = 0;
	ALUControlD = 0;
	ALUSrcD = 0;
	FlagWriteD = 0;//Z enable
	ImmSrcD = 0;
	RegSrcD = 0;
	
	case(Op)
		// Data Processing
		2'b00:begin
			
			MemtoRegD = 0;//Alu output
			MemWriteD = 0;
			ALUSrcD = 0;
			ImmSrcD = 0;
			RegSrcD = 0;
			case(Funct[4:1])				
				4'b0100: begin//ADD 
					ALUControlD = 4'b0100;
					PCSrcD = 0;
					RegWriteD = 1;
					FlagWriteD = 1;
				end			
				4'b0010: begin//SUB 
					ALUControlD = 4'b0010;
					PCSrcD = 0;
					RegWriteD = 1;
					FlagWriteD = 1;
				end				
				4'b0000: begin// AND 
					ALUControlD = 4'b0000;
					PCSrcD = 0;
					RegWriteD = 1;
					FlagWriteD = 1;
				end			
				4'b1100: begin// ORR 
					ALUControlD = 4'b1100;
					PCSrcD = 0;
					RegWriteD = 1;
					FlagWriteD = 1;
				end	 
				4'b1101: begin// MOV
					ALUControlD = 4'b1101;
					PCSrcD = 0;
					RegWriteD = 1;
					FlagWriteD = 0;
				end		
				4'b1010: begin// CMP 
					ALUControlD = 4'b0010;
					PCSrcD = 0;
					RegWriteD = 0;
					FlagWriteD = 1;
					end
				4'b1001: begin// BX 
					ALUControlD = 4'b1101;//MOV
					PCSrcD = 0;
					BranchD = 1;
					RegWriteD = 0;
					FlagWriteD = 0;
				end
				default: begin
					ALUControlD = 4'b0000;//Does not matter
					PCSrcD = 0;
					RegWriteD = 0;
					FlagWriteD = 0;
				end
			endcase
		end	
		// Memory
		2'b01:begin
			PCSrcD = 0;
			case(Funct[0])
				// LDR
				1'b1: begin
					MemtoRegD = 1;//Data Memory
					MemWriteD = 0;
					ALUControlD = 4'b0100;
					ALUSrcD = 1;
					ImmSrcD = 1;
					RegWriteD = 1;
					RegSrcD = 0;

				end			
				// STR
				1'b0: begin
					RegSrcD = 2;
					MemtoRegD = 0;
					MemWriteD = 1;
					ALUControlD = 4'b0100;
					ALUSrcD = 1;
					ImmSrcD = 1;
					RegWriteD = 0;
				end	
				default:begin
					RegSrcD = 0;
					MemtoRegD = 0;
					MemWriteD = 0;
					ALUControlD = 0;
					ALUSrcD = 0;
					ImmSrcD = 0;
					RegWriteD = 0;
					end
			endcase		
		end	
		// Branch
		2'b10:begin
			PCSrcD = 0; //Not Inc PC so that it should be 1
			MemtoRegD = 0;
			MemWriteD = 0;
			ImmSrcD = 2'b10;
			ALUSrcD = 1'b1;
			ALUControlD = 4'b0100;
			BranchD=1;
			case(Funct[5:4])
				2'b11: begin//BL
					RegSrcD = 2'b11;
					RegWriteD = 1;	
				end			
				2'b10: begin//B
					RegSrcD = 2'b01;
					RegWriteD = 0;
				end
				default:begin
					RegSrcD = 0;
					RegWriteD = 0;
				end
			endcase
			
		end
			
		default:begin
			RegSrcD = 0;
			MemtoRegD = 0;
			MemWriteD = 0;
			ALUControlD = 0;
			ALUSrcD = 0;
			ImmSrcD = 0;
			RegWriteD = 0;
			
		end
	endcase
end
endmodule