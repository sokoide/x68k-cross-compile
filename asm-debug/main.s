	.include "doscall.mac"

	.section .text
	.even
	.globl	main
	.type	main, @function

main:
	move.b	#10, d0
	move.b	#20, d1
	add.b	d1, d0
	DOS	_EXIT

	.end
