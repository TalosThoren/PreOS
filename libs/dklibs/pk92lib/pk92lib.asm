; PACKER92 - Copyright 1997, 1998 David Kuehling
; Adaptation for TI-89/92+ - Copyright 2002, 2003, 2004, 2005 Patrick Pelissier
;
; This file is part of the PACKER92 Library.
;
; The PACKER92 Library is free software; you can redistribute it and/or modify
; it under the terms of the GNU Lesser General Public License as published by
; the Free Software Foundation; either version 2.1 of the License, or (at your
; option) any later version.
;
; The PACKER92 Library is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
; License for more details.
;
; You should have received a copy of the GNU Lesser General Public License
; along with the MPFR Library; see the file COPYING.LIB.  If not, write to
; the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
; MA 02111-1307, USA.

;------------------------------------------------------------------------
	xdef	_library
	xdef	pk92lib@0000
	xdef	pk92lib@0001
	xdef	pk92lib@0002
;------------------------------------------------------------------------
	include "tios.h"
;------------------------------------------------------------------------

	ifne	CALC_TI92PLUS
	xdef	_ti89
	xdef	_ti89ti
	xdef	_ti92plus
	xdef	_v200
	DEFINE	_version01
	endif

;------------------------------------------------------------------------
;  ReadValue
;------------------------------------------------------------------------
;  Parameters:
;    a0.l = *Src  (++)
;    d0.b = Bit   (+x)
;    d1.b = Byte  (= *Src++)
;    d2.b = BitsperGroup
;  Return:
;    d3.l = Value
;  Temporary:
;    d4.w = GroupShift
;    d5.w = Group
;    d6.b = GroupBit/ValueEnd
;    d7.w = Break
;------------------------------------------------------------------------

ReadValue:
	moveq	#0,d3   		;Value = GroupShift = 0
	clr.w	d4

\ReadValueLp:
	;-------------Read Group -----------------
	clr.w	d5              ;Group = 0
	st.b	d6              ;GroupBit = -1

\ReadGroupLp:
	addq.b	#1,d6
	btst	d0,d1		;Bit set in Byte?
	beq.s	\BitClr
	bset    d6,d5		;set GroupBit in Group
\BitClr:
	addq.b	#1,d0		;Bit++;
	bclr	#3,d0		;Bit == 8 ?
	beq.s	\NoNewByte
	move.b	(a0)+,d1	;Byte = *Src++;
\NoNewByte:
	cmp.b	d2,d6		; GroupBit < BitsperGroup ?
	blt.s	\ReadGroupLp
	;-------------End Read Group ---------------

	; ------ Add Group ------
	bclr	d6,d5		;Break = ...
	seq	d7
	addq.w	#1,d5
	lsl.w	d4,d5		;Group <<= GroupShift
	add.w	d5,d3		;Value += Group
	add.w	d2,d4		;GroupShift += BitsperGroup

	tst.b	d7
	beq.s	\ReadValueLp	;while (!Break)

	subq.w	#1,d3		;Value -= 1;
	rts

;------------------------------------------------------------------------
;  ExtrPart
;------------------------------------------------------------------------
;  Parameters:
;    a0 = *Src (destroyed)
;    a1 = *Dest (destroyed)
;    a2 = *TransTbl (fst elm.: DiffChrs)
;    d0.l = _Length (destroyed)
;  Temp:
;    a3 = *Rep
;    d0.b = Bit
;    d1.b = Byte
;  Local:
;    -4(a7) = Length
;    all other Regs destroyed
;  Return:
;    d0.b = 0 OK / FF Error
;------------------------------------------------------------------------

ExtrPart:
	link	a6,#-4			;Initialize Local Var
	move.l	d0,-4(a6) 		;Length = _Length

	move.b	(a0)+,d1		;Byte = *Src++
	clr.b	d0                      ;Bit = 0

\ExtrLoop:
				;ReadValue3_1 ()
	moveq	#3,d2			;BitsPerGroup = 3
	bsr	ReadValue

	clr.w	d2			;DiffChrs.w = 0
	move.b	(a2),d2
	addq.w	#1,d2
	cmp.w	d2,d3			;Value < DiffChrs ?
;	beq.s	\RLE
;	bhi.s	\LZBC
;	bra.s	\BitCoded
	bhi.s	\LZBC
	bne.s	\BitCoded

	;------------------- RLE --------------------
\RLE:
				;ReadValue1_1 ()
	moveq	#1,d2			;BitsPerGroup = 1
	bsr	ReadValue

	move.b	-1(a1),d2	;d2 = Dest[I-1]
	addq.l	#1,d3		;Value += 1; (Value+2 Reps)
	sub.l	d3,-4(a6)
\RLELp:
	move.b	d2,(a1)+ 	;*Dest++ = d2
	dbra.s	d3,\RLELp

	bra.s	\ExtrLpCond

	;------------------ LZBC --------------------
\LZBC:
	sub.w	d2,d3			;Value -= DiffChrs
	neg.l	d3
	lea     -1(a1,d3.l),a3	;Rep = Dest + Value - 1
				;ReadValue1_1 ()
	moveq	#1,d2			;BitsPerGroup = 1
	bsr	ReadValue

	addq.l	#1,d3			;Value+=1 (Value+2 Reps)
	sub.l	d3,-4(a6)
\LZBCLp:
	move.b	(a3)+,(a1)+		;*Dest++ = *Rep++
	dbra.s	d3,\LZBCLp		;while (--Value != -1)

	bra.s	\ExtrLpCond

	;----------------- Bitwise ------------------
\BitCoded:
	move.b	1(a2,d3.w),(a1)+	;*Dest++ = TransTbl[Value]

\ExtrLpCond:
	subq.l	#1,-4(a6)		;Length--
	tst.l	-4(a6)
	bmi.s	\Error
	bne.s	\ExtrLoop		;while (Length != 0)

	unlk	a6			;Remove locals
	clr.b	d0			;d0 = 0h (OK)
	rts

\Error:
	unlk	a6                      ;Remove locals
	st	d0			;d0 = FFh (Error)
	rts

;************************************************************************
;*  ExtractA								*
;*----------------------------------------------------------------------*
;*  Extracts Packer92-packed archive, given its address			*
;*  Parameters:								*
;*	a0 = pointer to archives' begin					*
;*	a1 = pointer to free buffer					*
;*    for normal and divided archives: d0.w = number of file		*
;*  Return:                                                             *
;*    d0.b = 0 OK / FF ERROR                                            *
;*    a1   = pointer to uncompressed file				*
;*    d1.w = handle of uncompressed file				*
;*    d2.l = Length of uncompressed file				*
;*  All Registers are stored, and restored				*
;************************************************************************
pk92lib@0002:
	st.b	Flag_A
	move.l	a1,PtrUncp
	bra.s	pk92in

;************************************************************************
;*  Extract								*
;*----------------------------------------------------------------------*
;*  Extracts Packer92-packed archive, given its address			*
;*  Parameters:								*
;*    a0 = pointer to archives' begin					*
;*    for normal and divided archives: d0.w = number of file		*
;*  Return:                                                             *
;*    d0.b = 0 OK / FF ERROR                                            *
;*    a1   = pointer to uncompressed file				*
;*    d1.w = handle of uncompressed file				*
;*    d2.l = Length of uncompressed file				*
;*  All Registers are stored, and restored				*
;************************************************************************
pk92lib@0000:
	clr.b	Flag_A
pk92in:
	movem.l	d3-d7/a0/a2-a6,-(a7)

	moveq	#0,d1		; New version 1.2
	add.w	d0,d0		; New version 1.2

	;-------------- Archive Type? --------------------
	move.b	(a0)+,d7
	cmpi.b	#'s',d7
	beq.s	\SolidArc
	cmpi.b	#'n',d7
	beq.s	\NormalArc
	cmpi.b	#'d',d7
	beq.s	\DividedArc
	bra.s	\Error
\SolidArc:
	addq.l	#1,a0			;Dummy
\SolArcInit:
	moveq	#0,d0
	move.w	(a0)+,d0		;Length
	bsr.s	\GetDestMem		;GetDestMem () | d0/a0/a1 ok
	movea.l	a0,a2			;a2 = *TransTbl
	clr.w	d1
	move.b	(a0),d1
	lea	2(a0,d1.w),a0		;a0 = *Src
	bsr	ExtrPart
	bra.s	\UncpEnd

\NormalArc:
;	clr.w	d1		;Old Version
	move.b  (a0)+,d1     	;get TransT
;	lsl.w	#1,d1
	add.w	d1,d1
	lea	0(a0,d1.w),a2   	;a2 = *Trans
;	lsl.w   #1,d0          ;get Src
;	adda.w	0(a0, d0.w), a0 ;this is the old version
;	subq.l	#2, a0
                                ;high word of d1 is still cleared!
        move.w  0(a0,d0.w),d1	;newer version, now archives > 32K work
        lea    -2(a0,d1.l),a0

	moveq	#0,d0		;get Len
	move.w	(a0)+,d0
	bsr.s	\GetDestMem     ;get Dest
	bsr	ExtrPart	;Extract
	bra.s	\UncpEnd

\DividedArc:
	subq.l	#1,a0		; Version 1.2
                                ;(lsl.w #1, d0 was allready done)
	;adda.w	2(a0, d0.w), a0 ;this is the older version
                                ;newer version, now archives > 32 work
	move.w  2(a0,d0.w),d1 ;(d1.l was 0)
	adda.l  d1,a0		; Version 1.2

;	lsl.w	#1,d0		;get Src
;	subq.l	#1,a0
;	adda.w	2(a0,d0.w),a0
	bra.s	\SolArcInit	;same as SolArcInit...

\Error:	st	d0

\UncpEnd:
	lea	PtrUncp(PC),a0
	movea.l (a0)+,a1
	move.w	(a0)+,d1
	move.l	(a0),d2
	movem.l	(a7)+,d3-d7/a0/a2-a6
	rts

\GetDestMem:    ;-------- d0.l = Len; a1 = *Dest
		;-------- d0/a0/a2 stored; HandleUncp, PtrUncp, FileLen set
			; create_handle(long size)
	tst.b	Flag_A		; *
	beq.s	\Alloc		; *
	move.l	PtrUncp(Pc),a1	; *
	rts			; *
\Alloc:				; *
	movem.l  d0/a0/a2,-(a7)

	move.l	d0,FileLen		;(Use for D2 in move.l (a0), d2)
	move.l	d0,-(a7)     		;HandleUncp = create_handle (Length)
	jsr	tios::HeapAlloc
	addq.l	#4,a7
	move.w	d0,HandleUncp

	tst.l	d0
	beq.s	\NotEnoughMem

	tios::DEREF	d0,a1
	move.l	a1,PtrUncp

	movem.l	(a7)+,d0/a0/a2
	rts

\NotEnoughMem:
	movem.l	(a7)+,d0/a0/a2
	move.l	#\Error,(a7)
	rts


;************************************************************************
;*  FreeMem								*
;*----------------------------------------------------------------------*
;*  Destroys the handle, which was used by the last uncompression.	*
;*  Note: FreeMem saves all registers.					*
;*  Parameters: nothing                                                 *
;*  Return: nothing                                                     *
;************************************************************************
pk92lib@0001:
	movem.l	d0-d7/a0-a6,-(a7)
;	lea	HandleUncp(PC),a0
;	tst.w	(a0)
;	beq	\NoHandle
;		; dispose_handle(int *handle)
;	pea	(a0)
;	jsr	tios::HeapFreeIndir
;	addq.l	#4,a7

;	move.w	HandleUncp(PC),d0
	move.w	HandleUncp(Pc),-(a7)
	beq.s	\NoHandle
;	move.w	d0,-(a7)
	jsr	tios::HeapFree
\NoHandle:
	addq.l	#2,a7
;\NoHandle:
	movem.l	(a7)+,d0-d7/a0-a6
	rts

PtrUncp:	dc.l 0
HandleUncp:	dc.w 0
FileLen:	dc.l 0

Flag_A		dc.b 0
	EVEN

;------------------------------------------------------------------------
	ifeq	CALC_TI92PLUS
_library:	dc.b "pk92lib", 0
	endif
;------------------------------------------------------------------------

;************************************************************************
;************************************************************************
;************************************************************************

	END
