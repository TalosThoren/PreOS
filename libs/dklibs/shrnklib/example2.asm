; SHRINK92 - Copyright 1998 David Kuehling
; Adaptation for TI-89/92+ - Copyright 2002, 2003, 2004, 2005 Patrick Pelissier
;
; This file is part of the PACKER92 Library.
;
; The SHRINK92 Library is free software; you can redistribute it and/or modify
; it under the terms of the GNU Lesser General Public License as published by
; the Free Software Foundation; either version 2.1 of the License, or (at your
; option) any later version.
;
; The SHRINK92 Library is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
; License for more details.
;
; You should have received a copy of the GNU Lesser General Public License
; along with the MPFR Library; see the file COPYING.LIB.  If not, write to
; the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
; MA 02111-1307, USA.

; Fargo IDE header
;=============================================================================
; Last save: Tue Jan 12 17:59:42  1999
; 20.0 74.4 74.4 74.4 74.4 74.4
;=============================================================================
	INCLUDE "tios.h"
	INCLUDE "flib.h"
	INCLUDE "gray7lib.h"
	INCLUDE "shrnklib.h"

	; include file that was automatically created by Shrink92
	INCLUDE "archive2.inc"

	XDEF	_main
	XDEF	_comment

;-----------------------------------------------------------------------------
; Copy one plane (3840 bytes) from (a1) to (a2)
;-----------------------------------------------------------------------------
CopyPlane:
	move.w	#3840/4-1,d7		; d7 is our counter
\Loop:	move.l	(a1)+,(a2)+
	dbra	d7,\Loop		; loop back until d7 reaches -1
	rts

;-----------------------------------------------------------------------------
; MAIN
;-----------------------------------------------------------------------------
_main:	jsr	gray7lib::on		; switch 7 shade grayscale on
	tst.l	d0			; if d0.l = zero: failure
	beq	\Error

	; open the archive
	lea	Archive(PC),a0		; load addresss of archive into a0
	jsr	shrnklib::OpenArchive	; return: d0.w = archive descriptor handle

	; extract section #0 that contains all planes
	moveq	#0,d1			; d1 = index of archive section to extract
	movea.l	#0,a0			; a0 = 0: Extract has to allocate memory
	jsr	shrnklib::Extract	; do the extraction
					; ->a0.l points to allocated extraction memory
					; ->d2.l is the handle of that memory block

	jsr	shrnklib::CloseArchive	; close the archive whose handle is given
					; by d0 (d0 is still the descriptor handle)

	; copy plane #2 to gray7lib::plane2
	lea	PICTURE2.1PL(a0),a1	; load address of plane within extracted block
	movea.l	gray7lib::plane2,a2	; load destination address
	bsr	CopyPlane		; copy the plane from (a1) to (a2)

	; copy plane #1 to gray7lib::plane1
	lea	PICTURE1.1PL(a0),a1	; load address of plane within extracted block
	movea.l	gray7lib::plane1,a2	; load destination address
	bsr	CopyPlane		; copy the plane from (a1) to (a2)

	; copy plane #0 to gray7lib::plane0
	lea	PICTURE0.1PL(a0),a1	; load address of plane within extracted block
	movea.l	gray7lib::plane0,a2	; load destination address
	bsr	CopyPlane		; copy the plane from (a1) to (a2)

  	; free the memory that was allocated for extracting section #0
	move.w	d2,-(a7)		; d2 is still the handle (watch Extract)
	jsr	tios::HeapFree
	addq.l	#2,a7

	jsr	flib::idle_loop		; wait for keypress

	jsr	gray7lib::off		; disable 7 shade grayscale

\Error:	rts				; exit program
	

	; shrink archive containing the 3 planes in 1 archive section
Archive:	INCBIN "archive2.shk"

_comment:	dc.b "Shrink92 Example #2",0

	END

