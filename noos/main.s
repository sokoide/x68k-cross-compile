	.include "iocscall.mac"

	.section .text
	.align	2
	.globl	boot
	.type	boot, @function

boot:
	bra.w	entry

entry:
	lea		mysp, %a7

	move.w	#0, %d1
	move.w	#0, %d2

	IOCS	_B_LOCATE
	IOCS	_OS_CURON

	lea.l	.message1, %a1
	IOCS	_B_PRINT

	lea.l	.message2, %a1
	IOCS	_B_PRINT

	# read the sector2
	#  track 0, side 0, sector 1: IPL
	#  track 0, side 0, sector 2: <- read from here
	move.l	#0x010000, %a1
	move.w	#0x9070, %d1
	# 03: 2HD
	# 00: Track 0
	# 00: Side 0
	# 02: Sector 2
	move.l	#0x03000002, %d2
	move.l	#1024, %d3

	IOCS	_B_READ
	tst.l	%d0
	bne.w 	err

done:
	lea.l	.message_done, %a1
	IOCS	_B_PRINT
	jmp		loop

err:
	move.l	#0x010000, %a2
	move.l	%d0, (%a2)
	lea.l	.message_err, %a1
	IOCS	_B_PRINT

loop:
	jmp		loop

	.section .data
.message1:
	.string	"Booting Scott & Sandy OS...\r\n"
	.even

.message2:
	.string	"Loading the disk...\r\n"
	.even

.message_done:
	.string	"Sector 2 copied to 0x010000. Ready to go!\r\n"
	.even

.message_err:
	.string	"Error\r\n"
	.even

	.section .bss

mystack:
	ds.b	256
mysp:
	.end boot
