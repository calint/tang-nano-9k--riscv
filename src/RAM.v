//
// instructions and data RAM
// port A: read / write 32 bit data
// port B: read-only 32 bit instruction
//

`default_nettype none
//`define DBG

module RAM #(
    parameter ADDR_WIDTH = 12,  // 2**12 = RAM depth
    parameter DATA_FILE  = ""
) (
    input wire clk,
    input wire [NUM_COL-1:0] weA,
    input wire [ADDR_WIDTH-1:0] addrA,
    input wire [DATA_WIDTH-1:0] dinA,
    output reg [DATA_WIDTH-1:0] doutA,
    input wire [ADDR_WIDTH-1:0] addrB,
    output reg [INSTR_WIDTH-1:0] doutB
);

  localparam ADDR_DEPTH = 2 ** ADDR_WIDTH;
  localparam COL_WIDTH = 8;  // byte
  localparam NUM_COL = 4;  // 4 x 8 = 32 B
  localparam DATA_WIDTH = NUM_COL * COL_WIDTH;  // data width in bits
  localparam INSTR_WIDTH = 32;

  reg [INSTR_WIDTH-1:0] instr[ADDR_DEPTH-1:0];
  // note: synthesizes to pROM

  reg [ DATA_WIDTH-1:0] data [ADDR_DEPTH-1:0];
  // note: synthesizes to SP (single port block ram)

  initial begin
    if (DATA_FILE != "") begin
      $readmemh(DATA_FILE, instr, 0, ADDR_DEPTH - 1);
      $readmemh(DATA_FILE, data, 0, ADDR_DEPTH - 1);
    end
  end

  // Port-A Operation
  always @(posedge clk) begin
    for (integer i = 0; i < NUM_COL; i = i + 1) begin
      if (weA[i]) begin
        data[addrA][i*COL_WIDTH+:COL_WIDTH] <= dinA[i*COL_WIDTH+:COL_WIDTH];
      end
    end
    doutA <= data[addrA];
  end

  // Port-B Operation:
  always @(posedge clk) begin
    doutB <= instr[addrB];
  end

endmodule

`undef DBG
`default_nettype wire
