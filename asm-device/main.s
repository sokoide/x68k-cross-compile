#
# 単行本
# X68000マシン語プログラミング 入門編
# ChapterB
#

.include "doscall.mac"
.include "const.h"
.include "driver.h"
.xref	itoh

#  macros
.macro PUTC chr
	move.w \chr, -(sp)
	DOS	_PUTCHAR
	addq.l #2, sp
.endm

.macro PUTSP
	PUTC   #SPACE
.endm

.macro PUTS strptr
	pea.l  \strptr
	DOS	_PRINT
	addq.l #4, sp
.endm

.macro NEWLIN
	PUTS   crlfms
.endm

.macro SELMES bit, str1, str2
	btst.l #\bit, d7
	beq	0f
	PUTS   \str1
	bra	1f
0:
	PUTS \str2
1:
.endm

#
# entry
#
	.section .text
	.even
	.globl   main
	.type	main, @function

main:
	lea.l	mysp, sp
	clr.l	-(sp)
	DOS		_SUPER
	move.l	d0, -(sp)

	bsr		chkarg
	bsr		do

	DOS		_SUPER
	addq.l	#4, sp
	DOS		_EXIT

do:
	bsr		seanul
	tst.l	d1
	bmi		error
	PUTS	title
	PUTS	title2

loop:
	move.l d1, a0
	move.w  a0@(DEVATR), d7
	bsr	 prtadr
	bsr	 prtnam
	bsr	 prtatr
	SELMES  IOCTRL_BIT, okmes, notmes
	NEWLIN
	move.l  a0@(DEVLNK), d1
	cmpi.l  #-1, d1
	bne	 loop
	rts

	.equ HUMANST, 0x6800
	.equ NULATR, 0x8024

seanul:
	lea.l  .nulnam, a0
	move.w a0@+, d0
	move.l a0@+, d1
	move.w a0@+, d2
	lea.l  HUMANST, a0

seanl0:
	cmp.w a0@+, d0
	bne   seanl0

	cmp.l a0@, d1
	bne   seanl0

	cmp.w a0@(4), d2
	bne   seanl0

	cmpa.l .nulnam+2, a0
	beq	notfound

	cmp.w #NULATR, a0@(DEVATR-DEVNAM-2)
	bne   seanl0

	lea.l a0@(DEVLNK-DEVNAM-2), a0

	move.l a0, d1
	rts

notfound:
	moveq.l #-1, d1
	rts

prtadr:
	pea.l	temp
	move.l	a0, -(sp)
	bsr		itoh
	addq.l	#8, sp
	PUTS 	temp+2
	PUTSP
	rts

prtnam:
	lea.l	a0@(DEVNAM), a1
	moveq.l	#0, d1
	moveq.l	#8-1, d2
prtnm0:
	move.b	a1@+, d1
	cmpi.b	#SPACE, d1
	bcc		prtnm1
	moveq.l	#'.', d1
prtnm1:
	PUTC	d1
	dbra	d2, prtnm0
	rts

prtatr:
	btst.l	#ISCHRDEV_BIT, d7
	beq		prtat2
	PUTS	chrmes
	SELMES	ISRAW_BIT, rawmes, cokmes
	move.w	d7, d1
	lea.l	atrdat, a1
	moveq.l	#0, d2
	moveq.l	#4-1, d3
prtat0:
	move.b	a1@+, d2
	lsr.w	#1, d1
	bcs	prtat1
	moveq.l	#'-', d2
prtat1:
	PUTC	d2
	dbra	d3, prtat0
	rts

prtat2:
	PUTS	blkmes
	rts

chkarg:
	addq.l	#1, a2
	bsr		skpsp
	tst.b	a2@
	bne		usage
	rts

skpsp0:
	addq.l	#1, a2
skpsp:
	cmpi.b	#SPACE, a2@
	beq		skpsp0
	cmpi.b	#TAB, a2@
	beq		skpsp0
	rts

usage:
	lea.l	usgmes, a0
	bra		errout

error:
	lea.l	errmes, a0
errout:
	move.w	#STDERR, -(sp)
	move.l	a0, -(sp)
	DOS		_FPUTS
	addq.l	#6, sp
	move.w	#1, -(sp)
	DOS		_EXIT2
#
# data
#
	.section .data
	.even
/*               12345678 */
.nulnam:	.string	"NUL     "
/*               12345678901234567890 */
title:		.string	"Start  Device     Attribute           IOCTRL\r\n"
title2:		.string	"------ ---------- ------------------- ------\r\n"

chrmes:	.string	"   CHR "
blkmes:	.string	"   BLOCK            "
rawmes:	.string	"(RAW)    "
cokmes:	.string	"(COOKED) "
okmes:	.string "   OK"
notmes:	.string "   NG"

atrdat:	.string	"IONC"
usgmes: .string	"Print installed device drivers.\r\nusage) asmdev\r\n"
errmes: .string	"can't find NUL device\r\n"
crlfms: .dc.b 	CR, LF, 0x0

	.section .data
	.even

#
# bss
# .align is ignored in elf2x68k.py. must align it manually
#
	.section .bss
	.even

temp:
	# must be 2 aligned
 	.ds.b 10

#
# stack
# must be in .bss (not .stack)
#
mystack:
	.ds.l 1024
mysp:
	.end main
