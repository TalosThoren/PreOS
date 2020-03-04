;
; PreOs - Launcher - for Ti-89ti/Ti-89/Ti-92+/V200.
; Copyright (C) 2003 - 2009 Patrick Pelissier
;
; This program is free software; you can redistribute it and/or modify it under the
; terms of the GNU General Public License as published by the Free Software Foundation;
; either version 2 of the License, or (at your option) any later version. 
; 
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
; See the GNU General Public License for more details. 
; 
; You should have received a copy of the GNU General Public License along with this program;
; if not, write to the 
; Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 

	include "include/romcalls.h"
	include "kheader.h"
	
ShiftOn		set	1
RestoreTSR	set	1
TI89TI		set	1	;  Build patch support for titanium
;TraceCode	set	0
		
	xdef	_nostub

	xdef 	_ti89
	xdef	_ti89ti
	xdef	_ti92plus
	xdef	_v200
	
PREOS_VERSION	EQU	$FF79*65536+'PO'	; PREOS Internal Version
ROM_VECTOR	EQU	$012088			; Offset from ROM_BASE to get the original vectors


; Conditionnal codes

	ifd	WTI
	include	"wti.h"
	endif
	ifnd	WTI
IS_WTI		MACRO
		ENDM
	endif

	ifd	hw2tsr
		include "hw2tsr.h"
	endif
	ifnd	hw2tsr
HW2TSR_PATCH	MACRO				; An register / Dn register
		ENDM
HW2TSR_INSTALL	MACRO
		ENDM	
HW2TSR_EXTRA_VECTORS	MACRO
			ENDM
HW2TSR_EXTRA_CODE	MACRO
			ENDM	
	endif
	ifd	TraceCode
TRACE	MACRO
	bsr	TraceCall
	ENDM	
	endif
	ifnd	TraceCode
TRACE	MACRO
	ENDM
	endif
		
; **** PreOS messages List ****
INSTALL_KERNEL_DONE			EQU	0
INSTALL_WRONG_CALCULATOR		EQU	1
INSTALL_HW2PATCH_MISSING		EQU	2
INSTALL_MEMORY_FULL			EQU	3
INVALID_CALLER				EQU	4
UNINSTALL_DONE				EQU	5
KERNEL_ALREADY_INSTALLED		EQU	6
INVALID_COMMAND				EQU	7
NO_PREOS_INSTALLED			EQU	8
ARCHIVE_PREOS				EQU	9
CHECK_DONE				EQU	10
PREOS_NOT_FOUND				EQU	11
STDLIB_NOT_FOUND			EQU	12
STDLIB_NOT_ARCHIVED			EQU	13

_main:
	TRACE
	moveq	#INVALID_CALLER,d0
	cmp.l	#$200000,(a7)				; Check org of the call
	bls.s	DisplayMessage

	movem.l d3-d7/a2-a6,-(a7)
	move.l	($C8).w,a5				; RomCalls ptr

	; Install new auto-ints
	bclr.b	#2,$600001				; Unprotect acces to vector table
	moveq	#7-1,d0
	lea	($64).w,a1
	lea	($E0).w,a2
\loop		move.l  (a1)+,(a2)+			; Save old handler
		dbra    d0,\loop
	bset.b	#2,$600001				; Protect acces to vector table

	TRACE
	bsr	parser

	TRACE
	add.w	d5,d5
	move.w	ActionTable(pc,d5.w),d0
	jsr	ActionTable(pc,d0.w)
	bsr	DisplayMessage
	
	TRACE
	movem.l	(a7)+,d3-d7/a2-a6
	rts

; In:
;	d0.w = Message Id
DisplayMessage:
	add.w	d0,d0
	beq.s	ShowMessage				; Install msg is done with ST
	move.w	DisplayMessageTable(pc,d0.w),d0
	lea	DisplayMessageTable(pc,d0.w),a0

DisplayMessageA0:
	pea	(1).w
	pea	(a0)
	pea	Title(pc)
	ROM_CALL DlgMessage
	lea	12(a7),a7
	rts

ShowMessage
	pea	InstallKernelStr(pc)
	FAST_ROM_CALL ST_showHelp,a5
	addq.l	#4,a7
	rts
	
ActionTable:
	dc.w	Default-ActionTable		; Default
	dc.w	Install-ActionTable		; Install
	dc.w	Uninstall-ActionTable		; Uninstall
	dc.w	Check-ActionTable		; Check
	dc.w	ActionUpdate-ActionTable	; Update
	dc.w	ActionHelp-ActionTable		; Help
	dc.w	ActionLaunch-ActionTable	; Launch
	
DisplayMessageTable:
	dc.w	InstallKernelStr-DisplayMessageTable
	dc.w	InstallWrongCalculatorStr-DisplayMessageTable
	dc.w	InstallHw2PatchMissingStr-DisplayMessageTable
	dc.w	InstallMemoryFullStr-DisplayMessageTable
	dc.w	InvalidCallerStr-DisplayMessageTable
	dc.w	UninstallDoneStr-DisplayMessageTable
	dc.w	KernelAlreadyInstalled-DisplayMessageTable
	dc.w	InvalidCommand-DisplayMessageTable
	dc.w	NoPreOSInstalled-DisplayMessageTable
	dc.w	ArchivePreos-DisplayMessageTable
	dc.w	CheckDone-DisplayMessageTable
	dc.w	PreosNotFound-DisplayMessageTable
	dc.w	StdlibNotFound-DisplayMessageTable
	dc.w	StdlibNotArchived-DisplayMessageTable

Default:			; The default action it to check, and then install Preos
	bsr	Check
	cmpi.w	#CHECK_DONE,d0
	beq	Install	
	rts

ActionUpdate:			; Not done yet
ActionHelp:
ActionLaunch:
	moveq	#INVALID_COMMAND,d0
	rts

	include	"parser.asm"
	include	"install.asm"
	include	"uninstal.asm"
	include "check.asm"
	include	"sams.asm"

	ifd	TraceCode
TraceCall:
	movem.l	d0-d2/a0-a1/a5,-(a7)
	move.l	($c8).w,a5
	lea	-20(a7),a7
	move.l	6*4+20(a7),d1
	lea	_main(pc),a0
	sub.l	a0,d1
	move.l	d1,-(a7)
	pea	\Format(pc)
	pea	8(a7)
	FAST_ROM_CALL sprintf,a5
	pea	12(a7)
	FAST_ROM_CALL ST_showHelp,a5
	lea	16+20(a7),a7
	movem.l	(a7)+,d0-d2/a0-a1/a5
	rts
\Format:
	dc.b	"Position %06lX",0	
	endif
			
InstallKernelStr:		dc.b	"Installed: "
Title:				dc.b	"PreOS v1.0.8",0
InstallHw2PatchMissingStr:	dc.b	"Install HW Patch",0
InstallWrongCalculatorStr	dc.b	"Calc not supported",0
InstallMemoryFullStr		dc.b	"Memory full",0
InvalidCallerStr		dc.b	"Exec PreOS from 'home'",0
UninstallDoneStr		dc.b	"PreOS uninstalled",0
KernelAlreadyInstalled		dc.b	"Kernel already installed",0
InvalidCommand			dc.b	"Invalid command",0
NoPreOSInstalled		dc.b	"No PreOS installed",0
ArchivePreos			dc.b	"Archive 'preos' first",0
CheckDone			dc.b	"Check done",0
PreosNotFound			dc.b	"PreOS not found",0
StdlibNotFound			dc.b	"stdlib not found",0
StdlibNotArchived		dc.b	"stdlib not archived",0

install_cmd:			dc.b	"install",0
uninstall_cmd:			dc.b	"uninstall",0
check_cmd:			dc.b	"check",0

sysdir_cmd:			dc.b	"sysdir",0
shell_cmd:			dc.b	"shell",0

stdlib_format			dc.b	"%s\stdlib",0
outdated_format			dc.b	"%s\%s is outdated",0
multref_format			dc.b	"Too many '%s' found",0

	end

