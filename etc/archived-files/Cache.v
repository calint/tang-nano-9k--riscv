//
// instructions and data RAM
// port A: read / write 32 bit data
// port B: read-only 32 bit instruction
//

`default_nettype none
//`define DBG

module Cache #(
    parameter ADDRESS_BITWIDTH = 12,  // 2^12 = RAM depth
    parameter INSTRUCTION_BITWIDTH = 32,
    // size of an instruction. must be divisble by 8
    parameter ICACHE_LINE_IX_BITWIDTH = 1,
    // 2^1 cache lines
    parameter CACHE_IX_IN_LINE_BITWIDTH = 3,
    // 2^3 => instructions per cache line, 8 * 4 = 32 B
    // how many consequitive data is retrieved by BurstRAM
    parameter RAM_BURST_DATA_BITWIDTH = 64,
    // size of data sent in bits, must be divisible by 8 into bytes
    // RAM reads 4 * 8 = 32 B per burst
    // note: the burst size and cache line data must match in size
    //       a burst reads or writes one cache line thus:
    //       RAM_BURST_DATA_COUNT * RAM_BURST_DATA_BITWIDTH / 8 = 
    //       2 ^ CACHE_IX_IN_LINE_BITWIDTH * INSTRUCTION_BITWIDTH =
    //       32B
    parameter RAM_DEPTH_BITWIDTH = 4,
    parameter RAM_BURST_DATA_COUNT = 4
) (
    input wire clk,
    input wire rst,
    input wire [NUM_COL-1:0] weA,
    input wire [ADDRESS_BITWIDTH-1:0] addrA,
    input wire [DATA_BITWIDTH-1:0] dinA,
    output reg [DATA_BITWIDTH-1:0] doutA,
    input wire [ADDRESS_BITWIDTH-1:0] addrB,
    output reg [INSTRUCTION_BITWIDTH-1:0] doutB,
    input wire enB,
    output reg rdyB,
    output reg bsyB,

    // wiring to BurstRAM (prefix br_)
    output wire br_cmd,
    output wire br_cmd_en,
    output wire [RAM_DEPTH_BITWIDTH-1:0] br_addr,
    output wire [RAM_BURST_DATA_BITWIDTH-1:0] br_wr_data,
    output wire [RAM_BURST_DATA_BITWIDTH/8-1:0] br_data_mask,
    input wire [RAM_BURST_DATA_BITWIDTH-1:0] br_rd_data,
    input wire br_rd_data_valid,
    input wire br_busy
);

  ICache #(
      .LINE_IX_BITWIDTH(ICACHE_LINE_IX_BITWIDTH),  // 2^1 cache lines
      .ADDRESS_BITWIDTH(ADDRESS_BITWIDTH),
      .INSTRUCTION_BITWIDTH(32),  // 4 B per instruction
      .INSTRUCTION_IX_IN_LINE_BITWIDTH(CACHE_IX_IN_LINE_BITWIDTH),  // 2^3 32 bit instructions per cache line (32B)
      .RAM_DEPTH_BITWIDTH(RAM_DEPTH_BITWIDTH),
      .RAM_BURST_DATA_BITWIDTH(RAM_BURST_DATA_BITWIDTH),
      .RAM_BURST_DATA_COUNT(RAM_BURST_DATA_COUNT)  // 4 * 64 bits = 32B
      // note: size of INSTRUCTION_IX_IN_LINE_BITWIDTH and RAM_READ_BURST_COUNT must
      //       result in same number of bytes because a cache line is loaded by the size of a burst
  ) icache (
      .clk(clk),
      .clk_ram(clk),
      .rst(rst),
      .enable(icache_enable),
      .address(icache_address),
      .instruction(icache_instruction),
      .data_ready(icache_data_ready),
      .busy(icache_busy),

      // wiring to BurstRAM (prefix br_)
      .br_cmd(br_cmd),
      .br_cmd_en(br_cmd_en),
      .br_addr(br_addr),
      .br_wr_data(br_wr_data),
      .br_data_mask(br_data_mask),
      .br_rd_data(br_rd_data),
      .br_rd_data_valid(br_rd_data_valid),
      .br_busy(br_busy)
  );

  // ICache
  reg icache_enable;
  reg [ADDRESS_BITWIDTH-1:0] icache_address;
  wire [31:0] icache_instruction;
  wire icache_data_ready;
  wire icache_busy;
  // --

  localparam ADDRESS_DEPTH = 2 ** ADDRESS_BITWIDTH;
  localparam NUM_COL = 4;  // 4
  localparam COL_WIDTH = 8;  // 1 byte
  localparam DATA_BITWIDTH = NUM_COL * COL_WIDTH;  // data width in bits

  reg [DATA_BITWIDTH-1:0] data[ADDRESS_DEPTH-1:0];
  // note: synthesizes to SP (single port block ram)

  localparam STATE_PORT_B_IDLE = 3'b000;
  localparam STATE_PORT_B_WAITING_FOR_ICACHE_BUSY = 3'b010;
  localparam STATE_PORT_B_WAITING_FOR_ICACHE_DATA_READY = 3'b100;

  reg [1:0] state_port_b;

  always @(posedge clk) begin
    if (rst) begin
      state_port_b <= 0;
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
    case (state_port_b)
      STATE_PORT_B_IDLE: begin
        if (enB) begin
          rdyB <= 0;
          bsyB <= 1;
          if (icache_busy) begin
            state_port_b <= STATE_PORT_B_WAITING_FOR_ICACHE_BUSY;
          end else begin
            icache_address <= addrB;
            icache_enable <= 1;
            state_port_b <= STATE_PORT_B_WAITING_FOR_ICACHE_DATA_READY;
          end
        end
      end

      STATE_PORT_B_WAITING_FOR_ICACHE_BUSY: begin
        if (!icache_busy) begin
          icache_address <= addrB;
          icache_enable <= 1;
          state_port_b <= STATE_PORT_B_WAITING_FOR_ICACHE_DATA_READY;
        end
      end

      STATE_PORT_B_WAITING_FOR_ICACHE_DATA_READY: begin
        if (icache_data_ready) begin
          rdyB  <= 1;
          bsyB  <= 0;
          doutB <= icache_instruction;
          state_port_b <= STATE_PORT_B_IDLE;
        end
      end

    endcase
  end

endmodule

`undef DBG
`default_nettype wire
