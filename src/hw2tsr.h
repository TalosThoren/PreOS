;*
;* PreOs - HW2 TSR macros
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


	ifnd	__HW2TSR_MACROS__

__HW2TSR_MACROS__	set	1

HW2TSR_PATCH	MACRO				; An register / Dn register
	add.l	RAM_TABLE+$2E*4(pc),\1
		ENDM
HW2TSR_INSTALL	MACRO
	bsr	h220xTSR_internal		; Call the h220xTSR function
	tst.l	d0				; Check if the return value is h220xTSR_FAILED
	beq.s	\2 				; if it is not, skip, else proceed to the error message
	ori.l	#$00040000,(a6)			; Patch return address (2)
	bra.s	\1
		ENDM
HW2TSR_EXTRA_CODE	MACRO	
			ENDM
HW2TSR_EXTRA_VECTORS	MACRO
			ENDM
	endif
	