	.xdef itoh

	.text
	.align 2

value = 8
buff = 12

itoh:
	link	%a6, #0
	movem.l	%d0-%d2/%a0, %sp@-
	move.l	%a6@(value), %d0
	movea.l	%a6@(buff), %a0
	moveq.	#8-1, %d2

itoh0:
	rol.l	#4, %d0
	move.b	%d0, %d1
	andi.b	#0x0f, %d1
	addi.b	#'0', %d1
	cmpi.b	#'9'+1, %d1
	bcs	itoh1
	addq.b	#'A'-'0'-10, %d1

itoh1:
	move.b	%d1, %a0@+
	dbra	%d2, itoh0
	clr.b	%a0@

	movem.l	%sp@+, %d0-%d2/%a0
	unlk	%a6
	rts
