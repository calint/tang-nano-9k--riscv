//
// an emulator of a ram that bursts reads and writes
// used in simulations to mock IP components
//

`default_nettype none
//`define DBG

module BurstRAM #(
    parameter DEPTH_BITWIDTH = 4,  // 2^4 * 8B entries
    parameter DATA_FILE = "",
    parameter CYCLES_BEFORE_DATA_READY = 8,
    parameter BURST_COUNT = 4,
    parameter DATA_BITWIDTH = 64  // must be divisible by 8
) (
    input wire clk,
    input wire rst,
    input wire cmd,  // 0: read, 1: write
    input wire cmd_en,  // 1: cmd and addr is valid
    input wire [DEPTH_BITWIDTH-1:0] addr,  // 8 bytes word
    input wire [DATA_BITWIDTH-1:0] wr_data,  // data to write
    input wire [DATA_BITWIDTH/8-1:0] data_mask,  // not implemented (same as 0 in IP component)
    output reg [DATA_BITWIDTH-1:0] rd_data,  // read data
    output reg rd_data_valid,  // rd_data is valid
    output reg busy
);

  localparam DEPTH = 2 ** DEPTH_BITWIDTH;
  localparam CMD_READ = 0;
  localparam CMD_WRITE = 1;

  reg [DATA_BITWIDTH-1:0] data[DEPTH-1:0];
  reg [$clog2(BURST_COUNT)-1:0] burst_counter;
  reg [$clog2(CYCLES_BEFORE_DATA_READY):0] read_delay_counter;
  // note: not -1 because it should delay the number of cycles
  reg [DEPTH-1:0] addr_counter;

  localparam STATE_IDLE = 3'b000;
  localparam STATE_READ_DELAY = 3'b001;
  localparam STATE_READ_BURST = 3'b010;
  localparam STATE_WRITE_BURST = 3'b100;

  reg [2:0] state;

  initial begin
    if (DATA_FILE != "") begin
      $readmemh(DATA_FILE, data, 0, DEPTH - 1);
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      rd_data_valid <= 0;
      rd_data <= 0;
      busy <= 0;
      state <= STATE_IDLE;
    end else begin
      case (state)

        STATE_IDLE: begin
          if (cmd_en) begin
            busy <= 1;
            burst_counter <= 0;
            case (cmd)
              CMD_READ: begin
                read_delay_counter <= 0;
                addr_counter <= addr;
                state <= STATE_READ_DELAY;
              end
              CMD_WRITE: begin
                data[addr] <= wr_data;
                addr_counter <= addr + 1;
                // note: +1 because first write is done in this cycle
                state <= STATE_WRITE_BURST;
              end
            endcase
          end
        end

        STATE_READ_DELAY: begin
          if (read_delay_counter == CYCLES_BEFORE_DATA_READY) begin
            // note: not -1 because state would switch one cycle early
            rd_data_valid <= 1;
            rd_data <= data[addr_counter];
            addr_counter <= addr_counter + 1;
            state <= STATE_READ_BURST;
          end
          read_delay_counter <= read_delay_counter + 1;
        end

        STATE_READ_BURST: begin
          burst_counter <= burst_counter + 1;
          addr_counter  <= addr_counter + 1;
          if (burst_counter == BURST_COUNT - 1) begin
            // note: -1 because of non-blocking assignments
            rd_data_valid <= 0;
            set_new_state_after_command_done;
          end else begin
            rd_data <= data[addr_counter];
          end
        end

        STATE_WRITE_BURST: begin
          burst_counter <= burst_counter + 1;
          addr_counter  <= addr_counter + 1;
          if (burst_counter == BURST_COUNT - 1) begin
            // note: -1 because of non-blocking assignments
            set_new_state_after_command_done;
          end else begin
            data[addr_counter] <= wr_data;
          end
        end

        default: ;
      endcase
    end
  end

  task set_new_state_after_command_done;
    begin
      busy  <= 0;
      state <= STATE_IDLE;
      if (cmd_en) begin
        busy <= 1;
        burst_counter <= 0;
        case (cmd)
          CMD_READ: begin
            read_delay_counter <= 0;
            addr_counter <= addr;
            state <= STATE_READ_DELAY;
          end
          CMD_WRITE: begin
            data[addr] <= wr_data;
            addr_counter <= addr + 1;
            // note: +1 because first write is done in this cycle
            state <= STATE_WRITE_BURST;
          end
        endcase
      end
    end
  endtask

endmodule

`undef DBG
`default_nettype wire
