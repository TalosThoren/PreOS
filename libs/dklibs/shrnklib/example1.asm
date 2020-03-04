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
; Last save: Fri Jan 08 09:12:20  1999
; 33.0 49.4 49.4 49.4 49.4 49.4
;=============================================================================
	INCLUDE "flib.h"
	INCLUDE "gray7lib.h"
	INCLUDE "shrnklib.h"

	; include file that was automatically created by Shrink92
	INCLUDE "archive1.inc"

	XDEF	_main
	XDEF	_comment

_main:	jsr	gray7lib::on		; switch 7 shade grayscale on
	tst.l	d0			; if d0.l = zero: failure
	beq	\Error

	; open the archive
	lea	Archive(PC),a0		; load addresss of archive into a0
	jsr	shrnklib::OpenArchive	; return: d0.w = archive descriptor handle

	; extract plane #2 of picture
	moveq	#PICTURE2.1PL,d1	; d1 = index of archive section to extract
	movea.l	gray7lib::plane2,a0	; extraction destination is plane #2
	jsr	shrnklib::Extract	; do the extraction

	; extract plane #1 of picture
	moveq	#PICTURE1.1PL,d1	; d1 = index of archive section to extract
	movea.l	gray7lib::plane1,a0	; extraction destination is plane #1
	jsr	shrnklib::Extract	; do the extraction

	; extract plane #0 of picture
	moveq	#PICTURE0.1PL,d1	; d1 = index of archive section to extract
	movea.l	gray7lib::plane0,a0	; extraction destination is plane #0
	jsr	shrnklib::Extract	; do the extraction

	jsr	shrnklib::CloseArchive	; close the archive whose handle is given
					; by d0 (d0 is still the descriptor handle)

	jsr	flib::idle_loop		; wait for keypress

	jsr	gray7lib::off		; disable 7 shade grayscale

\Error:	rts				; exit program
	

	; shrink archive containing the 3 planes in 3 archive sections
Archive:	INCBIN "archive1.shk"

_comment:	dc.b "Shrink92 Example #1",0

	END
