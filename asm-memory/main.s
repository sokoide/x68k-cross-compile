*
* Oh! X 1990.1
* X68000マシン語プログラミング
* Chapter_0A
*

.include "doscall.mac"
	.xref	itoh

.equ	PREVMEM,	0
.equ	OWNERPROC,	4
.equ	MBEND,		8
.equ	NEXTMEM,	12

	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	lea.l	mysp, %sp
	clr.l	%sp@-
	DOS		_SUPER
	move.l	%d0, %sp@

loop1:
	move.l	%a0@(PREVMEM), %d0
	beq		loop2
	movea.l	%d0, %a0
	bra		loop1

loop2:
	pea.l	buff
	move.l	%a0, %sp@-
	bsr		itoh
	addq.l	#8, %sp
	move.b	#'-', buff+8

	pea.l	buff+9
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

	move.l	%a0@(NEXTMEM), %d0
	movea.l	%d0, %a0
	bne		loop2

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

	.section .stack
	.align	2
mystack:
	.ds.l	1024
mysp:
	.end 	main


