;*
;* PreOs - Shared Linker - Preos vectors - for Ti-89ti/Ti-89/Ti-92+/V200.
;* Copyright (C) 2004 PpHd
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
	include "kheader.h"

; This code is usefull for HW2 without HW3PATCH
; ie HW2 with HW2PATCH or HW2TSR
; AMS 2.0x is buggy. Try this:
;       exec "4E444E750000" (trap #4 / rts)
; on a calculator without any patch, nor TSR and try to change the batteries
; when the calc is shutdown. It crashes your HW2 calculator!
newTrap4:
	movem.l d0/a0-a1,-(sp)            		; Save A0/A1/d0
	move.l	OldTrap0+2(pc),a0			; Get Old trap #0 and restore it while calling Trap#4
	lea	($80).w,a1				; Trap #0 Vector
	move.l	(a1),-(sp)				; Save Current trap #0 Vector
	bsr	InstallVector				; Reinstall Original Trap #0
        move.l  USP,a1          			; Get User Stack Pointer
        pea     (a1)            			; Save Usp
	moveq	#20/4-1,d0				; Loop
\loop		move.l	a0,-(a1)			; Create a dummy Frame to fool AMS
		dbf	d0,\loop			; a0 is the original Trap #0, so it is inside TIOS
        move    a1,USP          			; but it is the original vector (the vectors are restored by AMS during the call of trap #B)
        bsr.s   t4call          			; So the range of $10(Usp) is Ok ! It will work.
        move.l  (sp)+,a0        			; Reload pushed USP
        move.l  a0,USP          			; Restore Usp
       	move.l	(sp)+,a0				; Reload Current Trap #0 Vector
	lea	($80).w,a1				; Trap #0 Vector
	bsr	InstallVector				; ReInstall Current Tra^#0
        movem.l (sp)+,d0/a0-a1        			; Restore a0-a1/d0
        rte	
t4call: move.w  SR,-(sp)        			; Call the original Trap #4 (Return addr is pushed, and pushes the SR)
OldTrap4
	jmp     ($0).l          			; Jump to the original trap #4


newLine1010:
	pea	(a0)					; Push a0
	lea	FirstRun(Pc),a0				; Test if we are under kernel final undo
	cmpi.b	#-1,(a0)
	beq	CrashHandler				; Yes => Crash Handler
	
	move.l	6(sp),a0				; The crash address
	cmp.w	#$A000+161,(a0)				; Test if it is 'Too long Exec Program'
	beq.s	ERThrow_return
	cmp.w	#$A244,(a0)				; Test if 'Illegal Program Reference'
	bne.s	ERTHrow_no			
AMS207_P1	cmpi.b	#$F3,(a3)			; Check if is an ASM program 
		bne.s	ERTHrow_no			; On AMS 2.08, it isn't a3 but a2 (That's why it is patched)
AMS207_P2	cmp.l	#$200000,a5			; If the variable is archived, we MUST NOT SKIP THE ERROR	
		bge.s	ERTHrow_no			; Otherwise, we crash the calc (It tries to execute archived programs !)
ERThrow_return		addq.l	#2,6(sp)		; Skip the illegal instruction
			move.l	(a7)+,a0		; Restore a0
			rte				; We return to the program, skipping the illegal
ERTHrow_no
	move.l	(a7)+,a0				; Restore a0
OldER_throw
	jmp	($0).l					; Jump to old ER_throw
	
; it is preos trap 12 which does exactly what trap #12 should do.
; it is very likely tios's trap 12.
; in fact i add this function so that i am sure that trap #12 goes to supervisor mode
; (if the function intercepts trap #12...) that's all.
newTrap12:
	move.w	(sp)+,d0
	rts

; Line 1111.
; Registers safe (32 bytes bigger)
; If $FFF0, 
;	~ jsr abs.l (Return address +6 / jsr to a1 ->Crash code+2 a1+(a1)
;	Ex:	dc.w	$FFF0 dc.l JumpAdr-*
; If $FFF1, 
;	~ jmp abs.l (Return address +6 / jmp to a1 ->Crash code+2 a1+(a1)
;	Ex:	dc.w	$FFF0 dc.l JumpAdr-*
; If $FFF2,
;	ROM_CALL with a word offset.
;	Example: dc.w $FFF2, HeapAlloc*4
newLine1111:	
	movem.l	d0/a0-a3,-(sp)			; Save registers
	move.l	(4*5+2)(sp),a0			; Get crash address
	move.w	(a0)+,d0			; Read crash opcode
	subi.w	#$F800,d0			; If < $F800, it is a crash
	bls	CrashHandler
	move.l	a0,a1				; a1 = Dest address a0 = Return address
	adda.l	(a0)+,a1			; Update a0/a1 in case of a JSR/JMP opcode
	lea	\JumpPatch2(Pc),a2		; Get code to execute if JMP
	move.l	a2,a3				; Set reference ptr
	cmpi.w	#$FFF1-$F800,d0			; Check if Opcode is JMP
	beq.s	\DoJSR				; Do jmp
	subq.l	#\JumpPatch2-\JumpPatch1,a2	; Fix code to execute: JSR mode
	cmpi.w	#$FFF0-$F800,d0			; Check if Opcode is JSR
	beq.s	\DoJSR				; Do jsr
	subq.l	#4,a0				; Since it is not JMP/JSR restore a0
	cmpi.w	#$FFF2-$F800,d0			; Check if Opcode is BigRomCall
	bne.s	\NoBigRomCall			; skip it
		move.w	(a0)+,d0		; Read offset of romcall
		lsr.w	#2,d0			; Get index of romcall
\NoBigRomCall:
	move.l	($C8).w,a1			; Get address of romcall table
	cmp.w	-(a1),d0			; Check overflow in romcall table
	bcc.s	CrashHandler			; overflow ? => crash
	lsl.w	#2,d0				; index * 4 => offset
	move.l	2(a1,d0.w),a1			; Get romcall ptr
\DoJSR:	move.l	a0,\JumpPatch1+2-\JumpPatch2(a3); Save return address
	move.l	a1,\JumpPatch2+2-\JumpPatch2(a3); Save dest  address
	move.l	a2,(4*5+2)(sp)			; Save execute handler
	movem.l	(sp)+,d0/a0-a3
	rte
\JumpPatch1	pea	($123456).l
\JumpPatch2	jmp	($789ABC).l

; New auto int 6 
newInt6:
	pea	(a0)
	move.l	d0,-(sp)		; Save d0
	lea	$600018,a0		; To access special IO ports
	btst.b	#1,($1A-$18)(a0)	; Test if ON key if effectively pressed
	bne.s	NoShell			; ON key is not pressed
					; Test if ESC is pressed
	move.w	(a0),-(sp)		; Push Org Mask
int6msk	move.w	#%0111111,(a0)		; Write mask (int1 & 5 can't be called ;)
	moveq	#$58,d0			; TiOs uses $58
		dbra d0,*		; 
int6key	btst	#0,($1B-$18)(a0)	; Read Key Matrix 
	beq.s	CrashHandler		; Yes => Crash handler
	move.w	(sp)+,(a0)		; Restore Org Mask
	ifd	ShiftOn
Statut		btst	#2,($6760).l	; SHIFT has been pressed? 
		beq.s	NoShell
			lea	Trap0FuncCall(Pc),a0
			tst.b	(a0)	; Test is we are already under SHIFT+ON call
			bne.s	NoShell
				move.b	#1,(a0)		; We want to Handle ShiftOn
				move.l	(sp)+,d0	; Restore d0
				move.l	(sp)+,a0	; Restore a0
				rte			; Don't call original int6
	endif
NoShell	move.l	(sp)+,d0		; Restore d0
	move.l	(sp)+,a0
oldint6	jmp	($0).l			; Call the original int.



; Something bad has happens...
; Try to recover from the crash.
CrashHandler:					; Crash handlers
	move.w  #$2700,SR			; Stop interrupts (Is it necessary!)
	bsr	GetDataPtr
	move.w	FirstRun-Ref(a6),d0		; Test if crash under no-kernel mode ? (=0) or under Kernel Anti-Crash ? (= $FF00)
	ble.s	VeryBadThings
	move.w	#ER_CRASH_INTERCEPTED,Error-Ref(a6)
	addq.l	#6,sp				; Pop SR / Return addr
	movea.w	#-$10,a5			; A5 -> Current prog ptr
	bra	_quit				; -$10 so that bit 2 of $11(a5) it bit 2 of byte 1, so this to say, byte = 0, so that it will redraw the screen.
		
; Very bad things have happen...
; But still try to recover from the crash by resetting partially AMS.
VeryBadThings:
	lea	($4C00-30*3).w,sp	; Load new Supervisor Stack Ptr (-30*3 to prevent some buggy programs to write inside the supervisor stack)
	bsr	InstallVectors		; Reinstall Preos vectors
	clr.w	FirstRun-Ref(a6)	; Reinit kernel

	lea	CrashFlags(Pc),a5	; Test for recursive nostub_crash
	move.l	($C8).w,a4		; Romcall Table
	
	;1. OSqclear and cmd_disphome doesn't exist on AMS 1.00 Ti-92 (It crashes once, but no twice).
	bset.b	#0,(a5)
	bne.s	\crash1
		moveq	#6,d0		; 6 = Key Queue address
		trap	#9		; System Call
		move.l	a0,(sp)
		ROM_THROW OSqclear	; reset the keyboard Queue
		ROM_THROW cmd_disphome	; Set Home Apps
\crash1

	; 2. Free some unused handles
	bset.b	#1,(a5)
	bne.s	\Dont_Free_Handles
		ROM_THROW HS_freeAll			; Free Home Screen History (I could call cmd_clrHome, but it doesn't work on AMS 1.00).
		move.l	FirstWindow*4(a4),a2
		move.l	(a2),d0
		beq.s	\Dont_Free_Handles		; If FirstWindow == NULL
\wloop			move.l	d0,a2
			move.w	32(a2),(sp)
			beq.s	\no_dupscr
				ROM_THROW HeapFree 	; Free duplicate screen (IO and Graph)
\no_dupscr		move.l	34(a2),d0
			bne.s	\wloop
\Dont_Free_Handles:

	; 3. Reset the link		
	ROM_THROW OSLinkReset	

	; 4. Reset AMS
	bset.b	#2,(a5)
	bne.s	crash3
AMS_HiddenFunc:
		jsr	($0).l				; Reset PortRestore / SetCurrentClip / ScreenClear(:() / FontSetSys + Some flags
		jsr	($0).l				; Reset Window List ;$529E10 ; Rom 2.03
crash3

	; 5. Reset Vectors
	bsr	reinstall_tios_stat			; Statut / Vectors / AutoInts / IO / Contrast	// CAN NOT CRASH

	; 6. Test if Auto-ints ok ?
	bset.b	#3,(a5)
	beq.s	autointorg_restored
		bclr.b	#2,$600001			; Allow write to vectors table
		; Restore the original auto-ints!
ROMBASE1	lea	ROM_VECTOR+$64,a0		; Original Auto-ints
		lea	($64).w,a1			; Auto-Ints
		moveq	#7-1,d0
\ailoop			move.l	(a0),($E0-$64)(a1) 	; New copy
			move.l	(a0)+,(a1)+
			dbf	d0,\ailoop
		lea	newInt6(pc),a0			; Rewrite autoint 6
		move.l	a0,($E0-$64-8)(a1) 		; New copy
		move.l	a0,-8(a1)
		bset.b	#2,$600001			; Unable write protect to vectors table
autointorg_restored:
	
	; 7. Save current EV_hook vector if we restore the TSR
	ifd	RestoreTSR
		bset.b	#4,(a5)				; To avoid the save of the new trap and an end-less loop
		bne.s	\restoreTSR_already
			ROM_PTR	EV_hook			; Save EV_hook vector
			move.l	(a0),Saved_EV_Hook-Ref(a6)
			move.b	#2,Trap0FuncCall-Ref(a6)
\restoreTSR_already
	endif

	move.w	#$0000,SR				; SR = $0000
ErrorFrameAdr	clr.l	($5CF8).w			; Reset ERROR FRAME
StackPtr	lea	($4200).w,a7			; ReLoad stack ptr
	ifnd	RestoreTSR
		clr.b	(a5)				; Reset Flags is there is not Restore TSR (It is worst because we don't let many time to the system, to crash if the auto-ints are corrupted). Nevertheless, if the auto-ints are really buggy, it will crash.
	endif
	;ROM_THROW EV_centralDispatcher			; Redo the main loop
	move.l	EV_centralDispatcher*4(a4),a0		; Avoid ROM_THROW to proprely set the User Stack
	jmp	(a0)					; Since it is needed by some programs

; New Trap #0 
newTrap0:
idleN	cmpi.w	#$1E4,d0			; idle ?
	bne.s	OldTrap0			; No idle => Don't intercept it.
	movem.l	d0-d7/a0-a6,-(sp)		; Push all registers
	bsr	GetDataPtr			; Get a6 ptr
	move.b	Trap0FuncCall-Ref(a6),d1	; Read Func number to run.
	ble.s	Trap0NoCall			; =0 or in use =-1, don't call it again.
		st.b	Trap0FuncCall-Ref(a6)	; Trap 0 in use.
		moveq   #64-1,d2               	; # of vectors to save.
		suba.l  a1,a1                	; NULL ptr
\SaveLoop:		move.l  (a1)+,-(sp)    	; Save old handler
			dbf    d2,\SaveLoop
		bsr	InstallVectors		; Install PreOS vectors
		move.w	#0,SR			; Go to User Mode
		ifd	ShiftOn
			cmpi.b	#1,d1
			beq	HandleShiftOn	; Handle Shift + ON
		endif
		ifd	RestoreTSR
			cmpi.b	#2,d1
			beq.s	HandleRestoreTSR	; Handle Restore TSR
		endif
Trap0Return:	trap	#12			; Go to Supervisor Mode
		moveq   #64-1,d2                ; # of vectors to restore.
		bclr.b	#2,$600001
		lea	($100).w,a1             ; NULL ptr
\RestoreLoop:		move.l  (sp)+,-(a1)     ; Restore old handler
			dbf    d2,\RestoreLoop
		clr.b	Trap0FuncCall-Ref(a6)	; Unuse Trap 0
		bset.b	#2,$600001
Trap0NoCall
	movem.l	(sp)+,d0-d7/a0-a6
OldTrap0
	jmp	($0).l

		
; It is called after the Hot-reset, to restore the EV_hook.
; It also displays Crash Intercepted.
	ifd	RestoreTSR
HandleRestoreTSR:
	lea	CrashFlags(Pc),a5	; Test for recursive nostub_crash
	clr.b	(a5)+			; Nostub crash ok (Auto ints ok !)
EV_hook3
	lea	($0).l,a4		; Get address of EV_hook
	lea	Saved_EV_Hook(Pc),a3	; get the address of the event hook
					; We need to use indirect addressing
					; so we can get rid of broken or
					; incompatible event hooks.
					; And we need to use the ghost space
					; because we want to write there!

	; Event hook restoring / freeing code
	tst.b	(a5)			; TSR have crashed ? 
	beq.s	\nocrash
		; Crash flag set - uninstall the event hook in the cleanest possible way
		move.l	(a3),a0			; get the address of the event hook
		; Check whether the event hook respects the evHk convention. This is
		; done to avoid restoring a corrupt address in case some broken
		; program corrupted EV_hook.
\crash_nexthook
		move.l	a0,d0
		beq.s	\crash_nomorehooks
		btst.b	#0,d0			; check if the address is even
		bne.s	\crash_nomorehooks	; if it is odd, it is obviuosly broken
		suba.w	#$10,a0			; Remove $10 to get the beginning of the 
		bcs.s	\crash_nomorehooks	; TSR - evHk convention -
		cmp.l	#'EvHk',(a0)		; Check for signature of Event Hook v2
		beq.s	\crash_okhook
		cmp.l	#'evHk',(a0)		; Check for signature of Event Hook v1
		bne.s	\crash_nomorehooks
\crash_okhook		move.l	12(a0),-(a7)		; get next event hook and save it on the stack
			pea.l	(a0)
			ROM_THROW HeapPtrToHandle	; get the handle number
			move.w	d0,(a7)
			beq.s	\nofree
				ROM_THROW HeapFree	; free (unallocate) the handle
\nofree 		addq.l #4,a7
			move.l	(a7)+,a0		; next event hook
			bra.s	\crash_nexthook
\crash_nomorehooks
		clr.l	(a4)			; get rid of EV_hook
		bra.s	evHk_crash

\nocrash:
	; Crash flag not set - try to restore the event hooks
	move.l	a3,a1
	
	; Check whether the event hook respects the evHk convention. This is
	; done to avoid restoring a corrupt address in case some broken
	; program corrupted EV_hook.
\nexthook
	tst.l	(a1)
	beq.s	\nomorehooks
	btst.b	#0,3(a1)		; check if the address is even
	bne.s	\incompatible		; if it is odd, it is obviuosly broken
	move.l	(a1),a0
	suba.w	#$10,a0			; Get the beginning of the EVhk 
	bcs.s	\incompatible		; evHk convention 
	cmp.l	#'EvHk',(a0)		; check for signature v2
	beq.s	\next2
	cmp.l	#'evHk',(a0)		; check for signature
	bne.s	\incompatible
\next2		lea.l	12(a0),a1	; get next event hook
		bra.s	\nexthook
\incompatible clr.l (a1)		; get rid of incompatible or broken
					; event hooks the dirty way
\nomorehooks
	st.b	(a5)			; set crash flag - in case the event hook crashes,
					; we will get back here with the crash flag set
	move.l	(a3),(a4)		; Restore EV_hook
	beq.s	\noevHk
		; Now try to send an idle event to check whether the event hooks actually work.
		; If it fails, we will get back here with the crash flag set.
		; Create a fake EVENT structure on the stack:
		clr.w	-(a7)			; StartType
		clr.l	-(a7)			; extra
		pea	($400).w		; Side, StatusFlags
		pea	($7000000).l		; Type, RunningApp
		move.l	a7,a2			; the convention requires a2 to hold the address of
						; the EVENT structure - while we are not worring about
						; TeOS here, unfortunately, some versions of XtraKeys for
						; the TI-92+ (including the latest released version) rely
						; on this too (because the move.l 64(a7),a2 got forgotten
						; by mistake)
		pea.l	(a7)			; EVENT structure
		move.l	(a3),a0			; adress of the EV_hook routines 
		jsr	(a0)
		lea.l	18(a7),a7		; pop the parameter AND the EVENT structure
\noevHk

; Common (whether crash flag is set or not)
evHk_crash
	clr.b	(a5)			; clear crash flag

	pea	errortext(Pc)
	ROM_THROW ST_helpMsg		; Display Crash Intercepted
	addq.l	#4,a7
	bra	Trap0Return
Saved_EV_Hook	dc.l	0	; Save EV_hook
	endif

CrashFlags		dc.b	0	; OSqclear / disphome success ?
evHkFlag		dc.b	0	; event hook has crashed?
	

; Try to run a shell.
	ifd	ShiftOn
HandleShiftOn:					; SHIFT+ON combo. Called either 'shell' or 'main\tictex'
	clr.w	-(a7)				; Get rid of SHIFT indicator Now
	ROM_THROW ST_modKey			; Auto-Int1 will do it too late.
	ROM_THROW OSClearBreak			; Clear break now.
	pea	($0F00+60).w			; Push SCREEN size + some info about supervisor stack.
	ROM_THROW HeapAllocPtr			; Allocate a block to save the screen
	move.l	a0,(a7)				; Save a0 and test if a0 == NULL
	beq.s	ShiftOnEnd
		lea	(LCD_MEM-60).w,a1	; Copy the LCD_MEM and some supervisor stack into the buffer
		move.w	#($0F00+60)/4-1,d0	; Buffer size / 4 (Longword copy)
\loop			move.l	(a1)+,(a0)+
			dbf	d0,\loop
		ROM_THROW FontGetSys		; Save current Font System
		move.w	d0,-(a7)

top_estack1	move.l	($0).l,-(a7)		; Save top_estack
		ROM_THROW push_END_TAG		; Push END tag so that progs which needs args won't crash (I hope)

		clr.w	-(a7)			; Normal Search
		pea	ShellSymStr(Pc)		; File '$shell'
		ROM_THROW SymFindPtr		; Find the file. If it failed, then a0 =0 and SYM_ENTRY.hVal = 7 or 3
		addq.l	#6,a7
		move.l	a0,d0
		beq.s	\NotFound
		move.w	SYM_ENTRY.hVal(a0),d0	; Get its handle
		bsr	startHandleKernel	; Even _nostub programs are run through Kernel
\NotFound
		
top_estack2	move.l	(a7)+,($0).l		; Restore top_estack
		
		ROM_THROW FontSetSys		; Restore current Font System
		addq.l	#2,a7
		move.l	(a7),a0
		lea	(LCD_MEM-60).w,a1	; Restore the LCD_MEM and some supervisor stack
		move.w	#($0F00+60)/4-1,d0	; Buffer size / 4 (Longword copy)
\loop2			move.l	(a0)+,(a1)+
			dbf	d0,\loop2
		ROM_THROW HeapFreePtr
ShiftOnEnd
	addq.l	#6,a7				; Pop Screen_size + Mod_indicator
	bra	Trap0Return
	endif
