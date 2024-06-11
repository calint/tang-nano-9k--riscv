`timescale 1ns / 1ps
//
`default_nettype none
`define DBG

module TestBench;
  RAMIO #(
      .ADDR_WIDTH(13),  // 2**15 = RAM depth in words
      .DATA_WIDTH(32),
      .DATA_FILE ("")
  ) dut (
      .rst(rst),
      .clk(clk),
      .weA(weA),  // b01 - byte, b10 - half word, b11 - word
      .reA(reA),  // b01 - byte, b10 - half word, b11 - word
      .addrA(addrA[14:0]),  // bytes addressable
      .dinA(dinA),
      .doutA(doutA),
      .addrB(addrB[14:0]),
      .doutB(doutB)
  );

  localparam clk_tk = 10;
  reg clk = 0;
  always #(clk_tk / 2) clk = ~clk;

  reg [1:0] weA;
  reg [2:0] reA;
  reg [31:0] addrA;
  reg [31:0] dinA;
  wire [31:0] doutA;
  reg [31:0] addrB;
  wire [31:0] doutB;
  reg rst = 1;

  initial begin
    $dumpfile("log.vcd");
    $dumpvars(0, TestBench);

    // reset
    #clk_tk;
    #clk_tk;
    rst = 0;

    // write bytes
    weA   = 1;
    reA   = 0;

    dinA  = 8'h12;
    addrA = 0;
    #clk_tk;

    dinA  = 8'h34;
    addrA = 1;
    #clk_tk;

    dinA  = 8'h56;
    addrA = 2;
    #clk_tk;

    dinA  = 8'h78;
    addrA = 3;
    #clk_tk;

    if (dut.ram.data[0] == 32'h78563412) $display("test 1 passed");
    else $display("test 1 FAILED");

    // read word
    reA   = 3'b111;
    weA   = 0;
    addrA = 0;
    #clk_tk;

    //    $display("%h",doutA);
    if (doutA == 32'h78563412) $display("test 2 passed");
    else $display("test 2 FAILED");

    // write half words
    reA   = 0;
    weA   = 2;
    dinA  = 16'h1234;
    addrA = 4;
    #clk_tk;

    dinA  = 16'h5678;
    addrA = 6;
    #clk_tk;

    //    $display("%h",dut.ram.data[1]);
    if (dut.ram.data[1] == 32'h56781234) $display("test 3 passed");
    else $display("test 3 FAILED");

    // read word
    reA   = 3'b111;
    weA   = 0;
    addrA = 4;
    #clk_tk;

    //    $display("%h",doutA);
    if (doutA == 32'h56781234) $display("test 4 passed");
    else $display("test 4 FAILED");

    // read unsigned byte
    reA   = 3'b001;
    weA   = 0;
    addrA = 0;
    #clk_tk;

    //    $display("%h",doutA);
    if (doutA == 8'h12) $display("test 5 passed");
    else $display("test 5 FAILED");

    // read unsigned byte
    reA   = 3'b001;
    weA   = 0;
    addrA = 1;
    #clk_tk;

    //    $display("%h",doutA);
    if (doutA == 8'h34) $display("test 6 passed");
    else $display("test 6 FAILED");

    // read unsigned byte
    reA   = 3'b001;
    weA   = 0;
    addrA = 2;
    #clk_tk;

    //    $display("%h",doutA);
    if (doutA == 8'h56) $display("test 7 passed");
    else $display("test 7 FAILED");

    // read unsigned byte
    reA   = 3'b001;
    weA   = 0;
    addrA = 3;
    #clk_tk;

    //    $display("%h",doutA);
    if (doutA == 8'h78) $display("test 8 passed");
    else $display("test 8 FAILED");

    // read unsigned half word
    reA   = 3'b010;
    weA   = 0;
    addrA = 4;
    #clk_tk;

    //    $display("%h",doutA);
    if (doutA == 16'h1234) $display("test 9 passed");
    else $display("test 9 FAILED");

    // read unsigned half word
    reA   = 3'b010;
    weA   = 0;
    addrA = 6;
    #clk_tk;

    //    $display("%h",doutA);
    if (doutA == 16'h5678) $display("test 10 passed");
    else $display("test 10 FAILED");

    // read word
    reA   = 3'b111;
    weA   = 0;
    addrA = 4;
    #clk_tk;

    //    $display("%h",doutA);
    if (doutA == 32'h56781234) $display("test 11 passed");
    else $display("test 11 FAILED");

    // write word
    reA   = 0;
    weA   = 3;
    dinA  = 32'hfffe_fdfc;
    addrA = 8;
    #clk_tk;

    if (dut.ram.data[2] == 32'hfffe_fdfc) $display("test 12 passed");
    else $display("test 12 FAILED");

    // read signed byte
    reA   = 3'b101;
    weA   = 0;
    addrA = 8;
    #clk_tk;

    //    $display("%h",doutA);
    if (doutA == -4) $display("test 13 passed");
    else $display("test 13 FAILED");

    // read signed byte
    reA   = 3'b101;
    weA   = 0;
    addrA = 9;
    #clk_tk;

    //    $display("%h",doutA);
    if (doutA == -3) $display("test 14 passed");
    else $display("test 14 FAILED");

    // read signed byte
    reA   = 3'b101;
    weA   = 0;
    addrA = 10;
    #clk_tk;

    //    $display("%h",doutA);
    if (doutA == -2) $display("test 15 passed");
    else $display("test 15 FAILED");

    // read signed byte
    reA   = 3'b101;
    weA   = 0;
    addrA = 11;
    #clk_tk;

    //    $display("%h",doutA);
    if (doutA == -1) $display("test 16 passed");
    else $display("test 16 FAILED");

    // read signed half word
    reA   = 3'b110;
    weA   = 0;
    addrA = 8;
    #clk_tk;

    //    $display("%h",doutA);
    if (doutA == -516) $display("test 17 passed");
    else $display("test 17 FAILED");

    // read signed half word
    reA   = 3'b110;
    weA   = 0;
    addrA = 10;
    #clk_tk;

    //    $display("%h",doutA);
    if (doutA == -2) $display("test 18 passed");
    else $display("test 18 FAILED");

    $finish;
  end

endmodule
