	include	"tios.h"
	include	"graphlib.h"

	xdef	_library
        xdef    _ti92plus
        xdef    _ti89
        xdef	_ti89ti
	xdef	_v200		; Create V200 program
	xdef	linelib@0000
	DEFINE	_version01

linelib@0000	jmp	graphlib::line
	end
