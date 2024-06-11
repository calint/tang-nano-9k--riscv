#!/bin/python3
# generates configuration files for Verilog source and 'os'

import configuration as cfg

# calculate memory addresses based on RAM_ADDR_WIDTH
# subtract 4 to get the top address for the stack (skipping LEDS and UART)
top_address = hex(2**cfg.RAM_ADDR_WIDTH - 4)

with open('os/os_start.S', 'w') as file:
    file.write('# generated - do not edit\n')
    file.write('.global _start\n')
    file.write('_start:\n')
    file.write('    li sp, {}\n'.format(hex(2**(cfg.RAM_ADDR_WIDTH+2) - 4)))
    file.write('    jal ra, run\n')

with open('os/os_config.h', 'w') as file:
    file.write('// generated - do not edit\n')
    file.write(
        'volatile unsigned char *leds = (unsigned char *){};\n'.format(hex(2**(cfg.RAM_ADDR_WIDTH+2) - 1)))
    file.write(
        'volatile unsigned char *uart_out = (unsigned char *){};\n'.format(hex(2**(cfg.RAM_ADDR_WIDTH+2) - 2)))
    file.write(
        'volatile unsigned char *uart_in = (unsigned char *){};\n'.format(hex(2**(cfg.RAM_ADDR_WIDTH+2) - 3)))

with open('src/Configuration.v', 'w') as file:
    file.write('// generated - do not edit\n')
    file.write('`define RAM_FILE \"../{}\"\n'.format(cfg.RAM_FILE))
    file.write('`define RAM_ADDR_WIDTH {}\n'.format(cfg.RAM_ADDR_WIDTH))
    file.write('`define UART_BAUD_RATE {}\n'.format(cfg.UART_BAUD_RATE))

print("generated: src/Configuration.v, os/os_config.h, os/os_start.S")
