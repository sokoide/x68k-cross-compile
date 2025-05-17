	.include "doscall.mac"

	.section .text
	.even
	.globl	main
	.type	main, @function

main:
	# push the effective address of .message addr into the stack
	pea.l	.message1

	# PRINT DOSCALL
	DOS		_PRINT

	# pop the pushed address
	addq.l 	#4,sp

	# EXIT DOSCALL
	DOS		_EXIT

	.section .data
	.even
.message1:
	.string "Hello, world!\r\n"

	.end 	main
