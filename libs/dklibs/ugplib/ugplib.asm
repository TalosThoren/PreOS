; UGPLIB - Copyright 1998 David Kuehling
; Adaptation for TI-89/92+ - Copyright 2004, 2005 Patrick Pelissier
;
; This file is part of the UGPLIB Library.
;
; The UGPLIB Library is free software; you can redistribute it and/or modify
; it under the terms of the GNU Lesser General Public License as published by
; the Free Software Foundation; either version 2.1 of the License, or (at your
; option) any later version.
;
; The UGPLIB Library is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
; License for more details.
;
; You should have received a copy of the GNU Lesser General Public License
; along with the MPFR Library; see the file COPYING.LIB.  If not, write to
; the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
; MA 02111-1307, USA.


;------------------------------------------------------------------------
	include "tios.h"
	include "pk92lib.h"
	include "graphlib.h"
;------------------------------------------------------------------------
 
;------------------------------------------------------------------------
	xdef	_library
	xdef	ugplib@0000
	xdef	ugplib@0001

	DEFINE	_version01
	xdef	_ti89
	xdef	_ti89ti
	xdef	_ti92plus
	xdef	_v200

;------------------------------------------------------------------------

;  The UGP-format:
;------------------
;     $0000.w:
;	bit 0: 1 = animation; 0 = picture
;	bit 1,2: number of planes = (word >> 1) & 3
;	bit 3: 1 = interleaved; 0 = non-interleaved
;	bit 4: compressed / uncompressed
;	bit 5: only for animations: 1 = pictures stored as xor-difference
;	       to the last picture,0 = pictures stored normal
;	bit 6: 1= slide show instead of animation
;       bit 7: unused
;	bit 8-15: reserved for version info...  currently: UGP_VERSION
;     $0002.b:
;	picture width
;     $0003.b:
;	picture height
;     $0004.w
;       if animation: number of pictures
;	else: begin of picture data (if compressed: packer92 - archive,
;	containingt hese data)
;     $0006:
;	begin of animation data (if compressed: packer92 - archive,
;	containingt hese data)

;----- UGP version number,as it is stored within the UGP pics ----
UGP_VERSION EQU 1

;----- UGP access - macros ----
ANIMAT	    EQU 0
PLANES      EQU 1
INTERL	    EQU 3
COMPR	    EQU 4
XORDIF      EQU 5
SLIDESHOW   EQU 6


;----------------------------------
;DispNonInterl
;----------------------------------
;Par:
;  a4.w = offset of Pixel in VideoRAM
;  d4.b = Number of Pixel 0..7
;  a1-a3.l = pointer to planes
;  a0.l = pointer to raw picdata
;  d3.b = UGP sign
;  d5.b = 1: rplc 0: xor
;  d6.w = Width,d7.w = Height
;Temp:
;  a5 = Byte of Pic
;  a6 = *putPlane

DispNonInterl:
	movem.l	d5-d7/a0/a5/a6,-(a7)

	lsr.w	#3,d6
	subq.w	#1,d6
	subq.w	#1,d7

	cmp.b	#29,d6
	bne.s	\NotFullWidth
		lea	putPlaneXorf(PC),a6
		tst.b	d5
		beq.s	\putXor
			lea	putPlaneRplcf(PC),a6
			bra.s	\putXor
\NotFullWidth:
	lea	putPlaneXor(PC),a6
	tst.b	d5
	beq.s	\putXor
		lea	putPlaneRplc(PC),a6

\putXor:
	lea	0(a1,a4.w),a5		;most significant plane
	jsr	(a6)

	btst	#PLANES+1,d3   	;next plane (lsp if 2 planes)
	beq.s	\EndDisp
		lea	0(a2,a4.w),a5
		jsr	(a6)
	
		btst	#PLANES,d3	;least significant plane (if 3 planes)
		beq.s	\EndDisp
			lea	0(a3,a4.w),a5
			jsr	(a6)
\EndDisp:
	movem.l	(a7)+,d5-d7/a0/a5/a6
	rts

;---------------------------- putPlanef --------------------------
; Changed: a0,a5 (to next plane)

putPlaneRplcf:
	move.w	d7,-(a7)
\YLoop:
		moveq	#6,d5		;put 7 longwords
\_XLoop:
			move.l	(a0)+,(a5)+
			dbra	d5,\_XLoop
		move.w	(a0)+,(a5)+    ;  + put 1 word = 30 Byte = 1 row
		dbra	d7,\YLoop

	move.w	(a7)+,d7
	rts

putPlaneXorf:
	movem.w	d7/d6,-(a7)
\YLoop:
		moveq	#6,d5		;xor 7 longwords
\_XLoop:
			move.l	(a0)+,d6
			eor.l	d6,(a5)+
			dbra	d5,\_XLoop
		move.l	(a0)+,d6	;  + xor 1 word = 30 Byte = 1 row
		eor.l	d6,(a5)+
		dbra	d7,\YLoop

	movem.w	(a7)+,d7/d6
	rts

;---------------------------- putPlane --------------------------
; Changed: d5,a0,a5 (a0 points to next plane)

putPlaneRplc:
	move.w	d7,-(a7)
\YLoop:
		movem.l	d6/a5,-(a7)
\_XLoop:
			move.w	#$FF00,d5
			ror.w	d4,d5
			and.b	d5,(a5)
			lsr.w	#8,d5
			and.b	d5,1(a5)
			move.b	(a0)+,d5
			ror.w   d4,d5
			or.b	d5,(a5)+
			lsr.w	#8,d5
			or.b	d5,(a5)
			dbra	d6,\_XLoop
\_XLpEnd:
		movem.l	(a7)+,d6/a5	;Pointer to next line
		moveq	#30,d5
		adda.l	d5,a5
		dbra	d7,\YLoop
\YLpEnd:
	move.w	(a7)+,d7
	rts

putPlaneXor:
	move.w	d7,-(a7)
\YLoop:
		movem.l	d6/a5,-(a7)
\_XLoop:
			move.b	(a0)+,d5
			ror.w   d4,d5
			eor.b	d5,(a5)+
			lsr.w	#8,d5
			eor.b	d5,(a5)
			dbra	d6,\_XLoop
\_XLpEnd:
		movem.l	(a7)+,d6/a5	;Pointer to next line
		moveq	#30,d5
		adda.l	d5,a5
		dbra	d7,\YLoop
\YLpEnd:
	move.w	(a7)+,d7
	rts

;----------------------------------
;DispInterl
;----------------------------------
;Par:
;  a4.w = offset of Pixel in VideoRAM
;  d4.b = Number of Pixel 0..7
;  a1-a3.l = pointer to planes
;  a0.l = pointer to raw picdata
;  d3.b = UGP sign
;  d5.b = 1: rplc 0: xor
;  d6.w = Width,d7.w = Height
;Temp:
;  d0.b = WriteMask
;  d1.b = ReadBit
;  d2.b = ReadByte
;  d3 = Planebyte0
;  d5 = Planebyte1
;  d7 = Planebyte2

DispInterl:
	movem.l	d0-d3/d5-d7/a0-a3,-(a7)
	subq.w	#1,d6			;set Counters
	subq.w	#1,d7
	moveq.b	#7,d1			;set ReadBit
	moveq	#-128,d0		;set WriteMask
	lea	0(a1,a4),a1		;set addresses for Plane0 & 1
	lea	0(a2,a4),a2

	tst.b	d5
	bne.s	\AndPlane
		btst.b	#PLANES,d3
		bne.s	\Xor3Planes
			bsr	xorI2Plane
			bra.s	\End
\Xor3Planes:	bsr	xorI3Plane
		bra.s	\End
\AndPlane:
	btst.b	#PLANES,d3
	bne	\And3Planes
		bsr	putI2Plane
		bra.s	\End
\And3Planes:
	bsr	putI3Plane
\End:
	movem.l	(a7)+,d0-d3/d5-d7/a0-a3
	rts

putI2Plane:
	clr.b	d3			;clear Plane0 & 1
	clr.b	d5
\YLoop:
		movem.l	d6/a1-a2,-(a7)
\_XLoop:
			addq.b	#1,d1			;Readbit += 1
			bclr	#3,d1
			beq.s	\__DontRead
				move.b	(a0)+,d2
\__DontRead:		btst	d1,d2
			beq.s	\__NoPlane0
				or.b	d0,d3
\__NoPlane0:		addq.b	#1,d1			;Readbit += 1
		
			btst	d1,d2
			beq.s	\__NoPlane1
					or.b	d0,d5
\__NoPlane1:		
			ror.b	#1,d0
			bcc.s	\__DontWrite
				move.w	#$FF00,d0		;Clear pixels
				ror.w	d4,d0
				and.b	d0,(a1)
				and.b	d0,(a2)
				lsr.w	#8,d0
				and.b	d0,1(a1)
				and.b	d0,1(a2)
				ror.w   d4,d3			;Set pixels
				ror.w	d4,d5
				or.b	d3,(a1)+
				or.b	d5,(a2)+
				lsr.w	#8,d3
				lsr.w	#8,d5
				or.b	d3,(a1)
				or.b	d5,(a2)
				clr.b	d3
				clr.b	d5
				moveq	#-128,d0
\__DontWrite:		dbra	d6,\_XLoop

\_XLpEnd:	movem.l	(a7)+,d6/a1-a2		;Pointer to next line
		moveq	#30,d5
		adda.l	d5,a1
		adda.l	d5,a2
		clr.b	d5
		dbra	d7,\YLoop
\YLpEnd:
	rts

putI3Plane:
	clr.b	d3			;clear Plane0 & 1
	clr.b	d5
	adda.l	a4,a3		;set address for Plane2
\YLoop:
		movem.l	d6/d7/a1-a3,-(a7)
		clr.b	d7			;clear Plane2byte
\_XLoop:
			addq.b	#1,d1			;Readbit += 1
			bclr	#3,d1
			beq.s	\__DontRead
				move.b	(a0)+,d2
\__DontRead:		btst	d1,d2
			beq.s	\__NoPlane0
				or.b	d0,d3
\__NoPlane0:		addq.b	#1,d1			;Readbit += 1
			bclr	#3,d1
			beq.s	\__DontRead1
				move.b	(a0)+,d2
\__DontRead1:		btst	d1,d2
			beq.s	\__NoPlane1
				or.b	d0,d5
\__NoPlane1:		addq.b	#1,d1			;Readbit += 1
			bclr	#3,d1
			beq.s	\__DontRead2
				move.b	(a0)+,d2
\__DontRead2:		btst	d1,d2
			beq.s	\__NoPlane2
				or.b	d0,d7
\__NoPlane2:

			ror.b	#1,d0
			bcc.s	\__DontWrite
				move.w	#$FF00,d0		;Clear pixels
				ror.w	d4,d0
				and.b	d0,(a1)
				and.b	d0,(a2)
				and.b	d0,(a3)
				lsr.w	#8,d0
				and.b	d0,1(a1)
				and.b	d0,1(a2)
				and.b	d0,1(a3)
				ror.w   d4,d3			;Set pixels
				ror.w	d4,d5
				ror.w	d4,d7
				or.b	d3,(a1)+
				or.b	d5,(a2)+
				or.b	d7,(a3)+
				lsr.w	#8,d3
				lsr.w	#8,d5
				lsr.w	#8,d7
				or.b	d3,(a1)
				or.b	d5,(a2)
				or.b	d7,(a3)
				clr.b	d3
				clr.b	d5
				clr.b	d7
				moveq	#-128,d0
\__DontWrite:		dbra	d6,\_XLoop

\_XLpEnd:	movem.l	(a7)+,d6/d7/a1-a3	;Pointer to next line
		moveq	#30,d5
		adda.l	d5,a1
		adda.l	d5,a2
		adda.l	d5,a3
		clr.b	d5
		dbra	d7,\YLoop
\YLpEnd
	rts

xorI2Plane:
	clr.b	d3			;clear Plane0 & 1
	clr.b	d5
\YLoop:
	movem.l	d6/a1-a2,-(a7)
\_XLoop:
	addq.b	#1,d1			;Readbit += 1
	bclr	#3,d1
	beq.s	\__DontRead
	move.b	(a0)+,d2
\__DontRead:
	btst	d1,d2
	beq.s	\__NoPlane0
	or.b	d0,d3
\__NoPlane0:
	addq.b	#1,d1			;Readbit += 1

	btst	d1,d2
	beq.s	\__NoPlane1
	or.b	d0,d5
\__NoPlane1:

	ror.b	#1,d0
	bcc.s	\__DontWrite
	ror.w   d4,d3			;Set pixels
	ror.w	d4,d5
	eor.b	d3,(a1)+
	eor.b	d5,(a2)+
	lsr.w	#8,d3
	lsr.w	#8,d5
	eor.b	d3,(a1)
	eor.b	d5,(a2)
	clr.b	d3
	clr.b	d5
	moveq	#-128,d0
\__DontWrite:
	dbra	d6,\_XLoop

\_XLpEnd:
	movem.l	(a7)+,d6/a1-a2		;Pointer to next line
	moveq	#30,d5
	adda.l	d5,a1
	adda.l	d5,a2
	clr.b	d5
	dbra	d7,\YLoop
\YLpEnd:
	rts

xorI3Plane:
	clr.b	d3			;clear Plane0 & 1
	clr.b	d5
	adda.l	a4,a3			;set address for Plane2
\YLoop:
	movem.l	d6/d7/a1-a3,-(a7)
	clr.b	d7			;clear Plane2byte
\_XLoop:
	addq.b	#1,d1			;Readbit += 1
	bclr	#3,d1
	beq.s	\__DontRead
	move.b	(a0)+,d2
\__DontRead:
	btst	d1,d2
	beq.s	\__NoPlane0
	or.b	d0,d3
\__NoPlane0:
	addq.b	#1,d1			;Readbit += 1
	bclr	#3,d1
	beq.s	\__DontRead1
	move.b	(a0)+,d2
\__DontRead1:
	btst	d1,d2
	beq.s	\__NoPlane1
	or.b	d0,d5
\__NoPlane1:
	addq.b	#1,d1			;Readbit += 1
	bclr	#3,d1
	beq.s	\__DontRead2
	move.b	(a0)+,d2
\__DontRead2:
	btst	d1,d2
	beq.s	\__NoPlane2
	or.b	d0,d7
\__NoPlane2:

	ror.b	#1,d0
	bcc.s	\__DontWrite
	ror.w   d4,d3			;Set pixels
	ror.w	d4,d5
	ror.w	d4,d7
	eor.b	d3,(a1)+
	eor.b	d5,(a2)+
	eor.b	d7,(a3)+
	lsr.w	#8,d3
	lsr.w	#8,d5
	lsr.w	#8,d7
	eor.b	d3,(a1)
	eor.b	d5,(a2)
	eor.b	d7,(a3)
	clr.b	d3
	clr.b	d5
	clr.b	d7
	moveq	#-128,d0
\__DontWrite:
	dbra	d6,\_XLoop

\_XLpEnd:
	movem.l	(a7)+,d6/d7/a1-a3	;Pointer to next line
	moveq	#30,d5
	adda.l	d5,a1
	adda.l	d5,a2
	adda.l	d5,a3
	clr.b	d5
	dbra	d7,\YLoop
\YLpEnd:
	rts

;-------------------------------
;  Delay
;-------------------------------
; Parameters:
;   d5.w:  wait for time*(1/350) seconds
;
; If Slide Show (bit #SLIDESHOW set in d3): wait for keypress instead
;
; Regs: all registers are kept as they are
;-------------------------------

Delay:
	movem.l	d0-d7/a0-a6,-(a7)
        btst	#SLIDESHOW,d3
        beq.s	\WaitDelay
	        jsr	tios::ngetchx
	        bra.s	\Exit
\WaitDelay:
	move.w	#$500,d0
	trap	#1
	bclr.b	#2,$600001
	move.l	($64).w,OldAutoInt1
	move.l	#\NewAutoInt1,($64).w
	trap	#1

\WaitLoop	tst.w	d5
		bne.s	\WaitLoop

	move.w	#$500,d0
	trap	#1
	move.l	OldAutoInt1(PC),($64).w
	bset.b	#2,$600001
	trap	#1
\Exit:
	movem.l	(a7)+,d0-d7/a0-a6
	rts

\NewAutoInt1:
	tst.w	d5
	beq.s	\d5Zero
		subq.w	#1,d5
\d5Zero	move.l	OldAutoInt1(PC),-(a7)
	rts

;************************************************************************
;*  Display								*
;*----------------------------------------------------------------------*
;*  Displays a ugp picture / animation (animation: for one cycle)       *
;*  Parameter:                                                          *
;*    d0.w = x-position                                                 *
;*    d1.w = y-position                                                 *
;*    d2.w = Delay per Picture (for animations only) in 1/350 seconds	*
;*    a0.l = pointer to ugp-image (mustn't be odd address)              *
;*    a1.l = pointer to most-significant plane                          *
;*    a2.l = pointer to plane with the next significance (2 greyplanes) *
;*    a3.l = pointer to least-significant plane (3 greyplanes)          *
;*  Output:                                                             *
;*    d3.b = 0: Ok,FF: Error                                           *
;*  Registers:                                                          *
;*    nothing is destroyed                                              *
;************************************************************************
;Temp:
;  d6.w = Width,d7.w = Height
;  a4.w = picture offset in videoram
;  d4.b = picture bit begin 0..7
;  d3.b = UGP sign
;  a0.w = pointer to raw picdata
;  a6.w = stored pointer -^ (if ani)
;  d1.w = num of pics (if ani)
;  d2.w = Picture count

ugplib@0000:
	movem.l d0-d7/a0-a6,-(a7)

	cmp.b   #UGP_VERSION,(a0)+   	;check version-byte
	bgt	\DispErr
	move.b	(a0)+,d3	;d3 = UGP-sign
	clr.w	d6              ;d6 x d7 = Width x Height
	clr.w	d7
	move.b	(a0)+,d6
	move.b	(a0)+,d7       ;a0 = *PicData

	move.w	d1,d5		;d5 = *PicBegin
	mulu	#30,d5
	move.w	d0,d4
	lsr.w	#3,d4
	add.w	d4,d5
	move.w	d5,a4
	moveq	#7,d4
	and.b	d0,d4		;d4 = Pixel

	btst	#ANIMAT,d3
	beq.s	\NoAni
		move.w	(a0)+,d1	;Pics = Pics-2 (for dbra-loop)
		movea.l	a0,a6		;a6 = a0
		subq.w	#2,d1
		move.w	d2,DelayTime
		clr.w	d0

\NoAni:	;---------------- put Picture ---------------
	btst	#COMPR,d3
	beq	\PicNotCompr
		movem.l	a1/d1,-(a7)
		jsr	pk92lib::Extract
		tst.b	d0
		bne	\DispErr
			movea.l	a1,a0
			movem.l	(a7)+,a1/d1
\PicNotCompr:
	st	d5		;put Picture rplc

	btst	#INTERL,d3
	bne.s	\PicInterl
		bsr	DispNonInterl
		bra	\PicEnd
\PicInterl:
	bsr     DispInterl
\PicEnd:
	btst	#COMPR,d3
	beq.s	\AniTest
		jsr	pk92lib::FreeMem

\AniTest:
	;--------------- Animation --------------
	btst	#ANIMAT,d3
	beq	\DispOk
		clr.w 	d2		 ;picCount = 0
		move.w	DelayTime(PC),d5
		bsr	Delay
\AniLp:
	addq.w	#1,d2
		;-------- get Add of Pic ------
	btst	#COMPR,d3
	beq	\AniUnC
	movem.l	a1/d1/d2,-(a7)
	move.w	d2,d0
	movea.l	a6,a0
	jsr	pk92lib::Extract
	tst.b	d0
	bne	\DispErr
	movea.l	a1,a0
	movem.l	(a7)+,a1/d1/d2
	bra	\ShowAniPic
\AniUnC:
	move.w	d6,d5		;Pic-Size to d5
	mulu.w	d7,d5
	move.w	d3,d4
	lsr.w	#1,d4
	andi.w	#3,d4
	mulu.w	d4,d5
	lsr.w	#3,d5		;add to a0
	mulu.w	d2,d5
	lea	0(a6,d5.w),a0
\ShowAniPic:
	btst	#XORDIF,d3
	seq	d5
	btst	#INTERL,d3
	beq.s	\AniNonI
	bsr     DispInterl
	bra.s	\Show_Done
\AniNonI:
	bsr	DispNonInterl
\Show_Done:
	btst	#COMPR,d3
	beq.s	\AniLpCond
	jsr	pk92lib::FreeMem
\AniLpCond:
	move.w	DelayTime(PC),d5
	bsr	Delay
	dbra	d1,\AniLp

\DispOk:
	movem.l (a7)+,d0-d7/a0-a6
	clr.b	d3
	rts
\DispErr:
	movem.l (a7)+,d0-d7/a0-a6
	st	d3
	rts

;************************************************************************
;*  AutoDisp								*
;*----------------------------------------------------------------------*
;* Displays a UGP - Picture automatically,switches to the right gray-  *
;* mode,clears the screen,shows the picture/animation/slide show until*
;* key is pressed,in the middle of the screen.                         *
;*  Parameter:                                                          *
;*    a0 = Ptr. to UGP-pic(/ani)                                        *
;*    d2.w = Delaytime for animations in 1/350 seconds			*
;*  Return:                                                             *
;*    d0 = 0: OK = 1: Error                                             *
;************************************************************************
ugplib@0001:
	movem.l	a0-a6/d1-d7,-(a7)
	move.b	1(a0),d0		;d0 = UGP-sign

	lea	LCD_MEM,a1		; Plane1 = LCD_MEM
	move.l	a1,a5
	bsr.s	\delPlane
	
	btst	#PLANES,d0
	bne.s	\PlaneNum1or3
		jsr	graphlib::gray4		;2 Planes
		tst.l	d0
		beq	\AbortDisp
		
\clear2Planes
		move.l	graphlib::plane1,a2
		move.l	a2,a5
		bsr.s	\delPlane
		move.l	graphlib::plane0,a1
		move.l	a1,a5
		bsr.s	\delPlane
	
		bra.s	\ShowUGP
\delPlane:				;Add of Plane in a5
	move.w	#959,d7                ;d7/a5 is destroyed
\delLoop	clr.l	(a5)+
		dbra	d7,\delLoop
	rts
\PlaneNum1or3:
	btst	#PLANES+1,d0
	beq.s	\ShowUGP
		jsr	graphlib::gray7		;3 Planes
		tst.l	d0
		beq.s	\AbortDisp

		move.l	graphlib::plane2,a3
		move.l	a3,a5
		bsr.s	\delPlane
		bra.s	\clear2Planes
\ShowUGP:
	move.w	#LCD_WIDTH,d0
	move.w	#LCD_HEIGHT,d1
	clr.w	d3
	move.b	2(a0),d3
	sub.w	d3,d0
	bge.s	\xok
		clr.w	d0
\xok	asr.w	#1,d0
	move.b	3(a0),d3
	sub.w	d3,d1
	bge.s	\yok
		clr.w	d1
\yok	asr.w	#1,d1
	lea	KEY_PRESSED_FLAG,a5	;KeysInBuffer-Address in a5
	clr.w	(a5)
\Display:
		bsr	ugplib@0000
		tst.b	d3
		bne.s	\AbortDisp
		btst.b	#ANIMAT,1(a0)
	        beq.s	\AbortDispWait
	        btst.b  #SLIDESHOW,1(a0)
	        bne.s	\AbortDisp
		tst.w	(a5)
		beq.s	\Display

\AbortDisp:
	clr.w	(a5)                    ;clear keaboard buffer
	move.b	d3,-(a7)
	jsr	graphlib::gray2		;switch off grayscale
	move.b	(a7)+,d0
	movem.l	(a7)+,a0-a6/d1-d7
\JustRts:
	rts

\AbortDispWait:
        jsr     tios::ngetchx
        bra.s	\AbortDisp


;----------------------------------------
DelayTime:	dc.w	0
OldAutoInt1:	dc.l	0
;----------------------------------------

	END
