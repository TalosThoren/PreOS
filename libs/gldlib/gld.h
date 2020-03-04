; Add DEBUG equ 1 or not !
	ifd	DEBUG
_debug	xdef	_debug
TRACE_FUNC MACRO
	jsr	gld@0000
	ENDM
TRACE_NBR MACRO
 	move.l	\1,-(a7)
 	jsr	gld@0001
 	addq.l	#4,a7
 	ENDM
TRACE_STR MACRO
	pea	\1
 	jsr	gld@0002
 	addq.l	#4,a7
	ENDM
	endif
	
	ifnd	DEBUG
TRACE_FUNC	MACRO
	ENDM
TRACE_VAL	MACRO
	ENDM
TRACE_STR	MACRO
	ENDM	
	endif
	
	
