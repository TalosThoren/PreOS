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

;************************************************************************
;*  Display								*
;*----------------------------------------------------------------------*
;*  Displays a ugp picture / animation (animation: for one cycle)       *
;*  Parameter:                                                          *
;*  NOTE: if you want to use it for sprites, you shouldn't use slow     *
;*        interleaved and/or compressed pictures.                       *
;*  Input:                                                              *
;*    d0.w = x-position                                                 *
;*    d1.w = y-position                                                 *
;*    d2.w = Delay per Picture (for animations only) in 1/350 seconds	*
;*    a0.l = pointer to ugp-image (mustn't be odd address)              *
;*    a1.l = pointer to most-significant screen plane (e.g. LCD_MEM)    *
;*    a2.l = pointer to plane with the next significance (2 greyplanes) *
;*    a3.l = pointer to least-significant plane (3 greyplanes)          *
;*  Output:                                                             *
;*    d3.b = 0: Ok d3.b != 0: Error                                     *
;*  All other registers are kept.                                       *
;************************************************************************
ugplib::Display		EQU	ugplib@0000

;************************************************************************
;*  AutoDisp								*
;*----------------------------------------------------------------------*
;*  Switches to the right gray-mode, clears the screen, and displays the*
;*  UGP-picture/animation centered. Afterwards it waits for keypress.   *
;*  Animations are played forward, and repeated permanent. If a key is  *
;*  pressed, AutoDisp disables grayscale, and returns.                  *
;*  NOTE:                                                               *
;*    * When an animation is played, a keypress is only checked after   *
;*      each cycle. So: don't panik, if it doesn't return immediately.  *
;*    * When you call ugplib::AutoDisp, grayscale have to be disabled,  *
;*      else your program will die a horrible death.                    *
;*  Input:                                                              *
;*    a0 = pointer to UGP-pic(/ani) (mustn't be odd address)		*
;*    d2.w = (animations only) delaytime per picture in 1/350 seconds   *
;*  Return:                                                             *
;*    d0.b = 0: OK d0.b != 0: Error                                     *
;*  All other registers are kept.                                       *
;************************************************************************
ugplib::AutoDisp	EQU	ugplib@0001

