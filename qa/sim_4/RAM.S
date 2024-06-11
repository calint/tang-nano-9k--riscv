.global _start

_start:
	addi x0, x0, 0			# nop
	lui x10, 0x20			# x10 = 0x1fffd
	addi x10, x10, -3		#
	
lp1:
	lbu x11, 0(x10)			# x11 = ram[0x1fffd]
	bne x11, x0, lp1		# if (x12 != 0)
	jal x0, lp1
