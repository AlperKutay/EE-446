module Controller(
	input clk,reset,
	input [3:0] Cond,
	input [1:0] Op,
	input [5:0] Funct,	
	input Z_FLAG,
	
	output reg PCWrite,
	output reg AdrSrc,
	output reg MemWrite,
	output reg IRWrite,
	output reg [1:0] ResultSrc,
	output reg [3:0] ALUControl,
	output reg ALUSrcA,
	output reg [1:0] ALUSrcB,
	output reg [1:0] ImmSrc,
	output reg RegWrite,
	output reg [1:0] RegSrc,
	output reg Cond_EX,
	output reg Write_Z_ENABLE,
	output reg [2:0] Cycle_reg,
	output reg [3:0] State_reg
); 
reg op_done = 0;

always @(posedge clk) begin

	if(reset == 0)begin
		case(op_done)
			0:begin
				Cycle_reg = Cycle_reg + 1;
			end
			1:begin
				Cycle_reg = 0;
			end
			default:begin
				Cycle_reg = 0;
			end
		endcase
	end
	else begin
		Cycle_reg = 0;
	end

end


always @(*) begin//Conditional Logic
	case(Cond)
		4'b0000:
		begin // Equal
			if(Z_FLAG == 1)
				Cond_EX = 1;
			else
				Cond_EX = 0;
		end
		4'b0001:
		begin	// Not Equal
			if(Z_FLAG == 0)
				Cond_EX = 1;
			else 	
				Cond_EX = 0;
		end
		4'b1110:
		begin  // Always
			Cond_EX = 1;
		end
		default: begin
			Cond_EX = 1;
		end			
endcase		 
end


always @(*) begin
	if(Cycle_reg == 0) begin 
		// Fetch 
		PCWrite 	= 1'b1; //GET PC
		AdrSrc   	= 1'b0;
		MemWrite 	= 1'b0;
		IRWrite  	= 1'b1;
		RegSrc 		= 2'b00; // don't care
		RegWrite 	= 1'b0;
		ImmSrc   	= 2'b00; // don't care
		ALUSrcA  	= 1'b1;
		ALUSrcB  	= 2'b10;
		ALUControl 	= 4'b0100;// don't care ADD
		ResultSrc 	= 2'b10;
		Write_Z_ENABLE = 1'b0; // don't care
		op_done = 0;
		State_reg = 0;//S0
		end
		
	else if(Cycle_reg == 1) begin 
		// Decode Cycle (Cycle 2)
		
		AdrSrc   	= 1'b0; // don't care
		MemWrite 	= 1'b0;
		IRWrite  	= 1'b0; // !
		case(Op)
			2'b00: RegSrc		= 2'b00;
			2'b01: RegSrc		= 2'b10;
			2'b10: RegSrc		= 2'b01;
			default: RegSrc		= 2'b00;
		endcase  
		//PC+4
		RegWrite 	= Op[1]&Funct[4];//if Instruction is BL then reg Write
		ImmSrc   	= {Op}; // don't care
		ALUSrcA  	= 1'b1;
		ALUSrcB  	= 2'b10;
		ALUControl 	= 4'b0100; // ADD
		ResultSrc 	= 2'b10;
		Write_Z_ENABLE = 1'b0; // Don't change Z flag in DECODE
		op_done 	= 0;
		PCWrite 	= Cond_EX ? Op[1] : 0;
		State_reg = 1;//S1
		
	end
	
	else if(Cycle_reg == 2) begin 
		case(Op)
			2'b00: begin// DP
				 
				AdrSrc   	= 1'b0; // don't care
				MemWrite 	= 1'b0; // don't care
				IRWrite  	= 1'b0; // don't care
				RegSrc		= 2'b00; 
				ImmSrc   	= 2'b00; 		// don't care
				if((Funct[4])&(Funct[1])&(~Funct[3])&(~Funct[2]))begin//1001 for BX 
					op_done = 1;
					PCWrite = 1;
					ALUSrcB  	= 2'b11;
					ALUControl 	= 4'b1101;	//MOV
					ResultSrc 	= 2'b10;
					RegWrite 	= 1'b1;
					Write_Z_ENABLE = 1'b0;
					ALUSrcA  	= 1'b0;
					State_reg = 10;//S10
				end
				else begin
					op_done= 0;
					PCWrite= 0;
					ALUSrcB  	= 2'b00;
					ALUControl 	= Funct[4:1];	
					ResultSrc 	= 2'b00;
					RegWrite 	= 1'b0;	
					Write_Z_ENABLE = 1'b1;
					ALUSrcA  	= 1'b0;
					State_reg = 6;//S6
				end
				end
				
			2'b01: begin// Memory
				PCWrite 		= 1'b0; // don't care
				AdrSrc   	= 1'b0; // don't care
				MemWrite 	= 1'b0; // don't care
				IRWrite  	= 1'b0; // don't care
				RegSrc		= 2'b10; //RN RD
				RegWrite 	= 1'b0;// not yet
				ImmSrc   	= 2'b01; // IMM12
				ALUSrcA  	= 1'b0;// RN
				ALUSrcB  	= 2'b01;	// ExtImm
				ALUControl 	= 4'b0100 ;	//ADD ExtImm+[RN]
				ResultSrc 	= 2'b00;	// don't care
				Write_Z_ENABLE = 1'b0;
				op_done = 0;
				State_reg = 2;//S2
				end 
				
			2'b10: begin// Branch
				PCWrite 	= Cond_EX ? 1 : 0;
				AdrSrc   	= 1'b0; // don't care
				MemWrite 	= 1'b0; // don't care
				IRWrite  	= 1'b0; // don't care
				RegSrc		= 2'b10; //RN RD
				RegWrite 	= 0;
				ImmSrc   	= 2'b10; // IMM12
				ALUSrcA  	= 1'b1;// PC+8
				ALUSrcB  	= 2'b01;	// ExtImm
				ALUControl 	= 4'b0100 ;	//ADD ExtImm+PC+8
				ResultSrc 	= 2'b10;	// Alu Result
				Write_Z_ENABLE = 1'b0;
				op_done = 1;//Branch instructrions have 3 cycles
				State_reg = 9;//S9
				end 
				
			default: begin 
				PCWrite 		= 1'b0; 
				AdrSrc   	= 1'b0; 
				MemWrite 	= 1'b0;
				IRWrite  	= 1'b0; 
				RegSrc 		= 2'b00;
				RegWrite 	= 1'b0; 
				ImmSrc   	= 2'b00; 
				ALUSrcA  	= 1'b0;
				ALUSrcB  	= 2'b00;
				ALUControl 	= 4'b0000; 
				ResultSrc 	= 2'b00;	
				Write_Z_ENABLE = 1'b0;
				op_done = 0;
				State_reg = 0;//S0
			end
		endcase
	end
	
	else if(Cycle_reg == 3) begin
	case(Op)
		2'b00:begin 
			// WriteBack
			PCWrite 		= 1'b0; 
			AdrSrc   	= 1'b0; 
			MemWrite 	= 1'b0; 
			IRWrite  	= 1'b0; 
			RegSrc 		= 2'b00; 
			ImmSrc   	= 2'b00; 		
			ALUSrcA  	= 1'b0;			
			ALUSrcB  	= 2'b00;		
			case(Funct[4:1])
				4'b1010: // FOR CMP, DO SUB BUT DO NOT WRITE TO REGISTER
					begin
					ALUControl = 4'b0010;
					RegWrite 	= 1'b0;	
					end
				
				default: 
					begin
					ALUControl = {Funct[4:1]};
					RegWrite 	= 1'b1;	
					end
			endcase
			ResultSrc 	= 2'b00;			// !
			State_reg = 8;//S8
			Write_Z_ENABLE = 1'b1;
			op_done = 1;//DP instructrions have 4 cycles
			end 		
		2'b01: begin
			// Read/Write Data 
			PCWrite 		= 1'b0; // don't care
			AdrSrc   	= 1'b1; //Result
			MemWrite 	= ~Funct[0]; //Read-write
			IRWrite  	= 1'b0; // don't care
			RegSrc 		= 2'b00;// don't care
			RegWrite 	= 1'b0; // RegWrite is at Writeback
			ImmSrc   	= 2'b01; // don't care
			ALUSrcA  	= 1'b0;// don't care
			ALUSrcB  	= 2'b01;// don't care
			ALUControl 	= 4'b0100; // don't care
			ResultSrc 	= 2'b00;	// don't care
			Write_Z_ENABLE = 1'b0;
			if(Funct[0])begin//LDR
				op_done = 0;
				State_reg = 3;//S3
			end
			
			else begin//STR
				op_done = 1;//STR instructrions have 4 cycles
				State_reg = 5;//S5
			end
				
			end 	
		default: begin
			PCWrite 		= 1'b0; 
			AdrSrc   	= 1'b0; 
			MemWrite 	= 1'b0;
			IRWrite  	= 1'b0; 
			RegSrc 		= 2'b00;
			RegWrite 	= 1'b0; 
			ImmSrc   	= 2'b00; 
			ALUSrcA  	= 1'b0;
			ALUSrcB  	= 2'b00;
			ALUControl 	= 4'b0000; 
			ResultSrc 	= 2'b00;
			Write_Z_ENABLE = 1'b0;
			op_done = 0;
			State_reg = 0;//S0
		end
		endcase
	end
	else if(Cycle_reg == 4) begin 
	// Only for LDR 
		if((Op == 2'b01) && (Funct[0] == 1)) begin
			// Writeback 
			PCWrite 		= 1'b0; // don't care
			AdrSrc   	= 1'b1; // don't care
			MemWrite 	= 1'b0; // don't care
			IRWrite  	= 1'b0; // don't care
			
			RegSrc 		= 2'b00; // don't care
				  
			RegWrite 	= 1'b1; // Write Dest Address
			ImmSrc   	= 2'b01; // don't care
			ALUSrcA  	= 1'b0; // don't care
			ALUSrcB  	= 2'b01; // don't care
			ALUControl 	= 4'b0100; // ADD
			ResultSrc 	= 2'b01;	// Read Data from Instr/Data Memory	
			Write_Z_ENABLE = 1'b0;
			op_done = 1;//LDR instructrions have 4 cycles
			State_reg = 4;//S4
		end
		else begin
				PCWrite 		= 1'b0; 
				AdrSrc   	= 1'b0; 
				MemWrite 	= 1'b0;
				IRWrite  	= 1'b0; 
				RegSrc 		= 2'b00;
				RegWrite 	= 1'b0; 
				ImmSrc   	= 2'b00; 
				ALUSrcA  	= 1'b0;
				ALUSrcB  	= 2'b00;
				ALUControl 	= 4'b0000; 
				ResultSrc 	= 2'b00;	
				Write_Z_ENABLE = 1'b0;
				op_done = 1;
				State_reg = 0;//S0
		end
	end
	
	else begin
				PCWrite 		= 1'b0; 
				AdrSrc   	= 1'b0; 
				MemWrite 	= 1'b0;
				IRWrite  	= 1'b0; 
				RegSrc 		= 2'b00;
				RegWrite 	= 1'b0; 
				ImmSrc   	= 2'b00; 
				ALUSrcA  	= 1'b0;
				ALUSrcB  	= 2'b00;
				ALUControl 	= 4'b0000; 
				ResultSrc 	= 2'b00;	
				Write_Z_ENABLE = 1'b0;
				op_done = 1;
				State_reg = 0;//S0
	end
	
	
	
end
endmodule
