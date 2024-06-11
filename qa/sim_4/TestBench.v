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
      .uart_tx(uart_tx),
      .uart_rx(uart_rx)
  );

  localparam CLK_FREQ = 50_000_000;
  localparam BAUD_RATE = CLK_FREQ >> 1;
  localparam UART_TICKS_PER_BIT = 2;  // CLK_FREQ / BAUD_RATE

  wire uart_tx;
  reg  uart_rx;

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

    // receive 0b0101_0101 (0x55)
    uart_rx = 1;  // idle
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 0;  // start bit
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 1;
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 0;
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 1;
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 0;

    // sample that reg has not changed
    if (dut.regs.mem[11] == 0) $display("test 1 passed");
    else $display("test 1 FAILED");

    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 1;
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 0;
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 1;
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 0;
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 1;  // stop bit
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 1;  // idle

    // wait until next load register
    #clk_tk;
    #clk_tk;
    #clk_tk;
    if (dut.regs.mem[11] == 8'h55) $display("test 2 passed");
    else $display("test 2 FAILED");

    // receive 0b0101_0101 (0x55)
    uart_rx = 1;  // idle
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 0;  // start bit
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 1;
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 0;
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 1;
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 0;
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;

    // sample that register has not changed
    if (dut.regs.mem[11] == 0) $display("test 3 passed");
    else $display("test 3 FAILED");

    uart_rx = 1;
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 0;
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 1;
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 0;
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 1;  // stop bit
    for (integer i = 0; i < UART_TICKS_PER_BIT; i = i + 1) #clk_tk;
    uart_rx = 1;  // idle

    // wait until next load register
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    #clk_tk;
    if (dut.regs.mem[11] == 8'h55) $display("test 4 passed");
    else $display("test 4 FAILED");

    $finish;
  end

endmodule
