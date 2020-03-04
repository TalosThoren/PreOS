	xdef	_library
	xdef	_ti92plus
	xdef	_ti89
	xdef	_ti89ti
	xdef	_v200		; Create V200 program

	include	"tios.h"
	include	"graphlib.h"

	DEFINE	_version01
	xdef	gray7lib@0000
	xdef	gray7lib@0001
	xdef	gray7lib@0002
	xdef	gray7lib@0003
	xdef	gray7lib@0004

gray7lib@0000	jsr	graphlib::gray7
		move.l graphlib::plane0,gplane2
		move.l graphlib::plane1,gplane0
		move.l graphlib::plane2,gplane1
		rts
gray7lib@0001	jmp	graphlib::gray2
gray7lib@0002:
gplane0		dc.l	0
gray7lib@0003:
gplane1		dc.l    0
gray7lib@0004:
gplane2		dc.l    0
        end
