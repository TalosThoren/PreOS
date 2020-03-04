;***************************************************************
;			     FXLIB
;			      BY
;		   MARKUS KLISICS - MARKEY (TCPA)
;
;	       HOMEPAGE: WWW.MARKUSOFT.COM
;		  EMAIL: MARKLI-9@STUDENT.LUTH.SE
;***************************************************************


_IDLE		EQU	0
_PLAYING	EQU	1

_ONCE		EQU	0
_LOOP		EQU	1

_END		EQU	0
_PAUSE		EQU	32000


;***************************************************************
; Install FX routine
;
; void install()
;
;***************************************************************
fxlib::install		EQU	fxlib@0000


;***************************************************************
; Uninstall FX routine
;
; void uninstall()
;
;***************************************************************
fxlib::uninstall	EQU	fxlib@0001


;***************************************************************
; Play Sound FX
;
; void playfx(void *fxptr, int mode) (mode = {_ONCE, _LOOP})
;
;***************************************************************
fxlib::playfx		EQU	fxlib@0002


;***************************************************************
; Stop FX
;
; void stop()
;
;***************************************************************
fxlib::stop		EQU	fxlib@0003


;***************************************************************
; Get Status
;
; int getstatus()
;
; returns: d0.w = _IDLE/_PLAYING
;
;***************************************************************
fxlib::getstatus	EQU	fxlib@0004


;***************************************************************
; Delay
;
; void delay(int ms) (ms in miliseconds, 1000 ms = 1 S)
;
; OBS! Maximum is 5.9 s
;
;***************************************************************
fxlib::delay		EQU	fxlib@0005


;***************************************************************
; Set Timer
;
; void settimer(int ms) (ms in miliseconds, 1000 ms = 1 S)
;
; OBS! Maximum is 5.9 s
;
;***************************************************************
fxlib::settimer		EQU	fxlib@0006


;***************************************************************
; Timer Expired?
;
; int timerexpired()
;
; returns: d0.w = 0 (means expired)
;	   d0.w > 0 (still counting)
;
;***************************************************************
fxlib::timerexpired	EQU	fxlib@0007

