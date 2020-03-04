; UGPLIB - Copyright 1998 David Kuehling
; Adaptation for TI-89/92+ - Copyright 2004, 2005 Patrick Pelissier
;
; This file is part of the UGPLIB Library.
;
; The UGPLIB Library is free software; you can redistribute it and/or modify
; it under the terms of the GNU Lesser General Public License as published by
; the Free Software Foundation; either version 2.1 of the License, or (at your
; option) any later version.
;
; The UGPLIB Library is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
; License for more details.
;
; You should have received a copy of the GNU Lesser General Public License
; along with the MPFR Library; see the file COPYING.LIB.  If not, write to
; the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
; MA 02111-1307, USA.

; ****************************************************************************/
        include tios.h
        include ugplib.h
        include brwselib.h
; ****************************************************************************/

; ****************************************************************************/
        xdef    _main
	xdef	_comment

	xdef	_ti89
	xdef	_ti89ti
	xdef	_ti92plus
	xdef	_v200
; ****************************************************************************/

; *****************************************************************************
;  Callback routine,that shows the chosen file
;  Input:
;    d0.w = handle of file
;  Output:
;    d4.b = Abort browser?
; /
DisplayUGP:	tios::DEREF	d0,a0			// a0 = Pointer to UGP-STR
		addq.l	#6,a0				// skip Var-Size-Word and UGP Signature

\SkipTitleLoop:	tst.b	(a0)+				// skip title
		bne	\SkipTitleLoop
		
	        move.l  a0,d0                    	// get the next even address
	        andi.w  #1,d0
	        add.w	d0,a0

		; ***** Display UGP Picture; *****/
		move.w  (a0)+,d2                 	// d2 = delaytime per picture
	        jsr     ugplib::AutoDisp          	// display picture (a0) with speed d2
 	        tst.b   d0				// if d0 is nonzero: there was an error
		beq.s	\End

		; ***** Failure; *****/
		lea	ErrorStr(PC),a4		// Title of message box is "ERROR"
		lea	FailureStr(PC),a5		// Message is "UGP Display Failure"
		jsr	brwselib::MessageBox

\End:		sf	d4				// do not abort the browser!
		rts

; *****************************************************************************
;  Callback routine,that filters out any files that are not UGP pictures
;  Input:
;    d0.w = handle of file
;  Output:
;    d4.b = Add file to list? (0 = do it; nonzero = don't add it)
; /
FilterUGP:	tios::DEREF	d0,a0			// a0 = Pointer to UGP-STR
	        cmp.l   #$55475000,2(a0)         	// check UGP Signature ("UGP\0")
		sne	d4				// if file doesn't have correct signature: d4.b = -1
		rts

; *****************************************************************************
;  Info callback routine,that shows the title of a UGP picture
;  Input:
;    d0.w = handle of file
; /
InfoUGP:	tios::DEREF	d0,a0			// a0 = Pointer to UGP-STR
		addq.l	#6,a0				// skip Var-Size-Word and UGP signature

		moveq	#2,d0				// get X-coordinate to center the title
		moveq	#2,d1				// Y-coordinate
		moveq	#4,d2				// color
		jsr	brwselib::ClearInfo
		jmp	brwselib::InfoString

; *****************************************************************************
;  MAIN
; /
_main:
		; ***** Execute the Browser; *****/
		lea	FilterUGP(PC),a0		// a0 = address of filter callback routine
		lea	InfoUGP(PC),a1			// a1 = address of info callback routine
		lea	DisplayUGP(PC),a5		// a5 = address of invoke-callback routine
		lea	_comment(PC),a4		// a4 = pointer to title of browser window
		jmp	brwselib::Browse

_comment:	dc.b	"UGP Browser",0


; *****************************************************************************
;   DATA
; /
ErrorStr:	dc.b	"ERROR",0
FailureStr:	dc.b 	"UGP Display Failure",0

; ****************************************************************************/

        END

