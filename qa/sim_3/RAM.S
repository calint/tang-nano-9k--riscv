.global _start

_start:
	addi x0, x0, 0			# nop
	lui x10, 0x20			# x10 = 0x1fffe
	addi x10, x10, -2		#
	
	addi x11, x0, 0x48 		# x11 = 0x48 ('H')
	sb x11, 0(x10)			# ram[0x1fffe] = 0x48
lp1:
	lbu x12, 0(x10)			# x12 = ram[0x1fffe] == 0x48 | 0
	bne x12, x0, lp1		# if (x12 != 0)

	addi x11, x0, 0x45 		# x11 = 0x45 ('E')
	sb x11, 0(x10)			# ram[0x1fffe] = 0x48
lp2:
	lbu x12, 0(x10)			# x12 = ram[0x1fffe] == 0x48 | 0
	bne x12, x0, lp2		# if (x12 != 0)

done:
	jal x0, done			# hang

