; SHRINK92 - Copyright 1998, 1999 David Kuehling
; Adaptation for TI-89/92+ - Copyright 2002, 2003, 2004, 2005 Patrick Pelissier
;
; This file is part of the SHRINK92 Library.
;
; The SHRINK92 Library is free software; you can redistribute it and/or modify
; it under the terms of the GNU Lesser General Public License as published by
; the Free Software Foundation; either version 2.1 of the License, or (at your
; option) any later version.
;
; The SHRINK92 Library is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
; License for more details.
;
; You should have received a copy of the GNU Lesser General Public License
; along with the MPFR Library; see the file COPYING.LIB.  If not, write to
; the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
; MA 02111-1307, USA.

; Version : 1.00.P4 by Patrick Pelissier Feb 10 2005
; Version : 1.00.P3 by Patrick Pelissier Nov 10 2004
; Version : 1.00.P2 by Patrick Pelissier Nov 24 2003

		include tios.h

		xdef	_library
		xdef	shrnklib@0000
		xdef	shrnklib@0001
		xdef	shrnklib@0002

	ifd	CALC_TI92PLUS
		xdef	shrnklib@0003
		xdef	_ti89
		xdef	_ti89ti
		xdef	_ti92plus
		xdef	_v200
		DEFINE	_version03
	endif

RLE_ESC		EQU	256
RLE_BITS	EQU	5
REP_ESC		EQU	257
START_REP_BITS	EQU	4
START_REP_CODES	EQU	16
REP_CODES	EQU	64
MIN_REP		EQU	3
CODES		EQU	256+REP_CODES+1


;; **
;  tios::DEREF d0,a0 as routine (for reducing program size)
; /
DEREF_d0_a0:
	tios::DEREF	d0,a0
	rts

;; **
;  tios::DEREF d0,a3 as routine (for reducing program size)
; /
DEREF_d0_a3:
	exg.l	a0,a3
	bsr.s	DEREF_d0_a0
	exg.l	a0,a3
	rts

;; **************************************************************************
;  OpenArchive
; --------------------------------------------------------------------------
;  Input:  a0.l = pointer to archive
;  Output: d0.w = handle of archive descriptor or zero on error
; /
shrnklib@0000:
OpenArchive:	movem.l	d1-d7/a0-a6,-(a7)	
		movea.l	a7,a6			;  a6 = saved SP for removing stack arguments later
		movea.l	a0,a2			;  a2 = pointer to archive (a2 isn't modified by ROM functions)

	;; ***** Initialize The Table Of The Unresolved Leaves/Junctions; /
		;  Table's format: <weight (word)> <address (word)> ...
                ;   <address>: pointer,relative to the huffman tree's begin
                ;              if the MSB is set: it represents a compression CODE (character)
		; /
	     ;;  allocate memory for the table; /
		pea	(CODES*4).w		;  shorter than 'move.l #CODES*4,-(a7)'
		bsr	HeapAlloc		;  (jsr tios::HeapAlloc)
		move.w	d0,d4			;  d4 = handle of that (temporary) table
		beq.s	\Error
		bsr.s	DEREF_d0_a3		;  a3 = pointer to that table
		
	     ;;  uncompress frequency table from archive's begin into that table; /
		;  a2 = pointer to archive begin (RLE compressed freqency table; each byte is a frequency) -- input
		;  a3 = pointer to Unresolved Table -- output
		move.w	#$8000,d7		;  d7 = <address>-counter (code | 0x8000)
		movea.l	a3,a1			;  a1 = output-pointer (is increased whereas a3 points to the table's begin)
		clr.w	d1			;  d1.w = one byte (high byte has to be cleared)
		moveq	#-1,d3			;  d3.w = number of entries in table - 1
\ExtrFreqLoop:	moveq	#0,d0			   ;  d0 = RLE repetition length - 1 (0 = ONE character -- no RLE)
		move.b	(a2)+,d1		   ;  d1 = current byte / RLE ESC byte
		cmpi.w	#$E0,d1 		   ;  is it an RLE ESC character ?
		blt.s	\__RLEloop		      ;  (if it isn't: cylcle one time through RLE loop)
		andi.w	#$001F,d1		      ;  extract RLE length from RLE ESC byte
		move.w	d1,d0			 
		move.b	(a2)+,d1		      ;  read RLE byte
\__RLEloop:	tst.w	d1			         ;  don't add entries with a frequency of zero
		beq.s	\____Skip
		move.w	d1,(a1)+                        ;  copy frequency and <address> (d7) to output table (a1)
		move.w	d7,(a1)+
		addq.w	#1,d3			         ;  (d3 = number of table entries)
\____Skip:	addq.w	#1,d7
		dbra	d0,\__RLEloop
		cmpi.w	#CODES+$8000,d7
		blt.s	\ExtrFreqLoop

	     ;;  align input address on even address; /
	     ;; Skip also the stored size of the archive descriptor: it isn't safe and reliable to use it. Instead recompute it
	     ;; It should be (4+2+4*unresNum) with unresNum=d3+1, but it isn't safe to assume it is correct.
		move.l	a2,d1
		addq.l	#3,d1
		bclr.l	#0,d1
		movea.l	d1,a2

	;; ***** Create Archive Descriptor,Containing the Huffman Tree; /
		;  d3 = number of entries in Table of Unresolved Elements - 1
		;  d4 = handle of Table of Unresolved Elements
		;  a2 = aligned pointer directly after the RLE compressed frequency table in the input archive
		;  a3 = pointer to first entry in Table of Unresolved Elements
	     ;;  allocate memory for archive descriptor; /
;		move.w	(a2)+,-(a7) ;  at the current position in the archive the size of the descriptor is stored
;		clr.w	-(a7)			;  it is a long value
		move.w	d3,d0			; Compute 6+(d3+1)*4
		addq.w	#1,d0			; The highest bits of d0 are already cleared
		lsl.w	#2,d0
		addq.w	#6,d0
		move.l	d0,-(a7)
		bsr.s	HeapAlloc		;  (jsr tios::HeapAlloc)		
		move.w	d0,d5			;  d5 = handle of archive descriptor
		beq.s	\Error
		bsr.s	DEREF_d0_a0		;  a0 = pointer to archive descriptor

		move.l	a2,(a0)+		;  store archive address into descriptor
		movea.l	a0,a1			;  a1 = working pointer; a0 = pointer to huffman tree
		clr.w	(a1)+			;  leave space for root pointer

	     ;;  create the huffman tree; /
\HuffTreeLoop:	;;  find the two elements with the lowest weight; /
		bsr.s	\GetMinWeight		   ;  a2 = pointer to min element; d0 = its weight
		move.w	d0,d2			   ;  d2 = lowest weight 1
		move.w	2(a2),d6		   ;  d6 = relative pointer to lowest elm 1
		move.l	(a3)+,(a2) 	           ;  "delete" element from unresolved list (replace it by first elm)
		subq.w	#1,d3			   ;  decrease number of entries
		bmi.s	\HuffTreeEnd		   ;  if number of entries was #1: end of Huffman Tree creation
		bsr.s	\GetMinWeight		   ;  a2 = pointer to min element; d0 = it's weight
	
		;;  replace that element by a newly created junction of the two min elements; /
		;  d2 = lowest weight1
		;  d6 = relative pointer to lowest elm 1
		;  a2 = pointer to entry of loweset elm1 in unresolved table: (a2) = weight; 2(a2) = pointer
		add.w	d2,(a2)+		   ;  weight of min2 += weight of min1
		move.l	a1,d1		   	   ;  d1 = relative address of new junction
		sub.l	a0,d1
		move.w	d6,(a1)+		   ;  new Huffman Tree element: set left branch of junction
		move.w	(a2),(a1)+		   ;                            set right branch of junction
		move.w	d1,(a2)		   ;  entry in Unresolved Table: set the pointer to the Huffman Tree element
		bra.s	\HuffTreeLoop		   ;  continue...
	
\HuffTreeEnd:	move.w	d6,(a0)  		;  store root pointer to archive descriptor

	     ;;  free the Table of Unresolved Elements; /
		move.w	d4,-(a7)
		bsr.s	HeapFree

		move.w	d5,d0			;  d0 = handle of archive descriptor
\Error:		movea.l	a6,a7			;  restore stored a7 -- remove all stack elements
		movem.l	(a7)+,d1-d7/a0-a6	;  restore registers
		rts
	; 
 	;  Get the element witht the minimum weight in the table of unresolved tree elements.
 	;  Input:  a3 = pointer to first table entry
	;          d3 = number of entries - 1
  	;  Output: a2 = pointer to element with the minimum weight < 32767 or NULL if no such elements are left
	;          d0 = minimum weight 
	;  a4/d1 destroyed!
	; /
\GetMinWeight:	moveq	#-1,d0			;  d0 = minimum weight = 32768 (unsigned)
		move.w	d3,d1			;  d1 = counter
		movea.l	a3,a4			;  a4 = scanning pointer
\CmpLoop:	cmp.w	(a4),d0		   ;  current element's weight less than minimum weight ?
		bls.s	\__NotLess
		movea.l	a4,a2			   ;  minimum element found: update a2 and d0
		move.w	(a4),d0
\__NotLess:	addq.l	#4,a4			   ;  go to next element
		dbra	d1,\CmpLoop
		rts


;; **
;  Routine that executes tios::HeapFree. Since a bsr is shorter than a jsr this will shorten the program a bit.
; /
HeapFree:	jmp	tios::HeapFree		;  return is done from tios::HeapFree

;; **
;  Routine that executes tios::HeapAlloc. Since a bsr is shorter than a jsr this will shorten the program a bit.
; /
HeapAlloc:	jmp	tios::HeapAlloc		;  return is done from tios::HeapAlloc

;; *************************************************************************************************
;  CloseArchive
; --------------------------------------------------------------------------------------------------
;  Input:  d0.w = handle of archive descriptor 
; /
shrnklib@0001:
CloseArchive:	movem.l	d0-d2/d4/a0-a1,-(a7)	;  store the registers,used by ROM routines
		move.w	d0,-(a7)		;  just free the handle 
		bsr.s	HeapFree
		addq.l	#2,a7
		movem.l	(a7)+,d0-d2/d4/a0-a1
		rts

;; *************************************************************************************************
;  Bitwise Input
; /
;; *************************************************************************************************
;  ReadBit
; --------------------------------------------------------------------------------------------------
;  Input:  a2.l = pointer to next byte
; 	   d0.b = contents of current byte
; 	   d1.b = last bit number
;  Output: zeroflag set or cleared,depending on value of bit,
;          a2,d0,d1 adjusted to current bit
; /
ReadBit:	addq.b	#1,d1			;  increase bit number  --  go to current bit
		cmpi.b	#8,d1			;  bit outside of current byte ?
		blt.s	\SameByte
			move.b	(a2)+,d0	;  read new byte,begin again with bit #0
			clr.b	d1
\SameByte:	btst.l	d1,d0			;  test bit -- set zero flag accordingly
		rts

;; *************************************************************************************************
;  ReadNBits
; --------------------------------------------------------------------------------------------------
;  Input:  a2.l = pointer to next byte
; 	   d0.b = contents of current byte
; 	   d1.b = last bit number
;          d7.w = number of bits to read
;  Output: a2,d0,d1 adjusted to last bit of bits read
;          d7 = -1 
;          d6 = read bits (first read bit is high bit)
; /
ReadNBits:	subq.w	#1,d7			;  d7 = counter
		moveq	#0,d6			;  d6 = bits

\ReadLoop:	add.l	d6,d6			  ;  create space for a new bit in d6 (initialized to zero)
		bsr.s	ReadBit		 	  ;  read a bit
		beq.s	\__ZeroBit		  ;  set new bit in 'd6' accordingly
			bset.l	#0,d6
\__ZeroBit:	dbra	d7,\ReadLoop
		rts
		

;; *************************************************************************************************
;  Extract
; --------------------------------------------------------------------------------------------------
;  Input:  d0.w = handle of archive descriptor
; 	   d1.w = index of section to extract
;          a0.l = address of extraction destination; if it is zero,a memory block of the right size
;                 is automatically allocated and used for extraction. In this case Extract returns
;                 it's address in a0 and it's handle in d2
;  Output: a0.l = address of extraction destination or ZERO on error
;          d2.w = if input-a0 was zero the handle of the allocated memory block,else it stays
;                 unchanged
; /
shrnklib@0002:
Extract: 	movem.l	a1-a6/d0-d1/d3-d7,-(a7)

		;;  Prepare Extraction...; /
		bsr	DEREF_d0_a3		;  a3 = pointer to archive descriptor
		ori.w	#$8000,-2(a3)		;  Lock Archive Descriptor
		move.l	(a3)+,a2		;  a2 = pointer to archive data (after frequency table)
		lsl.w	#2,d1			;  get the offset of the section descriptor entry
		moveq	#0,d3			;  extend 2(a2,d1.w) to longword in d3
		move.w	2(a2,d1.w),d3		;  d3 = length of section
		moveq	#0,d4			;  extend 0(a2,d1.w) to longword in d4
		move.w	0(a2,d1.w),d4		;  d4 = offset of a section
		adda.l	d4,a2			;  a2 = address of section given by d1

		move.l	a0,d7			;  check,whether a0.l is zero
		bne.s	\A0notZero		;  if it is zero: allocate a memory block...

			move.w	d3,-(a7)	;  push size of memory block to allocate
			clr.w	-(a7)		;  it is a long value
			bsr	HeapAlloc
			addq.l	#4,a7
			move.w	d0,d2		;  d2 = handle of allocated destination memory block
			beq.s	\Error
			bsr	DEREF_d0_a0	;  a0 = address of extraction destination
			ori.w	#$8000,-2(a0)	;  Lock created Handle
\A0notZero:	moveq	#8,d1			;  d1 = bit number (8 forces 'ReadBit' to read new byte into d0)
		moveq	#0,d4			;  d4 = input offset
		movea.l	a0,a1			;  a1 = working destination pointer

	    ;  a0 = address of destination memory block
	    ;  a1 = address of destination memory block (working pointer that is increased during extraction)
	    ;  a2 = address of archive section begin (is increased during extraction)
	    ;  a3 = pointer to huffman tree begin (within descriptor)
	    ;  d0 = current byte
	    ;  d1 = bit number within current byte 'd0'
	    ;  d2 = handle of allocated destination block or original value 
	    ;  d3 = length of section
	    ;  d4 = current input offset
	;; ***** Extraction Loop; /
\ExtractLoop:
	     ;;  check whether end of file; /
		cmp.l	d3,d4
		beq.s	\ExtractEnd
		bgt.s	\Error
		
	     ;;  read a Huffman code; /
		move.w	(a3),d7		;  d7 = relative pointer to root element

\__HuffLoop: 		bclr.l	#15,d7		;  if bit #15 in "address" is set -> it is a leaf; d7 contains the code
			bne.s	\__HuffDone	;  d7 points to current element; (d7) = left branch 2(d7) = right branch
			bsr.s	ReadBit
			beq.s	\____Left	;  continue with left branch
				addq.w	#2,d7	;  continue with right branch
\____Left:		move.w	0(a3,d7.w),d7
			bra.s	\__HuffLoop

\__HuffDone:	;  d7.w = current code
		cmp.w	#256,d7		;  check code
		beq.s	\__RLE			   ;  code = 256: RLE
		bgt.s	\__Rep			   ;  code > 256: Rep

		;;  'code' (d7) is a character; /
		move.b	d7,(a1)+		   ;  copy code to destination
		addq.l	#1,d4
		bra.s	\ExtractLoop

		;;  RLE; /
\__RLE:		move.b	-1(a1),d5		   ;  d5 = RLE repeating character
		moveq	#RLE_BITS,d7		   ;  read length of RLE sequence
		bsr	ReadNBits		   
		addq.w	#1,d6			   ;  d6 = RLE repetition length - 1
\____RLEloop:		move.b	d5,(a1)+		      ;  output characters...
			addq.l	#1,d4
			dbra	d6,\____RLEloop
		bra.s	\ExtractLoop

		;;  Repetition encoding; /
\__Rep:		sub.w	#REP_ESC-MIN_REP+1,d7	   ;  d7 = length of repetition - 1
		move.w	d7,-(a7)		   ;  store it on the stack
		moveq	#START_REP_BITS-1,d7	   ;  get the number of bits that is required for coding an offset
		moveq	#START_REP_CODES/2,d6
\____IncrBitN:		addq.l	#1,d7
			add.l	d6,d6
			move.l	d6,d5
			addq.l	#MIN_REP,d5
			cmp.l	d4,d5		;  codable range is too small ? --> increase bit number and try again
			bls.s	\____IncrBitN
						;  d7 = number of bits
		bsr	ReadNBits		;  d6 = repetition offset
		move.w	(a7)+,d7		;  d7 = length of repetition - 1
		lea	0(a0,d6.l),a4		;  a4 = pointer to repetition
\____RepCopyLp:		move.b	(a4)+,(a1)+	;  copy repetition to current output position...
			addq.l	#1,d4
			dbra	d7,\____RepCopyLp
		bra.s	\ExtractLoop

\Error:		suba.l	a0,a0			;  a0 = zero (indicates error)
\ExtractEnd:	andi.w	#$7FFF,-6(a3)		;  Unlock Archive Descriptor
		movem.l	(a7)+,a1-a6/d0-d1/d3-d7
		rts

	ifd	CALC_TI92PLUS
;; *************************************************************************************************
;  Kernel Archive Function
; --------------------------------------------------------------------------------------------------
;  Input: 
; 	d0.w = index of section to extract
; 	a0.l = pointer to archive
;  Output:
; 	d0.w = Handle or H_NULL
;  Registers destroyed : d0-d2/a0-a1
; /
shrnklib@0003:
	movem.l	d0-d2/a0-a1,-(a7)
	pea	decompress_str(pc)
	jsr	tios::ST_showHelp
	addq.l	#4,a7
	movem.l	(a7)+,d0-d2/a0-a1
	move.w	d0,d1			;  Save index
	bsr	OpenArchive
	tst.w	d0
	beq.s	\error
		suba.l	a0,a0
		bsr	Extract
		bsr	CloseArchive
		move.l	a0,d0
		beq.s	\error
			move.w	d2,d0
\error	move.w	d0,-(a7)
	jsr	tios::ST_eraseHelp
	move.w	(a7)+,d0
	rts
decompress_str	dc.b	"Extracting",0
	endif
	
	ifnd	CALC_TI92PLUS
;; **************************************************************************
_library:	dc.b	"shrnklib",0
;; **************************************************************************
	endif
		END
