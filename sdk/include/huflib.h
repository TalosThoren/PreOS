	include "ziplib.h"
	
;----------------------------------------------------------------------------
; extract()
;
; Function: Extracts data (huffman compression)
;
; Input:    A0   = Pointer to huffman compressed data
;           A1   = Pointer to where the uncompressed data should be stored
;           D3.W = File number to extract (not necessary if not multifile)
;----------------------------------------------------------------------------
hufflib::extract	equ	ziplib::extract

;----------------------------------------------------------------------------
; extract_string()
;
; Function: Extracts a string from huffman compressed data
;
; Input:    A0   = Pointer to huffman compressed data
;           A1   = Pointer to where the string should be stored
;           D3.W = File number to extract (not necessary if not multifile)
;           D4.W = String number. First string = number 0
;----------------------------------------------------------------------------
hufflib::extract_string	equ	ziplib::extract_string

;----------------------------------------------------------------------------
; write_string()
;
; Function: Writes a compressed string with the current font. The string
;           should not be longer than 80 characters.
;
; Input:    A0   = Pointer to huffman compressed data
;           D0.W = x location
;           D1.W = y location
;           D3.W = File number to extract (not necessary if not multifile)
;           D4.W = String number. First string = number 0
;----------------------------------------------------------------------------
hufflib::write_string	equ	ziplib::write_string

;----------------------------------------------------------------------------
; write_string_inv()
;
; Function: Writes a compressed string with the current font (inverted color)
;           The string should not be longer than 80 characters.
;
; Input:    A0   = Pointer to huffman compressed data
;           D0.W = x location
;           D1.W = y location
;           D3.W = File number to extract (not necessary if not multifile)
;           D4.W = String number. First string = number 0
;----------------------------------------------------------------------------
hufflib::write_string_inv	equ	ziplib::write_string_inv

;----------------------------------------------------------------------------
; check_mem()
;
; Function: Checks if there are enough memory (about 1100 bytes) free for
;           uncompression
;
; Output:   D0.W = 0 if NOT enough memory
;           D0.W = 1 if enough memory
;----------------------------------------------------------------------------
hufflib::check_mem	equ	ziplib::check_mem
