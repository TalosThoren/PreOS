; ************************************************************************
;
;			Wti Interface code
;
; ************************************************************************


; ************************************************************************
;
;			Wti Interface code Licence
;
; ************************************************************************

;Pour que toutes ces fonctionnalités restent efficaces, il faut qu'elles
;soient toujours utilisées correctement et il est donc nécessaire de prévenir
;tout abus. Par exemple, PrgmBP a un but bien précis et si quelqu'un
;l'utilise pour d'autres raisons, cela risque de créer des conflits et WTI
;s'arrêtera n'importe où. D'ailleurs, on peut déjà dire que PrgmBP est
;strictement interdit dans une application : PrgmBP est réservé à tout kernel
;ou substitut.
 
;Alors les règles concernant l'envoi d'information à WTI sont simples :
;1) Ces informations peuvent être utilisées librement à titre strictement
;privé.
;2) Il est formellement interdit de diffuser un programme utilisant ces
;informations sans mon autorisation.
;3) Lors qu'on distribue un programme utilisant ces informations, il est
;impératif de le mentionner, en commentaire à chaque séquence de code
;concerné si le programme est open-source et dans la documentation, en
;faisant uniquement référence à la documentation de WTI.

;						JM

ioWTI			equ 	('WTI'<<9)

IS_WTI	MACRO
	moveq	#0,d0
	lea	ioWTI,a0
	add.l	(a0),d0
	bcs.\0	\1
	ENDM
	
SET_WTI_BP	MACRO
	trap	#12
	move.l \1,(ioWTI+2).l
	move.w	#$0,SR
	ENDM
	
CLEAR_WTI_BP	MACRO
	trap	#12
	clr.l	(ioWTI+2).l
	move.w	#$0,SR
	ENDM
	
	
; ************************************************************************
;
;		[HW2] Bugs when changing batteries	
;
; ************************************************************************

; All work is done by JM.
;
; Il faut savoir que sur les 89 HW1&2 et 92+ HW2, le CPU n'est pas alimente par
; la pile bouton. Un changement de piles lorsque la calc est eteinte reinialise 
; toujours le CPU ! Le boot est execute, puis AMS. Enfin des ports gerant la 
; fameuse limite materielle sont reinialises ($700000-$700007). Puis AMS detecte
; que la calc s'est eteinte et elle continue l'execution a la fin de la routine
; trap #4. Trap #4 restaure a nouveau les ports $700000-$700007 a la fin en 
; reappelant le trap #B. Mais ce dernier considere que l'appel est invalide et 
; ne corrige pas les ports $700000-700007 :
;	move.l	Usp,a0
;	movea.l	$10(a0),a0
;	cmpa.l	#$212000,a0
;	bcs.s	\fatal
;	cmpa.l	#$33EC58,a0
;	bcc.s	\fatal
;	...
; Bref AMS 2.0x est "buggue". Il suffit d'executer :
;	exec "4E444E750000" (trap #4 / rts)
; sur une calculatrice propre (aucun patch / kernel / TSR) et de changer les piles
; lorsque la calc est eteinte pour faire planter la TI sur HW2 !
;
;						JM, 2002/08/28
;					(Adaptation par PpHd)
;
; Hw2Patch pourrait corriger cela en modifiant aussi le code restaurant les ports 
; $700000-$700007 lors du boot, mais ca fait ultra-chier JM.
; Bref c'est moi qui m'y colle.
; Patch a apporter sur HW2/AMS 2.0x s'il n'y a pas Hw2Tsr.
;						PpHd, 2002/08/29

NEW_TRAP4	MACRO
Trap4:	pea	(a0)		; Save A0
	move.l	USP,a0		;
	pea	(a0)		; Save Usp
	suba.l	a0,a0		; Usp = 0 (Vector Table), so $10(a0) = Illegal Instrution Vector
	move	a0,USP		; but it is the original vector (the vectors are restored by AMS during the call of trap #B)
	bsr.s	t4call		; So the range of $10(Usp) is Ok ! It will work.
	move.l	(sp)+,a0	; 
	move.l	a0,USP		; Restore Usp
	move.l	(sp)+,a0	; Restore a0
	rte
t4call:	move.w	SR,-(sp)	; Call the original Trap #4 (Return addr is pushed, and pushes the SR)
	jmp	($0).l		; Jump to the original trap #4
		ENDM
		