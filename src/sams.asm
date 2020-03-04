;*
;* PreOs - Shared Linker - Interface with AMS for Ti-89ti/Ti-89/Ti-92+/V200.
;* Copyright (C) 2004, 2005 Patrick Pelissier
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

MAX_HANDLES     	EQU     2000            ; # of handles to save.
MAX_RAMCALL     	EQU     $30             ; # of RAMCALLS
IS89_0_2		EQU	0
PROGRAM_MAX_ATEXIT_FUNC	EQU	10		; # of atexit functions

	include "include/romcalls.h"
	include "kheader.h"

GET_DATA_PTR	MACRO
	bsr	GetDataPtr
		ENDM
	
KernelBegin:
	include "sld.asm"
	include "svector.asm"
	
; Install One Vector a0 at (a1)
InstallVector:
	bclr.b	#2,$600001				; Unprotect acces to vector table
	move.l	a0,(a1)					; Set vector
	bset.b	#2,$600001				; Protect acces to vector table
	rts
	
; Install Preos Vector Table
InstallVectors:
	movem.l	d0-d3/a0-a3,-(a7)
	bclr.b	#2,$600001				; Unprotect acces to vector table
	; Restore the copies of the auto-ints
	moveq	#7-1,d0					; Restore auto-ints
	lea	($64).w,a1				; Dest
	lea	($E0).w,a0				; Src
\loop_autoint:	move.l  (a0)+,(a1)+			; restore old handler
		dbra    d0,\loop_autoint
	; Restore Crash Handler
	lea     CrashHandler(Pc),a0     		; ReInstall crash handler
        moveq   #7-1,d0                 		; 8 vectors
        lea     ($8+$4).w,a1
\Loop1: 	move.l  a0,(a1)+        		; ReInstall new one
		dbf     d0,\Loop1
	move.l  #PREOS_VERSION,($30).w			; Install Kernel Version
KHandle	move.w	#$1234,($48).w				; Install Kernel Handle
	lea	VectorTable(Pc),a0
	move.l	a0,a1
IVect	moveq	#(VectorTableEnd-VectorTable)/4-1,d0
\Loop2		movea.w	(a0)+,a2			; Dest
		move.w	(a0)+,d1
		lea	0(a1,d1.w),a3
		move.l	a3,(a2)
		dbf	d0,\Loop2
ROMBASE2
	move.l	(ROM_VECTOR+$C8).l,($C8).w 		; Reset RomCalls Table
	bset.b	#2,$600001				; Protect acces to vector table
	movem.l	(a7)+,d0-d3/a0-a3
	rts

VectorTable:	; # Vector | Offset
	dc.w	$28,newLine1010-VectorTable
	dc.w	$2C,newLine1111-VectorTable
	dc.w	$80,newTrap0-VectorTable
	dc.w	$B0,newTrap12-VectorTable
	dc.w	$34,startKernel-VectorTable	
	dc.w	$38,reloc-VectorTable
	dc.w	$3C,reloc2-VectorTable
	dc.w	$40,unreloc-VectorTable
	dc.w	$44,unreloc2-VectorTable
	dc.w	$50,startKernel-VectorTable
	dc.w	$64+5*4,newInt6-VectorTable
VectorTableEnd:
	HW2TSR_EXTRA_VECTORS


; Reset the Hardware ports
ResetPorts:
        move.w  #$4C00/8,$600010        ; Reset screen on HW1
hwtimer move.b  #$B2,$600017            ; Reset Timer
        ; Restore the contrast
orgcontrast     move.b  #$00,($5000).w  ; Restore Org value in Contrast Var 
        ROM_THROW OSContrastUp
        ; Restore the Hardware Protection by calling trap #$b (CAN'T USE function out of range
	; since it is buggy in Trap #$B: it skips the saving vectors function, but it calls the restoring
	; vectors function. So it will crash in an endless loop!
        moveq   #0,d3                   ; Function number 0 (write)
        suba.l  a3,a3                   ; Address out or range
        trap    #$B                     ; Redo Hardware protection.
        rts

; Get the data ref of Preos vars.
GetDataPtr:
	lea	Ref(Pc),a6
	rts

; Start a kernel program.
startKernel:
        move.l  (a7)+,a0                		; Load program address
	bsr	kernel::Ptr2Hd				; Get Handle of program
startHandleKernel:
	move.l	(a7),-(a7)				; Push again the return address (Final check)
        movem.l d3-d7/a2-a6,-(a7)
	move.w	d0,d7					; Save Handle of program to execute.
	bsr	kernel::Hd2Sym				; Get SYM of the program.
	move.l	a0,d0					; Sym not found ?
	beq.s	\NoTwin					; No twin symbol found
	btst.b	#2,SYM_ENTRY.flags(a0)			; Check Twin flag ?
	beq.s	\NoTwin					; No Twin Flag set.
		move.w	SYM_ENTRY.hVal+SYM_ENTRY.sizeof(a0),d7 ; (Twin symbol is always the next symbol! )
		pea	(4).w				; New size of the old SYM_ENTRY.
		move.w	SYM_ENTRY.hVal(a0),-(a7)	; Push old HANDLE
		ROM_THROW HeapUnlock			; Unlock handle
		ROM_THROW HeapRealloc			; Handle wont change and we can not get an error.
		ROM_THROW HeapDeref			; Rederef HANDLE
		move.l	#2*65536+$F8,(a0)		; Fill New file (Void file)
		addq.l	#6,a7				; Fix stack
\NoTwin
	bsr.s	GetDataPtr				; Get Preos data ptr
	bsr	InstallVectors				; Install Preos vectors
	; *** Install "Kernel Programs" Crash Handler. ***
        tst.w   FirstRun-Ref(a6)
        bne.s   already_install
                trap    #12                     	; Go to supervisor mode
                clr.w   Error-Ref(a6)			; Error: init it to 0
		move.w	d7,-(sp)			; Push program Handle
		ROM_THROW HeapDeref
		btst.b	#2,KHEADER_flags+2(a0)		; Check if we have to restore the screen
		sne.b	RestoreScreenCode+1-Ref(a6)
                ; Save the handle tab + some unused space so that an overflow of lcd_mem doesn't crash the calc.
                lea     -30*3-MAX_HANDLES/8(sp),sp      ; Push Table
                move.l  RAM_TABLE+$11*4(Pc),a1          ; a1 = Heap Table
                move.l  (a1),a1
                move.l  sp,a0                           ; A0 = Save table
                move.w  a0,HdTable+2-Ref(a6)		; Save Table (Modify the code).
                move.w  #MAX_HANDLES-1,d2       	; d2 = number of handles we save the state of
                moveq   #%01111111,d1           	; d1 = bit mask
                st.b    d3                      	; All handles are free
\loop                   tst.l   (a1)+           	; this handle is allocated ?
                        beq.s   \noset
                                and.b   d1,d3   	;  -> clear corresponding bit within the info-table
\noset                  ror.b   #1,d1           	; go to next bit
                        bcs.s   \nonext         	; next bit is within the next byte ?
                                move.b  d3,(a0)+
                                st.b    d3      	; Set next Bytes
\nonext                 dbf    d2,\loop        		; loop 2000 times
                ; Save the vector table & ev_hook
                moveq   #64-1,d0                	; # of vectors to save.
                suba.l  a1,a1                  		; NULL ptr
EV_hook2        move.l  ($0).l,-(sp)            	; Save ev_hook
\loop_autoint:          move.l  (a1)+,-(sp)     	; Save old handler
                        dbf    d0,\loop_autoint
                move.l  usp,a0                  	; Save user stack
                pea     (a0)
ErrorFrameAdr2  move.l  ($5400).w,-(sp)         	; Save error frame
                move.w  sp,org_stack-Ref(a6)	        ; save Supervisor Stack Ptr
                move.w  #$0000,sr               	; Back to user mode.
                ; Protection ER_catch
                lea     -60(a7),a7              	; Buffer of 60 bytes for ErrorFrame
                pea     (a7)
                ROM_THROW ER_catch              	; Catch all standard Errors from Ti-Os
                tst.w   d0
                beq.s   \NoError 
                        bsr     GetDataPtr
                        move.w  d0,Error-Ref(a6)        ; Save error message
                        bra.s   _quit
\NoError:
already_install:
        addq.w  #1,FirstRun-Ref(a6)                         	; One more Kernel program.

	; *** Run the program ***
	move.w	d7,d0
	bsr	kernel::exec

	; *** Ininstall Kernel Crash Handler ****
	subq.w  #1,FirstRun-Ref(a6)
        bne     dont_uninstall
_quit:		bsr	GetDataPtr
		st.b	FirstRun-Ref(a6)		; Mode : kernel exit
		trap	#12				; Goes to supervisor mode
		move.w	#$2700,sr			; Stop Auto Ints
		move.w	org_stack-Ref(a6),sp		; restore stack ptr
ErrorFrameAdr3	move.l	(sp)+,($5400).w			; restore error frame
		move.l	(sp)+,a0
		move.l	a0,usp				; restore user stack ptr
		bsr	InstallVectors			; Install Preos vectors (Before Clean Up)
		bsr	kernel::clean_up		; Clean up of all relocated progs
		bsr	reinstall_tios			; Reinstall TiOS (Also Vectors but after)
		moveq	#64-1,d0			; number of vectors to restore.
		bclr.b	#2,$600001			; Unprotect access to vector table
		lea	($100).w,a1			; Final vector in Ghost Space
\loop_autoint:		move.l  (sp)+,-(a1)		; restore old handler
			dbra    d0,\loop_autoint
		bset.b	#2,$600001			; Protect access to vector table
EV_hook4	move.l	(sp)+,($0).l			; restore ev_hook
		move.l	RAM_TABLE+$11*4(Pc),a2		; Restore handle table
		move.l	(a2),a2				; a2 = Heap Table
		move.l	sp,a3				; A3 = save table	
		move.w	#MAX_HANDLES/8-1,d5		; d5 = number of handles
		clr.w	d3				; d3 = handle number = 0
\loop			move.b	(a3)+,d6		; Read Handle Flags
			bne.s	\start_sloop		; Is 8 handles already allocated ?
				addq.w	#8,d3		; Handle Number += 8
				lea	8*4(a2),a2
				bra.s	\next
\start_sloop:		moveq	#8-1,d4			; 8 at a times
\small_loop:			tst.l	(a2)+
				beq.s	\OK
				btst	d4,d6		; Check if Bit is set ? (Handle not allocated before)
				beq.s	\OK		; If bit is clear, then the handle was already allocated
					cmp.w	LibTableHd-Ref(a6),d3
					beq.s	\OK
					move.w	d3,d0
					bsr	kernel::Hd2Sym	; Then see if this handle is in VAT (it is a file or a folder)
					move.l	a0,d0	; Test if Null
					bne.s	\OK
						clr.w	-(a7)		; Check if it is a Home History Handle (I don't think a program should do it, but...)
\HomeLoop						addq.w	#1,(a7)	; From index 1 to Max
							ROM_THROW HS_getFIFONode
							tst.w	d0	; No more index
							beq.s	\Free
							cmp.w	d0,d3
							beq.s	\HomeEnd
							ROM_THROW HS_getAns
							cmp.w	d0,d3
							beq.s	\HomeEnd
							ROM_THROW HS_getEntry
							cmp.w	d0,d3
							beq.s	\HomeEnd
							bra.s	\HomeLoop
\Free						move.w	d3,(a7)		; Free this handle (It may be usefull, but it is very probably that it is a memory leak.
						ROM_THROW HeapFree
\HomeEnd					addq.w	#2,a7
\OK:				addq.w	#1,d3		; increase handle number
				dbf	d4,\small_loop	; increase bit number
\next			dbf	d5,\loop
		lea	MAX_HANDLES/8+30*3+2(sp),sp	; Pop handle tabs + some unused space so that an overflow of lcd_mem doesn't crash the calc
		move.w	#$0000,sr			; User mode / allow auto-ints
		lea	RetVal(Pc),a0			; Get RetVal value
		move.l	(a0),d0				; Check if it is NULL
		beq.s	\noretval
			move.l	40(a7),a0		; No NULL, so check the return address
			cmp.l	#$200000,a0		; is it called from TiOs ?
			bls.s	\noretval		; No, no fix the return addr.
			; AMS 1.0x: $21CB AMS 2.0x: $21EE AMS 3.0x: $23EE
			cmpi.w	#$21EE,(a0)+		; Is-it : movea.w -$40(a6) ? or movea.l a3, ? (AMS 2.0x / AMS 1.0x)
			blt.s	\write			; AMS 1.0x
			addq.l	#2,a0			; Skip -$40(a6)
			beq.s	\write			; AMS 2.0x
			addq.l	#2,a0			; Skip 0.w
\write			movea.w	(a0)+,a1		; Read the ret-val addr.
			move.l	d0,(a1)			; Write its new value.
			move.l	a0,40(a7)		; Fix the return address
			move.l	a0,44(a7)		; Twice to avoid anti-stack-corruptio
\noretval	clr.w	FirstRun-Ref(a6)		; End of kernel crash handler
dont_uninstall:
	move.w	Error-Ref(a6),d0			; Print Errors in the Help Window
	beq.s	\noh		
		lea	Memory(Pc),a0			; Memory error message (code= 670)
		cmpi.w	#ER_MAX_KERNEL,d0		; Error > Max handle (=> AMS error code)
		bge.s	\DoneError			; Yes so it was a memory error
		lea	Message(Pc),a0			; Get the error message string
\LoopError:		subq.w	#1,d0			;
			beq.s	\DoneError		;
\NextError:			tst.b	(a0)+		;
				bne.s	\NextError	;
			bra.s	\LoopError		;
\DoneError	lea	-100(a7),a7			
		move.l	a7,a2	
		pea	LibLastName(pc)
		pea	(a0)
		pea	(a2)
		ROM_THROW sprintf			; Create the string to display
		move.l	a2,(a7)
		ROM_THROW ST_showHelp			; Display it
		lea	(100+4*3)(a7),a7
\noh	clr.w	Error-Ref(a6)				; Clear Error code
	movem.l (a7)+,d3-d7/a2-a6			; 
	move.l	(a7)+,a0				; Pop return address 1
	cmp.l	(a7),a0					; Check if the 2 return address are the same
	bne.s	\CrashHandler				; No => Very bad things happen
	rts						; Else return
\CrashHandler	ROM_THROW 0
	
; ReInstall the traps of the TiOs, and the ports.
; and redraw the current application
reinstall_tios:
	ROM_THROW PortRestore				; Restore standard screen

RestoreScreenCode:
	moveq	#0,d0					; Check if we have to redraw the screen
	bne.s	reinstall_tios_vars			; S.M.C.

	; Ask to the current application to redraw the screen (Properly).
	lea	-60(a7),a7		; Space for window struct
	move.l	a7,a0
	move.w	#$0300,-(a7)		; flags : no bold / no border
	pea	FullScr(Pc)		; Push SCR_RECT
	pea	(a0)			; Push Window
	ROM_THROW WinOpen		; Create the window
	ROM_THROW WinActivate		; Print it
	ROM_THROW WinClose		; And close it 
	lea	(4+4+2+60)(a7),a7	; Pop The args

reinstall_tios_stat:
	pea	MemoryEnd(Pc)
	ROM_THROW ST_showHelp		; Draw something so that ST_eraseHelp works
	ROM_THROW ST_eraseHelp		; Redraw the statut bar
	addq.l	#4,a7
blackline	lea	(LCD_MEM+30*(100-7)).w,a0	
		moveq	#30-1,d0	; Redraw the black line 
\blck_line		st.b	(a0)+
			dbf	d0,\blck_line

reinstall_tios_vars:
	bsr	InstallVectors
	bra	ResetPorts
	
; RamCall Table
RAM_TABLE	ds.l	MAX_RAMCALL	; RAM CALL table

Calc		dc.b	0		; CALCULATOR
Hw		dc.b	0		; HW_VERSION
Hw_disp_version	dc.b	0		; HW_DISPLAY_VERSION
Emulator	dc.b	0		; EMULATOR
		dc.l	0		; Copy of _RAM_CALL_0
		
ExitStackPtr	dc.l	0		; List of exit func
org_stack	dc.w	0		; Org Stack kernel
FirstRun	dc.w	0		; # of 'StartKernel' count
RetVal		dc.l	0		; estack return value
LibLastName:	ds.b	8		; Name of the last searched library
LibsExecList	dc.l	0		; List needed by LibsExec
Ref:
LibTableNum:	dc.w	0		; # of libraries in table
LibTableHd:	dc.w	0		; Handle of LibTable
Error:		dc.w	0		; Error code
LibCacheName:	ds.b	8		; Cache name of the libraries
LibCacheAddr:	dc.l	0		; Cache addr of the library
LibCacheFlags	dc.b	0		; Cache Flags of Library
Trap0FuncCall	dc.b	0		; # of func to call in trap #0
ExecFolderHd	dc.w	0		; Handle of Folder for current program
FullScr		dc.w	0,0,239,127

Message:	dc.b	"Panic",0
errortext	dc.b	"Crash intercepted",0
		dc.b	"Lib %s not found",0
		dc.b	"Wrong Lib %s",0
		dc.b	"Wrong Kernel",0
		dc.b	"Wrong Rom",0
		dc.b	"Corrupted program",0
		dc.b	"%s isn't a kernel lib",0
		dc.b	"Not a program",0
Memory		dc.b	"Out of memory"
MemoryEnd:	dc.b	0

kernel::SystemDir:
system_str	dc.b	"main",0,0,0,0,0		; Buffer of 9 chars
	ifd	ShiftOn
		dc.b	0,0,0,0,0,0,0,"main\stdlib"	; Buffer of 18 chars
ShellSymStr	dc.b	0
	endif
	EVEN
	HW2TSR_EXTRA_CODE
	EVEN
KernelEnd:
