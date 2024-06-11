`timescale 1ns / 1ps
//
`default_nettype none
`define DBG

module TestBench;
  SoC #(
      .RAM_FILE("RAM.mem")
  ) dut (
      .clk(clk),
      .rst(rst)
  );


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

    //    $display("*** start ***");

    // 0: 00000013 addi x0,x0,0
    #clk_tk;

    // 4: 12345537 lui x10,0x12345
    #clk_tk;
    if (dut.regs.mem[10] == 32'h1234_5000) $display("test 1 passed");
    else $display("test 1 FAILED");

    // 8: 67850513 addi x10,x10,1656 # 12345678
    #clk_tk;
    if (dut.regs.mem[10] == 32'h1234_5678) $display("test 2 passed");
    else $display("test 2 FAILED");

    // c: 00300593 addi x11,x0,3
    #clk_tk;
    if (dut.regs.mem[11] == 32'h3) $display("test 3 passed");
    else $display("test 3 FAILED");

    // 10: 0045a613 slti x12,x11,4
    #clk_tk;
    if (dut.regs.mem[12] == 32'h1) $display("test 4 passed");
    else $display("test 4 FAILED");

    // 14: fff5a613 slti x12,x11,-1
    #clk_tk;
    if (dut.regs.mem[12] == 32'h0) $display("test 5 passed");
    else $display("test 5 FAILED");

    // 18: 0045b613 sltiu x12,x11,4
    #clk_tk;
    if (dut.regs.mem[12] == 32'h1) $display("test 6 passed");
    else $display("test 6 FAILED");

    // 1c: fff5b613 sltiu x12,x11,-1
    #clk_tk;
    if (dut.regs.mem[12] == 32'h1) $display("test 7 passed");
    else $display("test 7 FAILED");

    // 20: fff64693 xori x13,x12,-1
    #clk_tk;
    if (dut.regs.mem[13] == 32'hffff_fffe) $display("test 8 passed");
    else $display("test 8 FAILED");

    // 24: 0016e693 ori x13,x13,1
    #clk_tk;
    if (dut.regs.mem[13] == 32'hffff_ffff) $display("test 9 passed");
    else $display("test 9 FAILED");

    // 28: 0026f693 andi x13,x13,2
    #clk_tk;
    if (dut.regs.mem[13] == 32'h2) $display("test 10 passed");
    else $display("test 10 FAILED");

    // 2c: 00369693 slli x13,x13,0x3
    #clk_tk;
    if (dut.regs.mem[13] == 16) $display("test 11 passed");
    else $display("test 11 FAILED");

    // 30: 0036d693 srli x13,x13,0x3
    #clk_tk;
    if (dut.regs.mem[13] == 2) $display("test 12 passed");
    else $display("test 12 FAILED");

    // 34: fff6c693 xori x13,x13,-1
    #clk_tk;
    if (dut.regs.mem[13] == -3) $display("test 13 passed");
    else $display("test 13 FAILED");

    // 38: 4016d693 srai x13,x13,0x1
    #clk_tk;
    if (dut.regs.mem[13] == -2) $display("test 14 passed");
    else $display("test 14 FAILED");

    // 3c: 00c68733 add x14,x13,x12
    #clk_tk;
    if (dut.regs.mem[14] == -1) $display("test 15 passed");
    else $display("test 15 FAILED");

    // 40: 40c70733 sub x14,x14,x12
    #clk_tk;
    if (dut.regs.mem[14] == -2) $display("test 16 passed");
    else $display("test 16 FAILED");

    // 44: 00c617b3 sll x15,x12,x12
    #clk_tk;
    if (dut.regs.mem[15] == 2) $display("test 17 passed");
    else $display("test 17 FAILED");

    // 48: 00f62833 slt x16,x12,x15
    #clk_tk;
    if (dut.regs.mem[16] == 1) $display("test 18 passed");
    else $display("test 18 FAILED");

    // 4c: 00c62833 slt x16,x12,x12
    #clk_tk;
    if (dut.regs.mem[16] == 0) $display("test 19 passed");
    else $display("test 19 FAILED");

    // 50: 00d83833 sltu x16,x16,x13
    #clk_tk;
    if (dut.regs.mem[16] == 1) $display("test 20 passed");
    else $display("test 20 FAILED");

    // 54: 00d84833 xor x17,x16,x13
    #clk_tk;
    if (dut.regs.mem[17] == -1) $display("test 21 passed");
    else $display("test 21 FAILED");

    // 58: 0105d933 srl x18,x11,x16
    #clk_tk;
    if (dut.regs.mem[18] == 1) $display("test 22 passed");
    else $display("test 22 FAILED");

    // 5c: 4108d933 sra x18,x17,x16
    #clk_tk;
    if (dut.regs.mem[18] == -1) $display("test 23 passed");
    else $display("test 23 FAILED");

    // 60: 00b869b3 or x19,x16,x11
    #clk_tk;
    if (dut.regs.mem[19] == 3) $display("test 24 passed");
    else $display("test 24 FAILED");

    // 64: 0109f9b3 and x19,x19,x16
    #clk_tk;
    if (dut.regs.mem[19] == 1) $display("test 25 passed");
    else $display("test 25 FAILED");

    // 68: 00001a37 lui x20,0x1
    #clk_tk;
    if (dut.regs.mem[20] == 32'h0000_1000) $display("test 26 passed");
    else $display("test 26 FAILED");

    // 6c: 013a2223 sw x19,4(x20) # 1004
    #clk_tk;
    if (dut.ram.ram.data[32'h0000_1004>>2] == 32'h0000_0001) $display("test 27 passed");
    else $display("test 27 FAILED");

    // 70: 013a1323 sh x19,6(x20)
    #clk_tk;
    if (dut.ram.ram.data[32'h0000_1004>>2] == 32'h0001_0001) $display("test 28 passed");
    else $display("test 28 FAILED");

    // 74: 013a03a3 sb x19,7(x20)
    #clk_tk;
    if (dut.ram.ram.data[32'h0000_1004>>2] == 32'h0101_0001) $display("test 29 passed");
    else $display("test 29 FAILED");

    // 78: 004a0a83 lb x21,4(x20)
    #clk_tk;  // x21 write is in the next cycle

    // 7c: 006a1a83 lh x21,6(x20)
    #clk_tk;
    // check previous cycle (78) lb
    if (dut.regs.mem[21] == 32'h0000_0001) $display("test 30 passed");
    else $display("test 30 FAILED");

    // 80: 004a2a83 lw x21,4(x20)
    #clk_tk;
    // check previous cycle (7c) lh
    if (dut.regs.mem[21] == 32'h0000_0101) $display("test 31 passed");
    else $display("test 31 FAILED");

    // 84: 011a2023 sw x17,0(x20)
    #clk_tk;
    if (dut.ram.ram.data[32'h0000_1000>>2] == 32'hffff_ffff) $display("test 32 passed");
    else $display("test 32 FAILED");
    // check previous cycle (80) lw
    if (dut.regs.mem[21] == 32'h0101_0001) $display("test 33 passed");
    else $display("test 33 FAILED");


    // 88: 000a4a83 lbu x21,0(x20)
    #clk_tk;  // the restult is writting to x21 in the next cycle

    // 8c: 002a5a83 lhu x21,2(x20)
    #clk_tk;  // the restult is writting to x21 in the next cycle
    // check previous cycle (88) lbu
    if (dut.regs.mem[21] == 32'h0000_00ff) $display("test 34 passed");
    else $display("test 34 FAILED");

    // 90: 001a8b13 addi x22,x21,1
    #clk_tk;
    // check previous cycle (8c) lhu
    if (dut.regs.mem[21] == 32'h0000_ffff) $display("test 35 passed");
    else $display("test 35 FAILED");
    // check that addi used the retrieved x20
    if (dut.regs.mem[22] == 32'h0001_0000) $display("test 36 passed");
    else $display("test 36 FAILED");

    // 94: 36c000ef jal x1,400 <lbl_jal>
    #clk_tk;
    #clk_tk;  // bubble

    // 400: 00008067 jalr x0,0(x1)
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_0404) $display("test 37 passed");
    else $display("test 37 FAILED");
    #clk_tk;
    #clk_tk;  // bubble

    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_009c) $display("test 38 passed");
    else $display("test 38 FAILED");
    // 98: 376b0863 beq x22,x22,408 <lbl_beq>
    #clk_tk;
    #clk_tk;  // bubble
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_040c) $display("test 39 passed");
    else $display("test 39 FAILED");

    // 408:	c95ff06f jal x0,9c <lbl1>
    #clk_tk;
    #clk_tk;  // bubble
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_00a0) $display("test 40 passed");
    else $display("test 40 FAILED");

    // 9c: 375b1a63 bne x22,x21,410 <lbl_bne>
    #clk_tk;
    #clk_tk;  // bubble
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_0414) $display("test 41 passed");
    else $display("test 41 FAILED");

    // 410: c91ff06f jal x0,a0 <lbl2>
    #clk_tk;
    #clk_tk;  // bubble
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_00a4) $display("test 42 passed");
    else $display("test 42 FAILED");

    // a0: 376acc63 blt x21,x22,418 <lbl_blt>
    #clk_tk;
    #clk_tk;  // bubble
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_041c) $display("test 43 passed");
    else $display("test 43 FAILED");

    // 418: c8dff06f jal x0,a4 <lbl3>
    #clk_tk;
    #clk_tk;  // bubble
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_00a8) $display("test 44 passed");
    else $display("test 44 FAILED");

    // a4: 375b5e63 bge x22,x21,420 <lbl_bge>
    #clk_tk;
    #clk_tk;  // bubble
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_0424) $display("test 45 passed");
    else $display("test 45 FAILED");

    // 420. c89ff06f jal x0,a8 <lbl4>
    #clk_tk;
    #clk_tk;  // bubble
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_00ac) $display("test 46 passed");
    else $display("test 46 FAILED");

    // a8: 3929e063 bltu x19,x18,428 <lbl_bltu>
    #clk_tk;
    #clk_tk;  // bubble
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_042c) $display("test 47 passed");
    else $display("test 47 FAILED");

    // 428: c85ff06f jal x0,ac <lbl5>
    #clk_tk;
    #clk_tk;  // bubble
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_00b0) $display("test 48 passed");
    else $display("test 48 FAILED");

    // ac: 39397263 bgeu x18,x19,430 <lbl_bgeu>
    #clk_tk;
    #clk_tk;  // bubble
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_0434) $display("test 49 passed");
    else $display("test 49 FAILED");

    // 430: c81ff06f jal x0,b0 <lbl6>
    #clk_tk;
    #clk_tk;  // bubble
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_00b4) $display("test 50 passed");
    else $display("test 50 FAILED");

    // b0: 355b0c63 beq x22,x21,408 <lbl_beq>
    #clk_tk;
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_00b8) $display("test 51 passed");
    else $display("test 51 FAILED");

    // b4: 355a9a63 bne x21,x21,408 <lbl_beq>
    #clk_tk;
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_00bc) $display("test 52 passed");
    else $display("test 52 FAILED");

    // b8: 375b4063 blt x22,x21,418 <lbl_blt>
    #clk_tk;
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_00c0) $display("test 53 passed");
    else $display("test 53 FAILED");

    // bc: 376ad263 bge x21,x22,420 <lbl_bge>
    #clk_tk;
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_00c4) $display("test 54 passed");
    else $display("test 54 FAILED");

    // c0: 37396463 bltu x18,x19,428 <lbl_bltu>
    #clk_tk;
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_00c8) $display("test 55 passed");
    else $display("test 55 FAILED");

    // c4: 3729f663 bgeu x19,x18,430 <lbl_bgeu>
    #clk_tk;
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_00cc) $display("test 56 passed");
    else $display("test 56 FAILED");

    // c8: 370000ef jal x1,438 <lbl_auipc>
    #clk_tk;
    #clk_tk;  // bubble
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_043c) $display("test 57 passed");
    else $display("test 57 FAILED");

    // 438: fffff117 auipc x2,0xfffff
    #clk_tk;
    if (dut.regs.mem[2] == 32'hffff_f438) $display("test 58 passed");
    else $display("test 58 FAILED");

    // 43c: 00008067 jalr x0,0(x1)
    #clk_tk;
    #clk_tk;  // bubble
    // note. pc is a step ahead thus pc + 4
    if (dut.pc == 32'h0000_00d0) $display("test 59 passed");
    else $display("test 59 FAILED");

    // cc: fffc6c13 ori x24,x24,-1
    #clk_tk;
    //$display("%h", dut.regs.mem[24]);

    // d0: 05500b93 addi x23,x0,85
    #clk_tk;

    // d4: 017c0023 sb x23,0(x24)
    #clk_tk;
    if (dut.ram.leds == 7'b01_0101) $display("test 60 passed");
    else $display("test 60 FAILED");

    // d8: 002a5a83 lhu x21,2(x20)
    #clk_tk;

    // dc: 001a8a93 addi x21,x21,1
    #clk_tk;
    if (dut.regs.mem[21] == 32'h1_0000) $display("test 61 passed");
    else $display("test 61 FAILED");

    // e0: 015a2023 sw x21,0(x20)
    #clk_tk;
    if (dut.ram.ram.data[32'h0000_1000>>2] == 32'h0001_0000) $display("test 62 passed");
    else $display("test 62 FAILED");

    // e4: 000a2c83 lw x25,0(x20)
    #clk_tk;

    // e8: 001c8d13 addi x26,x25,1
    #clk_tk;
    // one cycle delay for x25 to be written from load
    if (dut.regs.mem[25] == 32'h1_0000) $display("test 63 passed");
    else $display("test 63 FAILED");
    // check that pipeline resolution of x25 is correct
    if (dut.regs.mem[26] == 32'h1_0001) $display("test 64 passed");
    else $display("test 64 FAILED");

    // ec: fffd0d13 addi x26,x26,-1
    #clk_tk;
    if (dut.regs.mem[26] == 32'h1_0000) $display("test 65 passed");
    else $display("test 65 FAILED");

    $finish;
  end

endmodule
