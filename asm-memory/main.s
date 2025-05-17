#
# Oh! X 1990.1
# X68000マシン語プログラミング
# Chapter_0A
#

	.include "doscall.mac"
	.xref	itoh

# memory mgmt structure
.equ	PREVMEM,	0
.equ	OWNERPROC,	4
.equ	MBEND,		8
.equ	NEXTMEM,	12

	.section .text
	.align	1
	.globl	main
	.type	main, @function
main:
	# setup sp
	lea.l	mysp, %sp
	# 0 clear sp@ and decrement sp
	clr.l	%sp@-
	#  enter supervisor mode to access the memory block chain
	DOS		_SUPER
	move.l	%d0, %sp@
	# d0: previous ssp, need it when going back to user mode

#
# memory block chain
#
# a0 points to the current process's memory block mgmt struct
# each memory mgmt pointer is a doubly linked list node which has a 16 byte strust as below
#  +0x00 the previous memory mgmt pointer address. 0 if it's the last one
#  +0x04 memory mgmt pointer who allocated this block (parent). 0 if there is no parent
#  +0x08 address of the end of the memory block + 1
#  +0x0C the next memory mgmt pointer address. 0 if this is the last
# if you have the current memory mgmt pointer in a0,
#  movea.l %a0@, %a0 * get the previous memory mgmt pointer in a0
#  movea.l %a0@12, %a0 * get the next memory mgmt pointer in a0
#

loop1:
	# get the previous memory mgmt pointer in d0
	move.l	%a0@(PREVMEM), %d0
	# if 0, exit the loop
	beq		loop2
	# copy d0 to a0
	movea.l	%d0, %a0
	bra		loop1

# at this point, a0 points to the first memory mgmt pointer
loop2:
	# push buff address to stack
	pea.l	buff
	# push a0 to stack
	move.l	%a0, %sp@-
	bsr		itoh
	addq.l	#8, %sp
	move.b	#'-', buff+8

	# push buff+9 to stack
	pea.l	buff+9
	# push a0@(MBEND)-1 to stack
	move.l	%a0@(MBEND), %d0
	subq.l	#1, %d0
	move.l	%d0, %sp@-
	bsr		itoh
	addq.l	#8, %sp

	pea.l	buff
	DOS		_PRINT
	addq.l	#4, %sp

	pea.l	crlf
	DOS		_PRINT
	addq.l	#4, %sp

	# a0 = next memory mgmt ptr
	move.l	%a0@(NEXTMEM), %d0
	# movea doesn't change the flag
	movea.l	%d0, %a0
	# loop if it's not 0
	bne		loop2

	# the previous ssp is already in sp@ -> going to user mode
	DOS		_SUPER
	addq.l	#4, %sp

	DOS		_EXIT

newline:
	mov.w 	#0x0d, %sp@-
	DOS 	_PUTCHAR
	addq.l	#2, %sp
	mov.w 	#0x0a, %sp@-
	DOS 	_PUTCHAR
	addq.l	#2, %sp
	rts

	.section .data
	.align	2
buff:
	.string "12345678-12345678"
crlf:
	.dc.b	0x0d, 0x0a, 0x0

	# .stack or other custom sections are not supported
	.section .bss
	.align	2
mystack:
	.ds.l	1024
mysp:
	.end 	main

