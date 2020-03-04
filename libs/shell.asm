; Preos Browser by PpHd 2002
; This program is Public Domain. You can do what you want with it.
	
; This is a very simple browser which uses the powerfull function kernel::LibsExec
; and the powerfull library brwselib.

; During the call of a program, it will use only 289 bytes of memory !
; So you can easily run huge programs without any difficulty !

; As a consequence, when you return to browser, the launched program won't be
; selected. It is impossible to change this (Or brwselib has to been updated).

; Keys:
;	UP / DOWN / 2nd+UP / 2nd+DOWN / ENTER
;	You can only run asm programs !

	include "tios.h"
	include "romcalls.h"
	
	xdef	_main
	xdef	_comment
	xdef	_ti92plus
	xdef	_ti89
	xdef	_v200
	xdef	_ti89ti
	
;----------------------------------------------
; Callback routine, that checks, whether a file is an asm program
; Input:
;   d0.w = handle of file
; Output:
;   d4.w = Don't add this file to the list?
Filter:
	st	d4			; no Program: d4 = -1 -> do not
	bsr.s	DerefD02A0

	moveq	#0,d0
	move.w	(a0)+,d0		; Size of file
	cmp.b	#$F3,-1(a0,d0.l)	; Is it 'ASM' TAG ?
	bne.s	\NoPrgm
		cmp.l	#'68kL',4(a0)	; Library ?
		beq.s	\NoPrgm
			sf	d4	; signature ok: d4 = 0 -> add to list
\NoPrgm	rts

DerefD02A0:
	move.w	d0,-(a7)
	ROM_THROW HeapDeref
	addq.l	#2,a7
	rts
	
;----------------------------------------------
; Callback routine, that displays the comment of a chosen program
; within the Info-Window of the Browser, by the brwselib::InfoString
; routine.
; Input:
;   d0.w = handle of file
DisplayComment:
	move.w	d0,d6
	
	moveq	#2,d7			; Function 2 : Clear Info
	bsr.s	CallBrwselib		; clear the info window

	bsr.s	DerefD02A0
	addq.l	#2,a0			; Skip File size

	moveq	#3,d7			; Function 7 : InfoString

	lea	Nostub_str(Pc),a2	; Nostub Program

	cmp.l	#'68kP',4(a0)		; Test if Kernel Program (Libraries are not filtered !)
	bne.s	\NoKernel
		lea	Kernel_str(Pc),a2	; Kernel program

		moveq	#0,d3
		move.w	$A(a0),d3		; d0 = relative pointer to comment
		beq.s	\NoComment		; if it is zero: there is no comment!
			adda.l	d3,a0		; a0 = a0+d0 = absolute pointer to comment
	
			moveq	#2,d0		; X-coordinate of string (win-relative)
			moveq	#12,d1		; Y-coordinate of string (win-relative)
			moveq	#4,d2		; color (black on white)
			bsr.s	CallBrwselib	; display the string, pointed by a0
\NoComment:	bra.s	\Done
\NoKernel:
	cmp.l	#'68cA',2(a0)
	bne.s	\Done
		lea	comment_str(pc),a2
		move.w	d6,d0
		jsr	kernel::ExtractFileFromPack
		lea	Arch_str(Pc),a2	
		move.w	d0,-(a7)		; Handle of comment ?
		beq.s	\Done1
			bsr.s	DerefD02A0
			addq.l	#3,a0
			moveq	#2,d0		; X-coordinate of string (win-relative)
			moveq	#12,d1		; Y-coordinate of string (win-relative)
			moveq	#4,d2		; color (black on white)
			bsr.s	CallBrwselib	; display the string, pointed by a0
			ROM_THROW HeapFree	; Free it
\Done1:		addq.l	#2,a7
\Done:
	move.l	a2,a0
	moveq	#2,d0		; X-coordinate of string (win-relative)
	moveq	#2,d1		; Y-coordinate of string (win-relative)
	moveq	#0,d2		; color (white on black)

; In:
;	d7.w = Library function
CallBrwselib
	move.b	#1,-(a7)		; Version 1
	move.w	d7,-(a7)		; Function ?
	pea	brwselib_str(Pc)	; Library name
	jsr	kernel::LibsExec	; Execute the library
	tst.l	(a7)			; Test if the kernel has called the library
	addq.l	#8,a7
	rts

Execute:
	jsr	kernel::Exec
_main:	clr.w	-(a7)
	ROM_THROW ST_busy
	addq.l	#2,a7
	lea	_comment(PC),a4		; a4 points to title of browser window
	lea	Filter(PC),a0      	; a0 points to filter callback routine
	lea	DisplayComment(PC),a1	; a1 points to info callback routine
	suba.l	a5,a5			; a5 points to enter-pressed callback r.
	moveq	#6,d7			; Function 6 : Browse
	bsr.s	CallBrwselib		; Call Library
	beq.s	\error			; No => error
	tst.w	d0			; ESC has been pressed
	bne.s	Execute			; No,; execute handle
\error	rts

comment_str	dc.b "comment",0
brwselib_str	dc.b "brwselib",0
_comment:	dc.b "Preos "
Title_str	dc.b "Browser",0
Kernel_str	dc.b "Kernel",0
Nostub_str	dc.b "Nostub",0
Arch_str	dc.b "Pack Archive",0
	END
