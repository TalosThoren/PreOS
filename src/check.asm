;*
;* PreOs - Check - for Ti-89ti/Ti-89/Ti-92+/V200.
;* Copyright (C) 2004-2006 Patrick Pelissier
;*
;* This program is free software ; you can redistribute it and/or modify it under the
;* terms of the GNU General Public License as published by the Free Software Foundation;
;* either version 2 of the License, or (at your option) any later version. 
;* 
;* This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
;* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
;* See the GNU General Public License for more details. 
;* 
;* You should have received a copy of the GNU General Public License along with this program;
;* if not, write to the 
;* Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 

	include "include/romcalls.h"

Check:
	TRACE
	; Check if preos is archived.
	pea	_main-2(pc)				; Get org addr
	ifd	hw2tsr
		and.l	#$0003FFFF,(a7)			; Avoid Ghost Space
	endif
	FAST_ROM_CALL HeapPtrToHandle,a5
	move.w	d0,d3
	move.w	#2,(a7)
	clr.l	-(a7)
	FAST_ROM_CALL SymFindFirst,a5
	addq.l	#8,a7
\Loop		cmp.w	SYM_ENTRY.hVal(a0),d3
		beq.s	\Found
		FAST_ROM_CALL SymFindNext,a5
		move.l	a0,d0
		bne.s	\Loop
	moveq	#PREOS_NOT_FOUND,d0			; Can not find PreOS in the VAT.
	bra	\return
\Found	moveq	#ARCHIVE_PREOS,d0			; Error message
	btst.b	#2,SYM_ENTRY.flags(a0)			; Check Twin flag ?
	beq	\return					; No Twin Flag set.

	TRACE
	; Check if stdlib is archived and is in $system
	lea	-20(a7),a7
	clr.w	(a7)					; 0 Beginning
	pea	system_str(pc)				; System str
	pea	stdlib_format(pc)			; "%s\stdlib",0
	pea	9(a7)					; Buffer
	FAST_ROM_CALL sprintf,a5			; Create string
	lea	12+1(a7),a0				; Beginning of buffer
\Loop2		tst.b	(a0)+				; Loop until end of buffer
		bne.s	\Loop2
	pea	-1(a0)
	FAST_ROM_CALL SymFindPtr,a5			; Find 'stdlib'
	lea	4+12+20(a7),a7				; Pop args
	moveq	#STDLIB_NOT_FOUND,d0			; 'stdlib' not found
	move.l	a0,d1
	beq	\return
	moveq	#STDLIB_NOT_ARCHIVED,d0			; 'stdlib' not found
	btst.b	#1,SYM_ENTRY.flags(a0)			; Check if archived
	beq	\return

	TRACE
	; Check if all the libraries are with version >= 1
	move.w	#2,-(a7)		
	clr.l	-(a7)
	FAST_ROM_CALL SymFindFirst,a5
	move.l	a7,a4					; Lib ptr
\Loop3
		lea	LibCacheName(pc),a1
		move.w	SYM_ENTRY.hVal(a0),-(a7)	; Push handle
		move.l	(a0)+,d6
		move.l	(a0)+,d7
		move.l	d6,(a1)+
		move.l	d7,(a1)+
		FAST_ROM_CALL HeapDeref,a5
		tst.w	(a7)
		addq.l	#2,a7
		beq.s	\NextFile
		moveq	#0,d0
		move.w	(a0)+,d0
		cmp.b	#$F3,-1(a0,d0.l)
		bne.s	\NextFile
		cmp.l	#'68kL',4(a0)
		bne.s	\NextFile
		tst.b	KHEADER_version(a0)		; Updated Libs
		bne.s	\GoodLib
			lea	-50(a7),a7		; Buffer
			pea	LibCacheName(pc)
			FAST_ROM_CALL SymFindFoldername,a5
			pea	(a0)
			pea	outdated_format(pc)
			pea	12(a7)
			FAST_ROM_CALL sprintf,a5
			lea	12+4(a7),a0
			bsr	DisplayMessageA0
			lea	12+4+50(a7),a7
\GoodLib	; Check for multiple lib refs
		move.l	a7,a0
		bra.s	\SearchCmp
\SearchLoop
			cmp.l	(a0),d6
			bne.s	\SearchNext
			cmp.l	4(a0),d7
			bne.s	\SearchNext
				addq.w	#1,8(a0)	; Add one ref to this library
				bra.s	\NextFile
\SearchNext:		lea	10(a0),a0
\SearchCmp:		cmp.l	a0,a4
			bne.s	\SearchLoop
		; Add this library
		clr.w	-(a7)
		move.l	d7,-(a7)
		move.l	d6,-(a7)
\NextFile
		FAST_ROM_CALL SymFindNext,a5
		move.l	a0,d0
		bne	\Loop3

	TRACE
	; Check for Multiple Ref lib
	move.l	a7,a3
	bra.s	\MultCmp
\MultLoop
		tst.w	8(a3)			; Check if there is only one lib
		beq.s	\MultNext
			lea	-50(a7),a7		; Buffer
			pea	(a3)
			pea	multref_format(pc)
			pea	8(a7)
			FAST_ROM_CALL sprintf,a5
			lea	8+4(a7),a0
			bsr	DisplayMessageA0
			lea	8+4+50(a7),a7
\MultNext:	lea	10(a3),a3
\MultCmp:	cmp.l	a3,a4
		bne.s	\MultLoop
	lea	6(a4),a7

	; Check if there are global libraries in other folder than main
	
	; Check for file doorsos, teos, install, kernel file within stdlib

	TRACE
	moveq	#CHECK_DONE,d0				; Ok, check
\return	
	rts
	
