; ****************************************************************************************************
;
;	 Fargray library v0.2.4, Copyright (C) 1996-1998 Kristian Kræmmer Nielsenby
;
; ****************************************************************************************************

; Ported to HW2 by Julien MONVILLE a.k.a. Penpen.
; Optimised by PpHd

	include	tios.h
	include	graphlib.h
		
	xdef	_library
	DEFINE	_version01

	xdef	_ti89
	xdef	_ti92plus
	xdef	_ti89ti
	xdef	_v200
	
	xdef	fargray@0000			;fargray::readheader
	xdef	fargray@0001			;fargray::setbits
	xdef	fargray@0002			;fargray::putimage
	xdef	fargray@0003			;fargray::put1planepic
	xdef	fargray@0004			;fargray::put2planepic
	xdef	fargray@0005			;fargray::put3planepic

fargray@0000:
readheader:
;--------------------------------------------------------------
;unsigned char readheader(void *CompressedData)
;
;   ben.. lit le header je présume... #confus# ( où alors Kristian Kræmmer Nielsen (i.e. l'auteur original) c un sacré pervers #picol# ...................................... Brrr, rien que d'y penser, j'en ai froid ds le dos #gol# )
;
;Input :
;	a5.l= Pointer to compressed data
;Output :
;	d2.b= 0 ou 1 selon les cas, qu'il me reste à découvrir..
;--------------------------------------------------------------
	addq.l		#4,a5					; [0x7A (122)] 58 8d		    */
	move.b		(a5)+,d5				; [0x7C (124)] 1a 1d			  */
	addq.l		#1,a5					; [0x7E (126)]	52 8d		   */
	move.b		(a5)+,d3				; [0x80 (128)] 16 1d			  */
	move.b		(a5)+,d4				; [0x82 (130)] 18 1d			  */
	add.b		d3,d3				    ; [0x84 (132)]	e3 0b		   */
	addq.l		#1,a5				    ; [0x86 (134)]	52 8d		   */
	
	
	
	
	
fargray@0001:
setbits:
;--------------------------------------------------------------
;?? setbits(??)
;
;   ben.. aucune idée précise pour l'instant :( .... ça met des bits, mais à part ça #confus# (enfin ça remplit le buffer à la fin, mais g pas eu le temps d'étudier plus que ça :o)
;
;Input :
;	??
;Output :
;	d2.b= 0 ou 1 selon les cas, qu'il me reste à découvrir..
;--------------------------------------------------------------
	clr.b		d4				    ; [0x88 (136)]	42 04		   */
	moveq		#8,d3				    ; [0x8A (138)]	16 3c 00 08	   */
	lea		__L2BC(pc),a4			  ;	[0x8E (142)] 49 fa 02 2c		 */
	movem.l		d3-d6,(a4)				  ;	[0x92 (146)] 48 d4 00 78		 */
	moveq		#1,d2					 ;	[0x96 (150)] 14 3c 00 01		 */
	clr.w		d0					; [0x9A (154)]	42 40		   */
	move.b		(a5)+,d0				   ; [0x9C (156)] 10 1d			  */
	moveq		#7,d1					  ;	[0x9E (158)] 12 3c 00 07		 */
	lsl.w		#8,d0			    		; [0xA2 (162)]	e1 48		   */
	add.w		d0,d0			    		; [0xA4 (164)]	e3 48		   */
	bcc.s		__LAC					 ;+0x6*/			; [0xA6 (166)] 65 00 00	04	    */
	clr.b		d2			    		; [0xAC (172)]	42 02		   */
__LAC:
	rts								; [0xAE (174)] 4e 75		    */





fargray@0002:
putimage:
;--------------------------------------------------------------
;?? putimage(??)
;
;   é bé, heu.. même remarque que pour readheader.. #triso#
;
;Input :
;	??
;Output :
;	??
;--------------------------------------------------------------
	movem.l		d3-d7/a4,-(a7)		; [0xB0 (176)] 48 e7 1f	08	    */
	move.w		d7,d6				; [0xB4 (180)] 3c 07		    */
	movea.l		a6,a4				; [0xB6 (182)] 28 4e		    */
	subq.w		#1,d6				; [0xB8 (184)] 53 46		    */
__LBA:
	clr.b		(a4)+				; [0xBA (186)] 42 1c		    */
	dbf		d6,__LBA			;-0x2*/	; [0xBC (188)] 51 ce ff	fc	    */
	addi.w		#$A,d7			; [0xC0 (192)] 06 47 00	0a	    */
	lea		__L2BC(pc),a4		; [0xC4 (196)] 49 fa 01	f6	    */
	movem.l		(a4),d3-d6			; [0xC8 (200)] 4c d4 00	78	    */
	cmpi.b		#7,d2				; [0xCC (204)] 0c 02 00	07	    */
	bgt		__L19E			;+0xCE*/	; [0xD0 (208)] 6e 00 00	cc	    */
	bra.s		__LEC	 			;+0x18*/	; [0xD4 (212)] 60 00 00	16	    */

__LD8:
	clr.w		d6				; [0xD8 (216)] 42 46		    */
	move.b		(a5)+,d6			; [0xDA (218)] 1c 1d		    */
	moveq		#8,d5				; [0xDC (220)] 7a 08		    */
	sub.b		d1,d5				; [0xDE (222)] 9a 01		    */
	lsl.w		d5,d6				; [0xE0 (224)] eb 6e		    */
	or.w		d6,d0				; [0xE2 (226)] 80 46		    */
	ori.b		#8,d1				; [0xE4 (228)] 00 01 00	08	    */
	bra.s		__LF2				;+0xA*/	; [0xE8 (232)] 60 00 00	08	    */
__LEC:
	cmpi.b		#8,d1				; [0xEC (236)] 0c 01 00	08	    */
	blt.s		__LD8				;-0x18*/	; [0xF0 (240)] 6d e6		    */
__LF2:
	add.w		d0,d0				; [0xF2 (242)] e3 48		    */
	bcs.s		__L146			;+0x52*/	; [0xF4 (244)] 65 00 00	50	    */
	add.w		d0,d0				; [0xF8 (248)] e3 48		    */
	bcs.s		__L12E			;+0x34*/	; [0xFA (250)] 65 00 00	32	    */
	subq.b		#8,d1				; [0xFE (254)] 51 01		    */
	move.w		d0,d6				; [0x100	(256)] 3c	00			*/
	andi.w		#$FC00,d6			; [0x102	(258)] 02	46 fc 00		*/
	cmpi.w		#$FC00,d6			; [0x106	(262)] 0c	46 fc 00		*/
	beq.s		__L120			;+0x16*/	; [0x10A	(266)] 67	00 00 14		*/
	lsr.w		#8,d6				; [0x10E	(270)] e0	4e			*/
	lsr.w		#2,d6				; [0x110	(272)] e4	4e			*/
	addi.b		#$B,d6			; [0x112	(274)] 06	06 00 0b		*/
	bsr		__L224			;+0x10E*/; [0x116	(278)] 61	00 01 0c		*/
	lsl.w		#6,d0				; [0x11A	(282)] ed	48			*/
	bra		__L23C			;+0x120*/; [0x11C	(284)] 60	00 01 1e		*/

__L120:
	lsl.w		#6,d0				; [0x120	(288)] ed	48			*/
	moveq		#$49,d6			; [0x122	(290)] 1c	3c 00 49		*/
	bsr		__L224			;+0xFE*/	; [0x126	(294)] 61	00 00 fc		*/
	bra		__L24A			;+0x120*/; [0x12A	(298)] 60	00 01 1e		*/

__L12E:
	subq.b		#5,d1				; [0x12E	(302)] 5b	01			*/
	move.w		d0,d6				; [0x130	(304)] 3c	00			*/
	andi.w		#$E000,d6			; [0x132	(306)] 02	46 e0 00		*/
	lsr.w		#8,d6				; [0x136	(310)] e0	4e			*/
	lsr.w		#5,d6				; [0x138	(312)] ea	4e			*/
	addq.b		#3,d6				; [0x13A	(314)] 56	06			*/
	bsr		__L224			;+0xE8*/	; [0x13C	(316)] 61	00 00 e6		*/
	lsl.w		#3,d0				; [0x140	(320)] e7	48			*/
	bra		__L23C			;+0xFA*/	; [0x142	(322)] 60	00 00 f8		*/

__L146:
	add.w		d0,d0				; [0x146	(326)] e3	48			*/
	bcc.s		__L156			;+0xE*/	; [0x148	(328)] 64	00 00 0c		*/
	moveq		#2,d6				; [0x14C	(332)] 7c	02			*/
	bsr		__L224			;+0xD6*/	; [0x14E	(334)] 61	00 00 d4		*/
	bra.s		__L15A			;+0x8*/; [0x152	(338)] 60	00 00 06		*/

__L156:
	bsr.s		__L160			;+0xA*/	; [0x156	(342)] 61	00 00 08		*/
__L15A:
	subq.b		#2,d1				; [0x15A	(346)] 55	01			*/
	bra		__L23C			;+0xE0*/	; [0x15C	(348)] 60	00 00 de		*/

__L160:
	tst.b		d3				; [0x160	(352)] 0c	03 00 00		*/
	bne.s		__L180			;+0x1C*/	; [0x164	(356)] 66	00 00 1a		*/
	subq.w		#1,d7				; [0x168	(360)] 53	47			*/
	moveq		#7,d3				; [0x16A	(362)] 76	07			*/
	tst.b		d2				; [0x16C	(364)] 0c	02 00 00		*/
	beq.s		__L17A			;+0xA*/	; [0x170	(368)] 67	00 00 08		*/
	move.b		d4,(a6)+			; [0x174	(372)] 1c	c4			*/
	moveq		#1,d4				; [0x176	(374)] 78	01			*/
	rts						; [0x178	(376)] 4e	75			*/
__L17A:
	move.b		d4,(a6)+			; [0x17A	(378)] 1c	c4			*/
	clr.b		d4				; [0x17C	(380)] 42	04			*/
	rts						; [0x17E	(382)] 4e	75			*/

__L180:
	subq.b		#1,d3				; [0x180	(384)] 53	03			*/
	add.b		d4,d4				; [0x182	(386)] e3	0c			*/
	tst.b		d2				; [0x184	(388)] 0c	02 00 00		*/
	beq.s		__L18E			;+0x6*/; [0x188	(392)] 67	00 00 04		*/
	addq.b		#1,d4				; [0x18C	(396)] 52	04			*/
__L18E:
	rts						; [0x18E	(398)] 4e	75			*/

__L190:
	sub.b		d6,d3				; [0x190	(400)] 96	06			*/
	lsl.b		d6,d4				; [0x192	(402)] ed	2c			*/
	moveq		#1,d5				; [0x194	(404)] 7a	01			*/
	lsl.b		d6,d5				; [0x196	(406)] ed	2d			*/
	subq.b		#1,d5				; [0x198	(408)] 53	05			*/
	add.b		d5,d4				; [0x19A	(410)] d8	05			*/
	rts						; [0x19C	(412)] 4e	75			*/

__L19E:
	andi.b		#1,d2				; [0x19E	(414)] 02	02 00 01		*/
	beq.s		__L1B2			;+0xC*/	; [0x1A6	(422)] 67	00 00 0a		*/
	bsr.s		__L1EE			;+0x44*/	; [0x1AA	(426)] 61	00 00 42		*/
	bra.s		__L1B6			;+0x8*/	; [0x1AE	(430)] 60	00 00 06		*/

__L1B2:
	bsr		__L216			;+0x64*/	; [0x1B2	(434)] 61	00 00 62		*/
__L1B6:
	cmpi.b		#1,__L2CC			; [0x1B6	(438)] 0c	39 00 01 00 00	02 cc */
	beq		__L23C			;+0x7E*/	; [0x1BE	(446)] 67	00 00 7c		*/
	bra		__L24A			;+0x88*/	; [0x1C2	(450)] 60	00 00 86		*/

__L1C6:
	sub.b		d3,d6				; [0x1C6	(454)] 9c	03			*/
	lsl.b		d3,d4				; [0x1C8	(456)] e7	2c			*/
	tst.b		d2				; [0x1CA	(458)] 0c	02 00 00		*/
	beq.s		__L200			;+0x32*/	; [0x1CE	(462)] 67	00 00 30		*/
	moveq		#1,d5				; [0x1D2	(466)] 7a	01			*/
	lsl.b		d3,d5				; [0x1D4	(468)] e7	2d			*/
	subq.b		#1,d5				; [0x1D6	(470)] 53	05			*/
	add.b		d5,d4				; [0x1D8	(472)] d8	05			*/
	subq.w		#1,d7				; [0x1DA	(474)] 53	47			*/
	move.b		d4,(a6)+			; [0x1DC	(476)] 1c	c4			*/
__L1DE:
	cmpi.b		#8,d6				; [0x1DE	(478)] 0c	06 00 08		*/
	blt.s		__L1F8			;+0x16*/	; [0x1E2	(482)] 6d	00 00 14		*/
	cmpi.w		#$B,d7			; [0x1E6	(486)] 0c	47 00 0b		*/
	blt		__L262			;+0x78*/	; [0x1EA	(490)] 6d	00 00 76		*/
__L1EE:
	subq.b		#8,d6				; [0x1EE	(494)] 51	06			*/
	move.b		#$FF,(a6)+			; [0x1F0	(496)] 1c	fc 00 ff		*/
	subq.w		#1,d7				; [0x1F4	(500)] 53	47			*/
	bra.s		__L1DE			;-0x18*/	; [0x1F6	(502)] 60	e6			*/
__L1F8:
	clr.b		d4				; [0x1F8	(504)] 42	04			*/
	moveq		#8,d3				; [0x1FA	(506)] 76	08			*/
	bra.s		__L190			;-0x6C*/	; [0x1FC	(508)] 61	92			*/

__L200:
	subq.w		#1,d7				; [0x200	(512)] 53	47			*/
	move.b		d4,(a6)+			; [0x202	(514)] 1c	c4			*/
	clr.b		d4				; [0x204	(516)] 42	04			*/
__L206:
	cmpi.b		#8,d6				; [0x206	(518)] 0c	06 00 08		*/
	blt.s		__L21E			;+0x14*/	; [0x20A	(522)] 6d	00 00 12		*/
	cmpi.w		#$B,d7			; [0x20E	(526)] 0c	47 00 0b		*/
	blt.s		__L262			;+0x50*/	; [0x212	(530)] 6d	00 00 4e		*/
__L216:
	subq.b		#8,d6				; [0x216	(534)] 51	06			*/
	addq.l		#1,a6				; [0x218	(536)] 52	8e			*/
	subq.w		#1,d7				; [0x21A	(538)] 53	47			*/
	bra.s		__L206			;-0x16*/	; [0x21C	(540)] 60	e8			*/
__L21E:
	moveq		#8,d3				; [0x21E	(542)] 76	08			*/
	sub.b		d6,d3				; [0x220	(544)] 96	06			*/
	rts						; [0x222	(546)] 4e	75			*/

__L224:
	cmp.b		d3,d6				; [0x224	(548)] bc	03			*/
	bgt.s		__L1C6			;-0x60*/	; [0x226	(550)] 6e	9e			*/
	tst.b		d2				; [0x228	(552)] 0c	02 00 00		*/
	bne.s		__L190			;-0xA0*/	; [0x230	(560)] 61	00 ff 5e		*/
__L236:
	lsl.b		d6,d4				; [0x236	(566)] ed	2c			*/
	sub.b		d6,d3				; [0x238	(568)] 96	06			*/
	rts						; [0x23A	(570)] 4e	75			*/
__L23C:
	cmpi.b		#7,d2				; [0x23C	(572)] 0c	02 00 07		*/
	bgt.s		__L256			;+0x16*/	; [0x240	(576)] 6e	00 00 14		*/
	addq.b		#1,d2				; [0x244	(580)] 52	02			*/
	andi.b		#1,d2				; [0x246	(582)] 02	02 00 01		*/
__L24A:
	cmpi.w		#$A,d7			; [0x24A	(586)] 0c	47 00 0a		*/
	bgt		__LEC				;-0x162*/; [0x24E	(590)] 6e	00 fe 9c		*/
	bra.s		__L26E			;+0x1C*/	; [0x252	(594)] 60	00 00 1a		*/

__L256:
	move.b		#1,__L2CC			; [0x256	(598)] 13	fc 00 01 00 00	02 cc */
	bra.s		__L26E			;+0x10*/	; [0x25E	(606)] 60	00 00 0e		*/

__L262:
	ori.b		#8,d2				; [0x262	(610)] 00	02 00 08		*/
	clr.b		__L2CC			; [0x266	(614)] 42	39 00 00 02 cc	*/
	rts						; [0x26C	(620)] 4e	75			*/

__L26E:
	lea		__L2BC(pc),a4		; [0x26E	(622)] 49	fa 00 4c		*/
	movem.l		d3-d6,(a4)			; [0x272	(626)] 48	d4 00 78		*/
	movem.l		(a7)+,d3-d7/a4		; [0x276	(630)] 4c	df 10 f8		*/
	rts						; [0x27A	(634)] 4e	75			*/








fargray@0003:
put1planepic:
;----------------------------------------------------------------------------
; put1planepic()
;
;input :
;	a5.l= Pointer to compressed data
;	d7.w= Number of bytes to paint
;
;output:
;	nothing ?
;----------------------------------------------------------------------------:
	move.l		graphlib::plane0,a3
	bsr		readheader			;-0x202*/    ; [0x27C (636)] 61 00 fd	fc	    */
	movea.l		a3,a6				; [0x284	(644)] 2c	4b			*/
	bra		putimage	 		;-0x1D6*/	; [0x286	(646)] 61	00 fe 28		*/

fargray@0004:
put2planepic:
;----------------------------------------------------------------------------
; put2planepic()
;
;input :
;	a5.l= Pointer to compressed data
;	d7.w= Number of bytes to paint
;
;output:
;	nothing ?
;----------------------------------------------------------------------------
	move.l		graphlib::plane1,a1
	bsr.s		put1planepic		;-0x10*/	   ; [0x28C (652)]	61 ee		   */
	movea.l		a1,a6				; [0x28E	(654)] 2c	49			*/
	bra		putimage			 ;-0x1E0*/	; [0x290	(656)] 61	00 fe 1e		*/









fargray@0005:
put3planepic:
;----------------------------------------------------------------------------
; put3planepic()
;
;input :
;	a5.l= Pointer to compressed data
;	d7.w= Number of bytes to paint
;
;output:
;	nothing ?
;----------------------------------------------------------------------------
	move.l		graphlib::plane2,a2
	bsr.s		put2planepic			;-0xA*/	; [0x296	(662)] 61	f4			*/
	movea.l		a2,a6				; [0x298	(664)] 2c	4a			*/
	bra		putimage			;-0x1EA*/	; [0x29A	(666)] 61	00 fe 14		*/






__L2BC:	ds.l	4
__L2CC:	dc.b 0,0

_comment:
	dc.b	"jkkn@ctav.com fargray 2.0s",0
	
	END