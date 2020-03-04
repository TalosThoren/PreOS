;*
;* PreOs - Intstaller - for Ti-89ti/Ti-89/Ti-92+/V200.
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

Install:
	TRACE
	move.l	a7,a6					; Save Sp

	; 0. Check if we can install a kernel
	moveq	#KERNEL_ALREADY_INSTALLED,d0		; Error message
	tst.w	($30).w				
	bne	InstallError

	; 1 : Detection of CACULATOR / Hardware / RomBase    (Check if BOOT Update).
	move.l	($4).w,d0				; Read Reset Vector
	andi.l	#$00F00000,d0				; Clean it
	move.l	d0,a4					; A4 -> ROMBASE
	move.l	260(a4),a1				; HardwareParmBloc
	move.w	(a1)+,d1				; Read and skip size
	move.l	(a1)+,d2				; Read Calculator ( 1: 92+ / 3: 89 / 8: V200 / 9: TI-89 titanium)
	move.l	(a1)+,d5				; Read Hardware Revision version
	moveq	#1,d3					; HW_VERSION = 1
	cmpi.w	#$16,d1					; AMS reads Gate Array field to
	bls.s	\hw1					; see which hardware it is.
		move.l	($16-2-4-4)(a1),d3		; Read HW_VERSION
\hw1	

	TRACE
	; 2. Detection of Emulator: Change calc / hw_version.  (Check if EMULATOR Update).
	clr.b	d4					; Emulator = False
	trap	#12         				; Enter supervisor mode.
	IS_WTI.s	\emu
	moveq	#-97,d1					; Vti detection by JM
	nbcd	d1
	bmi.s	\real_calc
\emu:		st.b	d4				; EMULATOR = TRUE
		moveq	#1,d3				; Force HW1
		cmp.w	#$1400,(a4)			; Check if it is a TIB under VTi
		bne.s	\real_calc			; It is not a TIB, so HARDWARE PARM BLOC exists !
			moveq	#1,d2			; 92 + Version
			cmp.l	#$400000,a4
			beq.s	\real_calc
			moveq	#3,d2			; 89 Version
\real_calc
	move.w	#0,SR
	
	TRACE
	; 3. Translate calculator from Boot format to kernel format
	moveq	#1,d0					; 92+ Version
	subq.w	#1,d2					; Yes (1)
	beq.s	\TranslationDone
	moveq	#0,d0					; 89 Version
	subq.w	#2,d2					; Yes (3)
	beq.s	\TranslationDone
	moveq	#3,d0					; V200 Version
	subq.w	#5,d2					; Yes (8)
	beq.s	\TranslationDone
	moveq	#-1,d0					; 89 titanium Version
	subq.w	#1,d2					; Yes (9)
	beq.s	\TranslationDone
		moveq	#INSTALL_WRONG_CALCULATOR,d0
		bra	InstallError
\TranslationDone:

	TRACE	
	; 4 : Save calc / hardware in CALCULATOR variable
	lea	Calc(pc),a3
	move.b	d0,(a3)+				; Save Calculator
	move.b	d3,(a3)+				; Save Hardware Version
	move.b	d5,(a3)+				; Save HW_REVISION_VERSION (Useless)
	move.b	d4,(a3)+				; Save Emulator Flag

	TRACE
	; 5 . Copy 89/92-v200 values
	lea	RAM_TABLE+4(pc),a3
	lea	RAMCALL_89(pc),a0
	tst.b	d0					; Check calculator
	ble.s	\ti89
		lea	RAMCALL_92p(pc),a0
\ti89:
	moveq	#12,d0
\loopRAM:	move.l	(a0)+,(a3)+
		dbf	d0,\loopRAM
	move.l	a4,-4*11(a3)				; Fix Rom_Base for V200 and 89ti

	TRACE
	; 6 . Find FontMedium (It takes only 0.02s to find it.) (Check if BOOT Update).
	move.l	a4,a0
\fontloop:	cmp.l	#$54A854A8,(a0)+
		bne.s	\fontloop
	subq.l	#4,a0
	move.l	a0,(a3)+

	; 7. Clean Return value
	clr.l	(a3)+					; ReturnValue is calculated later.

	TRACE
	; 8. Find tios::kb_vars (Check if AMS Update).
	moveq	#6,d0					; 6 = Key Queue address
	trap	#9					; Call system
	lea	($6-$1C)(a0),a0				; Fix to get kb_vars
	move.l	a0,(a3)+				; Warning: On AMS 3.10, it is > $8000. Maybe bugs?

	TRACE
	; 9. Find tios::ST_status.
	ifd	ShiftOn					; (Check if AMS Update).
		FAST_ROM_PTR $443,a5			; ST_flags for AMS 2.0x
		cmpi.w	#$442,-2(a5)
		bhi.s	\stams2xx
			FAST_ROM_PTR ST_precision,a5	; Code looks like : andi.l #$FFFFFE7F,ST_statut
			move.w	6(a0),a0		; Read ST_statut
\stams2xx	addq.w	#3,a0				; On AMS 3.10, it is > $8000
		lea	Statut+3(Pc),a1
		moveq	#1,d1				; Bit : 1 for 89 / 2 for 92+ & V200 
		move.b	Calc(Pc),d2
		ble.s	\this89
			moveq	#2,d1
\this89		move.b	d1,(a1)+			; Patch Preos.bit
		move.l	a0,(a1)				; Patch Preos.addr
	endif

	TRACE
	; 10. Find Heap (All ROM. On rom 2.0x there is a rom_call ) (Check if AMS Update).
	; This variable must be < $8000, otherwise some programs won't work.
	FAST_ROM_PTR HeapDeref,a5
	movea.w	8(a0),a1
	cmpi.w	#1000,-2(a5)
	ble.s	\HeapDone
		; For AMS 2.xx and AMS 3.xx
		move.l	$441*4(a5),d0			; Get address of HeapTable
\heap_loop	move.w	(a0)+,d1			; 
		btst.l	#0,d1				; Check if ODD
		bne.s	\heap_loop			; Yes => Next word
		movea.w	d1,a1				;
		cmp.l	(a1),d0				; Check if it is a good variable
		bne.s	\heap_loop
\HeapDone
	move.l	a1,(a3)+				; Set tios::Heap

	TRACE
	; 11. Find main, its handle and the handle of FolderListHandle
	pea	main_sym_str(Pc)
	FAST_ROM_CALL SymFindHome,a5			; Find 'main' folder
	move.l	d0,d1
	clr.w	d1
	swap	d1
	move.l	d1,(a3)+				; Save FolderHandle
	move.l	d0,(a7)
	FAST_ROM_CALL DerefSym,a5			; Deref 'main' HSym
	move.w	SYM_ENTRY.hVal(a0),d0			; MainHandle
	moveq	#0,d1
	move.w	d0,d1
	move.l	d1,(a3)+				; Save MainHandle

	TRACE
	; 12. Find the ROM version number. (By Kevin Kofler - Modified by PpHd)
	move.l	#$1100,d1				; Version: Ti-92+ Rom 1.00
	move.l	-4(a5),d2				; Get number of ROM CALLS
	cmp.w	#cmd_table,d2 				; Check if cmd_table is defined
	bcs.s	\save					; Rom Call cmd_table isn't defined: ROM 1.00
		move.l	cmd_table*4(a5),a0
		lea	-$10(a0),a0 			; Get address of AMS version
		cmpi.w	#$440,d2 			; Check if AMS version ROM_CALL is present
		bls.s	\getversion
			move.l	$440*4(a5),a0 		; Get address of AMS version ROM_CALL
\getversion:
		moveq	#'0',d0 			; Translate the string into an AMS version
		move.b	Calc(Pc),d1			;
		lsl.w	#4,d1				; Calculator field
		add.b	(a0),d1				; Add main version number
		sub.b	d0,d1				; Sub '0'
		lsl.w	#4,d1
		addq.l	#2,a0
		add.b	(a0)+,d1
		sub.b	d0,d1
		lsl.w	#4,d1
		add.b	(a0)+,d1
		sub.b	d0,d1
\save:	move.l	d1,(a3)+

	TRACE
	; 13. Find LCD_MEM (Check if HW update).
	lea	4*($21-$15)(a3),a3
	move.l	#LCD_MEM,(a3)+

	TRACE
	; 14. Find font_small (It takes only 0.02s to find it.) (Check if BOOT Update).
	move.l	a4,a0
\fontsmall_loop	cmp.l	#$0450A050,(a0)+
		bne.s	\fontsmall_loop
	subq.l	#4,a0
	move.l	a0,(a3)+

	TRACE
	; 15. Find font_medium (It takes only 0.02s to find it.) (Check if BOOT Update).
	move.l	a4,a0
\fontmed_loop	cmp.l	#$55AA55AA,(a0)+
		bne.s	\fontmed_loop
	subq.l	#4,a0
	move.l	a0,(a3)+

	TRACE
	; 16. Desciption of a SYM_ENTRY struct
	moveq	#0,d0
	move.l	d0,(a3)+				; Name
	moveq	#8,d0
	move.l	d0,(a3)+				; Compat
	moveq	#10,d0
	move.l	d0,(a3)+				; Flags
	moveq	#12,d0
	move.l	d0,(a3)+				; hVal
	moveq	#14,d0
	move.l	d0,(a3)+				; sizeof

	TRACE
	; 17. hardware 2 & Not Hw2Tsr ?
	move.b	Hw(pc),d0				; Check if Harware 1
	subq.b	#1,d0
	ble.s	\_hw1
		; Check if there is HW2,3Patch
		cmp.w	#1000,-2(a5)			; Check if > 1000 entries (AMS 2.0x)
		bcs.s	\_hw1
		FAST_ROM_PTR EX_stoBCD,a5		; Well, the function which follows EX_stoBCD is the protect function
		tst.w	92(a0)				; Check for HW2,3Patch (ROM resident)
		beq.s	\_hw1				; Ok, there is HW2,3Patch
		cmp.l	#$200000,($ac).w		; Check for a TSR executor (RAM resident)
		bls.s	\_hw1				; Ok, there is something (Trap B is intercepted)
			HW2TSR_INSTALL \_hw1,\_error
\_error			moveq	#INSTALL_HW2PATCH_MISSING,d0
			bra	InstallError
\_hw1:

	TRACE
	; 18. Patch EV_hook (on AMS 3.10, this var is > $8000 )
	FAST_ROM_PTR EV_hook,a5
	lea	EV_hook2+2(pc),a1
	move.l	a0,(a1)					; Save EV_hook during kernel calls.
	ifd	RestoreTSR
		move.l	a0,EV_hook3-EV_hook2(a1)
	endif
	move.l	a0,EV_hook4-EV_hook2(a1)

	TRACE
	; 19. Find idle # (Check if AMS update)
	FAST_ROM_PTR idle,a5				; Get idle ptr
	lea	idleN+2(pc),a1				; Patch addr
	move.w	2(a0),(a1)				; get idle number identification and save it.

	TRACE
	; 20. Fix top_estack			(<= SHIFT+ ON)
	ifd	ShiftOn
		FAST_ROM_PTR	top_estack,a5		;  On AMS 3.10, this variable is > $8000
		lea	top_estack1+2(pc),a1
		move.l	a0,(a1)
		move.l	a0,(top_estack2-top_estack1)(a1)
	endif

	TRACE
	; 21: Initial value of contrast
	moveq	#4,d0
	trap	#9					; (Check if AMS Update).
	lea	orgcontrast+3(Pc),a1
	move.b	(a0),d0
	subq.b	#1,d0
	move.b	d0,(a1)+				; Save Contrast Value
	move.w	a0,(a1)					; Save Contrast addr

	TRACE
	; 22: Find the address of the error-frame list 
	FAST_ROM_PTR ER_success,a5			; Get ER_success ptr
	lea	ErrorFrameAdr+2(pc),a1			;(Check if AMS Update).
	move.w	2(a0),d0				; On AMS 3.0x, the variables are stored
	bne.s	\erframeok				; In long format :(
		move.w	4(a0),d0			; So check if it is the long format
\erframeok
	move.w	d0,(a1)					
	move.w	d0,ErrorFrameAdr2-ErrorFrameAdr(a1)
	move.w	d0,ErrorFrameAdr3-ErrorFrameAdr(a1)

	TRACE
	; 23: Find the original address of the user-stack (Check if AMS Update).
	move.w	#$4400,d0				; Org USP value on AMS 1.0x
	cmp.l	#1000,-4(a5)				; Check if > 1000 entries to test AMS 2.0x
	bcs.s	\_ams1
		move.w	#$4200,d0			; Org USP value on AMS 2.0x
\_ams1	lea	StackPtr+2(Pc),a1
	move.w	d0,(a1)					; Patch preos

	TRACE
	; 24. Find 3 secret functions of AMS (Check if AMS Update).
	move.l ($4).w,a1				; Read Org Reset vector

	; The searched code looks like
	; move.l #$DEADDEAD,$4200			; Separation between User Stack and Supervisor Stack
	; clr.l $5D86
	; bsr.s 
	; bsr.s 
	; bsr.s 
	; bsr.s 
	; bsr.s 
	; bsr.s 
	; bsr.s +$36					; The first  function we search
	; move.w #$00,SR
	; jmp tios::EV_CentralDispatcher
\search_dead:
		subq.l	#2,a1
		cmp.l	#$DEADDEAD,(a1)+
		bne.s	\search_dead
	FAST_ROM_PTR EV_centralDispatcher,a5
\search_EV
		subq.l	#2,a1
		cmp.l	(a1)+,a0
		bne.s	\search_EV
	move.l	($8C-$62+2)(a1),a1			; The searched function is in a1
	; Now it looks like on AMS 1.0x & 2.0x:
	;link	a6
	;tst.l	($5D7C).w
	;bne.s 
	;jsr	$					; The 1st : Reset a flag (I don't know what it does exactly!)
	;jsr	$					; The 2nd : Reset PortRestore / SetCurrentClip / ScreenClear(:() / FontSetSys + Some flags
	;jsr	$					; The 3rd : Reset the window list + Some Flags
	; On AMS 3.0x, it looks like:
	;link	a6
	;movem.l d3/a2-a3,-$40(a6)
	;tst.l	($5D7C).l
	;bne.w 
	;jsr	$					; The 1st : Reset a flag (I don't know what it does exactly!)
	;jsr	$					; The 2nd : Reset PortRestore / SetCurrentClip / ScreenClear(:() / FontSetSys + Some flags
	;jsr	$					; The 3rd : Reset the window list + Some Flags
\search_JSR						; Search for the JSR
		cmpi.w	#$4EB9,(a1)+
		bne.s	\search_JSR	
	lea	AMS_HiddenFunc+2(Pc),a0
	move.l	6(a1),(a0)				; Read the 2nd function.
	move.l	6+6(a1),6(a0)				; Read the 3rd function.

	TRACE
	; 25: Set Special values for 89/92p of the kernel (Check if HARDWARE Update).
	move.w	#(LCD_MEM+30*(100-7)),d1		; Value for 89	
	moveq	#%0111111,d2				; Key Mask for ESC
	clr.w	d3					; Key Bit for ESC
	moveq	#0,d0					; Offset for 89
	clr.w	d4					; Step 26 needs d4.w to be calculator
	move.b	Calc(Pc),d4				; Read calculator
	ble.s	\s89
		move.w	#LCD_MEM+30*(128-7),d1		; Value for 92
		move.w	#%1011111111,d2			; Key Mask for ESC
		moveq	#6,d3				; Key Bit for ESC
		moveq	#2,d0				; offset = 2 for 92+ / V200
\s89	
	lea	ExtraRamCalc+3(Pc),a0			; Save offset in extraram access
	move.b	d0,(a0)
	lea	blackline+2(Pc),a0			; Sauve the address of the black line
	move.w	d1,(a0)
	lea	int6msk+2(Pc),a0			; Save ESC mask
	move.w	d2,(a0)
	lea	int6key+2(Pc),a0			; Save ESC bit
	move.w	d3,(a0)

	TRACE
	; 26. Fix calculator offset in Flags (Check if HARDWARE Update).
	; CALCULATOR:	-1	0	1	2	3
	; COMPATFLAGS:	6	1	0	4	5
	addq.b	#1,d4					; 0,1,2,3,4
	move.b	\FromCalculatorToFlags(pc,d4.w),d1	; 6,1,0,4,5
	lea	CalcFlag+2(Pc),a1
	move.w	d1,(a1)

	; 26'. Fix calculator emulator (Check if HARDWARE Update).
	lea	Calc(Pc),a1
	move.l	(a1)+,d0
	move.l	d0,(a1)					; Copy calculator
	addq.b	#2,d4
	lsr.b	#2,d4					; (Calculator+1+2)/4
	move.b	d4,(a1)+				; (-1 / 0) --> 0 (1 / 2 / 3) --> 1
	move.b	#2,(a1)					; Set HW2

	TRACE
	; 27. Org value of timer (Check if HARDWARE Update).
	moveq	#$FFFFFFB2,d1				; Hw1 Value
	move.b	Hw(Pc),d0
	subq.b	#1,d0
	ble.s	\this_hw1
		moveq	#$FFFFFFCC,d1			; Hw2 Value
\this_hw1
	lea	hwtimer+3(Pc),a2			; Save new value
	move.b	d1,(a2)

	TRACE
	; 28.	AMS 1.00: 		Use a5 
	; 	AMS 1.01 --> 2.05:	Use a3
	;	AMS 2.07 --> ....:	Use a2
	lea	AMS207_P1(Pc),a1
	move.w	-2(a5),d0
	cmpi.w	#$2AC,d0
	bne.s	\NotAMS100
		move.w	#$0C15,(a1)			; cmpi.b #$F3,(a5)
		move.w	#$BBFC,AMS207_P2-AMS207_P1(a1)	; cmp.l #$200000,a5
		bra.s	\Not_AMS207
\FromCalculatorToFlags:	dc.b	6,1,0,4,5,0		; Tab for step 26
\NotAMS100
	cmpi.w	#$0607,d0
	blt.s	\Not_AMS207
		move.w	#$0C12,(a1)			; cmpi.b #$F3,(a2)
		move.w	#$B5FC,AMS207_P2-AMS207_P1(a1)	; cmp.l #$200000,a2
\Not_AMS207

	TRACE
	; 29. Patch ROMBASE
	lea	ROMBASE1+2(Pc),a1
	move.l	a4,d0
	or.l	d0,(a1)
	or.l	d0,(ROMBASE2-ROMBASE1)(a1)

	TRACE
	; 30. Patch org interrupts value
	lea	OldTrap4+2(PC),a0
	move.l	($90).w,(a0)
	move.l	($28).w,(OldER_throw-OldTrap4)(a0)
	move.l	($64+5*4).w,(oldint6-OldTrap4)(a0)
	move.l	($80).w,(OldTrap0-OldTrap4)(a0)

	TRACE
	; 31. Alloc memory for kernel
	pea	(KernelEnd-KernelBegin).w
	FAST_ROM_CALL HeapAllocHigh,a5
	move.w	d0,(a7)
	bne.s	\inst
		moveq	#INSTALL_MEMORY_FULL,d0
		bra	InstallError
\inst	
	lea	KHandle+2(pc),a0		; Save Kernel Handle
	move.w	d0,(a0)

	TRACE
	; 32. Compute Kernel Space and Ghost Space
	move.l	($0).w,d0
	lea	$40000,a0			; =$00040000 : GHOST SPACE for 92/92+/V200/89 and Vti
	cmp.l	(a0),d0
	beq.s	\NotTitanium
		lea	$200000,a0		; =$00200000 : GHOST SPACE for Titanium
\NotTitanium
	lea	RAM_TABLE(pc),a3
	move.l	a0,($2D*4)(a3)			; Save Ghost Space
	move.l	(a6),d0				; Compute Kernel space
	andi.l	#~$3FFFF,d0			; ....
	move.l	d0,($2E*4)(a3)			; Save kernel space

	; 32'. Get kernel ptr.
	FAST_ROM_CALL HeapDeref,a5		; Deref the Handle a0
	HW2TSR_PATCH	a0,d0			; Patch it if needed

	TRACE
	; 33. End of RAMCALLS 
	lea	Calc-KernelBegin(a0),a2		; CALCULATOR address
	move.l	a2,(a3)				; Save it
	lea	RetVal-KernelBegin(a0),a2	; RETVAL Address
	move.l	a2,($F*4)(a3)			; Save it
	lea	($15*4)(a3),a1
	lea	FuncRamCall1(pc),a2
	bsr.s	InstallRamcall
	lea	$29*4(a3),a1
	lea	FuncRamCall2(pc),a2
	bsr.s	InstallRamcall
	lea	kernel::SystemDir-KernelBegin(a0),a1
	move.l	a1,($2F*4)(a3)

	TRACE
	; 34. Copy the kernel into a Terminate and stay resident Handle
	move.l	a0,a2
	lea	KernelBegin(pc),a1
	move.w	#(KernelEnd-KernelBegin)/2-1,d0
\copy:		move.w	(a1)+,(a0)+
		dbf	d0,\copy

	TRACE
	; 35. Install Preos Kernel Vector Table
	lea	(InstallVectors-KernelBegin)(a2),a0
	jsr	(a0)

	TRACE
	; 36. Install Trap #4 independently since we don't want to be reinstall it again and again.
Trap4Patch:
	lea	(newTrap4-KernelBegin)(a2),a0
	lea	($90).w,a1
	bsr	InstallVector

	TRACE
	; The KERNEL is installed now!
	moveq	#INSTALL_KERNEL_DONE,d0
InstallError
	move.l	a6,a7
	rts

InstallRamcall:
	move.w	(a2)+,d0
\loop		move.w	(a2)+,d1
		pea	0(a0,d1.w)
		move.l	(a7)+,(a1)+
		dbf	d0,\loop
	rts

RAMCALL_89	dc.l	160,100,$200000,20,338,344,337,340,345,342,$4000,2000,$2000
RAMCALL_92p	dc.l	240,128,$400000,30,337,340,338,344,342,345,$2000,3840,$4000
	
FuncRamCall1
	dc.w	(FuncRamCall1End-FuncRamCall1)/2-2
	dc.w	kernel::idle-KernelBegin,kernel::exec-KernelBegin,kernel::Ptr2Hd-KernelBegin
	dc.w	kernel::Hd2Sym-KernelBegin,kernel::LibsBegin-KernelBegin,kernel::LibsEnd-KernelBegin
	dc.w	kernel::LibsCall-KernelBegin,kernel::LibsPtr-KernelBegin,kernel::LibsExec-KernelBegin
	dc.w	kernel::HdKeep-KernelBegin,kernel::ExtractFromPack-KernelBegin
	dc.w	kernel::ExtractFile-KernelBegin
FuncRamCall1End

FuncRamCall2
	dc.w	(FuncRamCall2End-FuncRamCall2)/2-2
	dc.w	kernel::ExtractFileFromPack-KernelBegin
	dc.w	kernel::exit-KernelBegin,kernel::atexit-KernelBegin
	dc.w	kernel::RegisterVector-KernelBegin
FuncRamCall2End

		dc.b	0,"main"
main_sym_str	dc.b	0
	EVEN
	
