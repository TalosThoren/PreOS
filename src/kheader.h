; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;				Kernel Header V4
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	ifnd	KHEADER_size
	
KHEADER_org	EQU	$0000   
KHEADER_signa	EQU	$0004   
KHEADER_format	EQU	$0008
KHEADER_reloc	EQU	$0009
KHEADER_comment	EQU	$000A
KHEADER_main	EQU	$000C
KHEADER_exit	EQU	$000E
KHEADER_version	EQU	$0010
KHEADER_flags	EQU	$0011
KHEADER_hdBss	EQU	$0012
KHEADER_impOff	EQU	$0014
KHEADER_expOff	EQU	$0016
KHEADER_extROff	EQU	$0018
KHEADER_size	EQU	$001A
	
	endif
	
