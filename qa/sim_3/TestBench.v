`timescale 1ns / 1ps
//
`default_nettype none
`define DBG

module TestBench;
  SoC #(
      .RAM_FILE ("RAM.mem"),
      .CLK_FREQ (CLK_FREQ),
      .BAUD_RATE(BAUD_RATE)
  ) dut (
      .clk(clk),
      .rst(rst),
      .uart_tx(uart_tx)
  );

  localparam CLK_FREQ = 50_000_000;
  localparam BAUD_RATE = CLK_FREQ >> 1;

  wire uart_tx;

  localparam clk_tk = 10;
  reg clk = 0;
  always #(clk_tk / 2) clk = ~clk;

  reg rst = 1;

  initial begin
    $dumpfile("log.vcd");
    $dumpvars(0, TestBench);

    // reset
    #clk_tk;
    #clk_tk;
    rst = 0;

    // start pipeline
    #clk_tk;

    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;

    // 'E'
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;

    // send done    
    #clk_tk;

    $finish;
  end

endmodule
