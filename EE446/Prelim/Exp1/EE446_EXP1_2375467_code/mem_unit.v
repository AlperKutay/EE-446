module mem_unit #(parameter W = 8, parameter ADDR_WIDTH = 8)(
  input wire CLK,
  input wire WE,
  input wire [W-1:0] WRITE,
  input wire [ADDR_WIDTH-1:0] INPUT_ADDRESS,
  output reg [W-1:0] READ
);

  reg [7:0] MEMORY [2**ADDR_WIDTH - 1:0];

  always @(posedge CLK)
    if (WE)//Write
      MEMORY[INPUT_ADDRESS] <= WRITE;

  always @(INPUT_ADDRESS)//When INPUT_ADDRESS changed, Read should be changed at that moment.
    READ = MEMORY[INPUT_ADDRESS];

endmodule