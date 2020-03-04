;--------------------------------------------------------------
;unsigned char readheader(void *CompressedData)
;
; Function :
;	ben.. lit le header je présume... #confus# ( où alors Kristian Kræmmer Nielsen (i.e. l'auteur original) c un sacré pervers #picol# ...................................... Brrr, rien que d'y penser, j'en ai froid ds le dos #gol# )
;	bon ba ct bien ça : Reads the header of a fargray-datablock :)
;
;Input :
;	a5.l= Pointer to compressed data
;Output :
;	d2.b= 0 ou 1 selon les cas, qu'il me reste à découvrir..
;--------------------------------------------------------------
fargray::readheader	equ	fargray@0000








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
fargray::setbits	equ	fargray@0001








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
fargray::putimage	equ	fargray@0002







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
fargray::put1planepic	equ	fargray@0003








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
fargray::put2planepic	equ	fargray@0004







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
fargray::put3planepic	equ	fargray@0005