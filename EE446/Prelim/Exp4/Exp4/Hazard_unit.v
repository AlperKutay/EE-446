module Hazard_unit(
	input MemtoRegE,
	
	input RegWriteW,
	input RegWriteM,
	
	input PCSrcD,
	input PCSrcE,
	input PCSrcM,
	input PCSrcW,
	
	input [3:0] RA1D,RA2D,RA1E,RA2E,WA3E,WA3M,WA3W,
	
	input BranchTakenE,
	
	output reg [1:0] ForwardBE,
	output reg [1:0] ForwardAE,
	output reg FlushE,
	
	output reg FlushD,
	output reg StallD,
	
	output reg StallF
);


wire Match_1E_M;
assign Match_1E_M = (RA1E == WA3M);

wire Match_1E_W;
assign Match_1E_W = (RA1E == WA3W);

wire Match_2E_M;
assign Match_2E_M = (RA2E == WA3M);

wire Match_2E_W;
assign Match_2E_W = (RA2E == WA3W);

wire Match_12D_E;
assign Match_12D_E = (RA1D == WA3E) | (RA2D == WA3E);

wire PCWrPendingF ;
assign PCWrPendingF= PCSrcD | PCSrcE | PCSrcM;

wire LDRstall ;
assign LDRstall= Match_12D_E & MemtoRegE;


always @(*) begin
	if(Match_1E_M & RegWriteM)begin
		ForwardAE = 2'b10;
	end
	else if(Match_1E_W & RegWriteW)begin
		ForwardAE = 2'b01;
	end
	else begin
		ForwardAE = 2'b00;
	end

	
	if(Match_2E_M & RegWriteM)begin
		ForwardBE = 2'b10;
	end
	else if(Match_2E_W & RegWriteW)begin
		ForwardBE = 2'b01;
	end
	else begin
		ForwardBE = 2'b00;
	end	
	

	StallF = LDRstall + PCWrPendingF;
	
	StallD = LDRstall;
	
	FlushD = PCWrPendingF + PCSrcW + BranchTakenE;
	
	FlushE = LDRstall + BranchTakenE;
	
end
endmodule