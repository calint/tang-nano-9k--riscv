#!/bin/sh

# flash fpga
openFPGALoader -b tangnano9k -f impl/pnr/riscv.fs

# program (not flashed)
#openFPGALoader -b tangnano9k impl/pnr/riscv.fs

