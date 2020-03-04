	include "userlib.h"
	include "graphlib.h"

util@version01		xdef	util@version01

util::find_pixel 	equ util@0000
util::pixel_on 		equ util@0001
util::pixel_off 	equ util@0002
util::pixel_chg 	equ util@0003
util::prep_rect 	equ util@0004
util::frame_rect 	equ graphlib::frame_rect
util::erase_rect 	equ graphlib::erase_rect
util::show_dialog 	equ graphlib::show_dialog
util::clear_dialog 	equ graphlib::clear_dialog
util::clr_scr 		equ graphlib::clr_scr2
util::zap_screen 	equ graphlib::clr_scr
util::idle_loop 	equ userlib::idle_loop
util::random 		equ userlib::random
util::DrawCharXY 	equ userlib::DrawCharXY
util::exec 		equ kernel::exec
util::FindSymEntry 	equ userlib::FindSymEntry
util::rand_seed 	equ userlib::rand_seed
util::InitFargoCompatibility equ util@0011
util::DeinitFargoCompatibility equ util@0012
util::__SF_font 	equ util@0013 ;FargoII binary compat only
util::FillRect		equ util@0014

flib::find_pixel	equ util::find_pixel
flib::pixel_on		equ util::pixel_on
flib::pixel_off		equ util::pixel_off
flib::pixel_chg 	equ util::pixel_chg
flib::prep_rect		equ util::prep_rect
flib::frame_rect	equ util::frame_rect
flib::erase_rect	equ util::erase_rect
flib::show_dialog	equ util::show_dialog
flib::clear_dialog	equ util::clear_dialog
flib::clr_scr		equ util::clr_scr
flib::zap_screen	equ util::zap_screen
flib::idle_loop		equ util::idle_loop
flib::random		equ util::random
flib::rand_seed		equ util::rand_seed
tios::DrawCharXY	equ util::DrawCharXY

tios::FindSymEntry	equ util::FindSymEntry
