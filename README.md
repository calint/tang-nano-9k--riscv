# Tang Nano 9K: RISC-V

* experiments with simple CPU design

* implements the __rv32i__ instructions with the exception for: `fence`, `ecall`, `ebreak` and counters which are irrelevant for the intended use

* most implementation in `always @(*)` block for the sake of simplicity and overview (["SoC.v"](https://github.com/calint/tang-nano-9k--riscv/blob/master/src/SoC.v))

* ad-hoc 2-stage pipeline where a new instruction is fetched while previous executes

## implementation
* __[Tango Nano 9K](https://www.aliexpress.com/item/1005003803994525.html)__
* 32 KB of RAM for instructions and data
* 20 MHz with instructions executing in one cycle except branches which use two cycles due to creating "bubble" in the pipeline
* UART to send and receive text (see [`etc/samples/os.c`](https://github.com/calint/tang-nano-9k--riscv/blob/master/etc/samples/os.c) for example)

## how-to with Gowin EDA 1.9.9.03:
* connect fpga board, click `Run`, program device
* find out which tty is on the usb connected to the card (e.g. `/dev/ttyUSB1`)
* connect with serial terminal at 9600 baud, 8 bits, 1 stop bit, no parity
* button S1 is reset, click it to restart and display the prompt (does not reset ram)
* "welcome to adventure #4" is the prompt

## configuration
`configuration.py` contains data used by `configuration-generate.py` to generate:
  - `src/Configuration.v`
  - `os/os_config.h`
  - `os/os_start.S`

## /riscv.*
* files associated with Gowin EDA

## /os/
* source of initial program
  
## /qa/
* simulations and tests
  
## /src/
* Verilog source

## /etc/
* various notes and files
