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

;--------------------------------------------------------------------------;
;                        Sample for my UGPLIB/UGPCONV                      ;
;                ----------- by David KÅhling 1998 ----------              ;
;                                                                          ;
; This programm displays a 32 picture animation of a rotating cube, that   ;
; was originally created with POVRAY by Felix KÅhling.                     ;
;                                                                          ;
; Picture format:                                                          ;
;   160x120                                                                ;
;   1 plane, (only black&white)                                            ;
;   dithering 3 (huge pattern),                                            ;
;   compressed,                                                            ;
;   xor  (because the background behind the cube allways stays the same)   ;
;                                                                          ;
;--------------------------------------------------------------------------;

        include "ugplib.h"

        XDEF _main
        XDEF _comment

_main:
        lea     Animation(PC),a0
        moveq.w #0,d2
        jsr     ugplib::AutoDisp
        rts

_comment:
        dc.b    "UGPLIB sample 'cube' by D.K."

        dc.w    0  ;align ugp file on even address

Animation:
        INCBIN "cube1.ugp"


        END
