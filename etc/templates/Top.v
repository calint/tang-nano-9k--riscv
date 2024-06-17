`default_nettype none
//`define DBG

`include "Configuration.v"

module Top (
    input wire sys_clk,  // 27 MHz
    input wire sys_rst_n,
    output reg [5:0] led,
    input wire uart_rx,
    output wire uart_tx,
    input wire btn1
);

  //   assign uart_tx = uart_rx;

  reg [7:0] send;
  reg uarttx_go;
  wire uarttx_bsy;

  UartTx #(
      .CLK_FREQ (27_000_000),
      .BAUD_RATE(9600)
  ) uarttx (
      .rst(!sys_rst_n),
      .clk(sys_clk),
      .data(send),  // data to send
      .go(uarttx_go),  // enable to start transmission, disable after 'data' has been read
      .tx(uart_tx),  // uart tx wire
      .bsy(uarttx_bsy)  // enabled while sending
  );

  reg [3:0] state;
  localparam STATE_NEXT = 4'b0001;
  localparam STATE_SEND = 4'b0010;

  //   assign led = ~state;

  always @(posedge sys_clk, negedge sys_rst_n) begin
    if (!sys_rst_n) begin
      send <= 64;
      uarttx_go <= 0;
      led <= 6'b111111;
      state <= STATE_NEXT;
    end else begin
      case (state)
        STATE_NEXT: begin
          uarttx_go <= 1;
          send <= send + 1;
          if (send == 90) begin
            send <= 65;
          end
          state <= STATE_SEND;
        end
        STATE_SEND: begin
          //   led <= 6'b111110;
          if (!uarttx_bsy) begin
            led <= 6'b111100;
            uarttx_go <= 0;
            state <= STATE_NEXT;
          end
        end
      endcase
    end
  end

endmodule

`undef DBG
`default_nettype wire
