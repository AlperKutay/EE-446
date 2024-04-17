module Controller(
	input clk,
	input [3:0] Cond,
	input [1:0] Op,
	input [5:0] Funct,
	input [3:0] Rd,	
	input Z_FLAG,
	
	output reg PCSrc,
	output reg MemtoReg,
	output reg Mem_Write,
	output reg [3:0] ALUControl,
	output reg ALUSrc,
	output reg [1:0]ImmSrc,
	output reg RegWrite,
	output reg [1:0]RegSrc,
	output reg Cond_EX,
	output reg Write_Z_ENABLE
); 

always @(*) begin//Conditional Logic

	case(Cond)
		4'b0000:
		begin // Equal
			if(Z_FLAG == 1)
				Cond_EX <= 1;
			else
				Cond_EX <= 0;
		end
		
		4'b0001:
		begin	// Not Equal
			if(Z_FLAG == 0)
				Cond_EX <= 1;
			else 	
				Cond_EX <= 0;
		end
		
		4'b1110:
		begin  // Always
			Cond_EX <= 1;
		end
		
		default: begin
			Cond_EX <= 1;
		end			
endcase		 
end





always @(*) begin
	Write_Z_ENABLE <= 0;
	case(Op)
		// Data Processing
		2'b00:begin
			
			MemtoReg <= 0;//Alu output
			Mem_Write <= 0;
			ALUSrc <= 0;
			ImmSrc <= 0;
			RegSrc <= 0;
			
			
			case(Funct[4:1])				
				4'b0100: begin//ADD 
					ALUControl <= 4'b0100;
					PCSrc <= 0;
					RegWrite <= Cond_EX ? 1 : 0;
					Write_Z_ENABLE <= 1;
				end			
				4'b0010: begin//SUB 
					ALUControl <= 4'b0010;
					PCSrc <= 0;
					RegWrite <= Cond_EX ? 1 : 0;
					Write_Z_ENABLE <= 1;
				end				
				4'b0000: begin// AND 
					ALUControl <= 4'b0000;
					PCSrc <= 0;
					RegWrite <= Cond_EX ? 1 : 0;
					Write_Z_ENABLE <= 1;
				end			
				4'b1100: begin// ORR 
					ALUControl <= 4'b1100;
					PCSrc <= 0;
					RegWrite <= Cond_EX ? 1 : 0;
					Write_Z_ENABLE <= 1;
				end	 
				4'b1101: begin// MOV
					ALUControl <= 4'b1101;
					PCSrc <= 0;
					RegWrite <= Cond_EX ? 1 : 0;
					Write_Z_ENABLE <= 0;
				end		
				4'b1010: begin// CMP 
					ALUControl <= 4'b0010;
					PCSrc <= 0;
					RegWrite <= 0;
					Write_Z_ENABLE <= 1;
					end
				4'b1001: begin// BX 
					ALUControl <= 4'b0000;//Does not matter
					PCSrc <= 1;
					RegWrite <= 0;
					Write_Z_ENABLE <= 0;
				end
			endcase
		end	
		// Memory
		2'b01:begin
			PCSrc <= 0;
			case(Funct[0])
				// LDR
				1'b1: begin
					MemtoReg <= 1;//Data Memory
					Mem_Write <= 0;
					ALUControl <= 4'b0100;
					ALUSrc <= 1;
					ImmSrc <= 1;
					RegWrite <= Cond_EX ? 1 : 0;
					RegSrc <= 0;

				end			
				// STR
				1'b0: begin
					RegSrc <= 2;
					MemtoReg <= 0;
					Mem_Write <= Cond_EX ? 1 : 0;
					ALUControl <= 4'b0100;
					ALUSrc <= 1;
					ImmSrc <= 1;
					RegWrite <= 0;
				end			
			endcase		
		end	
		// Branch
		2'b10:begin
			PCSrc <= Cond_EX ? 1 : 0; //Not Inc PC so that it should be 1
			MemtoReg <= 0;
			Mem_Write <= 0;
			ImmSrc <= 2'b10;
			
			ALUSrc <= 1'b1;
			ALUControl <= 4'b0100;
			case(Funct[5:4])
				2'b11: begin//BL
					RegSrc <= 2'b11;
					RegWrite <= 1;	
				end			
				2'b10: begin//B
					RegSrc <= 2'b01;
					RegWrite <= 0;
				end
			endcase
			
		end
			
	endcase
end

endmodule
