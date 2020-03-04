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

;************************************************************************
;*               Example for Program-Data Archive usage			*
;*----------------------------------------------------------------------*
;*                     by David KÅhling 1997/98 			*
;************************************************************************

	INCLUDE	"pk92lib.h"
	INCLUDE "tios.h"
	INCLUDE "flib.h"

	XDEF	_main
	XDEF	_comment

	INCLUDE "sample2.inc"
	; This file contains the macros, for accessing the data.
	; it was automatically created by PACKER92.exe.
        ;  you should  perhaps change the path in this statement.

; I know, this file does not look very nice, all this repititions of
; similar function calls... but this is just a sample.

_main:
	lea	Archive(PC),a0		;extract program data
	jsr	pk92lib::Extract
	tst.b	d0			;if (d0 != 0) goto Error
	bne	\Error

	jsr	flib::clr_scr

				; FontSetSys(2)
        move.l  a1,-(a7)        ; save a1 from destruction by the ROM-function
	move.w	#2,-(a7)
	jsr	tios::FontSetSys
	addq	#2,a7
        move.l  (a7)+,a1        ; restore a1

				;print String1
        move.l  a1,-(a7)        ; save a1 again...
	move.w	#4,-(a7)
        pea     String1(a1)     
	move.w	#12*1,-(a7)
	move.w	#2,-(a7)
	jsr	tios::DrawStrXY
	lea	10(a7),a7
        move.l  (a7)+,a1        ; restore a1

				;print String2
        move.l  a1,-(a7)        ;...
	move.w	#4,-(a7)
	pea     String2(a1)
	move.w	#12*2,-(a7)
	move.w	#2,-(a7)
	jsr	tios::DrawStrXY
	lea	10(a7),a7
	move.l	(a7)+,a1

				;print String3
	move.l	a1,-(a7)
	move.w	#4,-(a7)
	pea     String3(a1)
	move.w	#12*3,-(a7)
	move.w	#2,-(a7)
	jsr	tios::DrawStrXY
	lea	10(a7),a7
	move.l	(a7)+,a1

				;print String4
	move.l	a1,-(a7)
	move.w	#4,-(a7)
	pea     String4(a1)
	move.w	#12*4,-(a7)
	move.w	#2,-(a7)
	jsr	tios::DrawStrXY
	lea	10(a7),a7
	move.l	(a7)+,a1

				;print Formatstring
	move.l	a1,-(a7)
	move.w	#4,-(a7)
	pea     FormStr(a1)
	move.w	#12*5,-(a7)
	move.w	#2,-(a7)
	jsr	tios::DrawStrXY
	lea	10(a7),a7
	move.l	(a7)+,a1

				;print String5
	move.l	a1,-(a7)
	move.w	#4,-(a7)
	pea     String5(a1)
	move.w	#12*6,-(a7)
	move.w	#2,-(a7)
	jsr	tios::DrawStrXY
	lea	10(a7),a7
	move.l	(a7)+,a1

				;sprintf (Buffer, FormStr, Num1, Num2);
	move.l	a1,-(a7)
	move.l	Num2(a1),-(a7)
	move.w	Num1(a1),-(a7)
	pea	FormStr(a1)
	pea	Buffer(a1)
	jsr	tios::sprintf
	lea     14(a7),a7
	move.l	(a7)+,a1

				;print Buffer
	move.w	#4,-(a7)
	pea     Buffer(a1)
	move.w	#12*7,-(a7)
	move.w	#2,-(a7)
	jsr	tios::DrawStrXY
	lea	10(a7),a7

	jsr	flib::idle_loop

\Error:
	jsr	pk92lib::FreeMem	;Unallocate the memory-block used
					;  for uncompression
	rts
;************************* end of program ***************************

Archive:	INCBIN "d:\fargo0.2_3\mysource\pk92samp\sample2.p92"
		;       ^- you should perhaps change this directory

_comment:	dc.b "PACKER92 - Sample #2",0

	END
