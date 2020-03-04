;*
;* PreOs - UnIntstaller - for Ti-89ti/Ti-89/Ti-92+/V200.
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

Uninstall:
	moveq	#NO_PREOS_INSTALLED,d0				; Error message
	tst.w	($30).w						; Check if preos
	beq.s	\CantUninstall					; has been installed
	cmp.w	#'PO',($32).w			
	bne.s	\CantUninstall

	move.w	#$0700,d0					; Stop auto ints
	trap	#1
	
	move.w	($48).w,-(a7)					; Push the Kernel Handle

	; Get trap #$B vector
	move.l	#'2Tsr',d3
	move.l	($ac).w,a2
	move.l	a2,a3
	cmp.l	-8(a2),d3
	bne.s	\skip1
\loopHw2tsr
		cmp.l	(a3),d3
		beq.s	\foundtrap4
		addq.l	#2,a3
		bra.s	\loopHw2tsr
\foundtrap4
	addq.l	#8,a3
\skip1
			
	; Restore the vector table (exept the traps) !
	move.l	($04).w,d0					; Read Reset Vector
	andi.l	#$00F00000,d0					; Clean it
	add.l	#ROM_VECTOR,d0					; Get org vectors
	move.l	d0,a0						; Src
	suba.l	a1,a1						; Dest
	bclr.b	#2,$600001					; Unprotect access to vector table
	
	moveq	#64,d0
\loop		move.l	(a0)+,(a1)+
		dbf	d0,\loop
	
	; Restore HW2TSR vectors.
	cmp.l	-8(a2),d3
	bne.s	\skip2
		move.l	a2,($ac).w
		move.l	a3,($90).w
\skip2
		
	bset.b	#2,$600001					; Protect access to vector table

	; Free the handle
	FAST_ROM_CALL HeapFree,a5				; Free memory
	addq.l	#2,a7

	clr.w	d0
	trap	#1						; Restore auto-ints

	moveq	#UNINSTALL_DONE,d0
\CantUninstall
	rts
	