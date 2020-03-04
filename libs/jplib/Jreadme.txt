Welcome to Jplib!!!
	This is a library that contains all of the normal hiragana in the japanese language.  It is simple to use,  To use this you need graphlib.  To use it in a program use the following form.

	move.w	#147,d0			;x=147
	move.w	#0,d1			;y=0
	jsr	jplib::A		;put charactor "A" into a0 and mask into a2
	jsr	graphlib::put_sprite2	;draw (x,y,charactor "A",mask)

Hiragana are labeled by their sound.  A for Charactor A, KA for charactor KA.  Katakana Charactors are labeled by their sound but have a K after it.  Katakana A is AK, Katakana KA is KAK

I am currently working on kanji.  
Visit my website at http:\www.fortunecity.com\meltingpot\gilford\908
Any questions or problems email me at Bentensai@fcmail.com

JpLib v1.00.P1
Optimisations by PpHd (Reduce size to 4109 bytes).
