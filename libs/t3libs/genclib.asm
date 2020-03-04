; GENCLIB - Interface library with old C compilers
; Copyright 2000, 2001, 2002, 2003, 2004, 2005 Patrick Pelissier
;
; This file is part of the GENCLIB Library.
;
; The GENCLIB Library is free software; you can redistribute it and/or modify
; it under the terms of the GNU Lesser General Public License as published by
; the Free Software Foundation; either version 2.1 of the License, or (at your
; option) any later version.
;
; The GENCLIB Library is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
; License for more details.
;
; You should have received a copy of the GNU Lesser General Public License
; along with the MPFR Library; see the file COPYING.LIB.  If not, write to
; the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
; MA 02111-1307, USA.

_library	xdef	_library
_ti92plus	xdef	_ti92plus
_ti89		xdef	_ti89
_ti89ti		xdef	_ti89ti
_v200		xdef	_v200

_version01	xdef	_version01
		
	include "genlib.h"


	; Definitions des macros afin d'etre cool avec le C
func_new	macro
compt	set	4+5*4+5*4
	xdef	\1
\1	movem.l	d3-d7/a2-a6,-(a7)
	endm

arg	macro
\1	set	compt
compt	set	compt+\2
	endm	

func_end	macro
	movem.l	(a7)+,d3-d7/a2-a6
	rts
	endm


	; Les fonctions
	func_new	genclib@0000
	arg	Scr_adr,4
	arg	Hd_adr,2
	jsr	genlib::init_screen
	move.l	Scr_adr(a7),a1
	move.l	a0,(a1)
	move.l	Hd_adr(a7),a1
	move.w	d0,(a1)	
	func_end

	func_new	genclib@0001
	arg	Scr_adr,4
	arg	Hd_adr,2
	jsr	genlib::init_dscreen
	move.l	Scr_adr(a7),a1
	move.l	a0,(a1)
	move.l	Hd_adr(a7),a1
	move.w	d0,(a1)	
	func_end
		
	func_new	genclib@0002
	arg	Cond,2
	move.w	Cond(a7),d0
	jsr	genlib::set_filter
	func_end
	
	func_new	genclib@0003
	arg	x,2
	arg	y,2
	arg	color,2
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.w	color(a7),d3
	jsr	genlib::put_pixel
	func_end

	func_new	genclib@0004
	arg	x,2
	arg	y,2
	arg	r,2
	arg	color,2
	move.w	x(a7),d4
	move.w	y(a7),d5
	move.w	color(a7),d3
	move.w	r(a7),d2
	jsr	genlib::draw_circle
	func_end
	
	func_new	genclib@0005
	arg	x,2
	arg	y,2
	arg	r,2
	arg	color,2
	move.w	x(a7),d4
	move.w	y(a7),d5
	move.w	color(a7),d3
	move.w	r(a7),d2
	jsr	genlib::draw_clipped_circle
	func_end

	func_new	genclib@0006
	arg	oct,1
	move.b	oct(a7),d0
	jsr	genlib::send_byte
	func_end
	
	func_new	genclib@0007
	arg	Buffer_recpt,4
	arg	Buffer_send,4
	arg	LenR,2
	arg	LenS,2
	move.w	LenR(a7),d0
	move.w	LenS(a7),d1
	move.l	Buffer_recpt(a7),a1
	move.l	Buffer_send(a7),a2
	jsr	genlib::set_link
	func_end
	
	func_new	genclib@0008
	arg	x,2
	arg	y,2
	move.w x(a7),genlib::sprite_scr_x
	move.w y(a7),genlib::sprite_scr_y
	func_end

	func_new	genclib@0009
	arg	adr,4
	move.l	adr(a7),genlib::sprite_tile_adr
	func_end

	func_new	genclib@000A
	arg	Scr,4
	arg	x,2
	arg	y,2
	arg	str,4
	move.l	Scr(a7),a1
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.l	str(a7),a0
	jsr	genlib::put_small_string
	func_end
	
	func_new	genclib@000B
	arg	Scr,4
	arg	x,2
	arg	y,2
	arg	str,4
	move.l	Scr(a7),a1
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.l	str(a7),a0
	jsr	genlib::put_medium_string
	func_end

	func_new	genclib@000C
	arg	Scr,4
	arg	x,2
	arg	y,2
	arg	str,4
	move.l	Scr(a7),a1
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.l	str(a7),a0
	jsr	genlib::put_large_string
	func_end

	func_new	genclib@000D
	arg	x,2
	arg	y,2
	arg	bgs,4
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.l	bgs(a7),a0
	jsr	genlib::put_big_sprite
	func_end

	func_new	genclib@000E
	arg	x,2
	arg	y,2
	arg	bgs,4
	arg	tmp,4
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.l	bgs(a7),a1
	move.l	tmp(a7),a0
	jsr	genlib::put_big_sprite_flip_h
	func_end

	func_new	genclib@000F
	arg	x,2
	arg	y,2
	arg	bgs,4
	arg	tmp,4
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.l	bgs(a7),a1
	move.l	tmp(a7),a0
	jsr	genlib::put_big_sprite_flip_v
	func_end

	func_new	genclib@0010
	arg	x,2
	arg	y,2
	arg	bgs,4
	arg	tmp,4
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.l	bgs(a7),a1
	move.l	tmp(a7),a0
	jsr	genlib::put_big_sprite_flip_hv
	func_end

	func_new	genclib@0011
	arg	x,2
	arg	y,2
	arg	nbr,2
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.w	nbr(a7),d2
	jsr	genlib::put_sprite_16
	func_end

	func_new	genclib@0012
	arg	x,2
	arg	y,2
	arg	nbr,2
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.w	nbr(a7),d2
	jsr	genlib::put_sprite_16_flip_h
	func_end

	func_new	genclib@0013
	arg	x,2
	arg	y,2
	arg	nbr,2
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.w	nbr(a7),d2
	jsr	genlib::put_sprite_16_flip_v
	func_end

	func_new	genclib@0014
	arg	x,2
	arg	y,2
	arg	nbr,2
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.w	nbr(a7),d2
	jsr	genlib::put_sprite_16_flip_hv
	func_end

	func_new	genclib@0015
	arg	scr1,4
	arg	scr2,4
	arg	scr3,4
	move.l	scr1(a7),d0
	move.l	scr2(a7),d1
	move.l	scr3(a7),d2
	jsr	genlib::set_screen_int
	func_end

	func_new	genclib@0016
	arg	dscr,4
	move.l	dscr(a7),d0
	jsr	genlib::set_dscreen_int
	func_end

	func_new	genclib@0017
	arg	dscr,4
	move.l	dscr(a7),d0
	jsr	genlib::set_dscreen_function
	func_end

	func_new	genclib@0018
	arg	hd,2
	move.w	hd(a7),d0
	jsr	genlib::push_hd
	func_end

	func_new	genclib@0019
	arg	spr,4
	arg	fspr,4
	move.l	spr(a7),a0
	move.l	fspr(a7),a1
	jsr	genlib::make_fast_sprite
	func_end
	
	func_new	genclib@001A
	arg	map,4
	arg	tile,4
	arg	sizex,2
	move.l	map(a7),a3
	move.l	tile(a7),a4
	suba.l	a5,a5
	move.w	sizex(a7),d3
	jsr	genlib::init_plane
	func_end
	
	func_new	genclib@001B
	arg	plane,4
	move.l	plane(a7),a0
	jsr	genlib::free_plane
	func_end
	
	func_new	genclib@001C
	arg	plane,4
	move.l	plane(a7),a0
	jsr	genlib::refresh_plane
	func_end

	func_new	genclib@001D
	arg	plane,4
	move.l	plane(a7),a0
	jsr	genlib::copy_xyplane_xysprite
	func_end

	func_new	genclib@001E
	arg	plane,4
	arg	dscr,4
	move.l	plane(a7),a0
	move.l	dscr(a7),a1
	jsr	genlib::copy_dscreen_vscreen
	func_end

	func_new	genclib@001F
	arg	plane,4
	move.l	plane(a7),a0
	jsr	genlib::update_vscreen_8
	func_end

	func_new	genclib@0020
	arg	plane,4
	move.l	plane(a7),a0
	jsr	genlib::update_vscreen_16
	func_end

	func_new	genclib@0021
	arg	plane,4
	move.l	plane(a7),a0
	jsr	genlib::update_roll_vscreen_16
	func_end

	func_new	genclib@0022
	arg	plane,4
	move.l	plane(a7),a0
	jsr	genlib::update_vscreen_max16
	func_end

	func_new	genclib@0023
	arg	plane,4
	move.l	plane(a7),a0
	jsr	genlib::put_plane
	func_end

	func_new	genclib@0024
	arg	plane,4
	move.l	plane(a7),a0
	jsr	genlib::put_plane_89
	func_end

	func_new	genclib@0025
	arg	plane,4
	move.l	plane(a7),a0
	jsr	genlib::put_fgrd_plane
	func_end

	func_new	genclib@0026
	arg	plane,4
	move.l	plane(a7),a0
	jsr	genlib::put_fgrd_plane_89
	func_end

	func_new	genclib@0027
	arg	plane,4
	arg	dhz,4
	arg	hdz,4
	move.l	plane(a7),a0
	move.l	dhz(a7),a4
	move.l	hdz(a7),a5
	jsr	genlib::put_dhz_plane
	func_end

	func_new	genclib@0028
	arg	plane,4
	arg	dhz,4
	arg	hdz,4
	move.l	plane(a7),a0
	move.l	dhz(a7),a4
	move.l	hdz(a7),a5
	jsr	genlib::put_dhz_plane_89
	func_end

	func_new	genclib@0029
	arg	plane,4
	arg	dhz,4
	arg	hdz,4
	move.l	plane(a7),a0
	move.l	dhz(a7),a6
	move.l	hdz(a7),d7
	jsr	genlib::put_dhz_fgrd_plane
	func_end

	func_new	genclib@002A
	arg	plane,4
	arg	dhz,4
	arg	hdz,4
	move.l	plane(a7),a0
	move.l	dhz(a7),a6
	move.l	hdz(a7),d7
	jsr	genlib::put_dhz_fgrd_plane_89
	func_end

	func_new	genclib@002B
	arg	x,2
	arg	y,2
	arg	bgs,4
	arg	hf,4
	arg	vf,4
	move.l	bgs(a7),a1
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.l	hf(a7),d4
	move.l	vf(a7),d5
	jsr	genlib::put_big_sprite_zoom
	func_end

	func_new	genclib@002C
	arg	x,2
	arg	y,2
	arg	no,2
	arg	hf,4
	arg	vf,4
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.w	no(a7),d2
	move.l	hf(a7),d4
	move.l	vf(a7),d5
	jsr	genlib::put_big_sprite_zoom
	func_end

	func_new	genclib@002D
	arg	ptr1,4
	arg	ptr2,4
	arg	ptr3,4
	arg	scr,4
	move.l	ptr1(a7),a1
	move.l	ptr2(a7),a2
	move.l	ptr3(a7),a3
	move.l	scr(a7),a4
	jsr	genlib::draw_face
	func_end

	func_new	genclib@002E
	arg	ptr1,4
	arg	ptr2,4
	arg	ptr3,4
	arg	scr,4
	move.l	ptr1(a7),a1
	move.l	ptr2(a7),a2
	move.l	ptr3(a7),a3
	move.l	scr(a7),a4
	jsr	genlib::draw_clipped_face
	func_end

	func_new	genclib@002F
	arg	ptr1,4
	arg	ptr2,4
	arg	ptr3,4
	arg	color,2
	move.l	ptr1(a7),a1
	move.l	ptr2(a7),a2
	move.l	ptr3(a7),a3
	move.w	color(a7),d0
	jsr	genlib::draw_c_face
	func_end

	func_new	genclib@0030
	arg	ptr1,4
	arg	ptr2,4
	arg	ptr3,4
	arg	color,2
	move.l	ptr1(a7),a1
	move.l	ptr2(a7),a2
	move.l	ptr3(a7),a3
	move.w	color(a7),d0
	jsr	genlib::draw_clipped_c_face
	func_end

	func_new	genclib@0031
	arg	x,2
	arg	y,2
	arg	hf,4
	arg	vf,4
	arg	hw,2
	arg	vw,2
	arg	scr,4
	arg	text,4
	arg	text_inc,2
	
	move.w	hw(a7),d6
	swap	d6
	move.w	vw(a7),d6
	move.l	hf(a7),d4
	move.l	vf(a7),d5
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.l	scr(a7),a0
	move.l	text(a7),a1
	lea	(30).w,a3
	move.w	text_inc(a7),a4
	jsr	genlib::do_zoom	
	func_end

	func_new	genclib@0032
	arg	x1_ptr,4
	arg	y1_ptr,4
	arg	x2_ptr,4
	arg	y2_ptr,4
	move.l	x1_ptr(a7),a0
	move.l	x2_ptr(a7),a2
	move.l	y1_ptr(a7),a1
	move.l	y2_ptr(a7),a3
	move.w	(a0),d0
	move.w	(a1),d1
	move.w	(a2),d2
	move.w	(a3),d3
	jsr	genlib::clip_line
	move.w	d0,(a0)
	move.w	d1,(a1)
	move.w	d2,(a2)
	move.w	d3,(a3)
	move.w	d4,d0
	func_end
	
	func_new	genclib@0033
	arg	x1,2
	arg	y1,2
	arg	x2,2
	arg	y2,2
	arg	color,2
	move.w	x1(a7),d0
	move.w	x2(a7),d2
	move.w	y1(a7),d1
	move.w	y2(a7),d3
	move.w	color(a7),d5
	jsr	genlib::draw_line
	func_end

	func_new	genclib@0034
	arg	x1,2
	arg	y1,2
	arg	x2,2
	arg	y2,2
	arg	color,2
	move.w	x1(a7),d0
	move.w	x2(a7),d2
	move.w	y1(a7),d1
	move.w	y2(a7),d3
	move.w	color(a7),d5
	jsr	genlib::draw_clipped_line
	func_end

	func_new	genclib@0035
	arg	x1,2
	arg	x2,2
	arg	y,2
	move.w	x1(a7),d0
	move.w	x2(a7),d1
	move.w	y(a7),d3
	jsr	genlib::draw_bwhline_b
	func_end

	func_new	genclib@0036
	arg	x1,2
	arg	x2,2
	arg	y,2
	move.w	x1(a7),d0
	move.w	x2(a7),d1
	move.w	y(a7),d3
	jsr	genlib::draw_bwhline_w
	func_end

	func_new	genclib@0037
	arg	x1,2
	arg	x2,2
	arg	y,2
	move.w	x1(a7),d0
	move.w	x2(a7),d1
	move.w	y(a7),d3
	jsr	genlib::draw_hline_w
	func_end

	func_new	genclib@0038
	arg	x1,2
	arg	x2,2
	arg	y,2
	move.w	x1(a7),d0
	move.w	x2(a7),d1
	move.w	y(a7),d3
	jsr	genlib::draw_hline_lg
	func_end

	func_new	genclib@0039
	arg	x1,2
	arg	x2,2
	arg	y,2
	move.w	x1(a7),d0
	move.w	x2(a7),d1
	move.w	y(a7),d3
	jsr	genlib::draw_hline_dg
	func_end

	func_new	genclib@003A
	arg	x1,2
	arg	x2,2
	arg	y,2
	move.w	x1(a7),d0
	move.w	x2(a7),d1
	move.w	y(a7),d3
	jsr	genlib::draw_hline_b
	func_end

	func_new	genclib@003B
	arg	ptr1,4
	arg	ptr2,4
	arg	ptr3,4
	arg	func_ptr,4
	move.l	ptr1(a7),a1
	move.l	ptr2(a7),a2
	move.l	ptr3(a7),a3
	move.l	func_ptr(a7),callback
	lea	hline_callback(pc),a6
	jsr	genlib::render_triangle
	func_end

hline_callback:
	move.w	d3,-(a7)
	move.w	d1,-(a7)
	move.w	d0,-(a7)
	move.l	callback(pc),a0
	jsr	(a0)
	addq.l	#6,a7
	rts
callback	dc.l	0

	func_new	genclib@003C
	arg	x,2
	arg	y,2
	arg	r,2
	arg	color,2
	move.w	x(a7),d4
	move.w	y(a7),d5
	move.w	color(a7),d3
	move.w	r(a7),d2
	jsr	genlib::draw_disk
	func_end

	func_new	genclib@003D
	arg	x,2
	arg	y,2
	arg	r,2
	arg	color,2
	move.w	x(a7),d4
	move.w	y(a7),d5
	move.w	color(a7),d3
	move.w	r(a7),d2
	jsr	genlib::draw_clipped_disk
	func_end

	func_new	genclib@003E
	arg	x,2
	arg	y,2
	arg	r,2
	arg	callb,4
	move.w	x(a7),d4
	move.w	y(a7),d5
	move.l	callb(a7),callback
	move.w	r(a7),d2
	lea	hline_callback(pc),a2
	jsr	genlib::render_disk
	func_end

	func_new	genclib@003F
	arg	scr,4
	arg	pattern,4
	move.l	pattern(a7),d0
	move.l	scr(a7),a0
	jsr	genlib::fill_screen
	func_end
	
	func_new	genclib@0040
	arg	x1,2
	arg	x2,2
	arg	y,2
	move.w	x1(a7),d0
	move.w	x2(a7),d1
	move.w	y(a7),d3
	jsr	genlib::draw_hline_light
	func_end

	func_new	genclib@0041
	arg	str,4
	arg	bgs,4
	move.l	str(a7),a0
	move.l	bgs(a7),a1
	jsr	genlib::create_bgs_string
	func_end

	func_new	genclib@0042
	arg	pal,2
	arg	src,2
	arg	dest,2
	move.w	pal(a7),d0
	move.w	src(a7),d1
	move.w	dest(a7),d2
	jsr	genlib::pal_sprite_16
	func_end

	func_new	genclib@0043
	arg	x1,2
	arg	x2,2
	arg	y,2
	move.w	x1(a7),d0
	move.w	x2(a7),d1
	move.w	y(a7),d3
	jsr	genlib::draw_hline_shadow
	func_end

	func_new	genclib@0044
	arg	x,2
	arg	y,2
	arg	nbr,2
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.w	nbr(a7),d2
	jsr	genlib::put_mask_spr16
	func_end

	func_new	genclib@0045
	arg	x,2
	arg	y,2
	arg	nbr,2
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.w	nbr(a7),d2
	jsr	genlib::put_mask_spr16_flip_h
	func_end

	func_new	genclib@0046
	arg	x,2
	arg	y,2
	arg	nbr,2
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.w	nbr(a7),d2
	jsr	genlib::put_mask_spr16_flip_v
	func_end

	func_new	genclib@0047
	arg	x,2
	arg	y,2
	arg	nbr,2
	move.w	x(a7),d0
	move.w	y(a7),d1
	move.w	nbr(a7),d2
	jsr	genlib::put_mask_spr16_flip_hv
	func_end

	end
	
