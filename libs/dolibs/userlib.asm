	include "tios.h"
	include "romcalls.h"
	include "graphlib.h"

	xdef	_library		; Create a Library
	xdef	_ti89			; For Ti-89
	xdef	_ti89ti			; For Ti-89 Titanium
	xdef	_ti92plus		; For Ti-92+
	xdef	_v200			; For Ti-92+
	DEFINE	_version02		; Version 02

	xdef	userlib@0000		;idle_loop
	xdef	userlib@0001		;random
	xdef	userlib@0002		;rand_seed
	xdef	userlib@0003		;Exec
	xdef	userlib@0004		;FindSymEntry
	xdef	userlib@0005		;DrawCharXY
	xdef	userlib@0006		;InputStr
	xdef	userlib@0007		;getpassword
	xdef	userlib@0008		;changepass
	xdef	userlib@0009		;lockcalc
	xdef	userlib@000A		;idle_hot
	xdef	userlib@000B		;getfreeRAM
	xdef	userlib@000C		;smallmenu
	xdef	userlib@000D		;getfreearchive
	xdef	userlib@000E		;set_APD
	xdef	userlib@000F		;get_APD
	xdef	userlib@0010		;runprog
	xdef	userlib@0011		;password

idle_loop:
userlib@0000:
	movem.l d1-d7/a0-a6,-(a7)

	move.w	#2,-(a7)
\idle:	jsr	tios::OSTimerRestart
\wait:	jsr	tios::OSTimerExpired
	tst.w	d0
	beq.s	\not
\OFF:	trap	#4
	bra.s	\idle
\not	jsr	kernel::Idle
	tst.w	KEY_PRESSED_FLAG
	beq.s	\wait

	jsr	tios::ngetchx
	move.w	d0,d7
	cmp.w	#KEY_DIAMOND+$10B,d0
	beq.s	\OFF

	addq.w	#1,(a7)		; Pour 3
	jsr	tios::ST_busy	; Efface le busy
	addq.l	#2,a7

	move.w	d7,d0
	movem.l	(a7)+,d1-d7/a0-a6
	rts

random:
userlib@0001:
	move.l  d1,-(a7)
	move.w	rand_seed(pc),d1
	mulu.w	#31421,d1
	add.w	#6927,d1
	mulu.w	d1,d0
	move.w	d1,rand_seed
	clr.w	d0
	swap	d0
	move.l  (a7)+,d1
	rts

userlib::exec
userlib@0003:
	; Test if zipped program
	move.w	4(a7),d0		; Get handle
	move.w	d0,d2			; d2 = Saved handle
	move.w	d2,d1			; d1 = temporary register 
	DEREF	d1,a0
	moveq	#0,d1
	move.w	(a0),d1

	cmp.b	#$F8,1(a0,d1.l)		; Is it 'OTHER' TAG ?
	bne.s	\RunProgram		; No then check if it's ASM
	tst.b	2(a0)        		; Type = ASM ?
	bne.s	\Fail
		jsr	kernel::Hd2Sym	; Get the SYM entry
		moveq	#1,d0    	; semi-comment mode
		move.b	#$1,-(a7)	;clr.b	-(a7)	; At least, version 1 of ziplib
		move.w	#$7,-(a7)	; Function 7 : ziplib::tempfile	
		pea	ziplib_str(Pc)	; ZipLib library
		jsr	kernel::LibsExec ; Call the function
		tst.l	(a7)
		addq.l	#8,a7		; Addq #8,an doesn't affect the Zero flag
		beq.s	\Fail		; Failed to call ziplib ?
			tst.b	d0
			bne.s	\Fail
				move.w	d1,d0
				move.w	d0,-(a7)    ; pushes the handle of the temp block for future use
				jsr	kernel::Exec
				jsr	tios::HeapFree
				addq.l	#2,a7
\Fail:	rts
\RunProgram	jmp	kernel::Exec

userlib::FindSymEntry
userlib@0004:
;parameters are pushed in the stack in that order
;1 : adress to the name of the symbol to look for
;2 : handle of the list you look in
	movem.l	d0-d7/a1-a6,-(a7)
	move.l	62(a7),a1		; a1 : name of the entry we look for
	move.w	60(a7),d0		; d0 : handle of the list we look into

	DEREF	d0,a0			; a0 : contents of the list
	addq.l	#2,a0			; skips the 1st word
	move.w	(a0)+,d5		; d5 = nb items in the list
	beq.s	\false			; -> not found
		subq.w    #1,d5		; - 1 for dbra
\search		movem.l	a0/a1,-(a7)
		jsr	tios::strcmp	; compares the strings a0 & a1
		movem.l	(a7)+,a0/a1	; restores a0&a1
		tst.w	d0		; (a0) = (a1) ?
		beq.s	\end		; -> found !
		lea	SYM_ENTRY.sizeof(a0),a0	; else VAT pointer += 14
		dbf	d5,\search	; search again
\false	suba.l	a0,a0            ; a0 = 0, entry not found
\end    movem.l	(a7)+,d0-d7/a1-a6
	rts

userlib::DrawCharXY
userlib@0005:
;util::DrawCharXY(BYTE ch,WORD x,WORD y,WORD color)
	lea	charstr(pc),a0
	move.b	5(a7),(a0)
	move.w	10(a7),-(a7)
	pea	(a0)
	move.l	12(a7),-(a7)
	jsr	tios::DrawStrXY
	lea	10(a7),a7
	rts

userlib@0006:
;Input:	d1.w = x
;	d2.w = y
;	d3.w = maxchar
;Output: d0.w = string lenght
;	 a0.l = adress of the string
	move.l	d6,-(a7)
	moveq	#1,d6
	bsr.s	InputStr
	move.l	(a7)+,d6
	rts

InputStr:
	movem.l	d1-d7/a1-a6,-(a7)

;	A corriger !
;	move.b	#1,tios::MaxHandles+$24+$11	;ALPHA LOCK

	lea	temp,a0			;a0=adresse de la chaine
Clear:
	move.l	a0,a6
	lea	20(a0),a1		;pour les étoiles
	clr.w	d4			;part de 0 caractère
loop:
	clr.b	(a6)			;termine la chaine par un 0 pour pouvoir l'afficher
	clr.b	(a1)
	bsr.s	print
	bsr	idle_loop
	cmp.w	#13,d0		;Enter ?
	beq.s	Enter
	cmp.w	#263,d0		;Clear ?
	beq.s	Clear
	cmp.w	#257,d0		;Backspace ?
	beq.s	Del
	cmp.w	#264,d0		;ESC ?
	beq.s	Esc
	cmp.w	#255,d0		;Charactère invalide ?
	bhi.s	loop
	cmp.w	d3,d4		;Maxchar ?
	beq.s	loop
	move.b	d0,(a6)+
	move.b	#'*',(a1)+
	addq.w	#1,d4
	bra.s	loop
Del:
	tst.w	d4
	beq.s	loop
	subq.w	#1,d4
	clr.b	-(a6)
	clr.b	-(a1)
	bra.s	loop
Esc:
	clr.w	d4
	clr.b	(a0)
Enter:
	move.w	d4,d0
	movem.l	(a7)+,d1-d7/a1-a6
	rts

print:		;a0=adresse de chaine à afficher
	movem.l d0-d7/a0-a6,-(a7)
	move.w d1,d0	;x
	move.w d2,d1	;y
	move.w d3,d2
	subq.w #1,d2
	lsl.w #3,d2		;largeur
	moveq #7,d3		;hauteur
	moveq #1,d4		;en blanc
	jsr graphlib::fill

	move.w #4,-(a7)
	move.l a0,-(a7)
	tst.w d6
	bne.s notstars
	add.l #20,(a7)
notstars:
	move.w d1,-(a7)
	move.w d0,-(a7)
	jsr tios::DrawStrXY
	lea 10(a7),a7

	movem.l (a7)+,d0-d7/a0-a6
	RTS

userlib@0007:
getpassword:
	movem.l d0/d2-d7/a0-a6,-(a7)
	move.b	password(pc),d1
	beq	finpassword
	clr.w	-(a7)
	jsr	tios::FontSetSys
	addq.l	#2,a7
	move.w	d0,a6		;sauvegarde l'ancienne fonte
	lea	mpass(pc),a0
	jsr	graphlib::smallbox

	WriteStr #getpassx1,#getpassy1,#4,entpass
	move.w	#getpassd1,d1
	move.w	#getpassd2,d2
	moveq	#10,d3

	clr.l	d6
	bsr	InputStr
	move.l	a0,-(a7)
	pea	password(pc)
	move.w	a6,-(a7)
	jsr	tios::FontSetSys	;restaure la fonte
	addq.l	#2,a7
	jsr	tios::strcmp
	addq.l	#8,a7
	move.w	d0,d1
finpassword:
	movem.l (a7)+,d0/d2-d7/a0-a6
	rts

userlib@0008:
changepass:
	movem.l	d0-d7/a0-a6,-(a7)
	bsr	getpassword
	tst.b	d1
	bne	exit
	clr.w	-(a7)
	jsr	tios::FontSetSys
	addq.l	#2,a7
	lea	mpass(pc),a0
	jsr	graphlib::smallbox
	clr.l	d6		;pour afficher des étoiles
	moveq	#10,d3	;pour que Input demande 10 letrres

	WriteStr #getpassx1,#getpassy1,#4,newpass
	move.w	#getpassd1,d1
	move.w	#getpassd2,d2

	bsr	InputStr
	lea	40(a0),a1		;pour avoir newpasstemp
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+

	WriteStr #getpassx1,#getpassy2,#4,confirm
	move.w	#getpassd1,d1
	move.w	#getpassd22,d2

	bsr	InputStr
	lea	40(a0),a1		;pour avoir newpasstemp
	movem.l	a0-a1,-(a7)
	jsr	tios::strcmp
	movem.l	(a7)+,a0-a1

	tst.w	d0
	bne.s	exit

	lea	password(pc),a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
exit:
	movem.l	(a7)+,d0-d7/a0-a6
	rts


newint6:	RTE

userlib@0009
lockcalc:
;sauve l'ecran
	movem.l	d0-d7/a0-a6,-(a7)

	lea	GHOST_SPACE+$78,a6
	move.l	(a6),d7		;désactive l'auto-int6
	move.l	#newint6,(a6)	;pour ne pas quitter avec [ESC]+[ON]

	clr.w	d0
	clr.w	d1
	move.w	#LCD_LINE_BYTES,d2
	move.w	#LCD_HEIGHT,d3
	jsr	graphlib::scrtomem
;brouille l'écran
Setoff:
	movem.l	d0-d4,-(a7)
	lea 	LCD_MEM,a0
	move.w	#3840/2-1,d2
brouille:
		moveq	#-1,d0
		bsr	random
		move.w	d0,(a0)+
		dbra	d2,brouille
	movem.l	(a7)+,d0-d4
	trap	#4

;demande le mot de passe
	bsr	getpassword
	tst.b	d1
	bne.s	Setoff
	clr.w	d1
	jsr	graphlib::memtoscr

	move.l	d7,(a6)

	movem.l	(a7)+,d0-d7/a0-a6
	RTS

userlib@000A:
idle_hot:
	bsr	idle_loop

	cmp.w	#KeyLock,d0	;F7
	beq.s	hotlock
	cmp.w	#KeyOff,d0	;F8
	beq.s	hotoff
	rts

hotlock:
	bsr lockcalc
	bra.s idle_hot
hotoff:
	trap #4
	bra.s idle_hot

userlib@000B
getfreeRAM:
;renvoie dans d0 la memoire libre
	movem.l	d1-d7/a0-a6,-(a7)
	jsr	tios::HeapAvail
	movem.l	(a7)+,d1-d7/a0-a6
	RTS


userlib@000C
smallmenu:
;Input:
;	d0.w = x
;	d1.w = y
;	d2.b = nbitem
;	a0.l = string list; adding an extra null byte between 2 strings will force
;		smallmenu to draw an horizontal line.
;Output:
;	d0.w = Selected Item
;	d1.w = Last key pressed
;	d2.w = 0  -> ENTER pressed
;		Otherwise, another key has been pressed

	movem.l d3-d7/a0-a6,-(a7)

	clr.l d5		;longueur maximale

	movem.l d2/a0,-(a7)
	subq.w #1,d2	;pour DBRA

longmax:
	tst.b (a0)		;si ligne
	bne.s longsuite
	addq.l #1,a0
longsuite:
	jsr	graphlib::getlength		;d3=largeur, d4=hauteur(constante)
longloop:
	tst.b	(a0)+
	bne.s	longloop

	cmp.w d5,d3
	blt.s reste
	move.w d3,d5
reste:
	dbra d2,longmax

	movem.l (a7)+,d2/a0

	move.w d4,d6
	move.w d5,d7
	addq.w #5,d6	;même marge que doorsos pour même apparence
	addq.w #5,d7

	mulu.w d2,d6	;hauteur du menu

	movem.w d0-d2,-(a7)

	lsr.w #3,d0		;X en octets

	move.w d6,d3
	addq.w #1,d3	;pour éviter barre blanche

	move.w d7,d2
	lsr.w #3,d2		;largeur en octets
	addq.w #2,d2	;sinon les bords sont coupés

	jsr graphlib::scrtomem

	movem.w d0-d4,-(a7)
	movem.w 10(a7),d0-d2

	divu.w d2,d6	;hauteur d'un menu
	move.w d7,d2	;largeur du cadre
	subq.w #2,d3	;pour éviter que fill s'étale...
	moveq #1,d4		;en blanc
	jsr graphlib::fill

	move.w d2,d4
	move.w d3,d5
	addq.w #1,d5
	jsr graphlib::frame

;affiche maintenant tous les titres

	movem.w 10(a7),d0-d2	;pour restaurer d2
	subq.w #1,d2

loopligne:
	tst.b (a0)
	bne.s texte

	move.w d2,-(a7)
	move.w d0,d2	;x1 en d2
	add.w d7,d2		;+largeur-> x2
	jsr graphlib::horiz
	move.w (a7)+,d2
	addq.l #1,a0

texte:
	movem.l d0-d7/a0-a6,-(a7)
	addq.w #2,d0
	addq.w #3,d1
	WriteStrA d0,d1,#4,a0
	movem.l (a7)+,d0-d7/a0-a6

suivant:
	tst.b (a0)+
	bne.s suivant

	add.w d6,d1
	dbra d2,loopligne

	move.w d6,d3
	subq.w #2,d3
	movem.w 10(a7),d0-d2

	move.w d2,d5
	move.w d7,d2

	subq.w #2,d2	;largeur
	addq.w #1,d0
	addq.w #1,d1
	clr.w d4		;couleurs inverses

	move.w #1,a6	;se sert d'a6 comme d'un 9ème registre!

choixloop:
	jsr graphlib::fill

	move.w d0,d7	;sauvegarde d0 (détruit par idle_loop)
	bsr idle_hot
	exg.w d0,d7

	jsr graphlib::fill

	cmp.w #KEY_UP,d7
	bne.s pashaut

	cmp.w #1,a6
	bne.s pasmin
	move.w d5,a6
	move.w d5,d7
	subq.w #1,d7
	mulu.w d6,d7
	add.w d7,d1
	bra.s choixloop
pasmin:
	subq.w #1,a6
	sub.w d6,d1		;fait monter le menu
	bra.s choixloop
pashaut:
	cmp.w #KEY_DOWN,d7
	bne.s pasbas

	cmp.w a6,d5
	bne.s pasmax
	move.w #1,a6
	move.w d5,d7
	subq.w #1,d7
	mulu.w d6,d7
	sub.w d7,d1
	bra.s choixloop
pasmax:
	addq.w #1,a6
	add.w d6,d1		;fait descendre le menu
	bra.s choixloop

pasbas:

	movem.w (a7)+,d0-d4
	addq.l #6,a7

	jsr graphlib::memtoscr

;Est-ce que d7=chiffre ?

	move.w d7,d6
	sub.w #'0',d6	;pour obtenir le code de la touche
	ble.s paschiffre
	cmp.w d5,d6
	bgt.s paschiffre
	move.w d6,a6
	clr.w d2		;un menu a été choisi

paschiffre:
	move.w a6,d0
	move.w d7,d1
	cmp.w #13,d1
	bne.s pasenter
	clr.w d2
pasenter:
	movem.l (a7)+,d3-d7/a0-a6
	RTS

userlib@000D
getfreearchive:
	movem.l	d1-d7/a0-a6,-(a7)
	subq.l	#8,a7			; Stack Frame
	move.l	a7,a2			; Get ptr to stack frame
	clr.l	-(a7)			; &allExceptBaseCode
	clr.l	-(a7)			; &badSectors
	clr.l	-(a7)			; &unusedSectors
	pea	(a2)			; &free
	pea	4(a2)			; &freeAfterGC
	clr.l	-(a7)			; &inUse
	jsr	tios::EM_survey
	lea	8*4(a7),a7
	move.l	(a2),d0			; free
	add.l	(a2)+,d0		; free+freeAfterGc
	movem.l	(a7)+,d1-d7/a0-a6
	rts

userlib@000E
set_apd:
;Input: d0.w = new_APD
	movem.l	d0-d7/a0-a6,-(a7)
	move.w	d0,d7
	move.w	#2,-(a7)
	jsr	tios::OSFreeTimer		;remet à 0
	mulu.w	#20,d7
	move.l	d7,-(a7)
	move.w	#2,-(a7)
	jsr	tios::OSRegisterTimer
	addq.l	#8,a7
	movem.l	(a7)+,d0-d7/a0-a6
	RTS

userlib@000F
get_apd:
	movem.l	d1-d7/a0-a6,-(a7)
	move.w	#2,-(a7)
	jsr	tios::OSTimerRestart
	jsr	tios::OSTimerCurVal
	addq.l	#2,a7
	divu	#20,d0
	movem.l	(a7)+,d1-d7/a0-a6
	rts

userlib@0010
runprog:
	link.w	a6,#-60
	movem.l	d0-d7/a0-a6,-(sp)
	pea	-60(a6)
	jsr	tios::ER_catch
	addq.l	#4,sp
	tst.w	d0
	bne.s	\fail
		jsr	tios::OSDisableBreak
		move.l	8(a6),-(sp)
		ROM_THROW push_parse_text		; To be compatible with AMS 1.00 as much as possible
		move.l	tios::top_estack,-(sp)
		ROM_THROW NG_rationalESI
		jsr	tios::OSEnableBreak
		jsr	tios::ER_success
		addq.l #8,sp
		bra.s	\end
\fail:	clr.w	-(sp)
	move.w	d0,-(sp)
	jsr	tios::ERD_dialog
	addq.l	#4,sp
\end:	movem.l	(sp)+,d0-d7/a0-a6
	unlk a6
	rts


;*****************************************************
; miscellaneous program data
;*****************************************************

userlib@0002:
rand_seed	dc.w	13
charstr		dc.b	0,0
mpass		dc.b	"Password Protection",0
userlib@0011:
password	ds.b	12
entpass		dc.b "Enter current password:",0
newpass		dc.b "Enter the new password:",0
confirm		dc.b "Confirm the password:",0
ziplib_str	dc.b "ziplib",0

	; The ExtraRam table
	EVEN
	EXTRA_RAM_TABLE
	EXTRA_RAM_ADDR 0000,getpassx1,40,53
	EXTRA_RAM_ADDR 0001,getpassy1,38,44
	EXTRA_RAM_ADDR 0002,getpassd1,50,63
	EXTRA_RAM_ADDR 0003,getpassd2,48,59
	EXTRA_RAM_ADDR 0004,getpassy2,60,71
	EXTRA_RAM_ADDR 0005,getpassd22,70,84
	EXTRA_RAM_ADDR 0006,KeyLock,277,274
	EXTRA_RAM_ADDR 0007,KeyOff,266,275
	
	
	BSS

temp	ds.b 20		;utilisé pour InputStr
temp2	ds.b 20		;pour les étoiles
newpasstemp ds.b	12
	end