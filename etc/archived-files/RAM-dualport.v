`default_nettype none
//`define DBG

// note. line 35: synchronous assignment to avoid "Place and Route WRITE_MODE=2'b10" not supported issue.

module RAM #(
    parameter NUM_COL = 4,
    parameter COL_WIDTH = 8,
    parameter ADDR_WIDTH = 12,  // 2**12 = RAM depth
    parameter DATA_WIDTH = NUM_COL * COL_WIDTH,  // data width in bits
    parameter DATA_FILE = ""
) (
    input wire clk,
    input wire [NUM_COL-1:0] weA,
    input wire [ADDR_WIDTH-1:0] addrA,
    input wire [DATA_WIDTH-1:0] dinA,
    output reg [DATA_WIDTH-1:0] doutA,
    input wire [ADDR_WIDTH-1:0] addrB,
    output reg [DATA_WIDTH-1:0] doutB
);

  reg [DATA_WIDTH-1:0] data[(2**ADDR_WIDTH)-1:0];

  initial begin
    if (DATA_FILE != "") begin
      $readmemh(DATA_FILE, data, 0, 2 ** ADDR_WIDTH - 1);
    end
  end

  // Port-A Operation
  always @(posedge clk) begin
    for (integer i = 0; i < NUM_COL; i = i + 1) begin
      if (weA[i]) begin
        data[addrA][i*COL_WIDTH+:COL_WIDTH] = dinA[i*COL_WIDTH+:COL_WIDTH];
      end
    end
    doutA <= data[addrA];
  end

  // Port-B Operation:
  always @(posedge clk) begin
    doutB <= data[addrB];
  end

endmodule

`undef DBG
`default_nettype wire
