;TI-89/92+ Hardware 2.00 AMS 2.0x TSR support v.1.12 ASSEMBLY HEADER FILE VERSION
;Copyright (C) Kevin Kofler, 2001-2004

;This is the A68k assembly version of the include file.
;WARNING: You need TIGCC 0.95 minimum to use h220xTSR 1.12!

;Just include this at the beginning of your program (assuming _nostub
;mode) just before the first instruction of your program and then
;continue your program as normally. You will also have to link to the
;static library h220xtsr.a, either by adding it to your TIGCC IDE project,
;or by compiling your program using: "tigcc yourprog.asm h220xtsr.a".
;Right after the header file, d0.l will contain the value returned by
;the h220xTSR function - see section c. Also, note that for backwards
;compatibility reasons, the assembly version will automatically exit on
;a return value of 0 (installation failed).
;Do not use jmp or jsr instructions to labels in your program. Use bra or
;bsr instead!

;please read the readme file before using this file
;Please DO NOT distribute modified versions without my permission (unless you use
;the GPL licensing option, in which case your entire program MUST be GPLed)! Just
;include the header file as is and link to the static library as is and it should
;work.

;FATAL ERRORS:
h220xTSR_FAILED equ 0 ;installation failed (not enough memory or trap 4 already hooked)
                      ;A dialog box showing the error will be automatically displayed.
;This version will automatically exit on such an error.

;SUCCESS CODES:
h220xTSR_SUCCESS equ 1 ;successfully installed
h220xTSR_SUCCESS_UPDATE equ 2 ;successfully updated

;NON-FATAL, INFORMATIONAL ERROR CODES:
h220xTSR_HW1 equ -1 ;HW1 detected, h220xTSR is not needed on HW1
h220xTSR_AMS1 equ -2 ;AMS 1 detected, h220xTSR is not needed on AMS 1
h220xTSR_PATCHED equ -3 ;HW2/3Patch detected, h220xTSR is not needed on patched HW2
h220xTSR_ALREADY equ -4 ;h220xTSR is already installed
h220xTSR_PATCHED_HW3 equ -5 ;HW3 with HW3Patch detected, h220xTSR not needed

 bsr h220xTSR_internal ;call the h220xTSR function
 tst.l d0 ;check if the return value is h220xTSR_FAILED
 bne h220xtsr_skip ;if it is not, skip, else proceed to the error message

 pea.l h220xtsr_failedST(PC)
 move.l $c8,a0
 move.l $E6*4(a0),a0 ;$E6=ST_helpMsg
 jsr (a0) ;display the error message
 addq.l #4,a7 ;adjust the stack
 rts ;return

h220xtsr_failedST: dc.b 'h220xTSR installation failed',0
 EVEN

h220xtsr_skip: