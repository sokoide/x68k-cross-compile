	.include "iocscall.mac"

	.section .text
	.align	2
	.globl	main
	.type	main, @function

boot:
	bra.w	entry

	.string "FDD IPL"
	.even

entry:
	lea	(mysp, %pc), %a7

	move.w	#0, %d1
	move.w	#0, %d2

	IOCS	_B_LOCATE
	IOCS	_OS_CURON

	lea.l	(.message1, %pc), %a1
	IOCS	_B_PRINT

	IOCS	_B_KEYINP
	lea.l	(.message2, %pc), %a1
	IOCS	_B_PRINT

loop:
	bra	loop

	.section .data

.message1:
	.string	"Press any key\r\n"
	.even

.message2:
	.string	"Done\r\n"
	.even

	.section .bss

mystack:
	ds.b	256
mysp:
	.end main
