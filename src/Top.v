`default_nettype none
//`define DBG

`include "Configuration.v"

module Top (
    input wire sys_clk,  // 27 MHz
    input wire sys_rst_n,
    output wire [5:0] led,
    input wire uart_rx,
    output wire uart_tx,
    input wire btn1
);

  wire soc_clk;

  Gowin_rPLL clk_rpll (
      .clkout(soc_clk),  // 20.250 MHz
      .clkin (sys_clk)   // 27 MHz
  );

  SoC #(
      .CLK_FREQ(20_250_000),
      .RAM_FILE(`RAM_FILE),
      .RAM_ADDR_WIDTH(`RAM_ADDR_WIDTH),
      .BAUD_RATE(`UART_BAUD_RATE)
  ) soc (
      .clk(soc_clk),
      .rst(!sys_rst_n),
      .led(led),
      .uart_rx(uart_rx),
      .uart_tx(uart_tx),
      .btn(btn1)
  );

endmodule

`undef DBG
`default_nettype wire
