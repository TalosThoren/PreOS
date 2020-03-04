; 2004-02-14 Kevin Kofler: Don't use the ghost space. Use tios.h, not tios.h.
; 2004-04-07 Kevin Kofler: Put grayscale interrupt into always-exec-zone. Added
;                          VTI hack equivalent of Thomas' ALWAYS_HW2_TESTING.
; 2004-04-14 Kevin Kofler: Fixed $464 typo. Fixed "tells tios..." comment.
; 2004-06-05 Kevin Kofler: Don't clear or copy non-visible parts of the screen.
; 2004-06-21 Kevin Kofler: Don't put grayscale interrupt into always-exec-zone
;                          when compiling for Iceberg.
; 2004-09-07 Kevin Kofler: Merged fixes from PreOs 0.70.
;                          The Iceberg graphlib is no longer Titanium-specific.
;                          Bugfix: graphlib::gray7 allocated 3840 bytes too many.
;                          No longer forcing absolute addressing in the
;                          grayscale interrupt except for TitaniK.
; 2004-09-14 Kevin Kofler: Set PreOs 0.70 Titanium flag (#6).
;                          Actually enabling all calculators.
;                          Fixed 2004-09-07 \largescr test (ble->bgt).
; 2004-01-10 PpHd:	   Restore tios :p
;			   Simplify the code (Titanik version should be bigger, but
;			   Titanik's graphlib becomes compatible all HW/AMS - Not really true).
; 2004-11-24 PpHd:	   Fixed CALCULATOR tests (tst.w->tst.w).
;                          Fixed planes being only 3000 bytes each on the 89.

	include "tios.h"	; Standard Include file

	xdef	_library	; Define a library

	xdef	_ti89		; Create Ti-89 program
	xdef	_ti92plus	; Create Ti-92+ program
	xdef	_v200		; Create V200 program
	xdef	_ti89ti		; Create Ti-89 Titanium program

	xdef	_exit		; there is an exit point
	DEFINE	_version03	; Define version 03

;Define this if you want to debug graphlib:
;VTI EQU 1

;Define this if you want to compile for TitaniK (default: compile for Iceberg/PreOS):
;TitaniK EQU 1

	xdef graphlib@0000	;fill		;OK
	xdef graphlib@0001	;put_sprite	;OK
	xdef graphlib@0002	;smallbox	;OK
	xdef graphlib@0003	;box		;OK
	xdef graphlib@0004	;frame		;OK
	xdef graphlib@0005	;clr_scr	;OK
	xdef graphlib@0006	;vert		;OK
	xdef graphlib@0007	;horiz		;OK
	xdef graphlib@0008	;bigbox		;OK
	xdef graphlib@0009	;scrtomem	;OK
	xdef graphlib@000A	;memtoscr	;OK
	xdef graphlib@000B	;put_sprite_mask ;OK
	xdef graphlib@000C	;put_sprite2	;ÔK
	xdef graphlib@000D	;choosescreen	;OK
	xdef graphlib@000E	;gray2		;OK 
	xdef graphlib@000F	;gray4		;OK
	xdef graphlib@0010	;gray7		;OK
	xdef graphlib@0011	;plane0		;OK
	xdef graphlib@0012	;plane1		;OK
	xdef graphlib@0013	;plane2		;OK
	xdef graphlib@0014	;clr_scr2	;OK
	xdef graphlib@0015	;show_dialog	;
	xdef graphlib@0016	;clear_dialog	;
	xdef graphlib@0017	;line		;OK
	xdef graphlib@0018	;erase_rect	;
	xdef graphlib@0019	;frame_rect	;
	xdef graphlib@001A	;getlength	;

; Screen size
	ifd TitaniK
LCD_SIZE_div_4_minus_1 	equ 	3000/4-1
LCD_SIZE_div_3 		equ 	1000
LCD_SIZE_mul_2_div_3 	equ 	1000*2
	endc

	ifnd TitaniK
LCD_SIZE_div_4_minus_1	equ 	_extraramaddr@0000
LCD_SIZE_div_3		equ 	_extraramaddr@0001
LCD_SIZE_mul_2_div_3	equ 	_extraramaddr@0002
	xdef _extraram
_extraram:
	dc.w 3000/4-1,3840/4-1
	dc.w 1000,1280
	dc.w 1000*2,1280*2
	endc

GET_SCREEN_PTR	MACRO
	move.w	choosescreen(pc),\1
	bne.s	\\@no
		move.w	handle(pc),\1		; Fix a bug in SMQ
		beq.s	\\@LCD_MEM
			move.l	plane0(pc),a1
			bra.s	\\@done
\\@LCD_MEM:	lea	(LCD_MEM).w,a1
		bra.s	\\@done
\\@no	move.l	a1,\1		; FlashZ programs give an odd address for the screen :(
	btst.l	#0,\1		; Fix it :(
	beq.s	\\@done
		addq.w	#8,d0	; X+=8
		\2
		subq.l	#1,a1	; A1 EVEN
\\@done
		ENDM


FROM_COORD_TO_PTR	MACRO
	add.w	d1,d1
	move.w	d1,d2
	lsl.w	#4,d1
	sub.w	d2,d1		; d1 x 30
	moveq	#15,d2
	and.w	d0,d2
	asr.w	#4,d0
	add.w	d0,d0		; d0 / 16 *2
	add.w	d0,d1		; d1 = 30 * y + 2*x/16
	adda.w	d1,a1		; Scr Ptr
		ENDM
		
graphlib@0001:
	movem.l d0-d2/d5-d7/a0-a4,-(a7)

	move.w	(a0)+,d6
	move.w	(a0)+,d7
	move.w	d7,d5
	mulu.w	d6,d5
	lea	0(a0,d5.w),a2
	bra.s	PutSpr2


graphlib@000C
;   Puts the sprite pointed to by a0 on the screen 
;  at (d0,d1). The adress of the mask is a2
; Input:d0.w = x
;	d1.w = y
;	a0.l = adress of the sprite
;	a2.l = adress of the mask
;	Sprite format is:
; sprite:	dc.w	5 	;-> height of the sprite
;		dc.w	1	;width in bytes
;		dc.b	%11111000
;	(...)
;
; mask:		dc.b	%11111000
;	(...)
; Output: nothing
;	NO REGISTERS DESTROYED
;--------------------------------------------------------------
	movem.l d0-d2/d5-d7/a0-a4,-(a7)
	move.w (a0)+,d6	;hauteur en pixels
	move.w (a0)+,d7	;largeur en octets
PutSpr2:
	subq.w	#1,d6
	subq.w	#1,d7

	GET_SCREEN_PTR d2,<>
	FROM_COORD_TO_PTR
	
	lea	\loopxw(Pc),a4
	moveq	#8,d1
	cmp.w	d1,d2
	ble.s	\okw
		subq.w	#8,d2
		lea	\loopxl(Pc),a4
\okw:	sub.w	d2,d1

\loopy:
		move.l	a1,a3
		move.w	d7,d5
		jmp	(a4)
\loopxw
			moveq	#0,d0
			move.b	(a2)+,d0
			lsl.w	d1,d0
			not.w	d0
			and.w	d0,(a3)

			moveq	#0,d0
			move.b	(a0)+,d0
			lsl.w	d1,d0
			or.w	d0,(a3)

			dbf	d5,\loopxl
		lea	30(a1),a1
		dbf	d6,\loopy
	movem.l (a7)+,d0-d2/d5-d7/a0-a4
	rts
\loopxl
			moveq	#0,d0
			move.b	(a2)+,d0
			swap	d0
			lsr.l	d2,d0
			not.l	d0
			and.l	d0,(a3)

			moveq	#0,d0
			move.b	(a0)+,d0
			swap	d0
			lsr.l	d2,d0
			or.l	d0,(a3)

			addq.l	#2,a3
			dbf	d5,\loopxw
		lea	30(a1),a1
		dbf	d6,\loopy
	movem.l (a7)+,d0-d2/d5-d7/a0-a4
	rts


graphlib@000B
;	Does the same as put_sprite, but you don't have to create
;	a mask sprite after the sprite itself
;	Instead, you have to define a 'constant mask'
;	For example %00000000 as a constant mask will make all
;	zeroes of you sprite being transparent
;Input:	d0.w = x
;	d1.w = y
;	d3.b = constant mask
;	a0.l = adress of the sprite & the mask
;	Sprite format is:
; sprite:	dc.w	5 	;-> height of the sprite
;		dc.w	1	;width in bytes
;		dc.b	%11111000
	movem.l d0-d7/a0-a3,-(a7)
	move.w (a0)+,d6	;hauteur en pixels
	move.w (a0)+,d7	;largeur en octets
	subq.w	#1,d6
	subq.w	#1,d7

	GET_SCREEN_PTR d2,<>
	FROM_COORD_TO_PTR

	lea	\loopxw(Pc),a2
	moveq	#8,d1
	cmp.w	d1,d2
	ble.s	\okw
		subq.w	#8,d2
		lea	\loopxl(Pc),a2
\okw:	sub.w	d2,d1

	; PreCalculs masques
	moveq	#0,d4
	move.b	d3,d4
	lsl.w	d1,d4
	not.w	d4
	moveq	#0,d0
	move.b	d3,d0
	swap	d0
	lsr.l	d2,d0
	not.l	d0
	move.l	d0,d3
	
\loopy:
		move.l	a1,a3
		move.w	d7,d5
		jmp	(a2)
\loopxw
			moveq	#0,d0
			move.b	(a0)+,d0
			lsl.w	d1,d0
			and.w	d4,(a3)
			or.w	d0,(a3)
			dbf	d5,\loopxl
		lea	30(a1),a1
		dbf	d6,\loopy
	movem.l (a7)+,d0-d7/a0-a3
	rts
\loopxl
			moveq	#0,d0
			move.b	(a0)+,d0
			swap	d0
			lsr.l	d2,d0
			and.l	d3,(a3)
			or.l	d0,(a3)
			addq.l	#2,a3
			dbf	d5,\loopxw
		lea	30(a1),a1
		dbf	d6,\loopy
	movem.l (a7)+,d0-d7/a0-a3
	rts


graphlib@0014
clr_scr2:
	movem.l	d0-d3,-(a7)
	bsr.s	clr_scr
	clr.w	d0
	move.w	#LCD_HEIGHT-7,d1
	move.w	#LCD_WIDTH-1,d2
	moveq	#2,d3
	bsr	horiz
	movem.l (a7)+,d0-d3
	rts

graphlib@0005
clr_scr:
	movem.l	d0-d1/a1,-(a7)
	
	GET_SCREEN_PTR d0,<>
	moveq	#0,d1
	move.w	#LCD_SIZE_div_4_minus_1,d0
\clear:
		move.l	d1,(a1)+
		dbf	d0,\clear
	movem.l	(a7)+,d0-d1/a1
	RTS
	
graphlib@0006
vert:
;Input:	d0.w = x
;	d1.w = y1
;	d2.w = y2
	movem.l	d0-d3/a1,-(a7)
	cmp.w	d1,d2
	bgt.s	\plus
		exg	d1,d2
\plus:
	sub.w	d1,d2	;hauteur
	move.w	d2,d3
	
	GET_SCREEN_PTR d2,<>
	FROM_COORD_TO_PTR

	moveq	#15,d0
	sub.w	d2,d0
	clr.w	d2
	bset.w	d0,d2
\loop
		or.w	d2,(a1)
		lea	30(a1),a1
		dbf	d3,\loop
	movem.l	(a7)+,d0-d3/a1
	RTS

graphlib@0000
fill:
;Input:	d0.w = x
;	d1.w = y
;	d2.w = width
;	d3.w = height
;	d4.w = color:	0 -> Video Invert / 1 -> White 2 -> Black
	movem.l d0-d4,-(a7)
	add.w	d0,d2
	exg	d3,d4
\loop:
		bsr.s	horiz
		addq.w	#1,d1
		dbra	d4,\loop
	movem.l	(a7)+,d0-d4
	rts

graphlib@0007
horiz:
;Input:	d0.w = x1
;	d1.w = y
;	d2.w = x2
;	d3.w = color  	0 -> Video Invert
;			1 -> White
;			2 -> Black
	movem.l	d0-d4/a1,-(a7)
	cmp.w	d0,d2
	bgt.s	\plush
		exg	d0,d2
\plush:

	GET_SCREEN_PTR d4,<addq.w #8,d2>

	add.w	d1,d1
	move.w	d1,d4
	lsl.w	#4,d4
	sub.w	d1,d4
	adda.w	d4,a1

	moveq	#15,d4
	eor.w	d4,d2
	and.w	d2,d4
	lsr.w	#4,d2

	moveq	#$F,d1
	and.b	d0,d1
	lsr.w	#4,d0

	sub.b	d0,d2	; d1 = Nbr d'octets à remplir brutalement
	bne.s	\Long_line
		add.w	d0,d0
		adda.w	d0,a1	; A1 -> Screen + What I need
	
		moveq	#-1,d0	; D0 = #$FFFFFFFF
		add.w	d1,d4
		lsl.w	d4,d0
		lsr.w	d1,d0

		subq.b	#1,d3
		blt.s	\invert
		beq.s	\blanc
			; Noir
			or.w	d0,(a1)
			bra.s	\Exit
\blanc:			; Blanc
			not.w	d0
			and.w	d0,(a1)
			bra.s	\Exit
\invert			; Invert
			eor.w	d0,(a1)
			bra.s	\Exit
\Long_line:
	add.w	d0,d0
	adda.w	d0,a1	; A0 -> Screen + What I need

	moveq	#-1,d0	; D0 = #$FFFFFFFF
	lsr.w	d1,d0

	subq.b	#1,d3
	blt.s	\invert2
	beq.s	\blanc2
		; Noir 
		or.w	d0,(a1)+

		moveq	#-1,d0
		subq.b	#2,d2
		blt.s	\FinishN
\LoopN:			move.w	d0,(a1)+
			dbf	d2,\LoopN
\FinishN:	lsl.w	d4,d0
		or.w	d0,(a1)
		bra.s	\Exit
\blanc2		; Blanc
		not.w	d0
		and.w	d0,(a1)+
		moveq	#0,d0
		subq.b	#2,d2
		blt.s	\FinishB
\LoopB:			move.w	d0,(a1)+
			dbf	d2,\LoopB
\FinishB:	moveq	#-1,d0
		lsl.w	d4,d0
		not.w	d0
		and.w	d0,(a1)
		bra.s	\Exit
		; Noir 
\invert2	eor.w	d0,(a1)+
		moveq	#-1,d0
		subq.b	#2,d2
		blt.s	\FinishI
\LoopI:			not.w	(a1)+
			dbf	d2,\LoopI
\FinishI:	lsl.w	d4,d0
		eor.w	d0,(a1)
\Exit:
	movem.l	(a7)+,d0-d4/a1
	rts

graphlib@0002
smallbox:
	movem.l	d0-d3,-(a7)
	moveq	#25,d0
	moveq	#20,d1
	moveq	#110,d2
	moveq	#60,d3
	tst.b	CALCULATOR
	ble.s	\small89
		moveq	#40,d0
		moveq	#25,d1
		move.w	#158,d2
		moveq	#76,d3
\small89:
	bsr.s	box
	movem.l	(a7)+,d0-d3
	rts

graphlib@0008
bigbox:
	movem.l d0-d3,-(a7)
	clr.w	d0
	clr.w	d1
	move.w	#LCD_WIDTH-2,d2
	move.w	#LCD_HEIGHT-8,d3
	bsr.s	box
	movem.l	(a7)+,d0-d3
	rts

graphlib@0003
box:
;Input: d0.w = x
;	d1.w = y
;	d2.w = width
;	d3.w = height
;	a0.l = title of the box
	movem.l	d0-d7/a0-a6,-(a7)
	moveq	#1,d4		;en blanc
	bsr	fill

	move.w	d2,d4
	move.w	d3,d5
	addq.w	#1,d4
	addq.w	#1,d5

	bsr.s	commun2

	move.w	d4,d2
	moveq	#8,d3
	moveq	#2,d4		;en noir
	bsr	fill		;le cadre noir en haut

	addq.w	#2,d0
	addq.w	#2,d1

	movem.l	d0-d1/a0,-(a7)
	clr.w	-(a7)
	jsr	tios::FontSetSys
	addq.l	#2,a7
	move.w	d0,d7
	movem.l (a7)+,d0-d1/a0

	WriteStrA d0,d1,#2,a0

	move.w	d7,-(a7)
	jsr	tios::FontSetSys
	addq.l	#2,a7

	movem.l	(a7)+,d0-d7/a0-a6
	rts

commun2:
	bsr.s	frame

	addq.w	#1,d0
	addq.w	#1,d1
	subq.w	#2,d4
	subq.w	#2,d5
	bsr.s	frame

	addq.w	#2,d0
	addq.w	#2,d1
	subq.w	#4,d4
	subq.w	#4,d5

graphlib@0004
frame:
;Input: d0.w = x
;	d1.w = y
;	d4.w = width
;	d5.w = height
	movem.l	d0-d5,-(a7)
	moveq	#2,d3	;pour faire du noir

	move.w	d0,d2	;pour x2
	add.w	d4,d2
	bsr	horiz
	add.w	d5,d1
	bsr	horiz

	sub.w	d5,d1
	move.w	d1,d2
	add.w	d5,d2
	bsr	vert
	add.w	d4,d0
	bsr	vert

	movem.l	(a7)+,d0-d5
	rts

graphlib@0009
scrtomem:
;Input:	d0.w = X of top left-hand corner in bytes(0<X<30)
;	d1.w = Y of top left-hand corner (0<Y<128)
;	d2.w = width in bytes (0<d2<30)  
;	d3.w = height (0<d3<128)         
;Output: d4.w = handle to the memory containg the part of the screen.
	movem.l	d0-d3/d5-d7/a0-a6,-(a7)

	movem.l	d0-d3/a1,-(a7)
	mulu.w	d2,d3
	move.l	d3,-(a7)
	jsr	tios::HeapAlloc
	addq.l	#4,a7
	move.w	d0,d4
	beq.s	\error

	move.w	d0,-(a7)
	jsr	tios::HeapDeref
	addq.w	#2,a7
	movem.l	(a7)+,d0-d3/a1

	GET_SCREEN_PTR d5,<>
	mulu.w	#30,d1
	add.w	d0,d1
	adda.w	d1,a1

	subq.w	#1,d2	;pour les DBRA
	subq.w	#1,d3
\loopy:		move.w	d2,d5
		move.l	a1,a2
\loopx:			move.b	(a2)+,(a0)+
			dbf	d5,\loopx
		lea	30(a1),a1
		dbra	d3,\loopy

\exit	movem.l	(a7)+,d0-d3/d5-d7/a0-a6
	rts
\error	movem.l	(a7)+,d0-d3/a1
	bra.s	\exit

graphlib@000A
memtoscr:
;Input:	d0.w = X of top left-hand corner in bytes(0<X<30)
;	d1.w = Y of top left-hand corner (0<Y<128)
;	d2.w = width in bytes (0<d2<30)
;	d3.w = height (0<d3<128)
;	d4.w = handle previously created by memtoscr(containing the
;					part of the screen to restore)
	movem.l d0-d7/a0-a6,-(a7)

	move.w	d4,d5
	tios::DEREF d5,a0

	GET_SCREEN_PTR d5,<>

	mulu.w	#30,d1
	add.w	d0,d1
	adda.w	d1,a1

	subq.w #1,d2	;pour les DBRA
	subq.w #1,d3
\loopy:		move.w	d2,d5
		move.l	a1,a2
\loopx:			move.b	(a0)+,(a2)+
			dbf	d5,\loopx
		lea	30(a1),a1
		dbf	d3,\loopy

	move.w	d4,-(a7)
	jsr	tios::HeapFree
	addq.l	#2,a7
	movem.l (a7)+,d0-d7/a0-a6
	rts

; Draw a line from (d0.w, d1.w) to (d2.w, d3.w)
; In :
;	d0.w = X1
;	d1.w = Y1
;	d2.w = X2
;	d3.w = Y2
;	a0 -> Screen
graphlib@0017
line:
	movem.l d0-d7/a0,-(a7)

	; Classement des points
	cmp.w	d0,d2
	bge.s	\no_exg
		exg	d2,d0
		exg	d1,d3
\no_exg:

	; * 30
	move.w	d1,d4
	lsl.w	#5,d4
	sub.w	d1,d4
	sub.w	d1,d4

	; X / 8 
	move.w	d0,d6
	lsr.w	#3,d6		; x/8->x
	add.w	d6,d4		; D4 = 30*y + x /8
	adda.w	d4,a0

	move.w	d0,d6
	not.w	d6
	and.w	#07,d6		;obtient le pixel à changer ; *

	; Calcul de Dx, Dy et Offset
	move.w	d2,d5
	sub.w	d0,d5		; D5 = Dx = x2 - x1 >0
	moveq	#30,d4
	move.w	d3,d7
	sub.w	d1,d7		; D7 = Dy = y2 - y1
	bcc.s	\no
		moveq	#-30,d4
		neg.w	d7
\no:	cmp.w	d5,d7		;Cmp Dx et Dy 
	bcc.s	\up

	; Dx > Dy
	move.w	d5,d2		; D2 = Dx
	move.w	d7,d3
	sub.w	d5,d3
	add.w	d3,d3
	add.w	d7,d7
	sub.w	d7,d5
	neg.w	d5
	bpl.s	\loop1b		; optimization (~ 14%)
\loop1a:
	bset.b	d6,(a0)		; *
	add.w	d7,d5
	bpl.s	\mb
\ma:	subq.w	#1,d6	; *
	bge.s	\OK1a
		moveq	#7,d6
		addq.w	#1,a0
\OK1a:	dbra	d2,\loop1a
	bra.s	\end
\loop1b:
	bset.b	d6,(a0)		; *
	adda.w	d4,a0
	add.w	d3,d5
	bmi.s	\ma
\mb:	subq.w	#1,d6	; *
	bge.s	\OK1b
		moveq	#7,d6
		addq.w	#1,a0
\OK1b:	dbra	d2,\loop1b
	bra.s	\end

	; Dx < Dy
\up:	
	move.w	d7,d3
	move.w	d5,d2
	sub.w	d7,d2
	add.w	d2,d2
	add.w	d5,d5
	sub.w	d5,d7
	neg.w	d7
	bpl.s	\loop2b
\loop2a:
	bset.b	d6,(a0)		; *
	add.w	d5,d7
	bpl.s	\m2b
\m2a	adda.w	d4,a0
	dbra	d3,\loop2a
	bra.s	\end
	
\loop2b:
	bset.b	d6,(a0)		; *
	subq.w	#1,d6		; *
	bge.s	\Ok2b
		moveq	#7,d6
		addq.w	#1,a0
\Ok2b:	add.w	d2,d7
	bmi.s	\m2a
\m2b:	adda.w	d4,a0
	dbra	d3,\loop2b

\end:	movem.l (a7)+,d0-d7/a0
	rts


graphlib@0016
clear_dialog:
	movem.l	d0-d4/a5,-(a7)
	lea	dialogpos(pc),a5
	movem.w	(a5),d0-d3
	moveq	#1,d4
	bsr	fill
	movem.l	(a7)+,d0-d4/a5
	rts

graphlib@0015
show_dialog:
	movem.l	d0-d7/a0-a6,-(a7)
	move.w	(a6)+,d0
	move.w	(a6)+,d1
	move.w	(a6)+,d2
	move.w	(a6)+,d3
	sub.w	d0,d2		;largeur
	sub.w	d1,d3		;hauteur
	lea	dialogpos(pc),a5
	movem.w	d0-d3,(a5)
	moveq	#1,d4		;en blanc
	bsr	fill
	move.w	d2,d4
	move.w	d3,d5
	addq.w	#1,d0
	addq.w	#1,d1
	subq.w	#2,d4
	subq.w	#2,d5
	bsr	commun2
	move.w	#2,-(a7)
	jsr	tios::FontSetSys
	move.w	d0,(a7)		;sauvegarde la fonte
	move.w	(a6)+,d2
	move.w	(a6)+,d3
	movem.w	(a5),d0-d1	;recouvre x1 et y1
	add.w	d2,d0
	add.w	d3,d1
	WriteStrA d0,d1,#4,(a6)
	jsr	tios::FontSetSys
	addq.l	#2,a7
	movem.l	(a7)+,d0-d7/a0-a6
	rts

graphlib@0018
erase_rect:
	movem.l	d0-d4/a6,-(a7)
	lea	28(a7),a6
	move.w	(a6)+,d0
	move.w	(a6)+,d1
	move.w	(a6)+,d2
	move.w	(a6)+,d3
	sub.w	d0,d2		;largeur
	sub.w	d1,d3		;hauteur
	moveq	#1,d4		;en blanc
	bsr	fill
	movem.l (a7)+,d0-d4/a6
	rts

graphlib@0019
frame_rect:
	movem.l	d0-d5/a6,-(a7)
	lea	32(a7),a6
	move.w	(a6)+,d0
	move.w	(a6)+,d1
	move.w	(a6)+,d4
	move.w	(a6)+,d5
	sub.w	d0,d4		;largeur
	sub.w	d1,d5		;hauteur
	bsr	frame
	movem.l	(a7)+,d0-d5/a6
	rts

graphlib@001A
getlength:
;Input:	a0 = string
;Output:	d3 = length
;		d4 = heigth
	movem.l	d0-d2/a0-a2,-(a7)
	clr.w	d3
	jsr	tios::FontGetSys
	lea	tios::font_small,a1

	subq.b	#1,d0
	blt.s	\small
	beq.s	\medium

	; Large
	moveq	#10,d4
	bra.s	\final_large
\loop_large	addq.w	#8,d3
\final_large	move.b	(a0)+,d2
		bne.s	\loop_large
	bra.s	\end

	; Medium
\medium	moveq	#8,d4
	bra.s	\final_medium
\loop_medium	addq.w	#6,d3
\final_medium	move.b	(a0)+,d2
		bne.s	\loop_medium
	bra.s	\end

	; Small
\small	moveq	#5,d4
	bra.s	\final_small
\loop_small	mulu.w	#6,d2
		add.b	0(a1,d2.w),d3		; Ca peut pas depasser 240 !
\final_small	clr.w	d2
		move.b	(a0)+,d2
		bne.s	\loop_small

\end:
	movem.l (a7)+,d0-d2/a0-a2
	rts

; ************************************************************************************************
;		GRAY FUNCTIONS
; ************************************************************************************************

graphlib@000F
gray4:	movem.l d1-d7/a0-a6,-(a7)
	bsr	gray2				; Disable GRAY first (if needed)

	pea	($F00*1+8).w			; Alloc one extra screen for the Gray Buffer
	move.b	HW_VERSION,d4
	subq.b	#1,d4
	beq.s	\hw1
		add.l	#$F00,(a7)		; One more screen for HW2/HW3
\hw1
	jsr	tios::HeapAllocHigh
	addq.l	#4,a7
	move.w	d0,handle
	beq	graylib_fail

	bsr	DEREF_Mult8
	move.w	#LCD_SIZE_div_4_minus_1,d0
\loop:		clr.l	(a2)+
		dbra	d0,\loop
	; Now a2 -> Next plane (If HW > 1)
	
	; Setup auto-int1
	move.w	#$0700,d0
	trap	#1
	move.l	#$00000400,table
	move.b	#$3,ResetPhase
	lea	int1HW1(pc),a0
	lea	($64).w,a1
	move.l	(a1),oldint1
	bsr.s	InstallVector

	bsr	SetUpFirstPlane
	trap	#1
	movem.l (a7)+,d1-d7/a0-a6
	st.b	d0
	rts

InstallVector:
	bclr.b	#2,$600001
	move.l	a0,(a1)
	bset.b	#2,$600001
	rts
		
_exit:
	clr.w	choosescreen
	
graphlib@000E
gray2:
	movem.l d1-d7/a0-a6,-(a7)
        move.w  handle(pc),-(a7)
	beq.s	\fail
		move.l	oldint1(pc),a0
		lea	($64).w,a1
		bsr.s	InstallVector
		lea	LCD_MEM,a0		; Load LCD_MEM
		move.l	a0,d0
		lsr.l	#3,d0
		move.w	d0,$600010		
		lea	plane0(Pc),a1
		move.l	a0,(a1)+
		move.l	a0,(a1)+
		move.l	a0,(a1)+
	        jsr	tios::HeapFree
		jsr	tios::PortRestore        ; tells AMS to draw to LCD_MEM
		move.b	#2,phase
		clr.w	handle
\fail:
	addq.l	#2,a7
graylib_fail:
        movem.l (a7)+,d1-d7/a0-a6
	moveq	#0,d0
	rts

;In:
;	d0.w = HANDLE
; Out:
;	a2 = plane
;	plane1 set
DEREF_Mult8
	lsl.w	#2,d0
	move.l	tios::Heap,a0
	move.l	0(a0,d0.w),d0
	addq.l	#7,d0
	lsr.l	#3,d0
	lsl.l	#3,d0
	move.l	d0,a2
	move.l 	a2,plane1
	rts

graphlib@0010
gray7:
	movem.l	d1-d7/a0-a6,-(a7)
	bsr.s	gray2	

	pea	($F00*2+8).w
	move.b	HW_VERSION,d4
	subq.b	#1,d4
	beq.s	\hw1
		add.l	#$F00,(a7)		; One more for HW2/HW3
\hw1
	jsr	tios::HeapAllocHigh
	addq.l	#4,a7
	move.w	d0,handle
	beq.s	graylib_fail

	bsr.s	DEREF_Mult8
	lea	$F00(a2),a1
	move.l	a1,plane2
	
	move.w #LCD_SIZE_div_4_minus_1,d0
\loop:		clr.l (a1)+
		clr.l (a2)+
		dbra	d0,\loop

	; Parametrisation du comportement l'auto-int1
	move.w	#$0700,d0
	trap	#1
	move.l	#$00080004,table
	move.b	#$6,ResetPhase
	lea	int1HW1(pc),a0
	lea	($64).w,a1
	move.l	(a1),oldint1
	bsr	InstallVector
	bsr.s	SetUpFirstPlane
	trap	#1
	movem.l	(a7)+,d1-d7/a0-a6
	st.b	d0
	rts

; In:
;	d4.b = HW_VERSION-1
;	a2.l = Plane0 if HW_VERSION != 1
SetUpFirstPlane:
	move.w	d0,-(a7)
	; On determine le 1er plan.
	lea	(LCD_MEM).w,a0
	move.l	a0,plane0
	tst.b	d4
	beq.s	\done
		move.l	a2,plane0
		; Copy LCD_MEM to plane0
		move.w	#LCD_SIZE_div_4_minus_1,d0
		move.l	a2,a1
\loop			move.l	(a0)+,(a2)+
			dbf	d0,\loop
		; Set it for AMS drawing
		move.l	#239*65536+127,-(a7)	
		pea	(a1)
		jsr	tios::PortSet
		addq.l	#8,a7

 ifd TitaniK
		; Copy auto-int to always-exec-zone
		move.w	#-1+(end_int1HW2-int1HW2),d0
		lea	int1HW2(pc),a0
		lea	($57b8).w,a1
\loop2			move.b	(a0)+,(a1)+
			dbf	d0,\loop2
		lea	($57B8).w,a0				; Set up the auto-int
 endc
 ifnd TitaniK
		lea	int1HW2(pc),a0				; Set up the auto-int
 endc
		lea	($64).w,a1
		bsr	InstallVector
\done	move.w	(a7)+,d0
	rts

;*****************************************************
int1HW1:
	move.w	#$2700,sr
	pea	(a0)
	lea	vbl_phase(pc),a0
	addq.b	#1,(a0)
	andi.b	#3,(a0)+
	bne.s	\skip
		subq.b	#1,(a0)		;phase
		bne.s 	\no
			move.b	ResetPhase(Pc),(a0)	; 3 or 6
\no		move.l	d0,-(a7)
		clr.w	d0
		move.b	(a0),d0			;phase
		move.b	phase(Pc,d0.w),d0	;numéro de l'écran
		move.l	plane0(Pc,d0.w),d0
		lsr.l	#3,d0
		move.w	d0,$600010
		move.l	(a7)+,d0
\skip	move.l	(a7),a0
	move.l	oldint1(pc),(a7)
	rts

graphlib@0011
plane0		dc.l LCD_MEM		; Dark Plane
graphlib@0012
plane1		dc.l LCD_MEM		; Light Plane
graphlib@0013
plane2		dc.l LCD_MEM		; Very Light Plane

vbl_phase	dc.b	0
phase		dc.b	2
table		dc.b	0,8,0,4,0,8
ResetPhase	dc.b	3		; Le dernier c pour reseter au debut
Current_FS	dc.b	0
handle		dc.w	0
phase2		dc.w	0		; Phase2 

;*****************************************************
int1HW2
	move.w	#$2700,sr

	movem.l	d0-d7/a0-a6,-(a7)
	; Determine phase2
\test_fs	
 ifd TitaniK
	lea	(phase).l,a0
 endc
 ifnd TitaniK
	lea	phase(pc),a0
 endc
	clr.w	d4
	moveq	#0,d1		; Offset pour p2 1
	move.b	(a0),d4		; d4 = phase
	move.w	phase2-phase(a0),d0	; d0 = phase2
	bne.s	\no_test_fs
		; Attend la frame synchro
		move.b	Current_FS-phase(a0),d2
 ifd VTI
		move.b	d3,d2
		eor.b	#$80,d2
 endc
 ifnd VTI
		move.b	($70001D),d3
		eor.b	d3,d2
		bge	\stop		; On attend la prochaine !
 endc
		
		; Une nouvelle FS commence !
		move.b	d3,Current_FS-phase(a0)	; Sauve FS courante
		
		moveq	#3,d0		; Reinit phase2
		move.w	#LCD_SIZE_mul_2_div_3,d1	; Offset pour p2 3
\no_test_fs:
	; on ne teste pas le signal FS
	cmpi.w	#2,d0			; Si p2 = 2
	bne.s	\no_swap_screen
		subq.b	#1,d4		; Dec Screen phase
		bgt.s	\no
			move.b	ResetPhase-phase(a0),d4	; Reinit Screen Phase
\no:		move.b	d4,(a0)		; Save Screen phase
\no_swap_screen:

	subq.w	#1,d0
	bne.s	\nop2			
		move.w	#LCD_SIZE_div_3,d1	; Offset par rapport au debut pour l'affichage en p2 2
\nop2	move.w	d0,phase2-phase(a0)	; Sauvegarde p2
	
	; Copie du tiers de l'ecran
	; Cacul de l'adresse source
	moveq	#0,d2
	move.b	0(a0,d4.w),d2
	cmp.b	1(a0,d4.w),d2
	beq	\stop			; C encore le meme plan => C inutile de le recopier

	move.l	plane0-phase(a0,d2.w),a0
	adda.w	d1,a0

	; Calcul de l'adresse destination
	lea	LCD_MEM,a1
	adda.w	d1,a1
	
	; Copie
	tst.b	CALCULATOR
	bgt.s \largescr
		move.l (a0)+,(a1)+
		move.l (a0)+,(a1)+
		move.l (a0)+,(a1)+			; (89) 12 octets copies
\largescr:
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(0*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(1*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(2*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(3*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(4*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(5*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(6*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(7*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(8*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(9*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(10*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(11*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(12*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(13*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(14*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(15*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(16*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(17*13*4)(a1)
	movem.l (a0)+,d0-d7/a2-a6
	movem.l d0-d7/a2-a6,(18*13*4)(a1)			; (89) +988 = 1000 octets copies
	tst.b	CALCULATOR
	ble.s	\smallscr
		movem.l (a0)+,d0-d7/a2-a6
		movem.l d0-d7/a2-a6,(19*13*4)(a1)
		movem.l (a0)+,d0-d7/a2-a6
		movem.l d0-d7/a2-a6,(20*13*4)(a1)
		movem.l (a0)+,d0-d7/a2-a6
		movem.l d0-d7/a2-a6,(21*13*4)(a1)
		movem.l (a0)+,d0-d7/a2-a6
		movem.l d0-d7/a2-a6,(22*13*4)(a1)
		movem.l (a0)+,d0-d7/a2-a6
		movem.l d0-d7/a2-a6,(23*13*4)(a1)	; (9x) 1248 octets copies	
		movem.l (a0)+,d0-d7
		movem.l d0-d7,(24*13*4)(a1)		; (9x) +32 = 1280 octets copies
\smallscr:
 endc

	; Test si on peut continuer
 ifd TitaniK
	tst.w	(phase2).l
 endc
 ifnd TitaniK
	move.w	phase2(pc),d0
 endc
	beq	\test_fs

\stop:
	movem.l	(a7)+,d0-d7/a0-a6
	move.l	oldint1(Pc),-(a7)
	rts

oldint1		dc.l	0
end_int1HW2:

graphlib@000D
choosescreen	dc.w 0

dialogpos	ds.w 4


	end
	