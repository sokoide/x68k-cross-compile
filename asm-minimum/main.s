	.include "doscall.mac"

	.section .text
	.align	2
	.globl	main
	.type	main, @function

main:
	# push the effective address of .message addr into the stack
	pea.l	.message1

	# PRINT DOSCALL
	DOS		_PRINT

	# pop the pushed address
	addq.l 	#4,%sp

	# EXIT DOSCALL
	DOS		_EXIT

	.section .data
	.align	2
.message1:
	.string "Hello, world!\r\n"

	.end 	main

