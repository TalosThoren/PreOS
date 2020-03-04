	xdef	_library
	xdef	_ti92plus
	xdef	_ti89
	xdef	_ti89ti
	xdef	_v200		; Create V200 program

        include "tios.h"
	include "graphlib.h"

	DEFINE	_version01
	xdef	gray4lib@0000
	xdef	gray4lib@0001
	xdef	gray4lib@0002
	xdef	gray4lib@0003

gray4lib@0000	jsr	graphlib::gray4
		move.l	graphlib::plane1,gray4lib@0002
		move.l	graphlib::plane0,gray4lib@0003
		rts
gray4lib@0001	jmp	graphlib::gray2
gray4lib@0002	dc.l    0
gray4lib@0003	dc.l    0

        end
