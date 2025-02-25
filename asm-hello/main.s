.equ _exit, 0xff00
.equ _getc, 0xff08
.equ _putchar, 0xff02
.equ _print, 0xff09

	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	pea.l	.message1
	dc.w	_print
	addq.l 	#4,%sp
	pea.l	.message2
	dc.w	_print
	addq.l 	#4,%sp

	mov.b	#3, %d1
l1:
	#execute 0xff08 doscall
	dc.w	_getc
	and.b 	#0xdf, %d0
	mov.w 	%d0, %sp@-
	#execute 0xff02 doscall
	dc.w	_putchar
	addq.l	#2, %sp
	sub.b 	#1, %d1
	cmp.b	#0, %d1
	bne.b	l1
done:
	bsr	 	newline
	dc.w	_exit
newline:
	mov.w 	#0x0d, %sp@-
	dc.w	_putchar
	addq.l	#2, %sp
	mov.w 	#0x0a, %sp@-
	dc.w	_putchar
	addq.l	#2, %sp
	rts

	 .section .data
.message1:
	.string "Type 3 characters.\r\n"
.message2:
	.string "They'll be converted to upper-case\r\n"

	.end 	main

