;----------------------------------------------------------------------------
; Notes on TrigLib
;----------------------------------------------------------------------------
; Functions calculate various trigonometric functions.  Made for use in
; were high speed calculations are needed, parameters are passed to these
; functions through the registers instead of the through the use of the
; stack.
;----------------------------------------------------------------------------

;----------------------------------------------------------------------------
; Sine
;
; Function: Calculates the Sine of the D0.B
; Input: D0.B = Binary degrees from which Sine will be calculated.
; Return: D1.B = Sine of D0.B
;         A0 = Destroyed
;----------------------------------------------------------------------------
triglib::sin          equ       triglib@0000

;----------------------------------------------------------------------------
; Cosine
;
; Function: Calculates the Cosine of the D0.B
; Input: D0.B = Binary degrees from which Cosine will be calculated.
; Return: D1.B = Sine of D0.B
;         A0 = Destroyed
;----------------------------------------------------------------------------
triglib::cos          equ       triglib@0001

;----------------------------------------------------------------------------
; Inverse Sine  ( 1/sin(D0.B) )
;
; Function: Calculates the inverse of the Sine of the D0.B
; Input: D0.B = Binary degrees
; Return: D1.W = Inverse Sine of D0.B.  High byte is int, low byte is frac.
;         A0 = Destroyed
;----------------------------------------------------------------------------
triglib::invsin       equ       triglib@0002

;----------------------------------------------------------------------------
; Inverse Cosine  ( 1/cos(D0.B) )
;
; Function: Calculates the inverse of the Cosine of the D0.B
; Input: D0.B = Binary degrees
; Return: D1.W = Inverse Cosine of D0.B.  High byte is int, low byte is frac.
;         A0 = Destroyed
;----------------------------------------------------------------------------
triglib::invcos       equ       triglib@0003

;----------------------------------------------------------------------------
; Tangent
;
; Function: Calculates the Tangent of D0.B
; Input: D0.B = Binary degrees
; Return: D1.W = Tangent of D0.B.  High byte is int, low byte is frac.
;         A0 = Destroyed
;----------------------------------------------------------------------------
triglib::tan          equ       triglib@0005

;----------------------------------------------------------------------------
; Inverse Tangent ( 1/tan(D0.B) )
;
; Function: Calculates the inverse of the Tangent of the D0.B
; Input: D0.B = Binary degrees
; Return: D1.W = Inverse Tangent of D0.B.  High byte is int,low byte is frac.
;         A0 = Destroyed
;----------------------------------------------------------------------------
triglib::invtan       equ       triglib@0004

;----------------------------------------------------------------------------
; Full Sine
;
; Function: Calculates the Sine of the D0.B
; Input: D0.B = Binary degrees from which Sine will be calculated.
; Return: D1.B = Sine of D0.B
;         A0 = Destroyed
;----------------------------------------------------------------------------
triglib::sin2         equ       triglib@0006

;----------------------------------------------------------------------------
; Full Cosine
;
; Function: Calculates the Cosine of the D0.B
; Input: D0.B = Binary degrees from which Cosine will be calculated.
; Return: D1.B = Sine of D0.B
;         A0 = Destroyed
;----------------------------------------------------------------------------
triglib::cos2         equ       triglib@0007

