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
;*            Example for Divided / Normal Archive usage		*
;*----------------------------------------------------------------------*
;*                     by David Khling 1997/98 			*
;************************************************************************

	INCLUDE	"pk92lib.h"
	INCLUDE "gray4lib.h"
	INCLUDE "flib.h"

	XDEF	_main
	XDEF	_comment

; This file doesn't use the incude file, that is created automatically,
; when you compress a file with PACKER92.exe. But here it isn't useful,
; because the number of the file to uncompress is indicated by a counter,
; that is initialized to #0 (1st file) and counts up to 4 (5th file).
; Just for those who are interested, the file is included within the .zip
; file. it is named sample1.inc.

_main:
	jsr	gray4lib::on	;switch grayscale on
	tst.l	d0
	beq	\GrayError
        clr.w   d6              ;d6 = Number of file to uncompress = 1st file
    ;    ^-- move.w #sample11_2bp,d6 would be the same (if the sample.inc
    ;                                would be included into the program).
      
	; ----- uncompress file from Archive, specified by d0 ------
	lea	Archive(PC),a0
\Uncompress:
	move.w	d6,d0		;load Number of file to uncompress
	jsr	pk92lib::Extract
        tst.b   d0              ;if (d0 != 0) goto UncompressionError
        bne     \UncompressionError

	; ----- copy the uncompressed file to the 2 greyplanes -----
        move.w  #959,d7                 ;copy 960 longwords = 240x128 pixels
	move.l	gray4lib::plane1,a2
\PutPlane1:
	move.l	(a1)+,(a2)+
	dbra	d7,\PutPlane1

	move.w	#959,d7
	move.l	gray4lib::plane0,a2
\PutPlane2:
	move.l	(a1)+,(a2)+
	dbra	d7,\PutPlane2

	jsr	pk92lib::FreeMem	;unallocate the memory, used
					; for uncompression
	jsr	flib::idle_loop		;wait for keypress

	addq.w	#1,d6			;uncompress next file in Archive
	cmp.w	#5,d6
	beq	\End  			;if Number of file = 5 -> exit loop
	bra	\Uncompress
\End:
\UncompressionError:
	jsr	pk92lib::FreeMem

\GrayError:
	jsr	gray4lib::off

	rts

Archive:	INCBIN "sample1.p92"
		;      ^--- You should perhaps insert another directory here.
;	The Archive contains 5 Files, each of them is a 2 bitplane picture,
;       which size is 240x128. The planes follow each other, most significant
;	first, least significant last.

_comment:	dc.b	"PACKER92 - Sample #1",0

	END
