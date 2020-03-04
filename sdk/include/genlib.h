; genlib.h -- ASM include file for GENLIB
;
; Copyright 1999, 2000, 2001, 2002, 2003, 2004, 2005 Patrick Pelissier.
;
; This file is part of the GENLIB Library.
;
; The GENLIB Library is free software; you can redistribute it and/or modify
; it under the terms of the GNU Lesser General Public License as published by
; the Free Software Foundation; either version 2.1 of the License, or (at your
; option) any later version.
;
; The GENLIB Library is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
; License for more details.
;
; You should have received a copy of the GNU Lesser General Public License
; along with the GENLIB Library; see the file COPYING.LIB.  If not, write to
; the Free Software Foundation, Inc., 51 Franklin Place, Fifth Floor, Boston,
; MA 02110-1301, USA.

	ifnd	__GENLIB__INCLUDE__FILE__
genlib@version07	xdef	genlib@version07

__GENLIB__INCLUDE__FILE__	EQU	'1.1.'

genlib::init			EQU	genlib@0000
genlib::quit			EQU	genlib@0001
genlib::exg_gray		EQU	genlib@001D
genlib::use_int1		EQU	genlib@0036

genlib::init_screen		EQU	genlib@0049
genlib::init_dscreen		EQU	genlib@0002

genlib::set_dscreen_int		EQU	genlib@0003
genlib::set_dscreen_function	EQU	genlib@0004
genlib::set_screen_int		EQU	genlib@0043
genlib::set_LCD_MEM		EQU	genlib@0032
genlib::get_dscreen		EQU	genlib@0069

genlib::copy_window		EQU	genlib@0005

genlib::put_medium_string	EQU	genlib@003E
genlib::put_small_string	EQU	genlib@003F
genlib::put_large_string	EQU	genlib@0040
genlib::create_bgs_string	EQU	genlib@0065

genlib::cls			EQU	genlib@0028
genlib::clear_window		EQU	genlib@004A
genlib::fill_screen		EQU	genlib@0062

genlib::set_filter		EQU	genlib@0053

genlib::window			EQU	genlib@0041
genlib::timer			EQU	genlib@000D
gld				EQU	genlib@0042
genlib::internal_timer		EQU	gld+3
genlib::frame_timer		EQU	genlib@0067
genlib::hardware		EQU	genlib@0044
genlib::flipping_tab		EQU	genlib@004D
genlib::version			EQU	genlib@006A

gla				EQU	genlib@000A	; I use this, because, else
glb				EQU	genlib@000B	; a strange bug appears !
glc				EQU	genlib@000C
genlib::sprite_tile_adr		EQU	$2+gla
genlib::sprite_scr_x		EQU	$2+glb
genlib::sprite_scr_y		EQU	$2+glc

genlib::put_sprite_16		EQU	genlib@0009
genlib::put_sprite_16_flip_h	EQU	genlib@0011
genlib::put_sprite_16_flip_v	EQU	genlib@0012
genlib::put_sprite_16_flip_hv	EQU	genlib@0013
genlib::put_sprite_16_last_flip	EQU	genlib@0018
genlib::put_sprite_16_zoom	EQU	genlib@0026
genlib::pal_sprite_16		EQU	genlib@0066

genlib::put_mask_spr16		EQU	genlib@006B
genlib::put_mask_spr16_flip_h	EQU	genlib@006C
genlib::put_mask_spr16_flip_v	EQU	genlib@006D
genlib::put_mask_spr16_flip_hv	EQU	genlib@006E

genlib::put_tile_16		EQU	genlib@006B
genlib::put_tile_16_flip_h	EQU	genlib@006C
genlib::put_tile_16_flip_v	EQU	genlib@006D
genlib::put_tile_16_flip_hv	EQU	genlib@006E

genlib::put_gb_sprite_16	EQU	genlib@0074
genlib::put_gb_sprite_16_flip_h	EQU	genlib@0075
genlib::put_gb_sprite_16_flip_v	EQU	genlib@0076
genlib::put_gb_sprite_16_flip_hv	EQU	genlib@0077

genlib::put_big_sprite		EQU	genlib@0014
genlib::put_big_sprite_flip_h	EQU	genlib@0015
genlib::put_big_sprite_flip_v	EQU	genlib@0016
genlib::put_big_sprite_flip_hv	EQU	genlib@0017
genlib::put_big_sprite_zoom	EQU	genlib@0027

genlib::put_masked_big_sprite	EQU	genlib@0070
genlib::put_masked_big_sprite_flip_h	EQU	genlib@0071
genlib::put_masked_big_sprite_flip_v	EQU	genlib@0072
genlib::put_masked_big_sprite_flip_hv	EQU	genlib@0073

genlib::init_plane		EQU	genlib@0006
genlib::free_plane		EQU	genlib@0007
genlib::refresh_plane		EQU	genlib@0008
genlib::copy_xyplane_xysprite	EQU	genlib@001B
genlib::copy_dscreen_vscreen	EQU	genlib@001F

genlib::update_vscreen_8	EQU	genlib@0019
genlib::update_vscreen_16	EQU	genlib@001C
genlib::update_roll_vscreen_16	EQU	genlib@003D

genlib::update_vscreen_max16	EQU	genlib@0058

genlib::change_update		EQU	genlib@0045
genlib::restore_update		EQU	genlib@0046
genlib::set_callback_update	equ	genlib@0056
genlib::free_callback_update	equ	genlib@0057

genlib::put_plane		EQU	genlib@0010
genlib::put_fgrd_plane		EQU	genlib@001E
genlib::put_dhz_plane		EQU	genlib@0022
genlib::put_dhz_fgrd_plane	EQU	genlib@0023
genlib::put_dhz_trpt_plane	EQU	genlib@0047

genlib::put_plane_89		EQU	genlib@0020
genlib::put_fgrd_plane_89	EQU	genlib@0021
genlib::put_dhz_plane_89	EQU	genlib@003B
genlib::put_dhz_fgrd_plane_89	EQU	genlib@003C
genlib::put_dhz_trpt_plane_89	EQU	genlib@0048

genlib::wait_no_key		EQU	genlib@000E
genlib::wait_a_key		EQU	genlib@000F
genlib::keypressed		EQU	genlib@001A
genlib::read_key_matrix		EQU	genlib@0034
genlib::read_joypad		EQU	genlib@0035

genlib::make_fast_sprite	EQU	genlib@0024

genlib::do_zoom			EQU	genlib@0025
genlib::put_pixel		EQU	genlib@002B
genlib::draw_circle		EQU	genlib@004B
genlib::draw_clipped_circle	EQU	genlib@004C
genlib::draw_disk		EQU	genlib@0060
genlib::draw_clipped_disk	EQU	genlib@0061
genlib::render_disk		EQU	genlib@0063

genlib::draw_face		EQU	genlib@0029
genlib::draw_c_face		EQU	genlib@002A
genlib::draw_clipped_face	EQU	genlib@004E
genlib::draw_clipped_c_face	EQU	genlib@004F
genlib::render_triangle		EQU	genlib@005F

genlib::clip_line		EQU	genlib@0050
genlib::draw_line		EQU	genlib@0051
genlib::draw_clipped_line	EQU	genlib@0052

genlib::draw_bwhline_b		EQU	genlib@0059
genlib::draw_bwhline_w		EQU	genlib@005A
genlib::draw_hline_w		EQU	genlib@005B
genlib::draw_hline_lg		EQU	genlib@005C
genlib::draw_hline_dg		EQU	genlib@005D
genlib::draw_hline_b		EQU	genlib@005E
genlib::draw_hline_light	EQU	genlib@0064
genlib::draw_hline_shadow	EQU	genlib@0068

genlib::set_byte_link		EQU	genlib@002C
genlib::send_byte		EQU	genlib@002D
genlib::receive_byte		EQU	genlib@002E
genlib::send_data		EQU	genlib@002F
genlib::synchronize		EQU	genlib@0030
genlib::set_link		EQU	genlib@0033
genlib::link_data		EQU	genlib@0031

genlib::sin			EQU	genlib@0054
genlib::cos			EQU	genlib@0055

genlib::push_hd			EQU	genlib@0038
genlib::pop_hd			EQU	genlib@0039
genlib::free_hd			EQU	genlib@003A

; Plane structure

PLANE_HDL	EQU	0		; w.Handle of the plane
PLANE_SIZE	EQU	2		; w.Size of a row / ln(size)/ln(2)
PLANE_TABLE_ADR	EQU	4		; l.Adress of the matrix
PLANE_TILE_ADR	EQU	8		; l.Adress of the tiles
PLANE_COLOR	EQU	12		; w.Number of screen (0->1, 1->2, 2->3)
PLANE_XS_OLD	EQU	16		; w.Old coordinate
PLANE_YS_OLD	EQU	18		; w."
PLANE_XS	EQU	20		; w.Current coordinate X
PLANE_YS	EQU	22		; w." y
PLANE_V_SCREEN	EQU	24		; ?.Virtualscreen


; Point structure.
xe	EQU	0
ye	EQU	2

; Link data structure
link_flag		EQU	0	; w
buffer_recpt_adr	EQU	2	; l
buffer_send_adr		EQU	6	; l
buffer_recpt_size	EQU	10	; w
buffer_send_size	EQU	12	; w
buffer_recpt_flag	EQU	14	; b
buffer_send_flag	EQU	15	; b
buffer_recpt_offset	EQU	16	; w
buffer_send_offset	EQU	18	; w

; Joypad structure.
exit_key	EQU	0	; ESC  | ESC
mode_key	EQU	1	; APPS | APS
plus_key	EQU	2	; +    |  +
minus_key	EQU	3	; -    |  -
left_key	EQU	4	; 
up_key		EQU	5	;
right_key	EQU	6	;
down_key	EQU	7	;
ka_key		EQU	8	; F1 | 2nd
kb_key		EQU	9	; F2 | Diamond
kc_key		EQU	10	; F3 | Home
kd_key		EQU	11	; F4 | X
ke_key		EQU	12	; F5 | Shift
kf_key		EQU	13	; F6 | Alpha
kg_key		EQU	14	; F7 | Mode
kh_key		EQU	15	; F8 | Y
n_key		EQU	16	; Number of bits used

; Const

SCREEN_X	EQU	30		; Size in bytes of a line of the Video Screen
SCREEN_Y	EQU	128		; Number of rows of the video Sceen on Ti-92
SCREEN_Y_89	EQU	100		; Number of rows of the video Sceen on Ti-89
SCREEN_SIZE	EQU	$F00		; Size of a Screen
DSCREEN_SIZE	EQU	2*SCREEN_SIZE	; Size of a Dscreen (Double Screen)
TSCREEN_SIZE	EQU	3*SCREEN_SIZE	; Size of a Tscreen (Triple Screen)
VSCREEN_SIZE	EQU	5440*2		; Size of the Virtual Screen of a Dplane (Double plane <-> Dscreen)
VIRTUAL_X	EQU	34		; Size in bytes of a row of a VScreen
VIRTUAL_Y	EQU	5*4		; Number of rows in a VScreen / 8
MAX_HANDLE	EQU	20		; Max handles of functions push_hd,...
ONE		EQU	65536		; For fixed macros.

; Const reserved to GenLib use.
SCR_SX		EQU	30
Row_Key		EQU	9
WAIT_FOR_KEY	EQU	11

; Link Const
IN_PROGRESS	EQU	0
DONE		EQU	1
LINK_BYTE	EQU	63
MASTER		EQU	0
SLAVE		EQU	1

; Double screen macro
; Allocate a Double-Screen on the stack
; Call :PUSH_DSCREEN	ds
; Return : ds = adress of the Double Screen
genlib::PUSH_DSCREEN	MACRO
	lea	-(DSCREEN_SIZE+8)(a7),a7
	move.l	a7,\1
	addq.l	#7,\1
	lsr.l	#3,\1
	lsl.l	#3,\1
			ENDM

genlib::POP_DSCREEN	MACRO
	lea	(DSCREEN_SIZE+8)(a7),a7
			ENDM

; Screen macro
; Allocate a Screen on the stack
; Call :PUSH_SCREEN	ds
; Return : ds = adress of the Screen
genlib::PUSH_SCREEN	MACRO
	lea	-(SCREEN_SIZE+8)(a7),a7
	move.l	a7,\1
	addq.l	#7,\1
	lsr.l	#3,\1
	lsl.l	#3,\1
			ENDM

genlib::POP_SCREEN	MACRO
	lea	(SCREEN_SIZE+8)(a7),a7
			ENDM

; Fast sprites macros
; Input : d0 = x, d1 = y, a0 -> Source a1-> Destination
genlib::do_fast_sprite	MACRO
	add.w	d1,d1
	move.w	d1,d2
	lsl.w	#4,d2
	sub.w	d1,d2	; D2 = 30 * D1
	move.b	d0,d1
	lsr.w	#4,d0
	add.w	d0,d0
	add.w	d0,d2
	adda.w	d2,a1	; Destination
	and.w	#$000F,d1
	lsl.w	#6,d1
	adda.w	d1,a0	; Source
	movem.l	(a0)+,d0-d7
	\1.l	d0,(a1)
	\1.l	d1,SCREEN_X(a1)
	\1.l	d2,2*SCREEN_X(a1)
	\1.l	d3,3*SCREEN_X(a1)
	\1.l	d4,4*SCREEN_X(a1)
	\1.l	d5,5*SCREEN_X(a1)
	\1.l	d6,6*SCREEN_X(a1)
	\1.l	d7,7*SCREEN_X(a1)
	movem.l	(a0)+,d0-d7
	\1.l	d0,8*SCREEN_X(a1)
	\1.l	d1,9*SCREEN_X(a1)
	\1.l	d2,10*SCREEN_X(a1)
	\1.l	d3,11*SCREEN_X(a1)
	\1.l	d4,12*SCREEN_X(a1)
	\1.l	d5,13*SCREEN_X(a1)
	\1.l	d6,14*SCREEN_X(a1)
	\1.l	d7,15*SCREEN_X(a1)
			ENDM

genlib::put_fast_sprite	MACRO
	genlib::do_fast_sprite <or>
			ENDM

genlib::do_fast_sprite_ds	MACRO
	add.w	d1,d1
	move.w	d1,d2
	lsl.w	#4,d2
	sub.w	d1,d2	; D2 = 30 * D1
	move.b	d0,d1
	lsr.w	#4,d0
	add.w	d0,d0
	add.w	d0,d2
	adda.w	d2,a1	; Destination
	and.w	#$000F,d1
	lsl.w	#6,d1
	adda.w	d1,a0	; Source
	movem.l	(a0)+,d0-d7
	\1.l	d0,(a1)
	\1.l	d1,SCREEN_X(a1)
	\1.l	d2,2*SCREEN_X(a1)
	\1.l	d3,3*SCREEN_X(a1)
	\1.l	d4,4*SCREEN_X(a1)
	\1.l	d5,5*SCREEN_X(a1)
	\1.l	d6,6*SCREEN_X(a1)
	\1.l	d7,7*SCREEN_X(a1)
	\1.l	d0,SCREEN_SIZE(a1)
	\1.l	d1,SCREEN_SIZE+SCREEN_X(a1)
	\1.l	d2,SCREEN_SIZE+2*SCREEN_X(a1)
	\1.l	d3,SCREEN_SIZE+3*SCREEN_X(a1)
	\1.l	d4,SCREEN_SIZE+4*SCREEN_X(a1)
	\1.l	d5,SCREEN_SIZE+5*SCREEN_X(a1)
	\1.l	d6,SCREEN_SIZE+6*SCREEN_X(a1)
	\1.l	d7,SCREEN_SIZE+7*SCREEN_X(a1)
	movem.l	(a0)+,d0-d7
	\1.l	d0,8*SCREEN_X(a1)
	\1.l	d1,9*SCREEN_X(a1)
	\1.l	d2,10*SCREEN_X(a1)
	\1.l	d3,11*SCREEN_X(a1)
	\1.l	d4,12*SCREEN_X(a1)
	\1.l	d5,13*SCREEN_X(a1)
	\1.l	d6,14*SCREEN_X(a1)
	\1.l	d7,15*SCREEN_X(a1)
	\1.l	d0,SCREEN_SIZE+8*SCREEN_X(a1)
	\1.l	d1,SCREEN_SIZE+9*SCREEN_X(a1)
	\1.l	d2,SCREEN_SIZE+10*SCREEN_X(a1)
	\1.l	d3,SCREEN_SIZE+11*SCREEN_X(a1)
	\1.l	d4,SCREEN_SIZE+12*SCREEN_X(a1)
	\1.l	d5,SCREEN_SIZE+13*SCREEN_X(a1)
	\1.l	d6,SCREEN_SIZE+14*SCREEN_X(a1)
	\1.l	d7,SCREEN_SIZE+15*SCREEN_X(a1)
			ENDM


genlib::put_fast_sprite_ds	MACRO
	genlib::do_fast_sprite_ds <or>
				ENDM

	endif

	ifnd	__FIXED__INCLUDE__FILE__

__FIXED__INCLUDE__FILE__	EQU	'0.52'

; Divide 32 bits number by 16 bits number, 32 bits quotient.
; Input :
;	divu32 A.l,B.w,ds1.l,ds2.l
;	ds1 / ds2 temp registers (destroyed)
;	A register
;	B could be a number or a register
; Out:
;	A.l
divu32	MACRO
	move.l	\1,\3
	clr.w	\3
	swap	\3
	divu.w	\2,\3
	move.w	\3,\4
	swap	\3
	clr.w	\3
	mulu.w	\2,\4
	swap	\4
	clr.w	\4
	sub.l	\4,\1
	divu.w	\2,\1
	swap	\1
	clr.w	\1
	swap	\1
	add.l	\3,\1
	ENDM

divs32	MACRO
	move.l	\1,\3
	clr.w	\3
	swap	\3
	ext.l	\3
	divs.w	\2,\3
	move.w	\3,\4
	swap	\3
	clr.w	\3
	muls.w	\2,\4
	swap	\4
	clr.w	\4
	sub.l	\4,\1
	divs.w	\2,\1
	ext.l	\1
	add.l	\3,\1
	ENDM

; Fixed int macros (16 bits -> floating part)
; Warning : mul & div don't give always the right answer !

; fload A,B,ds
; ds = A / B
fload	MACRO
	move.l	#\1*65536+\2,\3
	ENDM

; fadd ea,ds
; Ds = ds + ea
fadd	MACRO
	add.l	\1,\2
	ENDM

; fsub ea,ds
; ds = ds - ea
fsub	MACRO
	sub.l	\1,\2
	ENDM

; fmulu ds1,ds2
fmulu	MACRO
	move.l	\1,-(a7)
	lsr.l	#8,\1
	lsr.l	#8,\2
	mulu.w	\1,\2
	move.l	(a7)+,\1
	ENDM
fmuls	MACRO
	move.l	\1,-(a7)
	asr.l	#8,\1
	asr.l	#8,\2
	muls.w	\1,\2
	move.l	(a7)+,\1
	ENDM

; fdivu A.f,B.f,dtmp1,dtmp2
; B = B / A
;fdivu	MACRO
;	movem.l	\1/\3/\4,-(a7)
;	clr.w	\4
;	move.l	\1,\3
;	swap	\3
;\@loop:		tst.w	\3
;		beq.s	\@done
;		addq.w	#1,\4
;		lsr.w	#1,\3
;		bra.s	\@loop
;\@done:	lsr.l	\4,\1
;	move.w	\4,-(a7)
;	divu32	\2,\1,\3,\4
;	move.w	(a7)+,\4
;	lsl.l	\4,\2
;	movem.l	(a7)+,\1/\3/\4
;	ENDM

fdivs	MACRO
	movem.l	\1/\3/\4,-(a7)
	asr.l	#8,\1
	divs32	\2,\1,\3,\4
	asl.l	#8,\2
	movem.l	(a7)+,\1/\3/\4
	ENDM

	endif

	ifnd	__STRUCT__INCLUDE__FILE__

__STRUCT__INCLUDE__FILE__	EQU	'1.00'

struct_data_offset	set	0		; Internal data variable


; Set one data in the struct
; Use:
;	rs	name,data_len
rs	MACRO
\1	EQU	struct_data_offset
struct_data_offset	set	struct_data_offset+\2
	ENDM

; Set one data in the struct, but you can't access it. It is a private data.
rs_no	MACRO
struct_data_offset	set	struct_data_offset+\2
	ENDM

; Make a synonimous of the next data in the struct
rs_sym	MACRO
\1	EQU	struct_data_offset
	ENDM

; Define a new struct
; Use:
;	NEW_STRUCT
NEW_STRUCT	MACRO
struct_data_offset	set	0
		ENDM

; Define a new structure with herited of a previous structure
; A child structure
; Use:
;	MULTI_STRUCT	NAME_OF_PARENT_STRUCT
MULTI_STRUCT	MACRO
struct_data_offset	set	\1
		ENDM

; End of the definition of a structur
; Use:
;	END_STRUCT	NAME_OF_STRUCT
END_STRUCT	MACRO
\1		set	struct_data_offset
		ENDM

; Example :
;	Define a coordinate struct, a point struct and a line struct

; NEW_STRUCT
; rs x,2
; rs y,2
; END_STRUCT coord_struct

; MULTI_STRUCT coord_struct
; rs color,2
; END_STRUCT point_struct

; NEW_STRUCT
; rs A,coord_struct
; rs A,coord_struct
; rs color,2
; END_STRUCT line_struct

; And to access it :
;	lea	Point_ptr(Pc),a0
;	move.w	x(a0),d0
;	move.w	y(a0),d1
	endif


