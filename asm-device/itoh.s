	.xdef itoh

	.text
	.even

#
# itoh (buff, value)
#
# convert 32bit integer into 8digit hex string
# destroyed: ccr
#
# value(in): 32bit integer
# buff(out): 8byte hex string

value = 8
buff = 12

itoh:
	# fp (a6) allocates 0 byte for local variables
	# since it's 0, it only pushes current fp (a6) into stack and keeps the frame pointer in a6
	# if it was link a6, #4, it'd do the followings
	#  movea.l a6, -(sp)
	#  lea sp@, a6
	#  lea sp@(-4), sp
	link	a6, #0
	# save d0, d1, d2, a0 registers in stack
	movem.l	d0-d2/a0, -(sp)
	# get value in d0
	move.l	a6@(value), d0
	# get buff in a0
	movea.l	a6@(buff), a0

	# repeat below 8 times
	moveq.	#8-1, d2
itoh0:
	# get the first 4 bit of the long word (4bytes)
	# e.g. if d0=0x12345678, rol.l #4 makes it 0x23456781
	rol.l	#4, d0
	move.b	d0, d1
	# get the last 4 bits
	# e.g. 0x81 and 0x0f -> 0x01
	andi.b	#0x0f, d1

	# is it > 9?
	cmpi.b	#10, d1
	bcc 	itohalpha
	# d1 is [0-9]
	# change it to ascii '0' to '9'
	addi.b	#'0', d1
	bra		itoh1

itohalpha:
	# change 10 to 'A', 11 to 'B', .., 15 to 'F'
	addi.b	#'A'-10, d1

itoh1:
	# store the converted char in a0@
	move.b	d1, a0@+
	# repeat until d2 becomes 0
	dbra	d2, itoh0
	# add '\0' at the end
	clr.b	a0@

	# restore d0, d1, d2, a0 registers
	movem.l	(sp)+, d0-d2/a0
	# reset the stack frame
	#  lea sp@(4), sp
	#  movea.l (sp)+, a6
	unlk	a6
	rts
