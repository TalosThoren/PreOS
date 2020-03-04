	include	tios.h
	
	xdef	_library
	xdef	_ti92plus
	xdef	_ti89
	xdef	_ti89ti
	xdef	_v200		; Create V200 program
	DEFINE	_version01
	
	xdef	triglib@0000
	xdef	triglib@0001
	xdef	triglib@0002
	xdef	triglib@0003

;*****************************************************

;********** Get sqrrt(d0^2+d1^2) and place it in d2 ***********

triglib@0000:
;distance:
	movem.l		d0-d1,-(sp)

	tst.w		d1
	bge.s		\ygtz
	neg.w		d1		;Get abs(delta-y)
\ygtz	tst.w		d0
	bge.s		\xgtz
	neg.w		d0		;Get abs(delta-x)
\xgtz	mulu.w		d0,d0
	mulu.w		d1,d1
	add.l		d0,d1		;d0=x^2+y^2

	moveq		#1,d0		;Odd number counter
	moveq		#-1,d2		;Returned value

\loop	sub.l		d0,d1
	addq.l		#2,d0
	addq.l		#1,d2
	tst.l		d1
	bge.s		\loop

	movem.l		(sp)+,d0-d1
	rts

;************ Get arctan(d1/d0) and place it in d2 ************

triglib@0001:
arctan:
	movem.l		d0-d2,-(sp)

	tst.w		d0
	bne.s		\notzx
	moveq		#90,d2		;x is zero so angle is +/- 90 degrees
	bra.s		\xgey2

\notzx	tst.w		d1
	bne.s		\notzy
	moveq		#0,d2		;y is zero so angle is 0 or 180 degrees
	bra.s		\xgey2

\notzy	tst.w		d1
	bge.s		\ygtz
	neg.w		d1		;Get abs(delta-y)
\ygtz	tst.w		d0
	bge.s		\xgtz
	neg.w		d0		;Get abs(delta-x)

\xgtz	movem.l		d0-d1,-(sp)	;Store abs values
	cmp.w		d0,d1
	blt.s		\xgey
	move.w		d0,d2
	move.w		d1,d0
	move.w		d2,d1		;Swap delta-x and delta-y if x<=y
\xgey	move.w		d1,d2
	mulu.w		#61,d2

	divu.w		d0,d2		;d2=61*(delta-y/delta-x)
	ext.l		d2

	mulu.w		d0,d0
	cmp.l		#$0000FFFF,d0
	ble.s		\xnz3
	move.w		#$FFFF,d0	;If the upper word of d0 is >FFFF, we have a *big* number
\xnz3	mulu.w		d1,d1
	lsl.l		#4,d1
	divu.w		d0,d1
	ext.l		d1		;d1=16*(delta-y/delta-x)^2
	sub.l		d1,d2		;d2=Angle for interval 0 to 45 degrees

	movem.l		(sp)+,d0-d1	;Restore the abs(x) and abs(y) values
	cmp.w		d0,d1
	blt.s		\xgey2
	neg.l		d2
	add.l		#90,d2		;If x<=y, calculate 90-angle
\xgey2	movem.l		(sp)+,d0-d1
	tst.w		d0
	bge.s		\xgtz2
	neg.l		d2
	add.l		#180,d2		;x<=0, calculate 180-angle
\xgtz2	tst.w		d1
	bge.s		\ygtz2
	neg.l		d2		;y<=0, calculate -angle
	tst.l		(sp)
	beq.s		\ygtz2
	add.l		#360,d2
\ygtz2	addq.l		#4,sp
	rts

;*************** Get sin(d1) and place it in d2 ***************
triglib@0002:
sin:
	move.w		d1,-(a7)		;Store our angle

	move.w		#360,d2
\tst1	tst.w		d1		;Negative angle?
	bge.s		\tst2
	add.w		d2,d1
	bra.s		\tst1
\tst2	cmp.w		d2,d1		;Angle > 360?
	blt.s		\ok
	sub.w		d2,d1
	bra.s		\tst2

\ok	move.w		d1,temp2
	cmp.w		#90,d1		;1st quadrant?
	blt.s		\cont		;Yep, skip

	neg.w		d1
	add.w		#180,d1		;Calculate 180-angle
	tst.w		d1		;2nd quadrant?
	bge.s		\cont		;Yep, skip

	neg.w		d1		;-(180-angle)=angle-180
	cmp.w		#90,d1		;3rd quadrant?
	blt.s		\cont		;Yep, skip

	neg.w		d1		;4th quadrant
	add.w		#180,d1

\cont	moveq		#0,d2
	move.b		sinus(PC,d1),d2
	cmp.w		#180,temp2	;If we are in the 3rd or 4th
	blt.s		\done		;quadrant, we need to make
	neg.w		d2		;the angle negative.

\done	move.w		(a7)+,d1	;Restore the angle

	rts

;*************** Get cos(d1) and place it in d2 ***************

triglib@0003:
cos:
	add.w		#90,d1			;cos(x)=sin(x+90)
	bsr		sin			;d2=cos(d1)
	sub.w		#90,d1			;Restore 90 addition
	rts

;********************* Variables *******************

temp2		dc.l	0

;********************* Sine table ******************

sinus:		dc.b	0,2,4,7,9,11,13,16,18,20,22,24,27,29
		dc.b	31,33,35,37,40,42,44,46,48,50,52,54,56,58
		dc.b	60,62,64,66,68,70,72,73,75,77,79,81,82,84
		dc.b	86,87,89,91,92,94,95,97,98,99,101,102,104,105
		dc.b	106,107,109,110,111,112,113,114,115,116,117,118,119,119
		dc.b	120,121,122,122,123,124,124,125,125,126,126,126,127,127
		dc.b	127,128,128,128,128,128,128

;*****************************************************

	end
