`default_nettype none
//`define DBG

module Registers #(
    parameter ADDR_WIDTH = 5,
    parameter WIDTH = 32
) (
    input wire clk,
    input wire [ADDR_WIDTH-1:0] rs1,
    input wire [ADDR_WIDTH-1:0] rs2,
    input wire [ADDR_WIDTH-1:0] rd,
    input wire [WIDTH-1:0] rd_wd,  // data to write to register 'rd' when 'rd_we' is enabled
    input wire rd_we,
    output wire [WIDTH-1:0] rd1,  // value of register 'ra1'
    output wire [WIDTH-1:0] rd2,  // value of register 'ra2'
    input wire [ADDR_WIDTH-1:0] ra3,  // register address 3
    input wire [WIDTH-1:0] wd3,  // data to write to register 'ra3' when 'we3' is enabled
    input wire we3
);

  reg signed [WIDTH-1:0] mem[0:2**ADDR_WIDTH-1];

  // register 0 is hardwired to value 0
  assign rd1 = rs1 == 0 ? 0 : mem[rs1];
  assign rd2 = rs2 == 0 ? 0 : mem[rs2];

  always @(posedge clk) begin
`ifdef DBG
    $display("%0t: clk+: Registers (rs1,rs2,rd)=(%0h,%0h,%0h)", $time, rs1, rs2, rd);
`endif
    //    $display("%0t: we3=%0h, wd3=%0h, ra3=%0h, rd_we=%0h, rd_wd=%0h", $time, we3, wd3, ra3, rd_we, rd_wd);

    // write first the 'wd3' which is from a 'load'
    // then the 'wd2' which might overwrite the 'wd3'
    //   example: lw x1, 0(x2) ; addi x1, x1, 1
    // note: ok to write to register 'zero' since reading it yields 0
    if (we3) mem[ra3] <= wd3;
    if (rd_we) mem[rd] <= rd_wd;
  end

endmodule

`undef DBG
`default_nettype wire
