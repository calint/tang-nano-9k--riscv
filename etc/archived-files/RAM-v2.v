`default_nettype none
//`define DBG

module RAM #(
    parameter NUM_COL = 4,
    parameter COL_WIDTH = 8,
    parameter ADDR_WIDTH = 12,  // 2**12 = RAM depth
    parameter DATA_WIDTH = NUM_COL * COL_WIDTH,  // data width in bits
    parameter DATA_FILE = "RAM.mem"
) (
    input wire clkA,
    input wire enaA,
    input wire [NUM_COL-1:0] weA,
    input wire [ADDR_WIDTH-1:0] addrA,
    input wire [DATA_WIDTH-1:0] dinA,
    output reg [DATA_WIDTH-1:0] doutA,
    input wire clkB,
    input wire enaB,
    input wire [NUM_COL-1:0] weB,
    input wire [ADDR_WIDTH-1:0] addrB,
    input wire [DATA_WIDTH-1:0] dinB,
    output reg [DATA_WIDTH-1:0] doutB
);

  reg [DATA_WIDTH-1:0] ram_block[(2**ADDR_WIDTH)-1:0];

  initial begin
    $readmemh(DATA_FILE, ram_block);
  end

  // Port-A Operation
  always @(posedge clkA) begin
    if (weA) begin
      case (weA)
        4'b0001: ram_block[addrA][0*COL_WIDTH+:COL_WIDTH] <= dinA[0*COL_WIDTH+:COL_WIDTH];
        4'b0010: ram_block[addrA][1*COL_WIDTH+:COL_WIDTH] <= dinA[1*COL_WIDTH+:COL_WIDTH];
        4'b0100: ram_block[addrA][2*COL_WIDTH+:COL_WIDTH] <= dinA[2*COL_WIDTH+:COL_WIDTH];
        4'b1000: ram_block[addrA][3*COL_WIDTH+:COL_WIDTH] <= dinA[3*COL_WIDTH+:COL_WIDTH];
        4'b0011: ram_block[addrA][0*COL_WIDTH+:COL_WIDTH*2] <= dinA[0*COL_WIDTH+:COL_WIDTH*2];
        4'b1100: ram_block[addrA][2*COL_WIDTH+:COL_WIDTH*2] <= dinA[2*COL_WIDTH+:COL_WIDTH*2];
        4'b1111: ram_block[addrA] <= dinA;
        default: ;
      endcase
      //        ram_block[addrA] <= dinA;
    end else begin
      doutA <= ram_block[addrA];
    end
  end

  // Port-B Operation:
  always @(posedge clkB) begin
    doutB <= ram_block[addrB];
  end

endmodule

`undef DBG
`default_nettype wire
