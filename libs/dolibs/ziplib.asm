	include "tios.h"
	include "filelib.h"

	xdef	_ti92plus
	xdef	_ti89
	xdef	_ti89ti			; For Ti-89 Titanium
	xdef	_v200			; Create V200 program
	xdef	_library
	DEFINE	_version01

	xdef	ziplib@0000
	xdef	ziplib@0001
	xdef	ziplib@0002
	xdef	ziplib@0003
	xdef	ziplib@0004
	xdef	ziplib@0005
	xdef	ziplib@0006
	xdef	ziplib@0007
	xdef	ziplib@0008
	xdef	ziplib@0009
	xdef	ziplib@000A
	xdef	ziplib@000B
	xdef	ziplib@000C
	
; Correction multiples et diverses par PpHd
; Tout reverfier !!!!

; Pb de lookage des fichiers archives

;ZIPLIB v1.7
;-----------------------------------------------------------------
;structure de l'archive : 00 01 pour nb de fichiers de hufflibs
;			  XX XX nLenght 
;                         XX XX position de l'addresse de depart
;                         XX XX position du bit de depart
;                         XX XX taille du fichier extrait 
;-----------------------------------------------------------------

 ; Kernel Archive Function
 ; Input: 
 ;	d0.w = index of section to extract
 ;	a0.l = pointer to archive
 ; Output:
 ;	d0.w = Handle or H_NULL (Not locked)
 ; Registers destroyed : d0-d2/a0-a1
ziplib@000C:
	movem.l	d0-d2/a0-a1,-(a7)
	pea	Title_e(pc)
	jsr	tios::ST_showHelp
	addq.l	#4,a7
	movem.l	(a7)+,d0-d2/a0-a1
	bra.s	\enter
	; Get archive of the file
\loop		adda.w	(a0)+,a0	; Add archive size
\enter		dbf	d0,\loop
	addq.w	#2,a0		; add size of size
	bsr	Eval_emem
	pea	(a0)
	move.l	d0,-(a7)
	jsr	tios::HeapAlloc
	addq.l	#4,a7
	move.l	(a7)+,a0
	move.w	d0,-(a7)
	beq.s	\error
		tios::DEREF d0,a1
		ori.w	#$8000,-2(a1)	; Locked it
		bsr	extract
		andi.w	#$7FFF,-2(a1)	; UnLocked it
\error	move.w	(a7)+,d0
	rts
	

Write8992 Macro
	lea	\1(PC),a0
	bsr	WriteS89
	ENDM

ziplib@0000:
Temp_cmem:
	movem.l	a0-a6/d1-d7,-(a7)
	pea	($1000).w
Test_mem:
	jsr	tios::HeapMax
	move.l	(a7)+,d1
	cmp.l	d1,d0
	bge.s	Out_Of_Mem
		moveq	#0,d0	; Not enought memory
Out_Of_Mem:
	movem.l	(a7)+,a0-a6/d1-d7
	rts

;-----------------------------------------------------------------
ziplib@0001:
Temp_emem:
	movem.l a0-a6/d1-d7,-(a7)
	pea	(1140).w
	bra.s	Test_mem

;-----------------------------------------------------------------
ziplib@0002:			;OK
Eval_cmem:
	movem.l	a0-a6/d1-d7,-(a7)
	move.w	d0,Lenght
	move.l	a0,origin
	bsr	Temp_cmem
	tst.w	d0
	beq.s	Out_Of_Mem
		bsr	Evaluation_frequences
		move.w	arbre_h(Pc),-(a7)
		jsr    	tios::HeapFree
		addq.l	#2,a7
		moveq	#0,d0
		move.w	d4,d0
		movem.l	(a7)+,a0-a6/d1-d7
		rts

;-----------------------------------------------------------------
ziplib@0003:			;OK
Eval_emem:
	moveq	#0,d0
	move.w	8(a0),d0
	rts

;-----------------------------------------------------------------
ziplib@0004:			;OK
Compress:
	movem.l	a0-a6/d1-d7,-(a7)
	move.w	d0,Lenght
	move.l	a0,origin
	move.l	a1,cible
	bsr	Temp_cmem
	tst.w	d0
	beq	Out_Of_Mem
	bsr	Evaluation_frequences
	bsr	Compression
	moveq	#1,d0
	movem.l	(a7)+,a0-a6/d1-d7
	rts

;-----------------------------------------------------------------
ziplib@0008:			;OK
extract_string:
 	movem.l d0-d7/a0-a6,-(sp)
 	st.b	d5
 	bsr 	Extract2
 	movem.l (sp)+,d0-d7/a0-a6
 	rts

;-------------------------------------------------------

ziplib@0009:			;OK
write_string:
 	movem.l	d0-d7/a0-a6,-(sp)
 	move.w	#4,-(sp)
WriteString:
 	subq.l	#4,sp
 	move.w	d1,-(sp)
 	move.w	d0,-(sp)
 	pea	(a0)
 	pea	(80).w
 	jsr 	tios::HeapAlloc
 	addq.l	#4,sp
 	move.l	(sp)+,a0
 	move.w	d0,tmpstrH
 	beq.s	\RestoreRegs
	 	tios::DEREF 	d0,a1
	 	move.l	a1,4(sp)
	 	st.b	d5
	 	bsr	Extract2
	 	jsr	tios::DrawStrXY
	 	move.w	tmpstrH(PC),-(sp)
	 	jsr	tios::HeapFree
	 	addq.l	#2,sp
\RestoreRegs:
	lea	10(sp),sp
	movem.l	(sp)+,d0-d7/a0-a6
	rts

;---------------------------------------------------------

ziplib@000A:			;OK
write_string_inv:
 	movem.l	d0-d7/a0-a6,-(sp)
 	clr.w	-(sp)
 	bra.s	WriteString

;---------------------------------------------------------

ziplib@000B:
iscomp:
	movem.l	a0-a1/d1,-(a7)
	moveq	#1,d0		; Uncompressed
	move.w	tios::SYM_ENTRY.hVal(a0),d1
	tios::DEREF	d1,a0
	moveq	#0,d1
	move.w	(a0),d1
	cmp.b	#$FF,3(a0)
	bne.s	\ncompress
		lea	-3(a0,d1.l),a0
		lea	term(PC),a1
		moveq	#4,d1
\loop:			cmp.b	(a0)+,(a1)+
			bne	\ncompress
			dbf	d1,\loop
		clr.w	d0
\ncompress:
	movem.l	(a7)+,a0-a1/d1
	rts

;------------------------------------------------------------------
ziplib@0005:			;OK
extract:
 	movem.l	d0-d7/a0-a6,-(sp)
 	sf.b	d5
 	bsr	Extract2
 	movem.l	(sp)+,d0-d7/a0-a6
 	rts

Extract2:
	movem.l	a0-a1,-(a7)
	pea	(1024).w
	jsr	tios::HeapAlloc
	addq.l	#4,a7
	movem.l	(a7)+,a0-a1
	move.w	d0,tableH
	beq	Out_Of_Mem
 	tios::DEREF 	d0,a6
	move.w	#$700,d0
	trap	#1
	move.w	d0,trapv
 	move.l	a0,a2
	move.w	(a2)+,d2
 	cmp.w	#1,d2
 	bne.s	\MultiFiles
 		clr.w	 d3
\MultiFiles:
 	move.w	(a2)+,d0	; ?
 	mulu.w	#6,d2
	lea	0(a2,d2.w),a3	; 
	mulu.w	#6,d3		; File index
 	add.w	d3,a2
 	move.w	d0,d6
 	subq.w	#1,d6
 	move.l	a3,a4
 	add.w	d0,a4
 	moveq	#0,d0
 	moveq	#0,d1

\UncrunchTree:
	 	btst.b	d1,(a4)
	 	beq.s	\NoBranch
		 	move.w	d0,-(a7)
		 	addq.w	#2,d0
\NextTreeBit:	 	addq.w	#1,d1
		 	bclr	#3,d1
		 	beq.s	\UncrunchTree
			 	addq.l	#1,a4
			 	bra.s	\UncrunchTree
\NoBranch:	clr.b	0(a6,d0)
		move.b	(a3)+,1(a6,d0)
		addq.w	#2,d0
 		tst.w	d6
 		beq.s	TreeBuilt
			move.w  (a7)+,d2
			move.w  d0,0(a6,d2)
			bset.b  #7,0(a6,d2)
			dbra	 d6,\NextTreeBit

TreeBuilt:
	moveq	#0,d0		; Signed ?
	move.w	(a2)+,d0
 	adda.l	d0,a0
 	move.w	(a2)+,d3
 	move.w	(a2),d7
 	subq.w	#1,d7
\UncrunchData:
		moveq	#0,d1
\CheckTree:
 		move.w	0(a6,d1),d2
		bclr	#15,d2
		beq.s	\EndOfBranch
			btst.b	d3,(a0)
			bne.s	\RightBranch
				addq.w	#2,d1
				bra.s	\NextDataBit
\RightBranch:	 	move.w  d2,d1
\NextDataBit: 		addq.w	#1,d3
			bclr	#3,d3
		 	beq.s	\CheckTree
			 	addq.l	#1,a0
 				bra.s	\CheckTree
\EndOfBranch: 	move.b	d2,(a1)+
	 	dbra	 d7,\UncrunchData

;	???????????????????
;	bra.s	Done

;ExtractString:
 ;	tst.w	 	d4
 ;	beq 		WriteData
 ;	tst.b		 d2
 ;	bne 		Repeat
 ;	subq	 	#1,d4
 ;	bra 		Repeat
;WriteData:
 ;	move.b  	d2,(a1)+
 ;	tst.b	 	d2
 ;	bne 		Repeat
;Done:
 	move.w	tableH(PC),-(a7)
 	jsr	tios::HeapFree
 	addq.w	#2,a7
	move.w	trapv(pc),d0
	trap	#1
 	move.w	(a2),d0
	rts

;-----------------------------------------------------------------
Evaluation_frequences:
	move.w	#$700,d0
	trap	#1
	move.w	d0,trapv

	pea	($200).w
	jsr	tios::HeapAlloc
	move.w	d0,(a7)
	jsr	tios::HeapLock
	addq.l	#4,a7
	move.w	d0,tab_handle
	tios::DEREF	 d0,a1
	bsr	Clr_Handle
	move.l	a1,tab_addr

	pea	($200).w
	jsr	tios::HeapAlloc
	move.w	d0,(a7)
	jsr	tios::HeapLock
	addq.l	#4,a7
	move.w	d0,tab_handle2
	tios::DEREF	 d0,a1
	bsr	Clr_Handle
	move.l	a1,tab_addr2

	move.l	tab_addr(Pc),a2
	move.l	origin(Pc),a0
	moveq	#0,d2
	move.w	Lenght(Pc),d2
	add.l	d2,a0
	subq.w	#1,d2
	moveq	#0,d7
\Boucle_de_construction_Tab_de_freq:
		clr.w	d0
		move.b	-(a0),d0
		add.w	d0,d0
		tst.w	0(a1,d0.w)
		bne.s	\Non_vide
			addq.w	#1,d7
\Non_vide:	addq.w	#1,0(a1,d0.w)
		addq.w	#1,0(a2,d0.w)
		dbra	d2,\Boucle_de_construction_Tab_de_freq

	move.w	d7,nLenght
	cmp.w	#1,d7
	bne	pas_uni_octet

		move.w  tab_handle2(PC),-(a7)
	 	jsr    	tios::HeapFree
		pea	($3FE).w
		jsr	tios::HeapAlloc
		move.w	d0,-(a7)
		jsr	tios::HeapLock
		addq.l	#8,a7
		move.w	d0,arbre_h
		tios::DEREF	d0,a1
		move.l	a1,arbre_a		
		move.l	a1,a4
		move.w	#2,nLenght
		move.l	tab_addr(Pc),a0
		moveq	#-2,d1
\uni_octet:		addq.w	#2,d1
			tst.w	0(a0,d1.w)
			beq.s	\uni_octet
		lsr.w	#1,d1
		clr.w	d7
		move.w	#$8004,(a1)+
		move.w	d1,(a1)+
		move.w	d1,(a1)+
		bra	uni_octet2

pas_uni_octet:
	pea	($400).w
	jsr	tios::HeapAlloc
	addq.l	#4,a7
	move.w	d0,freq_h
	tios::DEREF	d0,a1
	move.l	a1,freq_a
	move.l	tab_addr2(Pc),a0
	moveq	#0,d1
\Creation_freq:
		moveq	#$FFFFFFFF,d2
		moveq	#0,d3
		moveq	#0,d0

\Recherche_Freq		move.w	0(a0,d0.w),d4
			beq.s	\Plus_petite
				cmp.w	d4,d2
				bls.s	\Plus_petite
					move.w	d0,d3
					move.w	d4,d2
\Plus_petite:		addq.w	#2,d0
			cmp.w	#$200,d0
			bne.s	\Recherche_Freq

		tst.w	0(a0,d3.w)
		beq.s	\Fin_de_Creation_Freq
			clr.b	(a1)+
			move.w	d3,d4
			lsr.w	#1,d4
			move.b	d4,(a1)+		
			move.w	0(a0,d3.w),(a1)+
			clr.w	0(a0,d3.w)
			bra.s	\Creation_freq
\Fin_de_Creation_Freq:

	move.w  tab_handle2(PC),-(a7)
 	jsr	tios::HeapFree
	pea	($3FC).w
	jsr	tios::HeapAlloc
	move.w	d0,-(a7)
	jsr	tios::HeapLock
	addq.l	#8,a7
	move.w	d0,noeuds_h
	tios::DEREF	d0,a1
	move.l	a1,noeuds_a
	moveq	#0,d6				;d6 = arbre en construction
	move.w	nLenght(Pc),d7			;d7 = nombre de branches -1
	move.l	freq_a(Pc),a0
	cmpi.w	#2,d7
	beq.s	bi_octet

		subq.w	#1,d7
\Creation_des_noeuds:
		move.w	(a0)+,(a1)+
		move.w	(a0)+,d0
		move.w	(a0),(a1)+
		add.w	2(a0),d0
		subq.w	#1,d7
		clr.w	d2
		clr.w	d3
\Rang_Boucle:
			cmp.w	6(a0,d3.w),d0
			bls.s	\Bien_ranger
				move.l	4(a0,d3.w),0(a0,d3.w)
				addq.b	#1,d2
				addq.w	#4,d3
				cmp.b	d2,d7			; .B ?
				bhi.s	\Rang_Boucle
\Bien_ranger:
		move.w	d6,0(a0,d3.w)	
		bset.w	#15,0(a0,d3.w)	
		move.w	d0,2(a0,d3.w)
		addq.w	#1,d6		
		cmp.w	#1,d7
		bne.s	\Creation_des_noeuds		; d6 = nb de noeuds
bi_octet:
	move.w	(a0)+,(a1)+
	move.w	2(a0),(a1)+

	move.w	freq_h(PC),-(a7)
	jsr	tios::HeapFree
	pea	($3FE).w
	jsr	tios::HeapAlloc
	move.w	d0,-(a7)
	jsr	tios::HeapLock
	addq.l	#8,a7
	move.w	d0,arbre_h
	tios::DEREF	d0,a1
	move.l	a1,arbre_a
	move.l	noeuds_a(Pc),a0			
	move.l	a1,a4
	move.w	nLenght(pc),d7
	lsl.w	#2,d7
	subq.w	#2,d7
	add.w	d7,a4
	subq.w	#6,d7
	move.w	d7,d0
	bra.s	\Debut_Arbre

\Creation_Arbre:
		move.w	0(a0,d0.w),d0
		bclr.w	#15,d0
		beq.s	\Fin_de_branche
			lsl.w	#2,d0
\Debut_Arbre:		move.w	d0,d1
			addq.w	#2,d1
			pea	(a1)
			move.w	d1,-(a7)
			addq.l	#2,a1
			bra.s	\Creation_Arbre
\Fin_de_branche:
		move.w	d0,(a1)+
		cmp.l	a1,a4
		ble.s	\Fin_de_Creation_Arbre
			move.w	(a7)+,d0
			move.l	(a7)+,a2
			move.l	a1,d1
			sub.l	arbre_a(pc),d1
			bset.w	#15,d1
			move.w	d1,(a2)
			bra.s	\Creation_Arbre
\Fin_de_Creation_Arbre:

	move.w	noeuds_h(PC),-(a7)
	jsr	tios::HeapFree
	addq.l	#2,a7

uni_octet2:
	move.l	arbre_a(pc),a2
	move.w	d7,d6
	addq.w	#6,d6
	moveq	#0,d4
	move.l	tab_addr(pc),a0

	move.w	#$FF,d0
\Freq_non_nulle:
		move.w	d0,d1
		add.w	d1,d1
		tst.w	0(a0,d1.w)
		beq.s	\Freq_vide
		move.w	d6,d2
		moveq	#0,d7
\Trouve_debut_arbre	subq.w	#2,d2
			cmp.w	0(a2,d2.w),d0
			bne.s	\Trouve_debut_arbre

\Cherche_branche:
		move.w	d2,d3
		subq.w	#2,d3
		btst.b	#7,0(a2,d3.w)
		bne.s	\Bonne_branche
			clr.w	d3
			bset.w	#15,d2

\Loop_cherche_branche:
		cmp.w	0(a2,d3.w),d2				
		bne.s	\Pas_branche
\Bonne_branche:		addq.w	#1,d7
			tst.w	d3
			beq.s	\Trouver
				move.w	d3,d2
				bra.s	\Cherche_branche
\Pas_branche:	addq.w	#2,d3
		bra.s	\Loop_cherche_branche				
\Trouver:
		moveq	#0,d5
		move.w	0(a0,d1.w),d5
		mulu.w	d5,d7
		add.l	d7,d4
\Freq_vide	dbra	d0,\Freq_non_nulle

	move.w	tab_handle(PC),-(a7)
 	jsr	tios::HeapFree
	addq.l	#2,a7
	moveq	#0,d7
	move.w	nLenght(Pc),d7
	add.w	d7,d7
	subq.w	#1,d7
	add.l	d7,d4
	moveq	#%00000111,d7
	and.b	d4,d7
	lsr.l	#3,d4
	add.w	#10,d4
	moveq	#0,d0
	move.w	nLenght(Pc),d0
	add.l	d0,d4
	move.w	trapv(Pc),d0
	trap	#1
	tst.b	d7
	beq.s	\Pas_dexces            ;d4 = longueur total du texte compresse
		addq.l	#1,d4
		subq.b	#1,d7
		rts
\Pas_dexces:
	moveq	#7,d7
	rts

Compression:	
	move.w	#$700,d0
	trap	#1
	move.w	d0,trapv
	pea	($600).w
	jsr	tios::HeapAlloc
	addq.l	#4,a7
	move.w	d0,tableH
	tios::DEREF	d0,a4
	move.l	a4,a5
	move.l	a5,a6
	lea	$200(a6),a6

	moveq	#$3F,d0
\Clear_table	clr.l	(a5)+
		dbra	d0,\Clear_table

	move.l	cible(Pc),a1
	move.l	a1,a3
	move.w	#1,(a3)+
	clr.w	d0
	move.w	nLenght(pc),d0
	move.w	d0,(a3)+
	move.w	d0,d1
	subq.w	#1,d0
	lsr.w	#2,d0
	addq.w	#1,d0
	add.w	d1,d0
	add.w	#9,d0
	move.w	d0,(a3)+
	add.w	d1,d1
	subq.w	#1,d1
	andi.b	#%111,d1
	clr.b	(a3)+
	move.b	d1,(a3)+
	moveq	#0,d5
	move.w	Lenght(pc),d5
	move.w	d5,(a3)+		
	add.l	d4,a1
	subq.l	#1,a1
	move.l	origin(pc),a0
	move.l	arbre_a(pc),a2
	add.l	d5,a0
	subq.w	#1,d5
	clr.w	d0

Compression_des_donnees:
		move.b	-(a0),d0
		tst.b	0(a4,d0.w)
		beq.s	\Nouvel_octet
			move.w	d0,d1
			lsl.w	#2,d1
			clr.w	d4
			move.b	0(a4,d0.w),d4
			move.l	0(a6,d1.w),a3
			move.b	0(a5,d0.w),d1
\Copy_octet:			btst.b	d1,(a3)
				beq.s	\Copy_octet_nul
					bset.b	d7,(a1)
					bra.s	\Fin_Copy_octet
\Copy_octet_nul:		bclr.b	d7,(a1)
\Fin_Copy_octet:		tst.b	d7
				bne.s	\No_Shift_source
					bset.b	#3,d7
					subq.l	#1,a1
\No_Shift_source:		tst.b	d1
				bne.s	\No_Shift_origine
					bset.b	#3,d1
					subq.l	#1,a3
\No_Shift_origine:		subq.b	#1,d7
				subq.b	#1,d1
				dbra	d4,\Copy_octet
			bra.s	Fin_de_compression

\Nouvel_octet:	clr.b	d4
		move.w	d0,d1
		lsl.w	#2,d1
		move.l	a1,0(a6,d1.w)
		move.b	d7,0(a5,d0.w)
		move.w	d6,d2

\Trouve_debut_compression:
			subq.w	#2,d2
			cmp.w	0(a2,d2.w),d0
			bne.s	\Trouve_debut_compression

\Cherche_droit	move.w	d2,d3
		subq.w	#2,d3
		btst.b	#7,0(a2,d3.w)
		beq.s	\Cherche_gauche
			bclr.b	d7,(a1)
			bra.s	\Trouver_origine
\Cherche_gauche	clr.w	d3
		bset.l	#15,d2

\Loop_cherche_gauche:
			cmp.w	0(a2,d3.w),d2
			bne.s	\Pas_gauche
				bset.b	d7,(a1)
\Trouver_origine:		tst.b	d7
				bne.s	\No_Shift
					bset.b	#3,d7
					subq.l	#1,a1
\No_Shift:			subq.b	#1,d7
				tst.w	d3
				beq.s	\Fin_arbre
					addq.b	#1,d4
					move.w	d3,d2
					bra.s	\Cherche_droit
\Pas_gauche:		addq.w	#2,d3
			bra.s	\Loop_cherche_gauche	
\Fin_arbre:	move.b	d4,0(a4,d0.w)
Fin_de_compression:
	dbra		d5,Compression_des_donnees

	moveq	#0,d1
	move.w	nLenght(pc),d1
	lsl.w	#2,d1
	subq.w	#4,d1
	move.l	cible(pc),a0
	moveq	#0,d2
	move.w	nLenght(pc),d2
	lea	10(a0,d2.l),a0

\Compression_arbre:
		btst.b	#7,0(a2,d1.w)
		bne.s	\T_branche
			move.b	1(a2,d1.w),-(a0)
			bclr.b	d7,(a1)
\Loop_Compression_arbre:
			tst.b	d7
			bne.s	\No_Shift_arbre
				bset.b	#3,d7
				subq.l	#1,a1
\No_Shift_arbre:
			subq.b	#1,d7
			tst.w	d1
			beq.s	\Fin_de_compression_arbre
			subq.w	#2,d1
			bra.s	\Compression_arbre
\T_branche:	bset.b	d7,(a1)
		bra	\Loop_Compression_arbre
\Fin_de_compression_arbre:

	move.w	arbre_h(PC),-(a7)
 	jsr	tios::HeapFree
	move.w	tableH(PC),-(a7)
	jsr	tios::HeapFree
	addq.l	#4,a7
	move.w	trapv(pc),d0
	trap	#1
	rts


ziplib@0006:
	movem.l	d1-d7/a0-a6,-(a7)
	clr.b	temp
	bsr.s	Temp_file
	move.l	d0,-(a7)
	beq.s	\done
		move.w	arch_h(pc),-(a7)	; or file ?
		jsr	tios::HeapUnlock
		addq.l	#2,a7
\done:	move.l	(a7)+,d0
	movem.l	(a7)+,d1-d7/a0-a6
	rts

ziplib@0007:
	movem.l	d2-d7/a0-a6,-(a7)
	move.b	#1,temp	
	bsr.s	Temp_file
	movem.l	(a7)+,d2-d7/a0-a6
	rts

Temp_file:
;	clr.b	arc			; Test if archive back
	move.b	d0,com
	move.w	SYM_ENTRY.hVal(a0),d2
	jsr	filelib::hdltoindex
	lea	filevat(PC),a1
	move.w	d0,(a1)+
	move.w	d1,(a1)+	
	cmp.b	#1,temp		;
	beq.s	\not_archived	;tester l'extraction rapide de fichiers archivés
		btst.b	#1,SYM_ENTRY.flags(a0)
		bne	archived
		;btst	#9,SYM_ENTRY.flags(a0)	; Non sense !!
		;beq.s	not_archived
		; ????
		;move.b	#1,arc
		;move.w	SYM_ENTRY.hVal(a0),d2
		;move.w	d2,file_h
		;move.w	filevat(pc),d0
		;move.w	filevat2(pc),d1
		;jsr	filelib::unarchive
		;tst.w	d2
		;beq	mem
\not_archived:
	bsr	Get_VAT_add
	move.l	a0,a1
	lea	filename(PC),a2
	moveq	#8,d0
\Copy_nom:	move.b	(a1)+,(a2)+
		dbra	d0,\Copy_nom

	move.w	SYM_ENTRY.hVal(a0),d0
	move.w	d0,file_h
	tios::DEREF	d0,a4
	move.w	file_h(pc),-(a7)			;48521e
	jsr	tios::HeapLock
	addq.l	#2,a7

	moveq	#0,d0
	move.w	(a4)+,d0
	cmp.w	#24,d0
	bls	too_small

	move.w	d0,Lenght
	bsr	Get_VAT_add
	bsr	iscomp
	tst.w	d0
	bne	compress
	cmp.b	#2,com
	bne.s	eok
	lea	conf(PC),a1
	bsr	Winop
	SetFont	1
	Write8992	name
	Write8992	eq
	bsr	question
	tst.b	d7
	bne.s	eok
	rts

eok:
	pea	Title_e(PC)
	jsr	tios::ST_showHelp
	addq.l	#4,a7
	addq.w	#2,a4
	moveq	#0,d0
	move.w	8(a4),d0
	addq.l	#2,d0
	move.l	d0,d7
	move.l	d7,-(a7)
	jsr	tios::HeapAlloc
	addq.l	#4,a7
	tst.w	d0
	beq	mem

	move.w	d0,-(a7)
	jsr	tios::HeapLock
	addq.l	#2,a7
	move.w	d0,arch_h
	tios::DEREF	d0,a1
	move.l	a1,arch_a
	bsr	Temp_emem		
	tst.l	d0
	bne	\Enough_mem_for_extraction
		move.w	arch_h(Pc),-(a7)
		jsr	tios::HeapFree
		addq.l	#2,a7
		bra	mem
\Enough_mem_for_extraction:

	subq.w	#2,d7
	move.w	d7,(a1)+
	move.l	a4,a0
	bsr	extract
	jsr	tios::ST_eraseHelp
	bsr	Get_VAT_add
	move.b	temp(pc),d0
	beq.s	\No_Temp_End
		clr.b	temp
		move.w	file_h,-(a7)
		jsr	tios::HeapUnlock
		addq.l	#2,a7
		move.w	arch_h(pc),d1
		bra.s	\arche
\No_Temp_End:
	move.w	arch_h(pc),d0
	move.w	d0,SYM_ENTRY.hVal(a0)
;	move.w	d0,-(a7)
;	jsr	tios::HeapUnlock	; C'est fait ailleurs
	move.w	file_h(pc),-(a7)
	jsr	tios::HeapFree
	addq.l	#2,a7
;	tst.b		arc
;	beq		arche
;	move.w		filevat,d0
;	move.w		filevat2,d1
;	jsr		filelib::archive
\arche:
	clr.b	d0
	clr.b	com
	rts

compress:
	move.b	temp(pc),d0
	beq.s	\No_Temp_file
		move.b	com(pc),d0
		beq.s	\no_error5
			move.w	#50,-(a7)
			jsr	tios::ERD_dialog
			addq.l	#2,a7
\no_error5:
	moveq	#5,d0
	rts

\No_Temp_file:
	; Add a better test !
	cmp.l	#'68kP',4(a4)		;"68KP"
	beq	\OK
		cmp.l	#'68kL',4(a4)	;"68KL"
		bne.s	\NotDoors
\OK:	tst.b	9(a4)			; Reloc count
	beq.s	\NotDoors
		move.b	com(pc),d0
		beq.s	\no_error4
		move.w	#970,-(a7)
		jsr	tios::ERD_dialog
		addq.l	#2,a7
\no_error4:
	moveq	#4,d0
	rts

\NotDoors:
	cmp.b	#2,com
	bne.s	\cok
		lea	conf(PC),a1
		lea	rect(Pc),a0
		bsr	Winop
		SetFont	1
		Write8992 name
		Write8992 cq
		bsr	question
		tst.b	d7
		bne	\cok
		rts
\cok:
	pea	Title_c(PC)
	jsr	tios::ST_showHelp
	addq.l	#4,a7
	moveq	#0,d0
	move.w	Lenght(pc),d0
	move.l	d0,-(a7)
	jsr	tios::HeapAlloc
	addq.l	#4,a7
	tst.w	d0
	beq	mem

	move.w	d0,-(a7)
	jsr	tios::HeapLock
	addq.l	#2,a7
	move.w	d0,arch_h
	tios::DEREF	d0,a1
	move.l	a1,arch_a
	bsr	Temp_cmem
	tst.l	d0
	bne	\enuf_compr_mem
		move.w	arch_h(Pc),-(a7)
		jsr	tios::HeapFree
		addq.l	#2,a7
		bra	mem
\enuf_compr_mem:
	addq.l	#4,a1
	move.l	a4,origin
	move.l	a1,cible
	bsr	Evaluation_frequences
	add.w	#10,d4
	cmp.w	Lenght(Pc),d4
	bls	Good_compressed
	move.w	arbre_h(Pc),-(a7)
	jsr	tios::HeapFree
	move.w	arch_h(Pc),-(a7)
	jsr	tios::HeapFree
	addq.l	#4,a7

too_small:
	move.b	com(pc),d0
	beq.s	\no_error2
		lea	Title_nc(PC),a1		
		bsr	Winop
		SetFont	1
		Write8992	Sorry
		Write8992	Sorry2
		bsr	GetKey
		bsr	Winc
\no_error2:
	moveq	#2,d0
	rts

Good_compressed:
	move.w	d4,c_lenght
	sub.w	#10,d4
	bsr	Compression			
	moveq	#0,d7
	move.w	c_lenght(pc),d7
	subq.w	#2,d7
	move.w	filevat(pc),d0
	move.w	filevat2(pc),d1
	jsr	filelib::gettype
	move.b	d2,type
	bsr	Get_VAT_add
	move.w	arch_h(pc),SYM_ENTRY.hVal(a0)
	moveq	#0,d0
	move.w	c_lenght(pc),d0
	jsr	filelib::resizefile
	move.l	arch_a(pc),a1
	move.l	a1,a2
	add.l	d7,a2
	moveq	#5,d0
	subq.l	#4,a2
	lea	terma(PC),a0
\loot_term:
		move.b	(a0)+,(a2)+
		dbra	d0,\loot_term
	move.w	d7,(a1)+
	move.b	type(pc),(a1)+
	move.b	#$FF,(a1)+
	move.w	file_h(pc),-(a7)
	jsr	tios::HeapFree
	addq.l	#2,a7
;	tst.b	arc
;	beq	no_arch3
;	move.w		filevat,d0
;	move.w		filevat2,d1
;	jsr		filelib::archive
no_arch3:
	jsr	tios::ST_eraseHelp
	cmp.b	#2,com
	bne	\no_com_c
		addq.w	#2,d7
		moveq	#0,d0
		move.w	Lenght(pc),d0
		addq.w	#2,d0
		move.w	d0,d6
		lea	C_size(PC),a0
		moveq	#5,d1
		bsr	ConvStr
		addq.l	#5,a0
		move.b	#$20,(a0)+
		move.b	#26,(a0)+
		move.b	#$20,(a0)+
		move.w	d7,d0
		moveq	#5,d1
		bsr	ConvStr
		moveq	#0,d5
		move.w	d7,d5
		mulu.w	#100,d5
		divu.w	d6,d5
		move.w	#100,d6
		sub.w	d5,d6
		lea	Ratio(PC),a0
		addq.l	#8,a0
		moveq	#2,d1
		move.w	d6,d0
		bsr	ConvStr
		lea	done_c(PC),a1
		bsr	Winop
		SetFont	1
		Write8992 name
		Write8992 C_sizea
		Write8992 Ratioa
		SetFont	0
		Write8992 credits
		bsr	GetKey
		bsr	Winc
\no_com_c:
	clr.b		d0
	clr.b		com
	rts


WriteS89:
	move.w	#4,-(a7)
WriteS89s:
	pea	4(a0)
	moveq	#0,d0
	tst.b	CALCULATOR		; FIXME: Should use EXTRA_RAM_CALL
	ble.s	\W89
		moveq	#2,d0
\W89	clr.w	d1
	move.b	1(a0,d0.w),d1
	move.w	d1,-(a7)
	move.b	0(a0,d0.w),d1
	move.w	d1,-(a7)
	jsr	tios::DrawStrXY        ; call the DrawStrXY ROM function
	lea	 10(a7),a7
	rts


mem:
	move.b	com(pc),d0
	beq.s	\no_error3
		move.w	#670,-(a7)
		jsr	tios::ERD_dialog
		addq.l	#2,a7
\no_error3:
	moveq	#3,d0
	rts

question:
	tst.b	CALCULATOR
	bgt.s	\question922
		SetFont	0
\question922:
	move.w	#3,-(a7)			;1=OK 2=SAVE 3=YES 4=CANCEL 5=NO
	pea	window(PC)			:6=GOTO
	jsr	tios::DrawStaticButton
	addq.l	#6,a7
	move.w	#80,-(a7)
	move.w	#5,-(a7)			;1=OK 2=SAVE 3=YES 4=CANCEL 5=NO
	pea	window(PC)			:6=GOTO
	jsr	tios::DrawStaticButton
	addq.l	#8,a7
	bsr	GetKey
	clr.w	d7
	cmp.w	#264,d0
	beq	fin_q
		moveq	#1,d7
fin_q:	bsr	Winc
	rts
	
Winop:
	move.l	a1,-(a7)
	move.w	#$D018,-(a7)  
	lea	rect(PC),a0
	tst.b	CALCULATOR
	ble.s	\win89
		addq.l	#8,a0
\win89	pea	(a0)
	pea	window(PC)
	jsr	tios::WinOpen
	lea	14(a7),a7
	tst.b	CALCULATOR
	bgt.s	\question92
		clr.w	-(a7)
		pea	window(PC)
		jsr	tios::WinFont
		addq.l	#6,a7
\question92:
	pea	window(PC)
	jsr	tios::WinActivate
	addq.l	#4,a7
	rts

Winc:
	pea	window(PC)
	jsr	tios::WinClose
	addq.l	#4,a7
	rts

archived:
	move.b	com(pc),d0
	beq.s	\no_error1
		move.w	#980,-(a7)
		jsr	tios::ERD_dialog
		addq.l	#2,a7
\no_error1:
	move.b		#1,d0
	rts


; --------------------------------
;
;  Converts a number to a string
;
;   IN:  d0  - The number
;	 d1  - Number of digits
;	 a0  - Pointer to string
;   OUT: *a0 - The string (null-terminated)
;
; --------------------------------

ConvStr:
 	adda.w	d1,a0
 	subq.w	#1,d1
\RepConv: 	divu.w	#10,d0
	 	swap	d0
	 	add.w	#'0',d0
	 	move.b  d0,-(a0)
		clr.w	d0
		swap	d0
	 	dbra	d1,\RepConv
 	rts

Clr_Handle: ;a1 points to handle
	move.w	#$7F,d0			
	move.l	a1,a2
\Loop:		clr.l	(a2)+
		dbra	d0,\Loop
	rts

Get_VAT_add:		;détruit d0,	et a0 et a1
	lea	filevat(PC),a1
	move.w	(a1)+,d0		
	tios::DEREF	d0,a0
	move.w	(a1)+,d0
	mulu.w	#SYM_ENTRY.sizeof,d0
	lea	4(a0,d0.w),a0
	rts

GetKey:
	movem.l	d1-d2/a0-a1,-(a7)
	jsr	tios::ngetchx
	movem.l	(a7)+,d1-d2/a0-a1
	rts

;DATAS----------------------------------------------------------------

Lenght		dc.w		0
origin		dc.l		0
cible		dc.l		0
tab_handle	dc.w		0
tab_addr	dc.l		0
tab_handle2	dc.w		0
tab_addr2	dc.l		0
nLenght		dc.w		0
arbre_h		dc.w		0
arbre_a		dc.l		0
freq_h		dc.w		0
freq_a		dc.l		0
noeuds_h	dc.w		0
noeuds_a	dc.l		0
tableH	   	dc.w 		0	
arch_h		dc.w		0
file_a		dc.l		0
file_h		dc.w		0
arch_a		dc.l		0
c_lenght	dc.w		0
tmpstrH		dc.w		0
trapv		dc.w		0
window		ds.w		21
rect		dc.w		10,21,150,70,41,30,197,90
filevat		dc.w		0
filevat2	dc.w		0
conf		dc.b		"Confirmation",0
com		dc.b		0
name		dc.b		40,34,75,48,"Name : "
filename	ds.b		9
temp		dc.b		0
Title_e		dc.b		"EXTRACTING ...",0
Title_c		dc.b		"COMPRESSING ...",0
Title_nc	dc.b		"Not Compressing!",0
Ratioa		dc.b		47,54,83,68
Ratio		dc.b		"Ratio:    %",0
C_sizea		dc.b		42,45,78,58
C_size		ds.b		14           
Sorry		dc.b		12,40,52,51,"Compressed file bigger",0
Sorry2		dc.b		18,50,52,61,"than original file.",0
done_c		dc.b		"Compressed !",0
cq		dc.b		42,45,76,62,"Compress it ?",0
eq		dc.b		42,45,76,62,"Extract it ?",0
credits		dc.b		64,64,110,83,"© 1999 Marc TEYSSIER",0
arc		dc.b		0
type		dc.b		0
terma		dc.b		0
term		dc.b		"ZIP",0,$F8
x
 end
