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


;****************************************************************************
;* brwselib::MessageBox							    *
;*--------------------------------------------------------------------------*
;* Displays a message box in the middle of the window			    *
;*--------------------------------------------------------------------------*
;* Input:								    *
;*   a4.l = pointer to title						    *
;*   a5.l = pointer to text; may contain line feeds, marked by character '$'*
;*          maximum number of characters per row : 22			    *
;*	    maximum number of rows		 :  4			    *
;****************************************************************************
brwselib::MessageBox		EQU	brwselib@0000

;****************************************************************************
;* brwselib::FullScrWin							    *
;*--------------------------------------------------------------------------*
;* Draws a full-screen window, with a huge-font and inverted title-bar	    *
;*--------------------------------------------------------------------------*
;* Input:								    *
;*   a4.l = pointer to title (maximum: 30 characters)			    *
;****************************************************************************
brwselib::FullScrWin		EQU	brwselib@0001

;****************************************************************************
;* brwselib::ClearInfo							    *
;*--------------------------------------------------------------------------*
;* Clears the Info window						    *
;****************************************************************************
brwselib::ClearInfo		EQU	brwselib@0002

;****************************************************************************
;* brwselib::InfoString							    *
;*--------------------------------------------------------------------------*
;* Draws a string into the Info - window of the Browser (should be used by  *
;* brwselib::Browse's info - callback routine)				    *
;*--------------------------------------------------------------------------*
;* Input:								    *
;*   d0.w = X-coordinate (relative to the Info-window's top,left corner)    *
;*   d1.w = Y-coordinate (relative to the Info-window's top,left corner)    *
;*   d2.w = color (tios::DrawStrXY-like)				    *
;*   a0.l = pointer to string that is drawn				    *
;* Output:								    *
;*   String is drawn.							    *
;****************************************************************************
brwselib::InfoString		EQU	brwselib@0003

;****************************************************************************
;* brwselib::InfoRect							    *
;*--------------------------------------------------------------------------*
;* Draws a rectangle into the Info - window of the Browser (should be used  *
;* by brwselib::Browse's info - callback routine)			    *
;*--------------------------------------------------------------------------*
;* Input:								    *
;*   d0.w = X-coordinate of left, top corner    			    *
;*   d1.w = Y-coordinate of left, top corner 				    *
;*   d2.w = X-coordinate of right, bottom corner    			    *
;*   d3.w = Y-coordinate of right, bottom corner 	                    *
;*   (coordinates are relative to the window's top, left corner, (1|1) is   *
;*   the first point that is within the usable area of the window)	    *
;* Output:								    *
;*   String is drawn.							    *
;****************************************************************************
brwselib::InfoRect		EQU	brwselib@0004

;****************************************************************************
;* brwselib::Browse							    *
;*--------------------------------------------------------------------------*
;* Opens a screen-wide window (with title (a4)), and displays a dialog	    *
;* for choosing a file (similar to FBrowser). The choosen file can either   *
;* be handled after the dialog closed, or while the dialog is working, by   *
;* a callback routine.							    *
;*--------------------------------------------------------------------------*
;* Input:								    *
;*   a0.l = pointer to filter callback routine (may be NULL)		    *
;*           Parameters, the callback routine gets passed:		    *
;*             a0.l = pointer to symbol entry of choosen file		    *
;*             d0.w = handle of choosen file				    *
;*           Values the callback routine may return:			    *
;*	       d4.b != 0: do not add this file to the list of files, the    *
;*			  user can chose from				    *
;*									    *
;*   a1.l = pointer to info callback-routine (for displaying infos on the   *
;*	    files) (may be NULL)					    *
;*           Parameters, the callback routine gets passed:		    *
;*             a0.l = Name of choosen file 			    	    *
;*             d0.w = handle of choosen file				    *
;*          This callback routine may especially use the routines 	    *
;*	    brwselib::ClearInfo, brwselib::InfoString and 		    *
;* 	    brwselib::InfoRect.						    *
;*									    *
;*   a5.l = pointer to routine, that should be called on the file that was  *
;*          choosen							    *
;*	     If it is NULL, Browse will quit, when a file is choosen.	    *
;*           Parameters, the callback routine gets passed:		    *
;*             a0.l = pointer to symbol entry of choosen file		    *
;*             d0.w = handle of choosen file				    *
;*           Values the callback routine may return:			    *
;*	       d4.b != 0: Exit Browse, return d0.w as specified below       *
;*           The routine may NOT modify d0.w, if they are needed   	    *
;*           for further processing, when the browser exited		    *
;*           The routine may modify the content of the screen. After it     *
;*	     returned, the screen will be rebuild by the Browser.	    *
;*									    *
;*   a4.l = pointer to title that is displayed in the title bar		    *
;*									    *
;* Output:								    *
;*   if Browser was quit by ESC:					    *
;*     d0.w = 0								    *
;*   if Browser was quit by ENTER:					    *
;*     d0.w = handle of choosen file (if your callback (a5) didn't	    *
;*	      modified it)						    *
;****************************************************************************
brwselib::Browse		EQU	brwselib@0006

;****************************************************************************
;* Constants for direct Info - window access				    *
;****************************************************************************
INFO_X1 	EQU	54
INFO_Y1 	EQU	13
INFO_X2 	EQU	237
INFO_Y2 	EQU	119
INFO_WIDTH 	EQU	(INFO_X2-INFO_X1)
INFO_HEIGHT 	EQU	(INFO_Y2-INFO_Y1)

;****************************************************************************
;* brwselib::SurfList							    *
;*--------------------------------------------------------------------------*
;* Lets the user 'surf' through a file or folder (or anything else) list in *
;* VAT format. This routine is used by brwselib::Browse for choosing the    *
;* folder, and then the file. I export this routine for the reason, that I  *
;* will perhaps need it sometimes for letting the user choose files from an *
;* (compressed) archive.						    *
;*--------------------------------------------------------------------------*
;* Input:                                                                   *
;*    a2.l = pointer to info callback routine (may be NULL)                 *
;*           Parameters, the callback routine gets passed:                  *
;*             a0.l = pointer to symbol entry of the choosen symbol         *
;*             d0.w = handle of choosen file/folder (or anything else)      *
;*									    *
;*    a3.l = pointer to enter-pressed callback routine (may be NULL)        *
;*           Parameters, the callback routine gets passed:                  *
;*             a0.l = pointer to entry in List of choosen symbol            *
;*             d0.w = handle of choosen file/folder (or anything else)      *
;*           Values the callback routine may return:                        *
;*	       d4.b != 0: exit SurfList, return a0.l/d0.w (as you set them) *
;*                        to the user					    *
;*									    *
;*   Note: if the handle of the file is negative, no callback routine will  *
;*   be called. (this is used for the '..' item within the file list, that  *
;*   lets the user return to the folderlist of brwselib::Browse)            *
;*									    *
;*    a4.l = pointer to window title                                        *
;*    d6.l = pointer to list                                                *
;*    a1/a5.l/d1-d3 may be arguments/data for the callback routines         *
;*									    *
;* Output:                                                                  *
;*    if ENTER pressed                                                      *
;*      d0.w = handle of choosen file (if your callback didn't modify it)   *
;*      a0.l = pointer to VAT entry of file (if your callback routine       *
;*             didn't modify it)                                            *
;*    else (ESC presseed)      						    *
;*      d0.w = 0							    *
;*      a0.l = undefined						    *
;*									    *
;* Registers a1-a5/d1-d3 may be used to pass arguments from/to your         *
;* callback routine. These registers may be modified after SurfList was     *
;* called.								    *
;****************************************************************************
brwselib::SurfList		EQU	brwselib@0005

