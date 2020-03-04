;
;************************************************************
;************************************************************
;***                                                      ***
;***            GenALib	- Genlib extensions		  ***
;***                                                      ***
;*** 	Copyright 2001 by Pelissier Patrick		  ***
;***                                                      ***
;************************************************************
;************************************************************

genalib@version01	xdef	genalib@version01

; Minimun size we can alloc
GLA_ALLOC_MIN_SIZE	EQU	12

; Const for sort list
GLA_INC_U	EQU	%0010*256	;Not bcs : 0101	<	u
GLA_DEC_U	EQU	%0101*256	;Not bhi : 0010	>	u
GLA_INC_S	EQU	%1110*256	;Not blt : 1101	<	s
GLA_DEC_S	EQU	%1101*256	;Not bgt : 1110	>	s


; Functions
genalib::init		equ	genalib@0000
genalib::alloc		equ	genalib@0001
genalib::free		equ	genalib@0002
genalib::realloc	equ	genalib@0003
genalib::list_sort	equ	genalib@0004
genalib::list_set	equ	genalib@0005

genalib::set_sort_list	equ	genalib::list_set
genalib::sort_list	equ	genalib::list_sort

; Lists
genalib::list_new	macro
	suba.l	\1,\1
			endm

genalib::list_top	macro
	lea	4(\1),\2
			endm

genalib::list_tail	macro
	move.l	(\1),\2
			endm

genalib::list_empty	macro
	move.l	\1,d0
	\2.\0	\3
			endm
			
; list_add list,taille,label_error_list
; taille = #number or dataregister (!= d0)
; list = adress register != a0 
genalib::list_add	macro
	move.l	\2,d0
	addq.l	#4,d0
	jsr	genalib::alloc
	move.l	a0,d0
	beq.\0	\3
	move.l	\1,(a0)
	move.l	a0,\1
			endm
			
genalib::list_del	macro
	move.l	\1,d0
\\@loop:
	tst.l	d0
	beq.s	\\@end
		move.l	d0,a0
		move.l	(a0),d0
		jsr	genalib::free
		bra.s	\\@loop
\\@end
			endm

genalib::list_sub	macro
	move.l	\1,d0
	beq.s	\\@done
		move.l	(\1),a0
		move.l	(a0),d1
		move.l	a0,d0
		beq.s	\\@done
			jsr	genalib::free
			move.l	d1,(\1)
\\@done:
			endm

genalib::list_size	macro
	move.l	\1,a0
	moveq	#0,\2
\\@loop
	move.l	a0,d0
	beq.s	\\@arret
		addq.l	#1,\2
		move.l	(a0),a0
		bra.s	\\@loop
\\@arret
			endm
