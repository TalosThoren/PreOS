;
; BRWSELIB - Copyright 1998 by David Kühling
; Port to 89/92+ and bug fixes - copyright 2003, 2004, 2005 Patrick Pelissier
;
; This file is part of the BRWSELIB Library.
;
; The BRWSLIB Library is free software; you can redistribute it and/or modify
; it under the terms of the GNU Lesser General Public License as published by
; the Free Software Foundation; either version 2.1 of the License, or (at your
; option) any later version.
;
; The BRWSLIB Library is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
; License for more details.
;
; You should have received a copy of the GNU Lesser General Public License
; along with the MPFR Library; see the file COPYING.LIB.  If not, write to
; the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
; MA 02111-1307, USA.

; This is a Fargo library that contains a file browser (similar to FBrowser)
; and some similar 'menu' routines.

	include tios.h
	include graphlib.h
	DEFINE	_version01

	xdef	_library
	xdef	brwselib@0000
	xdef	brwselib@0001
	xdef	brwselib@0002
	xdef	brwselib@0003
	xdef	brwselib@0004
	xdef	brwselib@0005
	xdef	brwselib@0006

	xdef	_ti89
	xdef	_ti89ti
	xdef	_ti92plus
	xdef	_v200


; maximum number of files that can be displayed
MAXFILES	EQU	128

; Creates code for calling tios::FontSetSYS
; FONT should be one of the following equates,and shouldn't contain '#'
FONTSETSYS	MACRO	; FONT
	move.w	#\1,-(a7)
	jsr	tios::FontSetSys
		ENDM

; Font-Constants
FONT5  EQU 0
FONT8  EQU 1
FONT10 EQU 2

; Color-Constants
WONB EQU 0
BONB EQU 1
GONW EQU 3
BONW EQU 4

; Creates code for calling flib::frame_rect
; We don't use long <= RAM_CALL

FRAMERECT MACRO ; X1,Y1,X2,Y2
	move.w	#\4,-(a7)
	move.w	#\3,-(a7)
	move.w	#\2,-(a7)
	move.w	#\1,-(a7)
	jsr	graphlib::frame_rect
	ENDM

ERASERECT MACRO ;X1,Y1,X2,Y2
	move.w	#\4,-(a7)
	move.w	#\3,-(a7)
	move.w	#\2,-(a7)
	move.w	#\1,-(a7)
	jsr	graphlib::erase_rect
	ENDM

;***************************************************************************/

	EXTRA_RAM_TABLE
	EXTRA_RAM_ADDR	0000,LCD_CENTERX,80,120
	EXTRA_RAM_ADDR	0001,LCD_CENTERY,50,64
	EXTRA_RAM_ADDR	0002,FCBOX_LINES,9,13
	EXTRA_RAM_ADDR	0003,FCBOX_LINES_x_8,9*8,13*8
	EXTRA_RAM_ADDR	0004,LCD_BOX,((50-MBOX_HEIGHT/2)+2)*30+((80-MBOX_WIDTH/2)+2)/8,((64-MBOX_HEIGHT/2)+2)*30+((120-MBOX_WIDTH/2)+2)/8

MBOX_HEIGHT 	EQU 50
MBOX_WIDTH 	EQU (144+4)
MBOX_X1 	EQU (LCD_CENTERX-MBOX_WIDTH/2)
MBOX_Y1 	EQU (LCD_CENTERY-MBOX_HEIGHT/2)
MBOX_X2 	EQU (MBOX_X1+MBOX_WIDTH-1)
MBOX_Y2 	EQU (MBOX_Y1+MBOX_HEIGHT-1)


;**************************************************************************
;  Graphic - constants
FCBOX_X		EQU	3
FCBOX_MARK1	EQU	$1F
FCBOX_MARK2	EQU	$F0
FCBOX_Y 	EQU	14

FDBOX_X1	EQU	55
FDBOX_Y1 	EQU	14
FDBOX_X2 	EQU	LCD_WIDTH-4
FDBOX_Y2 	EQU	LCD_HEIGHT-10
FDBOX_HEIGHT 	EQU	(FDBOX_Y2-FDBOX_Y1)
FDBOX_WIDTH 	EQU	(FDBOX_X2-FDBOX_X1)



;; Checks the keys from (a0),and calls the corresponding routine,that is
;; stored after the key.
;;*
;; Input:
;;   d0: Key
;;   a0: Key,Routine,Key,Routine,...,0,0
;;       `Routine' is relative to it's location (jump (a0)+a0)
;; Output:
;;  ; d0/a0 destroyed
;;  ; routine is called
Switch:
\Loop:	cmp.w	(a0)+,d0
	beq.s	\Found
	tst.w	(a0)+
	bne.s	\Loop
	rts
\Found: move.w	(a0),d0				; call routine
	jmp	0(a0,d0)



;***************************************************************************
; Draws a Message box with,and waits for keypress
;*
; Input:
;   a4.l = pointer to title
;   a5.l = pointer to string that is displayed (may contain linebreaks,
;          that are expressed by character '$')
;          Maximum number of characters per row: 22
;	    Maximum number of rows: 4
; Output:
;   Message box is drawn.
;   d0.w = key
;/
brwselib@0000:
MessageBox:
	movem.l d0-d7/a0-a6,-(a7)
	move.l	a7,a6					; save SP

	ERASERECT MBOX_X1,MBOX_Y1,MBOX_X2,MBOX_Y2	; draw the window
	FONTSETSYS FONT8				; medium font
	FRAMERECT MBOX_X1+1,MBOX_Y1+1,MBOX_X2-1,MBOX_Y2-1

						; draw title
	; void DrawStrXY(WORD x,WORD y,BYTE;string,WORD color)
	move.w	#4,-(a7)
	pea	(a4)
	move.w	#MBOX_Y1+2,-(a7)
	move.w	#LCD_CENTERX+3,d7		; calculate centered-X-coordinate (d7)
\gXLp:	subq.w	#3,d7
	tst.b	(a4)+
	bne.s	\gXLp
	move.w	d7,-(a7)
	jsr	tios::DrawStrXY
						; invert title
	lea	(LCD_MEM).w,a0			; Cannot import 2 RAM_CALL in the same cte :(
	adda.w	#LCD_BOX,a0
	
	moveq	#9-1,d6					; d6 = Y-counter
\IYLp:	moveq	#(MBOX_WIDTH-4)/8-1,d7			; d7 = X-counter
	movea.l	a0,a1
\_IXLp:	not.b	(a1)+
	dbra	d7,\_IXLp
	lea	30(a0),a0				; go to next row
	dbra	d6,\IYLp

						; print text
	move.w	#BONW,-(a7)

	clr.w	d7					; d5 = X-position
	move.w	#MBOX_X1+4,d5				; d6 = centered Y-position
	move.w	#MBOX_Y1+(MBOX_HEIGHT-14)/2+12-4,d6	; d7 = character
	movea.l	a5,a0
\gCYLp:	cmpi.b	#'$',(a0)
	bne.s	\_Cont
	subq.w	#4,d6
\_Cont:	tst.b	(a0)+
	bne.s	\gCYLp


	;*************** Printing loop;***************/
\PrnLp:	move.b	(a5)+,d7
	beq.s	\EOS					; Character == 0: End of string
	cmp.b	#'$',d7				; Character == 10: line feed
	bne.s	\_NoLF
	addq.w	#8,d6					;   -> go to next row
	move.w	#MBOX_X1+4,d5				;   -> go to first column
	bra.s	\PrnLp

\_NoLF:	movem.w	d5-d7,-(a7)				; push character,x,y
	jsr	tios::DrawChar
	addq.l	#6,a7					; remove arguments
	addq.w	#6,d5					; go to next character
	bra.s	\PrnLp
\EOS:	;**********************************************/

	move.l	a6,a7					; restore SP
	movem.l (a7)+,d0-d7/a0-a6
	bra	GetKey


;***************************************************************************
; Draws a full screen window with a title bar
;*
; Input:
;   a4.l = pointer to window title
;/
brwselib@0001
FullScrWin:
	movem.l d0-d7/a0-a6,-(a7)
	move.l	a7,a6					; save SP

	ERASERECT 0,0,LCD_WIDTH,LCD_HEIGHT-7		;jsr graphlib::clr_scr2 erases the statut bar

	FONTSETSYS FONT10				; huge font

	move.w	#BONW,-(a7)				; draw title
	pea	(a4)					;  - push color,string and Y-coordinate
	move.w	#1,-(a7)
	move.w	#LCD_CENTERX+4,d7			;  - calculate center-X-coordinate
\CenLp:		subq.w	#4,d7
		tst.b	(a4)+
		bne.s	\CenLp
	move.w	d7,-(a7)				;  - push X
	jsr	tios::DrawStrXY
	lea	10(a7),a7

	moveq	#90-1,d7				; invert title bar
	lea	LCD_MEM,a5
\InvLp:		not.l	(a5)+
		dbra	d7,\InvLp

	FRAMERECT 0,11,LCD_WIDTH-1,LCD_HEIGHT-7		; draw screen-rectangle

	move.l	a6,a7					; restore SP
	movem.l (a7)+,d0-d7/a0-a6
	rts


;***************************************************************************
; SURFLIST routines
;/

;***************************************************************************
; Clears the Info window
;/
brwselib@0002:
ClearInfo
	ERASERECT FDBOX_X1,FDBOX_Y1,FDBOX_X2,FDBOX_Y2
	addq.l	#8,a7
	rts

;***************************************************************************
; Prints a string with the current font into the Info window at the left
; side.
;*
; Input:
;   d0.w = X-coordinate; relative to the window's left,top corner
;   d1.w = Y-coordinate; relative to the window's left,top corner
;   d2.w = Color (tios::DrawStrXY-like)
;   a0.l = Pointer to the string that is printed
; Output:
;   String is printed
;/
brwselib@0003:
InfoString:
	movem.l	d0-d2/a0-a1,-(a7)
	add.w	#FDBOX_X1-1,d0				; add window's left,top corner to coordinates
	add.w	#FDBOX_Y1-1,d1

	; void DrawStrXY(WORD x,WORD y,BYTE;string,WORD color)
	move.w	d2,-(a7)
	pea	(a0)
	move.w	d1,-(a7)
	move.w	d0,-(a7)
	jsr	tios::DrawStrXY
	lea	10(a7),a7

	movem.l	(a7)+,d0-d2/a0-a1
	rts

;***************************************************************************
; Draws a rectangle into the Info window at the left side.
;*
; Input:
;   d0.w = X-coordinate of left,top corner
;   d1.w = Y-coordinate of left,top corner
;   d2.w = X-coordinate of bottom,right corner
;   d3.w = Y-coordinate of bottom,right corner
;   (coordinates are relative to the top,left corner of the Info-window)
; Output:
;   Rectangle is drawn
;/
brwselib@0004:
InfoRect:
	movem.l	d0-d2/a0-a1,-(a7)
	add.w	#FDBOX_X1-1,d0				; add window's left,top corner to coordinates
	add.w	#FDBOX_Y1-1,d1
	add.w	#FDBOX_X1-1,d2
	add.w	#FDBOX_Y1-1,d3

	; frame_rect(rect r)
	movem.w	d0-d3,-(a7)
	jsr	graphlib::frame_rect
	addq.l	#8,a7

	movem.l	(a7)+,d0-d2/a0-a1
	rts

;*
; (Re)draws the folder list					** SurfList;
;*
; Input:
;   a6.l = pointer to handle list
;   d5.w = number of items in list
;   d6.w = number of first item on screen
; Output:
;   List is drawn
;/
SurfList_Draw:
	movem.l d0-d7/a0-a6,-(a7)
	movea.l	a7,a2					; a2 = Stored SP

	ERASERECT FCBOX_X,FCBOX_Y,FCBOX_X+8*6,FCBOX_Y+FCBOX_LINES_x_8
	FONTSETSYS FONT8				; middle font

	move.w	d6,d0					; a6.l = pointer to first item on screen
	mulu	#12,d0
	adda.l	d0,a6

	lea	ItemNameBuf(PC),a5			; a5 = pointer to Item Name Buffer
	move.w	#FCBOX_LINES-1,d4			; d4 = item counter

	move.w	#BONW,-(a7)				; push arguments for tios::DrawStrXY
	pea	(a5)
	move.l	#(FCBOX_X)*65536+(FCBOX_Y),-(a7)

	;************* Draw the Itemnames;************/
	; d6 = number of item drawn; d5 = total number of items; d4 = item counter
\Loop:	move.l	(a6)+,(a5)				; put Item Name into Buffer
	move.l	(a6)+,4(a5)
	jsr	tios::DrawStrXY				; display Name

	addq.w	#8,2(a7)				; increase Y-coordinate
	addq.w	#4,a6					; a6.l = pointer to next item
	addq.w	#1,d6					; d6 = number of next item

	cmp.w	d6,d5					; until NextNumber != TotalNumber
	dbeq	d4,\Loop
	;**********************************************/

	movea.l	a2,a7					; restore SP
	movem.l (a7)+,d0-d7/a0-a6
	rts

;*
; Draws/removes the marker and calls the info callback 	** SurfList;
; routine,that is pointed by a0
;*
; Input:
;   a2.l = pointer to info callback routine
;   d6.w = number of first item on screen
;   d7.w = number of marked item
;   a6.l = pointer to begin of item list
; Output:
;   Marker is inverted
;/
SurfList_Mark:
	movem.l d0-d7/a0-a6,-(a7)

	sub.w	d6,d7					; d7 = number of marked item (relative)
	mulu	#30*8,d7				; d7 = address of line of Marker (list-relative)
	add.w	#(FCBOX_Y)*30+(FCBOX_X)/8,d7    	; d7 = address of 1st byte of Marker (scr-relative)
	lea	LCD_MEM,a0				; a0 = address of 1st byte of Marker
	adda.w	d7,a0

	moveq	#8-1,d0				; d0 = line-counter
\Loop:	move.b	#FCBOX_MARK1,d1			; d1 = marker - begin - mask
	eor.b	d1,(a0)+

	moveq	#5-1,d2				; d2 = byte-counter
\_Loop:	not.b	(a0)+
	dbra	d2,\_Loop

	move.b  #FCBOX_MARK2,d1  	   	        ; d1 = marker - end - mask
	eor.b	d1,(a0)
	adda.w	#30-6,a0				; to next line
	dbra	d0,\Loop

	movem.l (a7)+,d0-d7/a0-a6
	rts

;*
; Adjust the marker 						** SurfList;
;   (Scroll if necessary,and hold it within the range 0...d5)
;  and calls the Info callback routine
; Input:
;   d7.w = number of marked item
;   d6.w = number of first item on screen
;   d5.w = number of items in list
;   a6.l = pointer to first item in list
; Output:
;   d6.w,d7.w may be modified
;   scrolled list is redrawn
;   marker is rawn
;/
SurfList_AdjustMarker:	; scolls if marker out of screen range
	tst.w	d7					; Marked item < 0 ?
	bge.s	\GE0
	clr.w	d7					; -> Marked item = 0

\GE0:	cmp.w	d5,d7					; Marked item >= Total #items ?
	blt.s	\LTd5
	move.w	d5,d7					; -> Marked item = Total #items-1
	subq.w	#1,d7

\LTd5:	cmp.w	d6,d7					; Marked item < first item on screen ?
	bge.s	\LBok
	move.w	d7,d6					; -> First item on screen = Marked item
	bsr	SurfList_Draw				; -> redraw list

\LBok:  move.w	d6,-(a7)
	add.w	#FCBOX_LINES,d6
	cmp.w	d6,d7					; Marked item >= first item out of screen ?
	blt.s	\UBok
	addq.w	#2,a7					; -> Last item on screen = Marked item
	move.w	d7,d6
	sub.w	#FCBOX_LINES-1,d6
	bsr	SurfList_Draw				; -> redraw list
	bra.s	\Draw

\UBok:  move.w	(a7)+,d6
\Draw:	bsr	SurfList_Mark				; draw marker

	movem.l d0-d7/a0-a6,-(a7)						; call the info-callback routine
	move.l	a2,d0					; a2 == NULL ?
	beq.s	\NoCb					;  -> don't call callback routine
	mulu	#12,d7					; calculate arguments for callback
	lea	0(a6,d7.w),a0
	move.w	10(a0),d0				; handle of item <= 0 ?
	bpl	\DoCb
	bsr	ClearInfo				;  -> clear the info window
	bra	\NoCb					;  -> don't call callback
\DoCb:	jsr	(a2)					; call callback routine
\NoCb:	movem.l (a7)+,d0-d7/a0-a6
	rts

;*								** SurfList;
; Builds the SurfList - window,draws the two rectangles and displays
; file/folder list + marker
; Input:
;    a4.l = pointer to window title
;/
SurfList_BuildScreen
	bsr	FullScrWin				; draw full screen window,title bar

	movem.l d0-d7/a0-a6,-(a7)						; draw the 2 boxes
	move.l	a7,a6					; store SP
	FRAMERECT FCBOX_X-1,FCBOX_Y-1,FCBOX_X+8*6+1,LCD_HEIGHT-9
	FRAMERECT FDBOX_X1-1,FDBOX_Y1-1,FDBOX_X2+1,FDBOX_Y2+1
	move.l	a6,a7					; restore SP
	movem.l (a7)+,d0-d7/a0-a6

	bsr	SurfList_Draw
	bra	SurfList_AdjustMarker

;*
; Key handler							** SurfList;
; Input:
;   d7.w = number of marked item
;   d6.w = number of first item on screen
;   d5.w = number of items in list
;   d4.w = exit flag
;   a3.l = pointer to enter-pressed callback routine
;   a6.l = pointer to first item in list
; possible Output:
;   d4.b = exit flag
;   d0.w = return value,handle of choosen item,#0 if aborted
;   a0.l = pointer to symbol entry of choosen item
;/

SurfList_Kup:			;********* UP;********/
	bsr	SurfList_Mark  				; remove marker
	subq.w	#1,d7					; Marked item --
	bra	SurfList_AdjustMarker			; redraw marker,adjust
SurfList_Kdown:			;******** DOWN;*******/
	bsr	SurfList_Mark  				; remove marker
	addq.w	#1,d7					; Marked item ++
	bra	SurfList_AdjustMarker			; redraw marker,adjust
SurfList_K2nd_up:		;******* 2nd UP;******/
	bsr	SurfList_Mark  				; remove marker
	sub.w	#FCBOX_LINES-1,d7			; Marked item -= #Lines on screen - 1
	bra	SurfList_AdjustMarker			; redraw marker,adjust
SurfList_K2nd_down:		;****** 2nd DOWN;*****/
	bsr	SurfList_Mark  				; remove marker
	add.w	#FCBOX_LINES-1,d7			; Marked item += #Lines on screen - 1
	bra	SurfList_AdjustMarker			; redraw marker,adjust
SurfList_Kenter:		;******** ENTER;******/
	movem.l	d5-d7/a2-a4/a6,-(a7)
	st.b	d4					; default: exit-flag set
	mulu	#12,d7					; calculate return values/callback parameters
	lea	0(a6,d7.w),a0				;   a0.l = pointer to Symbol entry
	move.w	10(a0),d0				;   d0.w = handle of choosen file/folder
	bmi.s	\NoCb					;      handle == -1 ? -> no callback
	move.l	a3,d7					; enter-callback != NULL ?
	beq.s	\NoCb					;
	jsr	(a3)					;   -> call callback routine
 	movem.l	(a7)+,d5-d7/a2-a4/a6
	tst.b	d4					; exit-flag not set ?
	bne.s	\NoBS
	bsr	SurfList_BuildScreen			;   -> rebuild screen contents
\NoBS:	rts
\NoCb:	movem.l	(a7)+,d5-d7/a2-a4/a6
	rts
SurfList_Kesc:			;********* ESC;*******/
	clr.w	d0					; return value: d0.w = 0 (aborted)
	st.b	d4					; set exit flag
	rts
SurfList_Koff:
        trap    #4
        rts
        
;*
; SurfList -- Key - Switch
;/
SurfList_Switch
	dc.w	KEY_UP	
	dc.w	SurfList_Kup-*
	dc.w	KEY_DOWN
	dc.w	SurfList_Kdown-*
	dc.w	KEY_2ND+KEY_UP
	dc.w	SurfList_K2nd_up-*
	dc.w	KEY_2ND+KEY_DOWN
	dc.w	SurfList_K2nd_down-*
	dc.w	13
	dc.w	SurfList_Kenter-*
	dc.w	264
	dc.w	SurfList_Kesc-*
        dc.w    4363
        dc.w    SurfList_Koff-*
        dc.l	0


;*************************************				** SurfList;
; Surfs through a folder/file list
;*
; Input:
;    a2.l = pointer to info callback routine (may be NULL)
;           Parameters,the callback routine gets passed:
;             a0.l = pointer to symbol entry of choosen symbol
;             d0.w = handle of choosen file/folder
;    a3.l = pointer to enter-pressed callback routine (may be NULL)
;           Parameters,the callback routine gets passed:
;             a0.l = pointer to symbol entry of choosen symbol
;             d0.w = handle of choosen file/folder
;           Values the callback routine may return:
;	       d4.b != 0: exit SurfList,return a0.l/d0.w (as you set them) to the user
;	     Note: if the handle of the file is negative,the callback routine
;		   won't be called
;    a4.l = pointer to window title
;    d6.l = pointer to list
;    a1/a5.l/d1-d3 may be arguments/data for the callback routines
; Output:
;    if ENTER pressed
;      d0.w = handle of choosen file (if your callback didn't modify it)
;      a0.l = pointer to VAT entry of file (if your callback routine didn't modify it)
;    else (ESC presseed)
;      d0.w = 0
;      a0.l = undefined
;
; Registers a1/a5/d1-d3 may be used to pass arguments from/to your callback routine.
; These registers may be modified after SurfList was called.
;/
brwselib@0005:
SurfList:
	movem.l d4-d6/a2-a4/a6,-(a7)

	clr.w	d7					; d7 = number of marked item
	clr.w	d6					; d6 = number of first item on screen
	clr.b	d4					; d4 = exit - flag
	addq.l	#2,a6					; d5 = number of items in list
	move.w	(a6)+,d5				;   a6 = pointer to first item in list

	bsr	SurfList_BuildScreen			; Draw window,list etc.

	;********* key processing loop;***************/
\Loop:	bsr	GetKey					; read key
	lea	SurfList_Switch(PC),a0			; switch key
	bsr	Switch
	tst.b	d4					; continue until exit-flag is set
	beq	\Loop
	;**********************************************/

	movem.l (a7)+,d4-d6/a2-a4/a6
	rts

;***************************************************************************
; Browser - routines
;/

;**								** Browse;*
; The user just choose a folder
; Let the user choose a file from it. Do filteriing first,by the callback
; routine that is pointed by d1.
; Input:
;   d0.w = handle of file-list
;  Data passed from Browse:
;   d1.l = pointer to filter callback
;   a1.l = pointer to file-info callback
;   a5.l = pointer to enter-pressed callback
; Output:
;   d4.b = continue surfing (SurfList)?
;  Data passed back to Browse:
;   d2.w = handle of choosen file
;/
DoFolder:
	tios::DEREF	d0,a0				; a0 = pointer to filelist

	; copy filtered files to an extra filelist
	; WORD HeapAllocThrow(LONG size)
	bsr	AllocList

	move.l	a6,a2					; a2 = working pointer to filtered list
	movea.l	d1,a3					; a3 = pinter to filter callback routine

	move.w	(a0)+,(a2)+				; copy header
	move.w	(a0)+,d7				; d7 = number of files in list
	move.w	#1,(a2)+				; number of files in filtered list = 1

	move.w	#'..',(a2)+				; first entry: `..' (to go back to folder list)
	clr.l	(a2)+
	clr.l	(a2)+
	move.w	#-1,(a2)+				; handle of this entry is -1 !! -> the enter-
							; pressed handle won't be called

			;******** filter loop;********/
	subq.w	#1,d7					; d7 = Counter: Number of files in list - 1
	bmi.s	\FilterDone
	moveq	#MAXFILES-1,d5				; d5 = Savety-counter: Maximum number of files-1
\Loop:
	tst.l	d1					; filter callback = NULL ?
	beq.s	\_Copy					;  -> copy,without filtering

	movem.l	d0-d3/d5-d7/a0-a6,-(a7)
	move.w	tios::SYM_ENTRY.hVal(a0),d0		; argument for filter callback routine
	jsr	(a3)					; call callback
	movem.l	(a7)+,d0-d3/d5-d7/a0-a6		; d4 = do not add file?

	tst.b	d4					; filter callback told me: file is OK ?
	bne	\_Skp
\_Copy:	
	move.l	SYM_ENTRY.name(a0),(a2)+		;  -> copy file-entry
	move.l	SYM_ENTRY.name+4(a0),(a2)+		;  -> copy file-entry
	clr.w	(a2)+
	move.w	SYM_ENTRY.hVal(a0),(a2)+
	addq.w	#1,2(a6)				;  -> increase number of files in list
	subq.w	#1,d5					;  -> decrease savety-counter
	beq.s	\FilterDone				;  -> if it is zero: exit loop
\_Skp:	lea	SYM_ENTRY.sizeof(a0),a0		; Skip: to next entry

\LpChk:	dbra	d7,\Loop

\FilterDone:		;******************************/

					; Let the user choose a file
	move.l	a1,a2					; info callback = a1
	move.l	a5,a3					; enter-pressed callback = a5
	movem.l	d1-d3/a1/a5,-(a7)
	bsr	SurfList
	movem.l	(a7)+,d1-d3/a1/a5

	clr.w	d4					; exit-flag = don't exit
	cmp.w	#-1,d0					; if handle of choosen file != -1
	beq	\NoEx
	st	d4					;  -> exit flag = exit!
	move.w	d0,d2					;  -> save d0 in d2
\NoEx:
	movem.l d0-d2/a0-a1,-(a7)					; free the filelist (handle is still in d6)
	move.w	d6,-(a7)
	jsr	tios::HeapFree
	addq.l	#2,a7
	movem.l (a7)+,d0-d2/a0-a1
	rts

;**								** Browse;*
; Display an info on the chosen folder (display the files,it contains,
; and filter them,by the callback routine,that is pointed by d1)
; Input:
;   d0.w = handle of folder (file list)
;/
FolderInfo:
	bsr	ClearInfo				; Clear the Info window

	tios::DEREF	d0,a1				; a1 = pointer to folder's contents
	movea.l	d1,a2					; a2 = pointer to filter callback routine
	addq.l	#2,a1
	move.w	(a1)+,d7				; d7 = number of files in folder

	moveq	#60,d0					; arguments for InfoRect
	moveq	#0,d1
	move.w	#LCD_HEIGHT-7,d2
	move.w	#FDBOX_HEIGHT+2,d3
	bsr	InfoRect

	moveq	#4,d0					; arguments for InfoString
	moveq	#1,d1
	moveq	#4,d2
	lea	ItemNameBuf(PC),a0

	move.l	#'..'*65536,(a0)			; display '..' as the first file
	bsr	InfoString
	addq.w	#8,d1

	subq.w	#1,d7					; Number of files in folder == 0 ?
	bmi.s	\Exit					;  -> Exit

	;************ File-display-loop;**************/
\Loop:	tst.w	KEY_PRESSED_FLAG			; keypressed ?
	bne.s	\Exit					;  -> Exit
        move.l	a2,d6					; if callback == NULL ?
	beq.s	\_Disp					;  -> Display file,no filtering
	movem.l	d0-d3/d5-d7/a0-a6,-(a7)
	move.w	tios::SYM_ENTRY.hVal(a1),d0		; arguments for callback...
	jsr	(a2)
	movem.l	(a7)+,d0-d3/d5-d7/a0-a6

	tst.b	d4					; d4 == true ?
	bne.s	\_Skp					;  -> Skip this file

\_Disp:	move.l	SYM_ENTRY.name(a1),(a0)		; copy filename to buffer
	move.l	SYM_ENTRY.name+4(a1),4(a0)
	bsr	InfoString				; Display file
	addq.w	#8,d1					; to next row...
	cmpi.w	#FDBOX_HEIGHT-7,d1			; out of the window?
	ble.s	\_VOK
	add.w	#6*8+12,d0				;   -> to next column
	moveq	#1,d1					;   -> row = 1
	cmpi.w	#FDBOX_WIDTH-6*8,d0			;   -> out of the window ?
	bgt.s	\Exit					;      -> exit

\_VOK:	
\_Skp:	lea	SYM_ENTRY.sizeof(a1),a1		; Skip: to next entry
\LpChk:	dbra	d7,\Loop
	;**********************************************/

\Exit:	rts

;*********************************************			** Browse;
; Let's the user chose a file
;*
; Input:
;   a0.l = pointer to filter callback routine (may be NULL)
;           Parameters,the callback routine gets passed:
;             a0.l = pointer to symbol entry of choosen file
;             d0.w = handle of choosen file
;           Values the callback routine may return:
;	       d4.b != 0: do not add this file to the list of files,the user
;			  can chose from
;   a1.l = pointer to info callback-routine (for displaying infos on the files)
;	    (may be NULL)
;           Parameters,the callback routine gets passed:
;             a0.l = pointer to symbol entry of choosen file
;             d0.w = handle of choosen file
;   a5.l = pointer to routine,that should be called on the file that was
;          choosen
;	     If it is NULL,Browse will quit,when a file is choosen.
;           Parameters,the callback routine gets passed:
;             a0.l = pointer to symbol entry of choosen file
;             d0.w = handle of choosen file
;           Values the callback routine may return:
;	       d4.b != 0: Exit Browse,return d0.w as specified below
;   a4.l = pointer to title that is displayed in the status bar
; Output:
;   if Browser was quit by ESC:
;     d0.w = 0
;   if Browser was quit by ENTER:
;     d0.w = handle of choosen file
;/
brwselib@0006:
Browse:
	movem.l	d1-d7/a0-a6,-(a7)
					; Let the user choose a folder
	move.l	a0,d1			; save a0 (filter callback) in d1
	
	; copy Folders to an extra filelist
	bsr	AllocList
	move.l	a6,a0			; a0 = Destination
	move.w	#tios::FolderListHandle,d0
	bsr	Deref_d0_a6		; a6 = source

	pea	(a0)
	move.w	(a6)+,(a0)+				; copy header
	move.w	(a6)+,d7				; d7 = number of files in list
	move.w	d7,(a0)+				; number of files in filtered list

	subq.w	#1,d7					; d7 = Counter: Number of files in list - 1
	moveq	#MAXFILES-1,d5				; d5 = Savety-counter: Maximum number of files-1
\Loop:		move.l	SYM_ENTRY.name(a6),(a0)+	;  -> copy file-entry
		move.l	SYM_ENTRY.name+4(a6),(a0)+	;  -> copy file-entry
		clr.w	(a0)+
		move.w	SYM_ENTRY.hVal(a6),(a0)+
		subq.w	#1,d5				;  -> decrease savety-counter
		beq.s	\Done				;  -> if it is zero: exit loop
		lea	SYM_ENTRY.sizeof(a6),a6	; Skip: to next entry
		dbra	d7,\Loop
\Done:
	move.l	(a7)+,a6

	lea	FolderInfo(PC),a2			; info callback
	lea	DoFolder(PC),a3			; enter-pressed callback
	bsr	SurfList
	
	tst.w	d0					; if browser not quit by ESC:
	beq	\NoRst
	move.w	d2,d0					; d0 = handle of choosen file (from DoFolder)

\NoRst:	movem.l	(a7)+,d1-d7/a0-a6
	rts

Deref_d0_a6
	tios::DEREF	d0,a6
	rts
	
AllocList
	; WORD HeapAllocThrow(LONG size)
	movem.l d0-d2/a0-a1,-(a7)				; allocate memory for the list
	pea	(12*MAXFILES).w
	jsr	tios::HeapAllocHighThrow
	addq.l	#4,a7
	move.w	d0,d6					; d6 = handle of filelist
	bsr.s	Deref_d0_a6
	movem.l (a7)+,d0-d2/a0-a1
	rts

GetKey:
	movem.l	d1-d2/a0-a1,-(a7)
	jsr	tios::ngetchx
	movem.l	(a7)+,d1-d2/a0-a1
	rts
	
;***************************************************************************
; DATA
;***************************************************************************/

ItemNameBuf:	dc.b 	"        ",0			; Buffer for Item Names

	END
