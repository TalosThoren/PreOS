        xdef _library

        xdef util@0000
        xdef util@0001
        xdef util@0002
        xdef util@0003
        xdef util@0004
        xdef util@0005
        xdef util@0006
        xdef util@0007
        xdef util@0008
        xdef util@0009
        xdef util@000A
        xdef util@000B
        xdef util@000C
        xdef util@000D
        xdef util@000E
        xdef util@000F
        xdef util@0010
        xdef util@0011
        xdef util@0012
        xdef util@0013
        xdef util@0014			;* line added by Th.FERNIQUE *

        include "tios.h"
	include "graphlib.h"
	include "userlib.h"

        xdef	_ti92plus
        xdef	_ti89
        xdef	_ti89ti
	xdef	_v200		; Create V200 program
	DEFINE	_version01

ST_busy equ $e2

pixel_do        macro
        movem.l d0-d1/a0,-(a7)

	lea	LCD_MEM,a0

        move.w  4*4+2(a7),d0            ; y-coordinate
        cmp.w   #LCD_HEIGHT,d0
	bcc.s	\pixel_bad
	add.w d0,d0
        move.w  d0,d1
        lsl.w   #4,d0
        sub.w   d1,d0
	adda.w	d0,a0			;y*30+a0->a0

        move.w  4*4+0(a7),d0            ; x-coordinate
        cmp.w   #LCD_WIDTH,d0
	bcc.s	\pixel_bad
	move.w	d0,d1
	lsr.w	#3,d0				;x/8->x

	not.w	d1
	and.w	#7,d1
	b\1.b	d1,0(a0,d0.w)		;fait l'opération sur le bon pixel

\pixel_bad:
        movem.l (a7)+,d0-d1/a0
		endm

;*****************************************************

find_pixel:
util@0000:
        move.w  d1,-(a7)

	lea	LCD_MEM,a0

	move.w  (4+2)+2(a7),d0	; y-coordinate
	cmp.w   #LCD_HEIGHT,d0
	bcc.s	pixel_bad
	add.w	d0,d0
	move.w  d0,d1
	lsl.w   #4,d0
	sub.w   d1,d0			;y*30->d0
	adda.w	d0,a0			;d0+a0->a0

        move.w  (4+2)+0(a7),d1		; x-coordinate
        cmp.w   #LCD_WIDTH,d1
	bcc.s	pixel_bad
	move.w	d1,d0
	lsr.w	#3,d1			;x/8->d1
	adda.w	d1,a0			;d1+a0->a0
	not.w	d0
	and.w	#7,d0				;indique la position du pixel à tester avec btst

pixel_good:
        move.w  (a7)+,d1
	rts

pixel_bad:
	sub.l	a0,a0
	bra.s	pixel_good

;*****************************************************

pixel_on:
util@0001:
	pixel_do	set
	rts

;*****************************************************

pixel_off:
util@0002:
	pixel_do	clr
	rts

;*****************************************************

pixel_chg:
util@0003:
	pixel_do	chg
	rts

;*****************************************************
; prep_rect: used by frame_rect and erase_rect
;*****************************************************
prep_rect:				;d2,d3 not used
util@0004:
	lea	LCD_MEM,a0
	movem.l	$34(a7),d4-d5
	mulu.w	#30,d4
	mulu.w	#30,d5
	
	lea	0(a0,d5.w),a1
	adda.w	d4,a0
	
	movem.l	$32(a7),d0-d1
	move.w	d0,d6
	move.w	d1,d7
	lsr.w	#3,d0
	lsr.w	#3,d1
	and.w	#7,d0
	and.w	#7,d1
	
	rts

;*****************************************************

frame_rect:
util@0005:
	jmp	graphlib::frame_rect

erase_rect:
util@0006:
	jmp	graphlib::erase_rect

;*****************************************************
fill_rect				;* line added by Th.FERNIQUE *
util@0014:				;* line added by Th.FERNIQUE *
	movem.l d0-d7/a0-a6,-(a7)
	lea	64(a7),a6
	move.w	(a6)+,d0
	move.w	(a6)+,d1
	move.w	(a6)+,d2
	move.w	(a6)+,d3

	sub.w	d0,d2		;largeur
	sub.w	d1,d3		;hauteur
	moveq	#2,d4		;en noir
	jsr	graphlib::fill

	movem.l	(a7)+,d0-d7/a0-a6
	rts

;*****************************************************

show_dialog:
util@0007:
	jmp	graphlib::show_dialog

clear_dialog:
util@0008:
	jmp	graphlib::clear_dialog

;*****************************************************

clr_scr:
util@0009:
	jmp	graphlib::clr_scr2

;*****************************************************

zap_screen:
util@000A:
	jmp	graphlib::clr_scr


idle_loop:
util@000B:
	jmp	userlib::idle_loop

;*****************************************************

random:
util@000C:
	move.w	userlib::rand_seed,-(a7)
	move.w	rand_seed(Pc),userlib::rand_seed
	jsr	userlib::random
	move.w	userlib::rand_seed,rand_seed
	move.w	(a7)+,userlib::rand_seed
	rts
	
tios::DrawCharXY
util@000D:
	jmp	userlib::DrawCharXY

util::exec
util@000E:
	jmp	userlib::exec

tios::FindSymEntry
util@000F:
	jmp	userlib::FindSymEntry

InitFargoCompatibility:
util@0011:
;        ; Copy the font so that the order is correct for Fargo programs
        pea	(6144).w
        jsr	tios::HeapAlloc
        addq.l	#4,a7
        move.w	d0,SF_font_handle
        beq.s	ifcEnd

		DEREF	d0,a0

		lea	tios::font_small,a1
		move.w	#383,d0
smallFontCopy:		move.l	(a1)+,(a0)+
			dbra	d0,smallFontCopy

		lea	tios::font_medium,a1
		move.w	#511,d0
medFontCopy:		move.l (a1)+,(a0)+
			dbra d0,medFontCopy

		lea	tios::font_large,a1
		move.w	#639,d0
largeFontCopy:		move.l (a1)+,(a0)+
		        dbra d0,largeFontCopy
ifcEnd:	rts

DeinitFargoCompatibility:
util@0012:
        move.w	SF_font_handle(pc),-(a7)
        beq.s	\End
		jsr	tios::HeapFree
\End:	addq.l	#2,a7
        rts


;*****************************************************
; miscellaneous program data
;*****************************************************

SF_font_handle  dc.w    0
util@0013:
SF_font         dc.l    0
util@0010:
rand_seed	dc.w	13

        end
