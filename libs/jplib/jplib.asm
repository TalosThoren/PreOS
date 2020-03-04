	include	tios.h
	include	graphlib.h

	xdef	_library	;85% smaller than original japlib

	xdef	_ti89
	xdef	_ti89ti
	xdef	_ti92plus
	xdef	_v200		

	xdef	_comment


	xdef	jplib@0000
	xdef	jplib@0001
	xdef	jplib@0002
	xdef	jplib@0003
	xdef	jplib@0004
	xdef	jplib@0005
	xdef	jplib@0006
	xdef	jplib@0007
	xdef	jplib@0008
	xdef	jplib@0009
	xdef	jplib@000A
	xdef	jplib@000B
	xdef	jplib@000C
	xdef	jplib@000D
	xdef	jplib@000E
	xdef	jplib@000F
	xdef	jplib@0010
	xdef	jplib@0011
	xdef	jplib@0012
	xdef	jplib@0013
	xdef	jplib@0014
	xdef	jplib@0015
	xdef	jplib@0016
	xdef	jplib@0017
	xdef	jplib@0018
	xdef	jplib@0019
	xdef	jplib@001A
	xdef	jplib@001B
	xdef	jplib@001C
	xdef	jplib@001D
	xdef	jplib@001E
	xdef	jplib@001F
	xdef	jplib@0020
	xdef	jplib@0021
	xdef	jplib@0022
	xdef	jplib@0023
	xdef	jplib@0024
	xdef 	jplib@0025
	xdef	jplib@0026		;ra
	xdef	jplib@0027
	xdef	jplib@0028
	xdef	jplib@0029
	xdef	jplib@002A
	xdef	jplib@002B		;wa
	xdef	jplib@002C
	xdef	jplib@002D
	xdef	jplib@002E		;Katakana
	xdef	jplib@002F
	xdef	jplib@0030
	xdef	jplib@0031
	xdef	jplib@0032
	xdef	jplib@0033		;ka
	xdef	jplib@0034
	xdef	jplib@0035
	xdef	jplib@0036
	xdef	jplib@0037
	xdef	jplib@0038		;sa
	xdef	jplib@0039
	xdef	jplib@003A
	xdef	jplib@003B
	xdef	jplib@003C
	xdef	jplib@003D		;ta
	xdef	jplib@003E
	xdef	jplib@003F
	xdef	jplib@0040
	xdef	jplib@0041
	xdef	jplib@0042		;na
	xdef	jplib@0043
	xdef	jplib@0044
	xdef	jplib@0045
	xdef	jplib@0046
	xdef	jplib@0047		;ha
	xdef	jplib@0048
	xdef	jplib@0049
	xdef	jplib@004A
	xdef	jplib@004B
	xdef	jplib@004C		;ma
	xdef	jplib@004D
	xdef	jplib@004E
	xdef	jplib@004F
	xdef	jplib@0050
	xdef	jplib@0051		;ya
	xdef	jplib@0052
	xdef	jplib@0053
	xdef	jplib@0054		;ra
	xdef	jplib@0055
	xdef	jplib@0056
	xdef	jplib@0057
	xdef	jplib@0058
	xdef	jplib@0059		;wa
	xdef	jplib@005A
	xdef	jplib@005B
	xdef	jplib@005C
	xdef	jplib@005D
	xdef	jplib@005E
	xdef	jplib@005F
	xdef	jplib@0060
	xdef	jplib@0061
	xdef	jplib@0062
	xdef	jplib@0063
	xdef	jplib@0064
	xdef	jplib@0065
	xdef	jplib@0066
	xdef	jplib@0067
	xdef	jplib@0068
	xdef	jplib@0069
	xdef	jplib@006A
	xdef	jplib@006B

	DEFINE	_version01

jplib::A
jplib@0000:
	lea	planea(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#1,charno2
	rts

jplib::I
jplib@0001:
	lea	planei(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#2,charno2
	rts

jplib::U
jplib@0002:
	lea	planeu(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#3,charno2
	rts

jplib::E
jplib@0003:
	lea	planee(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#4,charno2
	rts

jplib::O
jplib@0004:
	lea	planeo(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#5,charno2
	rts

jplib::KA
jplib@0005:
	lea	planeka(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#6,charno2
	rts

jplib::KI
jplib@0006:
	lea	planeki(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#7,charno2
	rts

jplib::KU
jplib@0007:
	lea	planeku(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#8,charno2
	rts

jplib::KE
jplib@0008:
	lea	planeke(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#9,charno2
	rts

jplib::KO
jplib@0009:
	lea	planeko(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#10,charno2
	rts

jplib::SA
jplib@000A:
	lea	planesa(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#11,charno2
	rts

jplib::SHI
jplib@000B:
	lea	planeshi(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#12,charno2
	rts

jplib::SU
jplib@000C:
	lea	planesu(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#13,charno2
	rts

jplib::SE
jplib@000D:
	lea	planese(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#14,charno2
	rts

jplib::SO
jplib@000E:
	lea	planeso(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#15,charno2
	rts	

jplib::TA
jplib@000F:
	lea	planeta(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#16,charno2
	rts

jplib::TCHI
jplib@0010:
	lea	planetchi(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#17,charno2
	rts

jplib::TSU
jplib@0011:
	lea	planetsu(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#18,charno2
	rts

jplib::TE
jplib@0012:
	lea	planete(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#19,charno2
	rts

jplib::TO
jplib@0013:
	lea	planeto(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#20,charno2
	rts

jplib::NA
jplib@0014:
	lea	planena(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#21,charno2
	rts

jplib::NI
jplib@0015:
	lea	planeni(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#22,charno2
	rts

jplib::NU
jplib@0016:
	lea	planenu(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#23,charno2
	rts

jplib::NE
jplib@0017:
	lea	planene(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#24,charno2
	rts

jplib::NO
jplib@0018:
	lea	planeno(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#25,charno2
	rts

jplib::HA
jplib@0019:
	lea	planeha(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#26,charno2
	rts

jplib::HI
jplib@001A:
	lea	planehi(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#27,charno2
	rts

jplib::FU
jplib@001B:
	lea	planefu(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#28,charno2
	rts

jplib::HE
jplib@001C:
	lea	planehe(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#29,charno2
	rts

jplib::HO
jplib@001D:
	lea	planeho(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#30,charno2
	rts

jplib::MA
jplib@001E:
	lea	planema(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#31,charno2
	rts

jplib::MI
jplib@001F:
	lea	planemi(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#32,charno2
	rts

jplib::MU
jplib@0020:
	lea	planemu(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#33,charno2
	rts

jplib::ME
jplib@0021:
	lea	planeme(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#34,charno2
	rts

jplib::MO
jplib@0022:
	lea	planemo(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#35,charno2
	rts

jplib::YA
jplib@0023:
	lea	planeya(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#36,charno2
	rts

jplib::YU
jplib@0024:
	lea	planeyu(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#37,charno2
	rts

jplib::YO
jplib@0025:
	lea	planeyo(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#38,charno2
	rts

jplib::RA
jplib@0026:
	lea	planera(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#39,charno2
	rts

jplib::RI
jplib@0027:
	lea	planeri(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#40,charno2
	rts

jplib::RU
jplib@0028:
	lea	planeru(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#41,charno2
	rts

jplib::RE
jplib@0029:
	lea	planere(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#42,charno2
	rts

jplib::RO
jplib@002A:
	lea	planero(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#43,charno2
	rts

jplib::WA
jplib@002B:
	lea	planewa(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#44,charno2
	rts

jplib::WO
jplib@002C:
	lea	planewo(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#45,charno2
	rts

jplib::N
jplib@002D:
	lea	planen(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#46,charno2
	rts


;****************katakana*****************


jplib::AK
jplib@002E:
	lea	planeak(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#47,charno2
	rts

jplib::IK
jplib@002F:
	lea	planeik(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#48,charno2
	rts

jplib::UK
jplib@0030:
	lea	planeuk(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#49,charno2
	rts

jplib::EK
jplib@0031:
	lea	planeek(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#50,charno2
	rts

jplib::OK
jplib@0032:
	lea	planeok(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#51,charno2
	rts

jplib::KAK
jplib@0033:
	lea	planekak(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#52,charno2
	rts

jplib::KIK
jplib@0034:
	lea	planekik(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#53,charno2
	rts

jplib::KUK
jplib@0035:
	lea	planekuk(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#54,charno2
	rts

jplib::KEK
jplib@0036:
	lea	planekek(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#55,charno2
	rts

jplib::KOK
jplib@0037:
	lea	planekok(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#56,charno2
	rts

jplib::SAK
jplib@0038:
	lea	planesak(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#57,charno2
	rts

jplib::SHIK
jplib@0039:
	lea	planeshik(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#58,charno2
	rts

jplib::SUK
jplib@003A:
	lea	planesuk(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#59,charno2
	rts

jplib::SEK
jplib@003B:
	lea	planesek(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#60,charno2
	rts

jplib::SOK
jplib@003C:
	lea	planesok(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#61,charno2
	rts

jplib::TAK
jplib@003D:
	lea	planetak(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#62,charno2
	rts

jplib::TCHIK
jplib@003E:
	lea	planetchik(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#63,charno2
	rts

jplib::TSUK
jplib@003F:
	lea	planetsuk(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#64,charno2
	rts

jplib::TEK
jplib@0040:
	lea	planetek(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#65,charno2
	rts

jplib::TOK
jplib@0041:
	lea	planetok(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#66,charno2
	rts

jplib::NAK
jplib@0042:
	lea	planenak(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#67,charno2
	rts

jplib::NIK
jplib@0043:
	lea	planenik(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#68,charno2
	rts

jplib::NUK
jplib@0044:
	lea	planenuk(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#69,charno2
	rts

jplib::NEK
jplib@0045:
	lea	planenek(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#70,charno2
	rts

jplib::NOK
jplib@0046:
	lea	planenok(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#71,charno2
	rts

jplib::HAK
jplib@0047:
	lea	planehak(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#72,charno2
	rts

jplib::HIK
jplib@0048:
	lea	planehik(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#73,charno2
	rts

jplib::FUK
jplib@0049:
	lea	planefuk(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#74,charno2
	rts

jplib::HEK
jplib@004A:
	lea	planehe(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#75,charno2
	rts

jplib::HOK
jplib@004B:
	lea	planehok(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#76,charno2
	rts

jplib::MAK
jplib@004C:
	lea	planemak(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#77,charno2
	rts

jplib::MIK
jplib@004D:
	lea	planemik(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#78,charno2
	rts

jplib::MUK
jplib@004E:
	lea	planemuk(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#79,charno2
	rts

jplib::MEK
jplib@004F:
	lea	planemek(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#80,charno2
	rts

jplib::MOK
jplib@0050:
	lea	planemok(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#81,charno2
	rts

jplib::YAK
jplib@0051:
	lea	planeyak(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#82,charno2
	rts

jplib::YUK
jplib@0052:
	lea	planeyuk(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#83,charno2
	rts

jplib::YOK
jplib@0053:
	lea	planeyok(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#84,charno2
	rts

jplib::RAK
jplib@0054:
	lea	planerak(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#85,charno2
	rts

jplib::RIK
jplib@0055:
	lea	planerik(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#86,charno2
	rts

jplib::RUK
jplib@0056:
	lea	planeruk(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#87,charno2
	rts

jplib::REK
jplib@0057:
	lea	planerek(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#88,charno2
	rts

jplib::ROK
jplib@0058:
	lea	planerok(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#89,charno2
	rts

jplib::WAK
jplib@0059:
	lea	planewak(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#90,charno2
	rts

jplib::WOK
jplib@005A:
	lea	planewok(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#91,charno2
	rts

jplib::NK
jplib@005B:
	lea	planenk(Pc),a0
	lea	mask1(Pc),a2
	;move.w	#92,charno2
	rts

jplib::smallak
jplib@005C:
	lea	planeakm(Pc),a0
	lea	mask2(Pc),a2
	;move.w	#93,charno2
	rts

jplib::smallik
jplib@005D:
	lea	planeikm(Pc),a0
	lea	mask2(Pc),a2
	;move.w	#94,charno2
	rts

jplib::smalluk
jplib@005E:
	lea	planeukm(Pc),a0
	lea	mask2(Pc),a2
	;move.w	#95,charno2
	rts

jplib::smallek
jplib@005F:
	lea	planeekm(Pc),a0
	lea	mask2(Pc),a2
	;move.w	#96,charno2
	rts

jplib::smallok
jplib@0060:
	lea	planeokm(Pc),a0
	lea	mask2(Pc),a2
	;move.w	#97,charno2
	rts

jplib::smalltsu
jplib@0061:
	lea	planetsum(Pc),a0
	lea	mask2(Pc),a2
	;move.w	#98,charno2
	rts

jplib::smalltsuk
jplib@0062:
	lea	planetsukm(Pc),a0
	lea	mask2(Pc),a2
	;move.w	#99,charno2
	rts

jplib::smallya
jplib@0063:
	lea	planeyam(Pc),a0
	lea	mask2(Pc),a2
	;move.w	#100,charno2
	rts

jplib::smallyu
jplib@0064:
	lea	planeyum(Pc),a0
	lea	mask2(Pc),a2
	;move.w	#101,charno2
	rts

jplib::smallyo
jplib@0065:
	lea	planeyom(Pc),a0
	lea	mask2(Pc),a2
	;move.w	#102,charno2
	rts

jplib::smallyak
jplib@0066:
	lea	planeyakm(Pc),a0
	lea	mask2(Pc),a2
	;move.w	#103,charno2
	rts

jplib::smallyuk
jplib@0067:
	lea	planeyukm(Pc),a0
	lea	mask2(Pc),a2
	;move.w	#104,charno2
	rts

jplib::smallyok
jplib@0068:
	lea	planeyokm(Pc),a0
	lea	mask2(Pc),a2
	;move.w	#105,charno2
	rts

jplib::tenten
jplib@0069:
	lea	tenten(Pc),a0
	lea	mask3(Pc),a2
	;move.w	#106,charno2
	rts

jplib::maru
jplib@006A:
	lea	maru(Pc),a0
	lea	mask3(Pc),a2
	;move.w	#107,charno2
	rts

jplib::none
jplib@006B:
	rts


planea:
	dc.w	12
	dc.w	2
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00001111,%11100000
 dc.b %00000001,%00000000
 dc.b %00000001,%01000000
 dc.b %00000011,%11000000
 dc.b %00000101,%01000000
 dc.b %00001001,%10100000
 dc.b %00001001,%10100000
 dc.b %00001001,%00100000
 dc.b %00000111,%00000000
 dc.b %00000000,%00000000

mask1:
	dc.b	%00000000,%00000000
	dc.b	%00000000,%00000000
	dc.b	%00000000,%00000000
	dc.b	%00000000,%00000000
	dc.b	%00000000,%00000000
	dc.b	%00000000,%00000000
	dc.b	%00000000,%00000000
	dc.b	%00000000,%00000000
	dc.b	%00000000,%00000000
	dc.b	%00000000,%00000000
	dc.b	%00000000,%00000000
	dc.b	%00000000,%00000000

planei:
	dc.w	11
	dc.w	2
 dc.b %00000010,%01000000
 dc.b %00000010,%01000000
 dc.b %00000100,%00100000
 dc.b %00000100,%00100000
 dc.b %00001000,%00000000
 dc.b %00001000,%00000000
 dc.b %00001000,%00000000
 dc.b %00001000,%00000000
 dc.b %00000100,%10000000
 dc.b %00000101,%00000000
 dc.b %00000010,%00000000

planeu:
	dc.w	12
	dc.w	2
 dc.b %00001000,%00000000
 dc.b %00000100,%00000000
 dc.b %00000010,%00000000
 dc.b %00000000,%00000000
 dc.b %00000110,%00000000
 dc.b %00001001,%00000000
 dc.b %00000000,%10000000
 dc.b %00000000,%10000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000010,%00000000
 dc.b %00000100,%00000000

planee:
	dc.w	12
	dc.w	2
 dc.b %00000010,%00000000
 dc.b %00000001,%00000000
 dc.b %00000000,%00000000
 dc.b %00001111,%11100000
 dc.b %00000000,%00100000
 dc.b %00000000,%01000000
 dc.b %00000000,%10000000
 dc.b %00000001,%00000000
 dc.b %00000010,%00000000
 dc.b %00000100,%00000000
 dc.b %00001001,%11000000
 dc.b %00001110,%00100000

planeo:
	dc.w	12
	dc.w	2
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000111,%11000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00100000
 dc.b %00000001,%00010000
 dc.b %00000001,%00000000
 dc.b %00000011,%10000000
 dc.b %00000101,%01000000
 dc.b %00001001,%00100000
 dc.b %00000110,%00100000
 dc.b %00000000,%00000000

planeka:
	dc.w	12
	dc.w	2
 dc.b %00000010,%00100000
 dc.b %00000010,%00010000
 dc.b %00000111,%10000000
 dc.b %00001010,%01000000
 dc.b %00000010,%00100000
 dc.b %00000010,%00010000
 dc.b %00000010,%00010000
 dc.b %00000010,%00010000
 dc.b %00000010,%00010000
 dc.b %00000010,%00010000
 dc.b %00000010,%00100000
 dc.b %00000000,%00000000

planeki:
	dc.w	12
	dc.w	2
 dc.b %00010001,%00000000
 dc.b %00001010,%00000000
 dc.b %00000100,%01000000
 dc.b %00001010,%10000000
 dc.b %00010001,%00000000
 dc.b %00000010,%10000000
 dc.b %00000100,%01000000
 dc.b %00000000,%10000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00010000
 dc.b %00000000,%11100000

planeku:
	dc.w	12
	dc.w	2
 dc.b %00000000,%01000000
 dc.b %00000000,%10000000
 dc.b %00000001,%00000000
 dc.b %00000010,%00000000
 dc.b %00000100,%00000000
 dc.b %00001000,%00000000
 dc.b %00000100,%00000000
 dc.b %00000010,%00000000
 dc.b %00000001,%00000000
 dc.b %00000000,%10000000
 dc.b %00000000,%01000000
 dc.b %00000000,%00000000

planeke:
	dc.w	12
	dc.w	2
 dc.b %00001000,%01000000
 dc.b %00010000,%00100000
 dc.b %00010000,%00100000
 dc.b %00100000,%00010000
 dc.b %00100000,%01111100
 dc.b %00100000,%00010000
 dc.b %00100000,%00010000
 dc.b %00010000,%00010000
 dc.b %00010000,%00100000
 dc.b %00001000,%00100000
 dc.b %00001010,%00000000
 dc.b %00000100,%00000000

planeko:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000111,%11100000
 dc.b %00001100,%00110000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00001100,%00110000
 dc.b %00000111,%11100000
 dc.b %00000000,%00000000

planesa:
	dc.w	12
	dc.w	2
 dc.b %00000100,%01000000
 dc.b %00000010,%10000000
 dc.b %00000011,%00000000
 dc.b %00000100,%10000000
 dc.b %00000000,%10000000
 dc.b %00000001,%11000000
 dc.b %00000010,%00100000
 dc.b %00000100,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00100000
 dc.b %00000001,%11000000

planeshi:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000010,%00000000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00001000,%00000000
 dc.b %00001000,%00000000
 dc.b %00001000,%00000000
 dc.b %00001000,%00000000
 dc.b %00000100,%00100000
 dc.b %00000100,%01000000
 dc.b %00000011,%10000000
 dc.b %00000000,%00000000

planesu:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000001,%00000000
 dc.b %00000111,%11000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000111,%10000000
 dc.b %00001001,%01000000
 dc.b %00000110,%01000000
 dc.b %00000000,%01000000
 dc.b %00000000,%01000000
 dc.b %00000000,%01000000
 dc.b %00000000,%00000000

planese:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000100,%00000000
 dc.b %00000100,%10000000
 dc.b %00000100,%10000000
 dc.b %00001111,%11000000
 dc.b %00000100,%10000000
 dc.b %00000100,%10000000
 dc.b %00000100,%00000000
 dc.b %00000010,%00000000
 dc.b %00000001,%11100000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000

planeso:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000111,%11000000
 dc.b %00000001,%10000000
 dc.b %00000010,%00000000
 dc.b %00000111,%10000000
 dc.b %00000000,%01000000
 dc.b %00000011,%10000000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00000011,%11000000
 dc.b %00000000,%00000000

planeta:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00001111,%11110000
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00000100,%11110000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00000100,%11110000
 dc.b %00000100,%00000000
 dc.b %00000000,%00000000

planetchi:
	dc.w	12
	dc.w	2
 dc.b %00000001,%00000000
 dc.b %00000000,%10100000
 dc.b %00000000,%01000000
 dc.b %00000000,%10100000
 dc.b %00000001,%00010000
 dc.b %00000011,%00000000
 dc.b %00000000,%10000000
 dc.b %00000000,%01000000
 dc.b %00000000,%01000000
 dc.b %00000000,%01000000
 dc.b %00001000,%10000000
 dc.b %00000111,%00000000

planetsu:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000111,%11000000
 dc.b %00011000,%00110000
 dc.b %00100000,%00010000
 dc.b %00000000,%00001000
 dc.b %00000000,%00001000
 dc.b %00000000,%00001000
 dc.b %00000000,%00010000
 dc.b %00000000,%00110000
 dc.b %00000001,%11000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000

planete:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00001111,%11110000
 dc.b %00000000,%11100000
 dc.b %00000011,%00000000
 dc.b %00000010,%00000000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00000010,%00000000
 dc.b %00000011,%00000000
 dc.b %00000000,%11100000
 dc.b %00000000,%00000000

planeto:
	dc.w	12
	dc.w	2
 dc.b %00001000,%00000000
 dc.b %00000100,%00000000
 dc.b %00000010,%01110000
 dc.b %00000001,%10000000
 dc.b %00000001,%00000000
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00000001,%00000000
 dc.b %00000000,%10000000
 dc.b %00000000,%01110000
 dc.b %00000000,%00000000

planena:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00010000,%00110000
 dc.b %00010000,%00001000
 dc.b %00111111,%10000000
 dc.b %00010000,%00000000
 dc.b %00010000,%00100000
 dc.b %00100000,%00100000
 dc.b %00100000,%00100000
 dc.b %00100000,%01110000
 dc.b %00100000,%10101000
 dc.b %00100000,%01001000
 dc.b %00000000,%00000000

planeni:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00010000,%00000000
 dc.b %00010001,%11000000
 dc.b %00010110,%00110000
 dc.b %00010000,%00000000
 dc.b %00010000,%00000000
 dc.b %00010000,%00000000
 dc.b %00010000,%00000000
 dc.b %00010000,%00000000
 dc.b %00010110,%00110000
 dc.b %00010001,%11000000
 dc.b %00000000,%00000000

planenu:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00010111,%11000000
 dc.b %00011001,%00100000
 dc.b %00011001,%00010000
 dc.b %00101001,%00001000
 dc.b %00100101,%00001000
 dc.b %00100110,%00001000
 dc.b %00100010,%00011000
 dc.b %00100110,%00101000
 dc.b %00011001,%00010100
 dc.b %00000000,%00000000

planene:
	dc.w	12
	dc.w	2
 dc.b %00000100,%00000000
 dc.b %00011111,%10000000
 dc.b %00000101,%00000000
 dc.b %00000101,%00100000
 dc.b %00000110,%11110000
 dc.b %00000101,%10001000
 dc.b %00001110,%00000100
 dc.b %00001100,%00000100
 dc.b %00010100,%00010100
 dc.b %00100100,%00101000
 dc.b %00000100,%00010100
 dc.b %00000000,%00000000

planeno:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000111,%11000000
 dc.b %00001001,%00100000
 dc.b %00010001,%00010000
 dc.b %00100001,%00001000
 dc.b %00100001,%00001000
 dc.b %00100010,%00001000
 dc.b %00100010,%00001000
 dc.b %00100100,%00001000
 dc.b %00011000,%00010000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000

planeha:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00010000,%01000000
 dc.b %00100000,%01000000
 dc.b %00100000,%01000000
 dc.b %01000001,%11110000
 dc.b %01000000,%01000000
 dc.b %01000000,%01000000
 dc.b %01000000,%11100000
 dc.b %00100001,%01010000
 dc.b %00101001,%01010000
 dc.b %00010000,%10010000
 dc.b %00000000,%00000000

planehi:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00011100,%01100000
 dc.b %00001000,%01000000
 dc.b %00010000,%00100000
 dc.b %00010000,%00100000
 dc.b %00010000,%01000000
 dc.b %00010000,%01000000
 dc.b %00001000,%10000000
 dc.b %00000111,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000

planefu:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000011,%00000000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00000011,%10000000
 dc.b %00000000,%01000000
 dc.b %00001000,%01010000
 dc.b %00010000,%01001000
 dc.b %00010001,%10001000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000

planehe:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000001,%00000000
 dc.b %00000010,%10000000
 dc.b %00000100,%01000000
 dc.b %00001000,%00100000
 dc.b %00010000,%00010000
 dc.b %00100000,%00001000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000

planeho:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00001000,%11111000
 dc.b %00010000,%00100000
 dc.b %00010000,%00100000
 dc.b %00100000,%11111000
 dc.b %00100000,%00100000
 dc.b %00100000,%00100000
 dc.b %00100000,%01110000
 dc.b %00010000,%10101000
 dc.b %00010100,%10101000
 dc.b %00001000,%01001000
 dc.b %00000000,%00000000

planema:
	dc.w	12
	dc.w	2
 dc.b %00000001,%00000000
 dc.b %00001111,%11100000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00001111,%11100000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000011,%10000000
 dc.b %00000101,%01000000
 dc.b %00000101,%01000000
 dc.b %00000010,%01000000
 dc.b %00000000,%00000000

planemi:
	dc.w	12
	dc.w	2
 dc.b %00000011,%11100000
 dc.b %00000000,%00100000
 dc.b %00000000,%01000000
 dc.b %00000000,%01000000
 dc.b %00000000,%10000100
 dc.b %00000000,%10000100
 dc.b %00000001,%00001000
 dc.b %00001111,%11101000
 dc.b %00010010,%00011100
 dc.b %00001010,%00010000
 dc.b %00000100,%00010000
 dc.b %00000000,%00100000

planemu:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000001,%00000000
 dc.b %00000111,%11000000
 dc.b %00000001,%00000000
 dc.b %00000001,%01000000
 dc.b %00000011,%00100000
 dc.b %00000101,%00000000
 dc.b %00000011,%00000000
 dc.b %00000001,%00100000
 dc.b %00000001,%01000000
 dc.b %00000001,%10000000
 dc.b %00000000,%00000000

planeme:
	dc.w	12
	dc.w	2
 dc.b %00010000,%00000000
 dc.b %00010000,%00000000
 dc.b %00001011,%11100000
 dc.b %00001100,%10010000
 dc.b %00001100,%10001000
 dc.b %00010100,%10000100
 dc.b %00010100,%10000100
 dc.b %00010011,%00000100
 dc.b %00010011,%00000100
 dc.b %00010011,%00000100
 dc.b %00001101,%00001000
 dc.b %00000000,%00000000

planemo:
	dc.w	12
	dc.w	2
 dc.b %00000010,%00000000
 dc.b %00011111,%11000000
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00011111,%11000000
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00000001,%00001000
 dc.b %00000001,%00010000
 dc.b %00000000,%11100000
 dc.b %00000000,%00000000

planeya:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00010000,%10000000
 dc.b %00010000,%10000000
 dc.b %00001000,%01011000
 dc.b %00001000,%11100100
 dc.b %00000111,%00100010
 dc.b %00011100,%00100010
 dc.b %01100100,%00000100
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000

planeyu:
	dc.w	12
	dc.w	2
 dc.b %00000000,%10000000
 dc.b %00100111,%11110000
 dc.b %00101000,%10001000
 dc.b %00110000,%01000100
 dc.b %00100000,%01000010
 dc.b %00100000,%01000010
 dc.b %00100000,%01000010
 dc.b %00100000,%01000010
 dc.b %00100000,%01000010
 dc.b %00110000,%01000100
 dc.b %00101000,%10001000
 dc.b %00100111,%11110000

planeyo:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%11110000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00001111,%10000000
 dc.b %00010001,%01000000
 dc.b %00010010,%00100000
 dc.b %00001100,%00100000

planera:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000001,%00000000
 dc.b %00000100,%11000000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00000111,%10000000
 dc.b %00000100,%01000000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000100,%01000000
 dc.b %00000011,%10000000

planeri:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000100,%01000000
 dc.b %00001000,%00100000
 dc.b %00001000,%00010000
 dc.b %00001010,%00010000
 dc.b %00000100,%00010000
 dc.b %00000000,%00010000
 dc.b %00000000,%00010000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000000,%01000000
 dc.b %00000000,%00000000

planeru:
	dc.w	12
	dc.w	2
 dc.b %00000111,%11100000
 dc.b %00000000,%01000000
 dc.b %00000000,%10000000
 dc.b %00000001,%00000000
 dc.b %00000010,%00000000
 dc.b %00000111,%10000000
 dc.b %00000000,%01000000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000011,%00100000
 dc.b %00000100,%11000000
 dc.b %00000011,%10000000
planere:
	dc.w	12
	dc.w	2
 dc.b %00001000,%00000000
 dc.b %00111111,%00000000
 dc.b %00001010,%00000000
 dc.b %00001010,%01000000
 dc.b %00001101,%11100000
 dc.b %00001011,%00010000
 dc.b %00011100,%00010000
 dc.b %00011000,%00010000
 dc.b %00101000,%00010000
 dc.b %01001000,%00010010
 dc.b %00001000,%00001100
 dc.b %00000000,%00000000

planero:
	dc.w	12
	dc.w	2
 dc.b %00000111,%11100000
 dc.b %00000000,%01000000
 dc.b %00000000,%10000000
 dc.b %00000001,%00000000
 dc.b %00000010,%00000000
 dc.b %00000111,%10000000
 dc.b %00000000,%01000000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00001000,%00100000
 dc.b %00000100,%01000000
 dc.b %00000011,%10000000

planewa:
	dc.w	12
	dc.w	2
 dc.b %00000100,%00000000
 dc.b %00011111,%10000000
 dc.b %00000101,%00000000
 dc.b %00000101,%00100000
 dc.b %00000110,%11110000
 dc.b %00000101,%10001000
 dc.b %00001110,%00000100
 dc.b %00001100,%00000100
 dc.b %00010100,%00000100
 dc.b %00100100,%00000100
 dc.b %00000100,%00001000
 dc.b %00000000,%00000000

planewo:
	dc.w	12
	dc.w	2
 dc.b %00000010,%00000000
 dc.b %00001111,%10000000
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00000010,%11000000
 dc.b %00000011,%00100000
 dc.b %00000010,%01110000
 dc.b %00000000,%10100000
 dc.b %00000000,%10100000
 dc.b %00000000,%10000000
 dc.b %00000000,%01110000
 dc.b %00000000,%00000000

planen:
	dc.w	12
	dc.w	2
 dc.b %00001000,%00000000
 dc.b %00001000,%00000000
 dc.b %00001000,%00000000
 dc.b %00010000,%00000000
 dc.b %00010000,%00000000
 dc.b %00010000,%00000000
 dc.b %00010011,%00000000
 dc.b %00010100,%10000000
 dc.b %00101000,%01000100
 dc.b %00100000,%01001000
 dc.b %00100000,%00110000
 dc.b %00000000,%00000000

planeak:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00011111,%11111000
 dc.b %00000000,%00010000
 dc.b %00000001,%00100000
 dc.b %00000001,%01000000
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00001000,%00000000
 dc.b %00001000,%00000000

planeik:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000000,%00010000
 dc.b %00000000,%01100000
 dc.b %00000000,%10000000
 dc.b %00000001,%10000000
 dc.b %00000110,%10000000
 dc.b %00001000,%10000000
 dc.b %00000000,%10000000
 dc.b %00000000,%10000000
 dc.b %00000000,%10000000
 dc.b %00000000,%10000000
 dc.b %00000000,%10000000

planeuk:
	dc.w	12
	dc.w	2
 dc.b %00000000,%10000000
 dc.b %00000000,%10000000
 dc.b %00000000,%10000000
 dc.b %00011111,%11111100
 dc.b %00010000,%00000100
 dc.b %00010000,%00000100
 dc.b %00010000,%00001000
 dc.b %00000000,%00001000
 dc.b %00000000,%00010000
 dc.b %00000000,%00100000
 dc.b %00000000,%11000000
 dc.b %00000011,%00000000

planeek:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00011111,%11110000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00111111,%11111000

planeok:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000000,%10000000
 dc.b %00000000,%10000000
 dc.b %00000000,%10000000
 dc.b %00000000,%10000000
 dc.b %00000111,%11110000
 dc.b %00000001,%10000000
 dc.b %00000001,%10000000
 dc.b %00000010,%10000000
 dc.b %00000100,%10000000
 dc.b %00000000,%10000000
 dc.b %00000001,%10000000

planekak:
	dc.w	12
	dc.w	2
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00000100,%11111000
 dc.b %00011111,%00001000
 dc.b %00000100,%00010000
 dc.b %00000100,%00010000
 dc.b %00000100,%00010000
 dc.b %00001000,%00010000
 dc.b %00001000,%00100000
 dc.b %00001000,%00100000
 dc.b %00000000,%00000000

planekik:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00010000,%01000000
 dc.b %00001000,%10000000
 dc.b %00000101,%00000000
 dc.b %00000010,%00001000
 dc.b %00000101,%00010000
 dc.b %00001000,%10100000
 dc.b %00010000,%01000000
 dc.b %00000000,%10100000
 dc.b %00000001,%00010000
 dc.b %00000010,%00001000
 dc.b %00000000,%00000100

planekuk:
	dc.w	12
	dc.w	2
 dc.b %00000000,%01000000
 dc.b %00000000,%10000000
 dc.b %00000001,%11110000
 dc.b %00000010,%00010000
 dc.b %00000100,%00100000
 dc.b %00001000,%01000000
 dc.b %00000000,%10000000
 dc.b %00000001,%00000000
 dc.b %00000010,%00000000
 dc.b %00000100,%00000000
 dc.b %00001000,%00000000
 dc.b %00000000,%00000000

planekek:
	dc.w	12
	dc.w	2
 dc.b %00000001,%00000000
 dc.b %00000010,%00000000
 dc.b %00000111,%11111000
 dc.b %00001000,%01000000
 dc.b %00010000,%10000000
 dc.b %00100001,%00000000
 dc.b %00000010,%00000000
 dc.b %00000100,%00000000
 dc.b %00001000,%00000000
 dc.b %00010000,%00000000
 dc.b %00100000,%00000000
 dc.b %00000000,%00000000

planekok:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00001111,%11110000
 dc.b %00000000,%00010000
 dc.b %00000000,%00010000
 dc.b %00000000,%00010000
 dc.b %00000000,%00010000
 dc.b %00000000,%00010000
 dc.b %00000000,%00010000
 dc.b %00001111,%11110000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000

planesak:
	dc.w	12
	dc.w	2
 dc.b %00010001,%00000000
 dc.b %00010001,%00000000
 dc.b %11111111,%11100000
 dc.b %00010001,%00000000
 dc.b %00010001,%00000000
 dc.b %00010001,%00000000
 dc.b %00010001,%00000000
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00000000,%00000000

planeshik:
	dc.w	12
	dc.w	2
 dc.b %11100000,%00001000
 dc.b %00000000,%00010000
 dc.b %11100000,%01100000
 dc.b %00000000,%11000000
 dc.b %00000001,%10000000
 dc.b %00000011,%00000000
 dc.b %00000110,%00000000
 dc.b %00011100,%00000000
 dc.b %00111000,%00000000
 dc.b %01110000,%00000000
 dc.b %11100000,%00000000
 dc.b %00000000,%00000000

planesuk:
	dc.w	12
	dc.w	2
 dc.b %00001111,%11100000
 dc.b %00000000,%01000000
 dc.b %00000000,%01000000
 dc.b %00000000,%10000000
 dc.b %00000000,%10000000
 dc.b %00000001,%00000000
 dc.b %00000011,%00000000
 dc.b %00000010,%10000000
 dc.b %00000100,%01000000
 dc.b %00000100,%01000000
 dc.b %00001000,%00100000
 dc.b %00000000,%00000000

planesek:
	dc.w	12
	dc.w	2
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00000100,%11111000
 dc.b %00011111,%00010000
 dc.b %00000100,%00100000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00000011,%11111000
 dc.b %00000000,%00000000

planesok:
	dc.w	12
	dc.w	2
 dc.b %00001000,%00010000
 dc.b %00001000,%00110000
 dc.b %00001000,%00110000
 dc.b %00000000,%01100000
 dc.b %00000000,%11000000
 dc.b %00000000,%10000000
 dc.b %00000001,%10000000
 dc.b %00000011,%00000000
 dc.b %00000110,%00000000
 dc.b %00000100,%00000000
 dc.b %00001000,%00000000
 dc.b %00000000,%00000000

planetak:
	dc.w	12
	dc.w	2
 dc.b %00000000,%10000000
 dc.b %00000001,%11110000
 dc.b %00000010,%00010000
 dc.b %00000100,%00100000
 dc.b %00001010,%01000000
 dc.b %00010001,%10000000
 dc.b %00000001,%00000000
 dc.b %00000010,%00000000
 dc.b %00000100,%00000000
 dc.b %00001000,%00000000
 dc.b %00010000,%00000000
 dc.b %00000000,%00000000

planetchik:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000000,%11100000
 dc.b %00000111,%10000000
 dc.b %00000000,%10000000
 dc.b %00011111,%11111000
 dc.b %00000000,%10000000
 dc.b %00000000,%10000000
 dc.b %00000000,%10000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000010,%00000000
 dc.b %00000100,%00000000

planetsuk:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00010100,%00011100
 dc.b %00010100,%00111000
 dc.b %00010100,%01110000
 dc.b %00000000,%01100000
 dc.b %00000000,%11000000
 dc.b %00000001,%10000000
 dc.b %00000011,%00000000
 dc.b %00000110,%00000000
 dc.b %00000100,%00000000
 dc.b %00001000,%00000000
 dc.b %00010000,%00000000

planetek:
	dc.w	12
	dc.w	2
 dc.b %00000111,%11100000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00011111,%11111000
 dc.b %00000000,%10000000
 dc.b %00000000,%10000000
 dc.b %00000000,%10000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000010,%00000000
 dc.b %00000100,%00000000
 dc.b %00000000,%00000000

planetok:
	dc.w	12
	dc.w	2
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%10000000
 dc.b %00000001,%01000000
 dc.b %00000001,%00100000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000000,%00000000

planenak:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00000111,%11111100
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00000100,%00000000
 dc.b %00000100,%00000000
 dc.b %00001000,%00000000
 dc.b %00001000,%00000000
 dc.b %00010000,%00000000
 dc.b %00000000,%00000000

planenik:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000111,%11110000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00011111,%11111100
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000

planenuk:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00001111,%11110000
 dc.b %00000000,%00010000
 dc.b %00000000,%00010000
 dc.b %00000000,%00100000
 dc.b %00000011,%00100000
 dc.b %00000000,%11000000
 dc.b %00000000,%11000000
 dc.b %00000001,%00100000
 dc.b %00000110,%00010000
 dc.b %00001000,%00000000
 dc.b %00000000,%00000000

planenek:
	dc.w	12
	dc.w	2
 dc.b %00000010,%00000000
 dc.b %00000001,%10000000
 dc.b %00000000,%00000000
 dc.b %00000111,%11000000
 dc.b %00000000,%01000000
 dc.b %00000000,%10000000
 dc.b %00000001,%00000000
 dc.b %00000011,%10000000
 dc.b %00000101,%01000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000

planenok:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000000,%00111000
 dc.b %00000000,%01110000
 dc.b %00000000,%11100000
 dc.b %00000000,%11000000
 dc.b %00000001,%10000000
 dc.b %00000011,%00000000
 dc.b %00000110,%00000000
 dc.b %00001100,%00000000
 dc.b %00001000,%00000000
 dc.b %00010000,%00000000
 dc.b %00100000,%00000000

planehak:
	dc.w	12
	dc.w	2
 dc.b %00001000,%10000000
 dc.b %00001000,%10000000
 dc.b %00010000,%01000000
 dc.b %00010000,%01000000
 dc.b %00100000,%00100000
 dc.b %01000000,%00010000
 dc.b %10000000,%00001000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000

planehik:
	dc.w	12
	dc.w	2

 dc.b %00000000,%00000000
 dc.b %00010000,%00000000
 dc.b %00010000,%01100000
 dc.b %00010111,%10000000
 dc.b %00011000,%00000000
 dc.b %00010000,%00000000
 dc.b %00010000,%00000000
 dc.b %00010000,%00000000
 dc.b %00010000,%00000000
 dc.b %00001111,%11100000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000

planefuk:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00011111,%11111000
 dc.b %00000000,%00001000
 dc.b %00000000,%00001000
 dc.b %00000000,%00010000
 dc.b %00000000,%00010000
 dc.b %00000000,%00100000
 dc.b %00000000,%01000000
 dc.b %00000000,%10000000
 dc.b %00000011,%00000000
 dc.b %00011100,%00000000
 dc.b %00000000,%00000000

planehok:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00001111,%11100000
 dc.b %00000001,%00000000
 dc.b %00000101,%01000000
 dc.b %00000101,%01000000
 dc.b %00001001,%00100000
 dc.b %00001001,%00100000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000000,%00000000

planemak:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00011111,%11110000
 dc.b %00000000,%00001000
 dc.b %00000000,%00010000
 dc.b %00000000,%00100000
 dc.b %00000001,%01000000
 dc.b %00000000,%10000000
 dc.b %00000000,%01000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000

planemik:
	dc.w	12
	dc.w	2
 dc.b %00000100,%00000000
 dc.b %00000011,%10000000
 dc.b %00000000,%01000000
 dc.b %00000000,%00000000
 dc.b %00000100,%00000000
 dc.b %00000010,%00000000
 dc.b %00000001,%10000000
 dc.b %00000000,%01000000
 dc.b %00000000,%00000000
 dc.b %00000100,%00000000
 dc.b %00000011,%00000000
 dc.b %00000000,%11000000

planemuk:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000000,%00010000
 dc.b %00000000,%00100000
 dc.b %00000000,%01000000
 dc.b %00000000,%10000000
 dc.b %00000001,%00000000
 dc.b %00000010,%00010000
 dc.b %00000100,%00010000
 dc.b %00111111,%11111000
 dc.b %00000000,%00001000
 dc.b %00000000,%00001000
 dc.b %00000000,%00000000

planemek:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000000,%00111000
 dc.b %00000000,%01110000
 dc.b %00000000,%11100000
 dc.b %00001100,%11000000
 dc.b %00000011,%10000000
 dc.b %00000011,%00000000
 dc.b %00000110,%10000000
 dc.b %00001100,%01000000
 dc.b %00001000,%01000000
 dc.b %00010000,%00000000
 dc.b %00100000,%00000000

planemok:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00001111,%11100000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00011111,%11110000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000
 dc.b %00000000,%10000000
 dc.b %00000000,%01100000

planeyak:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00001000
 dc.b %00010000,%00011000
 dc.b %00010000,%01101000
 dc.b %00001000,%10001000
 dc.b %00001001,%00001000
 dc.b %00000110,%00000000
 dc.b %00001100,%00000000
 dc.b %00010100,%00000000
 dc.b %00000010,%00000000
 dc.b %00000010,%00000000
 dc.b %00000001,%00000000
 dc.b %00000001,%00000000

planeyuk:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00001111,%11100000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00111111,%11111100
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000

planeyok:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00001111,%11100000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00001111,%11100000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00001111,%11100000

planerak:
	dc.w	12
	dc.w	2
 dc.b %00000111,%11100000
 dc.b %00000000,%00000000
 dc.b %00001111,%11110000
 dc.b %00000000,%00010000
 dc.b %00000000,%00010000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000000,%01000000
 dc.b %00000000,%10000000
 dc.b %00000001,%00000000
 dc.b %00000110,%00000000
 dc.b %00000000,%00000000

planerik:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000100,%00100000
 dc.b %00000100,%00100000
 dc.b %00000100,%00100000
 dc.b %00000100,%00100000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000000,%00100000
 dc.b %00000000,%01000000
 dc.b %00000000,%10000000
 dc.b %00000000,%00000000

planeruk:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000010,%01000000
 dc.b %00000010,%01000000
 dc.b %00000010,%01000000
 dc.b %00000010,%01000000
 dc.b %00000010,%01000000
 dc.b %00000100,%01000100
 dc.b %00000100,%01000100
 dc.b %00001000,%01001000
 dc.b %00010000,%01010000
 dc.b %00100000,%01100000
 dc.b %00000000,%00000000

planerek:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00001000,%00000000
 dc.b %00001000,%00000000
 dc.b %00001000,%00000000
 dc.b %00001000,%00000000
 dc.b %00001000,%00000000
 dc.b %00001000,%00010000
 dc.b %00001000,%00010000
 dc.b %00001000,%00100000
 dc.b %00001000,%01000000
 dc.b %00001001,%10000000
 dc.b %00001110,%00000000

planerok:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000
 dc.b %00001111,%11110000
 dc.b %00001000,%00010000
 dc.b %00001000,%00010000
 dc.b %00001000,%00010000
 dc.b %00001000,%00010000
 dc.b %00001000,%00010000
 dc.b %00001000,%00010000
 dc.b %00001111,%11110000
 dc.b %00000000,%00000000
 dc.b %00000000,%00000000

planewak:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00011111,%11111000
 dc.b %00010000,%00001000
 dc.b %00010000,%00001000
 dc.b %00000000,%00010000
 dc.b %00000000,%00010000
 dc.b %00000000,%00100000
 dc.b %00000000,%01000000
 dc.b %00000000,%10000000
 dc.b %00000011,%00000000
 dc.b %00011100,%00000000
 dc.b %00000000,%00000000

planewok:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00011111,%11111000
 dc.b %00000000,%00001000
 dc.b %00000000,%00001000
 dc.b %00011111,%11111000
 dc.b %00000000,%00010000
 dc.b %00000000,%00100000
 dc.b %00000000,%01000000
 dc.b %00000000,%10000000
 dc.b %00000011,%00000000
 dc.b %00011100,%00000000
 dc.b %00000000,%00000000

planenk:
	dc.w	12
	dc.w	2
 dc.b %00000000,%00000000
 dc.b %00000000,%00001000
 dc.b %00001000,%00010000
 dc.b %00001000,%00110000
 dc.b %00001000,%00100000
 dc.b %00000000,%01100000
 dc.b %00000000,%11000000
 dc.b %00000001,%10000000
 dc.b %00000011,%10000000
 dc.b %00000011,%00000000
 dc.b %00000111,%00000000
 dc.b %00001110,%00000000

mask2:
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000

planeakm:
	dc.w 8
	dc.w 1
 dc.b %11111000
 dc.b %00001000
 dc.b %00101000
 dc.b %00110000
 dc.b %00100000
 dc.b %00100000
 dc.b %00100000
 dc.b %00000000

planeikm:
	dc.w 8
	dc.w 1
 dc.b %00010000
 dc.b %00100000
 dc.b %01100000
 dc.b %10100000
 dc.b %00100000
 dc.b %00100000
 dc.b %00100000
 dc.b %00000000

planeukm:
	dc.w 8
	dc.w 1
 dc.b %00100000
 dc.b %11111000
 dc.b %10001000
 dc.b %00001000
 dc.b %00010000
 dc.b %00100000
 dc.b %00000000
 dc.b %00000000

planeekm:
	dc.w 8
	dc.w 1
 dc.b %01111100
 dc.b %00010000
 dc.b %00010000
 dc.b %11111110
 dc.b %00000000
 dc.b %00000000
 dc.b %00000000
 dc.b %00000000

planeokm:
	dc.w 8
	dc.w 1
 dc.b %00100000
 dc.b %11111000
 dc.b %01100000
 dc.b %10100000
 dc.b %00100000
 dc.b %00100000
 dc.b %00000000
 dc.b %00000000

planetsum:
	dc.w 8	
	dc.w 1	
 dc.b %00111000
 dc.b %11000100
 dc.b %00000010
 dc.b %00000010
 dc.b %00000100
 dc.b %00001000
 dc.b %00110000
 dc.b %00000000

planetsukm:
	dc.w 8
	dc.w 1
 dc.b %10100110
 dc.b %00001100
 dc.b %00011000
 dc.b %00010000
 dc.b %00100000
 dc.b %01000000
 dc.b %00000000
 dc.b %00000000

planeyam:
	dc.w 8
	dc.w 1
 dc.b %01010000
 dc.b %01011100
 dc.b %11101000
 dc.b %00100000
 dc.b %00100000
 dc.b %00100000
 dc.b %00000000
 dc.b %00000000

planeyum:
	dc.w 8
	dc.w 1
 dc.b %10011100
 dc.b %10101010
 dc.b %11001001
 dc.b %10101010
 dc.b %10011100
 dc.b %00000000
 dc.b %00000000
 dc.b %00000000

planeyom:
	dc.w 8
	dc.w 1
 dc.b %00100000
 dc.b %00111000
 dc.b %00100000
 dc.b %01110000
 dc.b %10101000
 dc.b %01001000
 dc.b %00000000
 dc.b %00000000

planeyakm:
	dc.w 8
	dc.w 1
 dc.b %01000001
 dc.b %01000111
 dc.b %01011001
 dc.b %01100000
 dc.b %10100000
 dc.b %00100000
 dc.b %00100000
 dc.b %00000000

planeyukm:
	dc.w 8
	dc.w 1
 dc.b %00111100
 dc.b %00000100
 dc.b %00000100
 dc.b %11111111
 dc.b %00000000
 dc.b %00000000
 dc.b %00000000
 dc.b %00000000

planeyokm:
	dc.w 8
	dc.w 1
 dc.b %11111000
 dc.b %00001000
 dc.b %00001000
 dc.b %11111000
 dc.b %00001000
 dc.b %00001000
 dc.b %11111000
 dc.b %00000000

mask3:
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00000000

tenten:
	dc.w 3
	dc.w 1
 dc.b %01000000
 dc.b %10100000
 dc.b %01000000

maru:
	dc.w 8
	dc.w 1
 dc.b %11100000
 dc.b %10100000
 dc.b %11100000

_comment:	dc.b	"jplib by Bentensai",0

	end
