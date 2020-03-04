	include	"tios.h"
	xdef	_library
	xdef	_ti92plus
	xdef	_ti89
	xdef	_ti89ti
	xdef	_v200

	DEFINE	_version01
	xdef	hexlib@0000
	xdef	hexlib@0001
	xdef	hexlib@0002

;************** Start of Fargo library ***************
;Originally written by David Ellsworth for Fargo

hexlib@0000:
put_char:
	movem.l d1-d3/a0-a1,-(a7)

	lsl.l	#3,d0
	lea	numbers(pc),a0		; a0 -> numbers + 8*char
	add.l	d0,a0

	lea	LCD_MEM,a1
	lsl.l	#4,d1
	move.l	d1,d0
	lsl.l	#4,d0
	sub.l	d1,d0
	add.l	d2,d0
	add.l	d0,a1

	moveq		#30,d1                  ; 30 bytes per pixel row
	moveq		#7,d2			; 8 bytes per character
put_char_loop:
	move.b	(a0)+,(a1)
	add.l	d1,a1
	dbf.w	d2,put_char_loop

	movem.l (a7)+,d1-d3/a0-a1
	rts

;*****************************************************

hexlib@0001:                       
put_bin:
	movem.l	d3-d5,-(a7)

put_bin_loop:
	move.l	d0,d5			; save number
	lsr.l	d4,d0
	and.l	#1,d0
	bsr	put_char
	move.l	d5,d0			; restore number
	addq.l	#1,d2			; increment column
	dbf.w	d4,put_bin_loop

	movem.l	(a7)+,d3-d5
	rts

;*****************************************************

hexlib@0002:
put_hex:
	movem.l	d3-d5,-(a7)

put_hex_loop:
	move.l	d0,d5			; save number
	move.l	d4,d3
	lsl.l	#2,d3			; d3 = 4*loopcount (# bits to shift)
	lsr.l	d3,d0
	and.l	#$0000000F,d0
	bsr	put_char
	move.l	d5,d0			; restore number
	addq.l	#1,d2			; increment column
	dbf.w	d4,put_hex_loop

	movem.l	(a7)+,d3-d5
	rts

;*****************************************************
; NUMBER CHARACTER DATA
;*****************************************************
numbers:
	dc.b %01111100	* 0
	dc.b %11000110
	dc.b %11000110
	dc.b %11010110
	dc.b %11000110
	dc.b %11000110
	dc.b %01111100
	dc.b %00000000

	dc.b %00011000	* 1
	dc.b %00111000
	dc.b %01111000
	dc.b %00011000
	dc.b %00011000
	dc.b %00011000
	dc.b %01111110
	dc.b %00000000

	dc.b %01111100	* 2
	dc.b %11000110
	dc.b %00000110
	dc.b %00111100
	dc.b %01100000
	dc.b %11000000
	dc.b %11111110
	dc.b %00000000

	dc.b %11111110	* 3
	dc.b %00000110
	dc.b %00001100
	dc.b %00111100
	dc.b %00000110
	dc.b %11000110
	dc.b %01111100
	dc.b %00000000

	dc.b %00011100	* 4
	dc.b %00111100
	dc.b %01101100
	dc.b %11001100
	dc.b %11111110
	dc.b %00001100
	dc.b %00001100
	dc.b %00000000

	dc.b %11111110	* 5
	dc.b %11000000
	dc.b %11000000
	dc.b %11111100
	dc.b %00000110
	dc.b %11000110
	dc.b %01111100
	dc.b %00000000

	dc.b %00111100	* 6
        dc.b %01100000
	dc.b %11000000
	dc.b %11111100
	dc.b %11000110
	dc.b %11000110
	dc.b %01111100
	dc.b %00000000

	dc.b %11111110	* 7
	dc.b %00000110
	dc.b %00001100
	dc.b %00011000
	dc.b %00110000
	dc.b %01100000
	dc.b %11000000
	dc.b %00000000

	dc.b %01111100	* 8
	dc.b %11000110
	dc.b %11000110
	dc.b %01111100
	dc.b %11000110
	dc.b %11000110
	dc.b %01111100
	dc.b %00000000

	dc.b %01111100	* 9
	dc.b %11000110
	dc.b %11000110
	dc.b %01111110
	dc.b %00000110
	dc.b %00001100
	dc.b %01111000
	dc.b %00000000

	dc.b %00111000	* A
	dc.b %01101100
	dc.b %11000110
	dc.b %11111110
	dc.b %11000110
	dc.b %11000110
	dc.b %11000110
	dc.b %00000000

	dc.b %11111100	* B
	dc.b %11000110
	dc.b %11000110
	dc.b %11111100
	dc.b %11000110
	dc.b %11000110
	dc.b %11111100
	dc.b %00000000

	dc.b %00111100	* C
	dc.b %01100110
	dc.b %11000000
	dc.b %11000000
	dc.b %11000000
	dc.b %01100110
	dc.b %00111100
	dc.b %00000000

	dc.b %11111000	* D
	dc.b %11001100
	dc.b %11000110
	dc.b %11000110
	dc.b %11000110
	dc.b %11001100
	dc.b %11111000
	dc.b %00000000

	dc.b %11111110	* E
	dc.b %11000000
	dc.b %11000000
	dc.b %11111000
	dc.b %11000000
	dc.b %11000000
	dc.b %11111110
	dc.b %00000000

	dc.b %11111110	* F
	dc.b %11000000
	dc.b %11000000
	dc.b %11111000
	dc.b %11000000
	dc.b %11000000
	dc.b %11000000
	dc.b %00000000

;*****************************************************

;*****************************************************

	end
