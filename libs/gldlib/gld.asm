; PREGLDLIB - Copyright 2001, 2002, 2003, 2004, 2005 Patrick Pelissier
;
; This file is part of the PREGLDLIB Library.
;
; The PREGLDLIB Library is free software; you can redistribute it and/or modify
; it under the terms of the GNU Lesser General Public License as published by
; the Free Software Foundation; either version 2.1 of the License, or (at your
; option) any later version.
;
; The PREGLDLIB Library is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
; License for more details.
;
; You should have received a copy of the GNU Lesser General Public License
; along with the MPFR Library; see the file COPYING.LIB.  If not, write to
; the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
; MA 02111-1307, USA.

	include	tios.h

	xdef	_main
	xdef	_comment

	xdef	_ti89
	xdef	_ti89ti
	xdef	_ti92plus
	xdef	_v200		

	xdef	gld@0000
	xdef	gld@0001
	xdef	gld@0002

; You can set the size of the Dump Table.
; It should a 2^N number : 32, 64, 128, 256, 512, 1024, 2048, ...
TABLE_DUMP_SIZE		EQU	256

; Install the crash handler
; Call it before allocate stack frame !
; In:
;	Call it after your _main entry
install:
	bclr.b	#2,$600001                      ; Unprotect low memory

        move.l  a7,originalsp                   ; Save stack pointer
	
	; Install crash handler
	move.l	#crash_handler,d1		; Install crash handler
	lea	oldint,a0
        moveq	#8,d0
        lea	($8+$4).w,a1
\loop:		move.l  (a1),(a0)+		; Save old handler
		move.l  d1,(a1)+		; Install new one
		addq.l	#6,d1			; Next int
		dbra    d0,\loop
	move.l	($7C).w,(a0)+			; Auto Int 7
	move.l	#crash_handler7,($7C).w

	; Clear Datas
	move.w	#(tableend-index)/2-1,d0
\loop2		clr.w	(a0)+
		dbf	d0,\loop2
	moveq	#$FFFFFFFF,d0
	move.l	d0,-(a0)

	bset.b	#2,$600001			; protect low memory
	rts

uninstall:
	bclr.b	#2,$600001                      ; Unprotect low memory

	lea	($8+4).w,a1                      ; Uninstall crash handler
	lea	oldint,a0
	moveq	#8,d0
\loop:		move.l	(a0)+,(a1)+
		dbra	d0,\loop
	move.l	(a0)+,($7C).w			; Restore AutoInt 7
	bset.b	#2,$600001			; protect low memory

	ILLEGAL					; The only wait to quit properly is to use the kernel protection :)

RomThrow
	move.l	oldint+8*4,-(a7)
	rts
crash_handler7
	pea	AutoInt7Error(pc)
        bra.s   crash_handler_main		; Go to main handler
crash_handler:					; Crash handlers
	pea	AdressError(Pc)			; Store exception number
        bra.s   crash_handler_main		; Go to main handler
        pea	IllegalError(Pc)		; Store exception number
        bra.s   crash_handler_main		; Go to main handler
        pea	ZeroError(Pc)			; Store exception number
        bra.s   crash_handler_main		; Go to main handler
        pea	ChkError(Pc)			; Store exception number
        bra.s   crash_handler_main		; Go to main handler
        pea	TrapVError(Pc)			; Store exception number
        bra.s   crash_handler_main		; Go to main handler
        pea	PrivilegeError(Pc)		; Store exception number
        bra.s   crash_handler_main		; Go to main handler
        pea	TraceError(Pc)			; Store exception number
        bra.s   crash_handler_main		; Go to main handler
        pea	Line1010Error(Pc)		; Store exception number
        bra.s   crash_handler_main		; Go to main handler
	move.l	2(a7),a0			; Addresse du 'crash'
	move.w	(a0),d0				; On recupere l'instruction
	cmp.w	#$F800,d0			; C'est > $F8xx ?
	bge.s	RomThrow			; Faut appeler l'ancien int
	pea	Line1011Error(Pc)		; Store exception number : Pb ROM_CALLS.
crash_handler_main:
	move.l	(a7)+,crash_err			; Get the error

	move.w  #$2700,sr			; Stop interrupts:: GROSSE ERREUR DE CONCEPTION
	
	movem.l a0-a7,-(sp)			; Save registers at crash + 64
	move.l	usp,a0				; Save Usp instead of ssp
	move.l	a0,(7*4)(a7)
	movem.l	d0-d7,-(sp)
	lea	64(a7),a6			; Save SP at crash
						; End of saved state
	jsr	tios::PortRestore        	; Tells tios to draw to LCD_MEM
	move.w	#LCD_MEM,d0
	lsr.w	#3,d0
	move.w	d0,($600010)			; Restore Screen pointer
        clr.w	-(sp)        			; Small font
        jsr	tios::FontSetSys 		; Set font
	addq.l	#2,sp

        lea     LCD_MEM+3840-2*30,a3		; Set Temporary buffer on screen !
	
	bsr.s	DisplayRegisters
	clr.w	d5		; Page 
	clr.w	d3		; Offset +/4
\loop	
	lea	$600000,a1	; Set a1 to I/O 
		; Read ON
		btst	#1,$1a(a1)
		beq	crash_handler_quit
		; Read Keys
		moveq	#-2,d0		; Mask
		move.w	d0,$18(a1)	; mask to read some key
		moveq	#40,d2
\Wait:		dbf	d2,\Wait	; Wait until the hardware answer.
		move.b	$1B(a1),d0	
		; Test keys
		move.w	d5,d1
		btst.l	#UpBit,d0
		bne.s	\no_up
			sub.w	#4*10,d3	
			st.b	d1
\no_up:		btst.l	#DownBit,d0
		bne.s	\no_down
			add.w	#4*10,d3
			st.b	d1
\no_down	btst.l	#LeftBit,d0
		bne.s	\no_left
			subq.w	#1,d5	
\no_left:	btst.l	#RightBit,d0
		bne.s	\no_right
			addq.w	#1,d5
\no_right	andi.w	#3,d5
		; Test if displays
		cmp.w	d1,d5
		beq.s	\loop
		; Jump to the right functions
		move.w	d5,d0
		add.w	d0,d0
		move.w	DisplayTable(Pc,d0.w),d0
		jsr	DisplayTable(Pc,d0.w)
		; Attente
		moveq	#-1,d0
\waiting		dbra	d0,\waiting
		bra.s	\loop
DisplayTable:
	dc.w	DisplayRegisters-DisplayTable
	dc.w	DisplayDump-DisplayTable
	dc.w	DisplayFunc-DisplayTable
	dc.w	DisplayTrace-DisplayTable
	
crash_err	dc.l    0			; Error code
originalsp	dc.l    0			; Original Stack Pointer
reference	dc.l	0

DisplayRegisters:
	clr.w	d3		; Offset +/4
	bsr	Clear_LCD_MEM

        move.l  2(a6),-(a7)
        move.l  crash_err(pc),-(sp)		; Display error#
        pea	(a3)				; Buffer
        bsr	sprintf				; Sp -= 12
	movea.l	a3,a0
        moveq	#1,d0
        moveq	#1,d1
        bsr	Display_string			; Display

	move.l	reference(Pc),a0		; get original Stack pointer
	subq.l	#6,a0				; Skip the jsr gendlib::install
	pea	(a0)				; Display prog start
        move.w  (a6),-(sp)			; SR
        pea     seconderrortext(pc)		; String
        pea     (a3)				; Buffer
        bsr     sprintf				; Sp -= 14
	movea.l	a3,a0
        moveq   #1,d0
        moveq   #6*1,d1
        bsr	Display_string			; Display

        lea	(12+14)(a7),a7

        lea     -64(a6),a4
        moveq   #0,d7                           ;D7 = n
        moveq   #14,d6                          ;D6 = line
\loopshowregs:
		; Create string
		move.l  32(a4),-(sp)                    ; An
		move.w  d7,-(sp)			; n
		move.l  (a4)+,-(sp)                     ; Dn
		move.w  d7,-(sp)			; n
		pea     reglisttext(pc)			; String
		pea     (a3)				; Buffer
		bsr     sprintf
		lea     20(sp),sp			; Correct SP

		; Show string
		move.l	a3,a0
		move.w  d6,d1
		moveq   #1,d0
	        bsr	Display_string			; Display
                
		; Next line for register
		addq.w  #6,d6                           ; Next row
		addq.w  #1,d7				; Next register
		cmp.w   #8,d7
		bne.s   \loopshowregs

        moveq	#100-10,d1				;"Press ON to exit"
        lea     thirderrortext(pc),a0
        bra	Display_string			; Display

DisplayDump:
	clr.w	d3		; Offset +/4
	bsr	Clear_LCD_MEM

	lea	firsterrortext(pc),a0
	moveq	#1,d0
	moveq	#1,d1
	bsr	Display_string
	
        lea     -32(a6),a4
        moveq   #0,d7                           ;D7 = n
        moveq   #14,d6                          ;D6 = line
\loopshowregs:
		; Create string
		move.l  (a4)+,a2		; Adress
		lea     (6*4)(a2),a2
		
		bsr	geta2
		move.l	d0,-(a7)		; 1
		bsr	geta2
		move.l	d0,-(a7)		; 2
		bsr	geta2
		move.l	d0,-(a7)		; 3
		bsr	geta2
		move.l	d0,-(a7)		; 4
		bsr	geta2
		move.l	d0,-(a7)		; 5
		bsr	geta2
		move.l	d0,-(a7)		; 6

		move.w  d7,-(sp)			; n
	        pea     stacktext(pc)
	        pea     (a3)
	        bsr     sprintf
		lea     (6*4+2+2*4)(sp),sp		; Correct SP

		; Show string
		move.l	a3,a0
		move.w  d6,d1
		moveq   #1,d0
	        bsr	Display_string			; Display
                
		; Next line for register
		addq.w  #6,d6                           ; Next row
		addq.w  #1,d7				; Next register
		cmp.w   #8,d7
		bne.s   \loopshowregs

        moveq	#100-10,d1				;"Press ON to exit"
        lea     thirderrortext(pc),a0
        bra	Display_string			; Display

DisplayTrace
	bsr	Clear_LCD_MEM

	lea	nerrortext(pc),a0
	moveq	#1,d0
	moveq	#1,d1
	bsr	Display_string			; 'Func dump'
	lea	index,a4
	move.w	(a4),d4
	add.w	d3,d4				; + Offset
	andi.w	#(TABLE_DUMP_SIZE-1)*4,d4
	moveq	#7,d6				; Y
	moveq	#120/6-1,d7			; Number of func
\loopshowfunc:
		subq.w	#4,d4
		bge.s	\ok
			move.w	#4*(TABLE_DUMP_SIZE-1),d4
\ok:		lea     nbrstr(pc),a1		; Number format
		move.l	2(a4,d4.w),d0
		bge.s	\show
		cmpi.l	#$FFFFFFFF,d0
		beq.s	\stop
		lea	strstr(Pc),a1		; String format
		btst.l	#30,d0
		beq.s	\show
			move.l	d0,a0
			jsr	kernel::Ptr2Symbol
			lea	funcstr(Pc),a1	; Func format
			move.l	a0,d0
			bne.s	\show
				lea	unkstr(Pc),a1
\show:		move.l	d0,-(sp)		; Push Number / str / funcname
	        pea     (a1)			; Push format
	        pea     (a3)
	        bsr     sprintf
		lea     (4*3)(sp),sp		; Correct SP
		move.l	a3,a0
		; Show string
		moveq	#1,d0		; X
		move.w	d6,d1		; Y
		bsr.s	Display_string
		addq.w	#6,d6		; Y++				
		dbf	d7,\loopshowfunc
\stop	moveq	#15*4,d0
	moveq	#1,d1			;"Press ON to exit"
	lea     thirderrortext(pc),a0
	bra	Display_string			; Display

DisplayFunc
	clr.w	d3		; Offset +/4
	bsr	Clear_LCD_MEM

	lea	functext(pc),a0
	moveq	#1,d0
	moveq	#1,d1
	bsr	Display_string			; 'Func dump'

	move.l	USP,a4
	
	move.l	originalsp(Pc),d4
	moveq	#7,d6				; Y
	moveq	#120/6-1,d7			; Number of func

        move.l  2(a6),a0			; Start with this address
	bra.s	\start
\loopshowfunc:
		move.l	(a4)+,d0
		move.l	#$FF800001,d1
		and.l	d0,d1
		bne.s	\next
		move.l	d0,a0
\start		jsr	kernel::Ptr2Symbol
		move.l	a0,d0
		beq.s	\next
		moveq	#1,d0		; X
		move.w	d6,d1		; Y
		bsr	Display_string
		addq.w	#6,d6		; Y++				
		dbf	d7,\loopshowfunc
		bra.s	\stop
\next:		subq.w	#2,a4
		cmp.l	d4,a4
		bls.s	\loopshowfunc
\stop	moveq	#15*4,d0
	moveq	#1,d1			;"Press ON to exit"
	lea     thirderrortext(pc),a0
	bra	Display_string			; Display
	
crash_handler_quit:
        clr.w   (a6)				; SR = 0 (user mode)
	move.l	a6,sp				; Restore stack pointer
	move.l	originalsp(pc),a0
	move.l	a0,usp				; Restore User stack pointer
  	move.l	#uninstall,2(a6)		; New return address
        rte                                     ; Return (to exit code)
      
; Put a string on the screen
; In:
;	a0 -> String
;	d0.w = x
;	d1.w = y
; Out :
;	nothing
; Destroy:
;	nothing
Display_string:
	movem.l	d0-d2/a0-a1,-(a7)
	move.w	#4,-(a7)
	pea	(a0)
	move.w	d1,-(a7)
	move.w	d0,-(a7)
	jsr	tios::DrawStrXY
	lea     10(a7),a7
	movem.l	(a7)+,d0-d2/a0-a1
	rts

; Sprintf
sprintf	jmp	tios::sprintf

; Efface l'ecran LCD_MEM
; In :
;	nothing
; Out :
;	nothing
; Destroy :
;	nothing
Clear_LCD_MEM:
	movem.l	d0/a0,-(a7)
	lea	LCD_MEM,a0
	move.w	#960-1,d0
\loop:		clr.l	(a0)+
		dbf	d0,\loop
	movem.l	(a7)+,d0/a0
	rts

geta2
	move.b	-(a2),d0
	ror.l	#8,d0
	move.b	-(a2),d0
	ror.l	#8,d0
	move.b	-(a2),d0
	ror.l	#8,d0
	move.b	-(a2),d0
	ror.l	#8,d0
	rts	

; Ajoute une entree
; In / Out / Destroy
;	Nothing
gld@0000:
	pea	(a0)
	move.w	d0,-(a7)
	lea	index,a0
	move.w	(a0),d0
	move.l	(4+2)(a7),2(a0,d0.w)
	ori.w	#$C000,2(a0,d0.w)	; Set it as Program Code 
	addq.w	#4,d0
	andi.w	#(TABLE_DUMP_SIZE-1)*4,d0
	move.w	d0,(a0)
	move.w	(a7)+,d0
	move.l	(a7)+,a0
	rts
	
; Ajoute une valeur entiere
; In :
;	Valeur sur 31 bits pushed on the stack
; Out / Destroy
;	Nothing
gld@0001:
	pea	(a0)
	move.w	d1,-(a7)
	lea	index,a0
	move.w	(a0),d1
	move.l	(4+2+4)(a7),2(a0,d1.w)
	andi.w	#$7FFF,2(a0,d1.w)
	addq.w	#4,d1
	andi.w	#(TABLE_DUMP_SIZE-1)*4,d1
	move.w	d1,(a0)
	move.w	(a7)+,d1
	move.l	(a7)+,a0
	rts

; Ajoute une chaine de caractere
; In :
;	a0.l = String
; Out / Destroy
;	Nothing
gld@0002:
	pea	(a1)
	move.w	d0,-(a7)
	lea	index,a1
	move.w	(a1),d0
	move.l	(4+2+4)(a7),2(a1,d0.w)
	ori.w	#$8000,2(a1,d0.w)	; Set it as String Ref
	addq.w	#4,d0
	andi.w	#(TABLE_DUMP_SIZE-1)*4,d0
	move.w	d0,(a1)
	move.w	(a7)+,d0
	move.l	(a7)+,a1
	rts

;char *a0 kernel::Ptr2Symbol(void *a0)
kernel::Ptr2Symbol:
	movem.l	d0-d4/a1,-(a7)

	move.l	a0,d4		; Save Ptr
	jsr	kernel::Ptr2Hd
	tst.w	d0		; Handle found ?
	beq.s	\fail

	move.w	d0,-(a7)
	jsr	tios::HeapDeref	; Get the address of the handle
	addq.l #2,a7

	moveq	#0,d1
	move.w	(a0)+,d1	; Read size
	sub.l	a0,d4		; Get offset
	
	move.l	($4)(a0),d0	; Check 68k signature
	lsr.l	#8,d0
	cmp.l	#'68k',d0
	bne.s	\fail
	btst.b	#4,($11)(a0)	; Check if there is a symbol table
	beq.s	\fail
	lea	-6(a0,d1.l),a0		; Point to zero
\loop		; Read offset
		move.b	1(a0),d1	; Lecture offset : poids fort
		lsl.w	#8,d1
		move.b	2(a0),d1	; Lecture offset : poids faible
		cmpi.w	#$FFFF,d1	; End of symbol table (The first symbol may be skiped ?)
		beq.s	\fail
		; Next offset
		subq.l	#1,a0		; Skip current zero
\zero			tst.b	-(a0)
			bne.s	\zero
		; Fix it if the offset is < $FF
		tst.b	-(a0)		; Is it the zero of an offset ?
		beq.s	\fix
			addq.l	#1,a0	; Do not fix
\fix		cmp.w	d4,d1		; Test si SymbolOffset < Offset
		bhi.s	\loop
\found	addq.l	#3,a0			; Get the string
	bra.s	\ret
\fail	suba.l	a0,a0			; Error
\ret	movem.l	(a7)+,d0-d4/a1
	rts

_main:
	bsr	install
	; Get adress of the string
	move.l	tios::top_estack,a0
	subq.l	#1,a0		; We don't test the string TAG
	clr.w	-(a7)
	move.l	a0,-(a7)
	jsr	tios::SymFindPtr
	addq.l	#6,a7
	; Found ?
	move.l	a0,d0
	beq.s	\no
	; Get handle
	move.w	SYM_ENTRY.hVal(a0),d0
	; Calcul de la reference (=_main entry point du program)
	move.w	d0,d1
	tios::DEREF d1,a0
	moveq	#0,d1
	move.w	(2+$C)(a0),d1
	lea	2(a0,d1.l),a0
	move.l	a0,reference
	; Execution du programme
	jsr	kernel::Exec
\no:	bra	uninstall
	
	EXTRA_RAM_TABLE
	EXTRA_RAM_ADDR	0000,LeftBit,1,4
	EXTRA_RAM_ADDR	0001,RightBit,3,6
	EXTRA_RAM_ADDR	0002,UpBit,0,5
	EXTRA_RAM_ADDR	0003,DownBit,2,7
	
firsterrortext	dc.b	"Memory dump",0
seconderrortext	dc.b    'SR=%04x  _main=%08lX',0
thirderrortext	dc.b    'Press [ON] to exit',0
nerrortext	dc.b	"Trace window",0
functext	dc.b	"Function called",0
reglisttext	dc.b    'D%d=%08lX  A%d=%08lX',0
stacktext	dc.b    '*A%d=%08lX%08lX%08lX%08lX%08lX%08lX',0        
AdressError:	dc.b	"Adress Error at %08lx",0	; 0
IllegalError	dc.b	"Illegal Instr. at %08lx",0	; 1
ZeroError	dc.b	"Division by 0 at %08lx",0	; 2
ChkError	dc.b	"Chk Error at %08lx",0		; 3
TrapVError	dc.b	"Trapv Error at %08lx",0	; 4
PrivilegeError	dc.b	"Privilege violation at %08lx",0	; 5
TraceError	dc.b	"Trace called at %08lx",0	; 6
Line1010Error	dc.b	"Line 1010 at %08lx",0		; 7
Line1011Error	dc.b	"Line 1011 at %08lx",0		; 8
AutoInt7Error	dc.b	"Protected Mem at %08lx",0
nbrstr		dc.b	"NBR : %08lx",0
funcstr		dc.b	"FUNC: %s",0
strstr		dc.b	"STR : %s",0
unkstr		dc.b	"FUNC: Unknow",0
_comment	dc.b	"Gld v0.4 - Crash Analyser",0

	BSS
oldint		ds.l	11
index		dc.w	0
table		ds.l	TABLE_DUMP_SIZE
tableend
	END
	
