
	include "tios.h"
	include "ziplib.h"

	xdef	_library
	xdef    _ti89
	xdef    _ti92plus
	xdef	_ti89ti
	xdef	_v200		; Create V200 program
	DEFINE	_version01
	
	xdef	hufflib@0000	;extract
	xdef	hufflib@0001	;extract_string
	xdef	hufflib@0002	;write_string
	xdef	hufflib@0003	;write_string_inv
	xdef	hufflib@0004	;chec_mem

;*****************************************************

hufflib@0000:
extract:
	jmp ziplib::extract

;*****************************************************

hufflib@0001:
extract_string:
	jmp ziplib::extract_string

;*****************************************************

hufflib@0002:
write_string:
	jmp ziplib::write_string

;*****************************************************

hufflib@0003:
	jmp ziplib::write_string_inv

;*****************************************************

hufflib@0004:
check_mem:
	jmp ziplib::check_emem

	end
