	.include "doscall.mac"

	.section .text
	.align	2
	.globl	main
	.type	main, @function

main:
	# setup sp
	lea.l	mysp, %a0
	# 0 clear sp@ and decrement sp
	clr.l	%sp@-
	#  enter supervisor mode to access the memory block chain
	DOS		_SUPER
	move.l	%d0, %sp@

	pea.l	.message1
	DOS		_PRINT
	addq.l 	#4,%sp

	 DOS		_SUPER
	 addq.l	#4, %sp

	 DOS		_EXIT

	 .section .data
	.align	2
.message1:
	.string "Hello, world!\r\n"

	# .stack or other custom sections are not supported
	.section .bss
	.align	2
mystack:
	.ds.l	1024
mysp:
	.end 	main

