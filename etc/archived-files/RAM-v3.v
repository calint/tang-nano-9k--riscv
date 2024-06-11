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

  reg [7:0] ram_b0[(2**ADDR_WIDTH)-1:0];
  reg [7:0] ram_b1[(2**ADDR_WIDTH)-1:0];
  reg [7:0] ram_b2[(2**ADDR_WIDTH)-1:0];
  reg [7:0] ram_b3[(2**ADDR_WIDTH)-1:0];

  initial begin
    //    $readmemh(DATA_FILE, ram_block);
  end

  // Port-A Operation
  always @(posedge clkA) begin
    if (weA) begin
      case (weA)
        4'b0001: ram_b0[addrA] <= dinA[0*COL_WIDTH+:COL_WIDTH];
        4'b0010: ram_b1[addrA] <= dinA[1*COL_WIDTH+:COL_WIDTH];
        4'b0100: ram_b2[addrA] <= dinA[2*COL_WIDTH+:COL_WIDTH];
        4'b1000: ram_b3[addrA] <= dinA[3*COL_WIDTH+:COL_WIDTH];
        4'b0011: begin
          ram_b0[addrA] <= dinA[0*COL_WIDTH+:COL_WIDTH];
          ram_b1[addrA] <= dinA[1*COL_WIDTH+:COL_WIDTH];
        end
        4'b1100: begin
          ram_b2[addrA] <= dinA[2*COL_WIDTH+:COL_WIDTH];
          ram_b3[addrA] <= dinA[3*COL_WIDTH+:COL_WIDTH];
        end
        4'b1111: begin
          ram_b0[addrA] <= dinA[0*COL_WIDTH+:COL_WIDTH];
          ram_b1[addrA] <= dinA[1*COL_WIDTH+:COL_WIDTH];
          ram_b2[addrA] <= dinA[2*COL_WIDTH+:COL_WIDTH];
          ram_b3[addrA] <= dinA[3*COL_WIDTH+:COL_WIDTH];
        end
        default: ;
      endcase
    end else begin
      doutA <= {ram_b3[addrA], ram_b2[addrA], ram_b1[addrA], ram_b0[addrA]};
    end
  end

  // Port-B Operation:
  always @(posedge clkB) begin
    doutB <= {ram_b3[addrB], ram_b2[addrB], ram_b1[addrB], ram_b0[addrB]};
  end

endmodule

`undef DBG
`default_nettype wire
