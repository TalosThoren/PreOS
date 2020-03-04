;TI-89/92+/V200 Hardware 2.00 AMS 2.0x TSR support v.1.12 STATIC LIBRARY VERSION
;Copyright (C) Kevin Kofler, 2001-2004
;This is the source for the h220xTSR static library, used by the developer
;versions.
;WARNING: You need TIGCC 0.95 minimum to use h220xTSR 1.12 (BOTH in assembly AND
;         in C)!
;Instructions depending on the language you are programming in follow.
;Please read the readme file before using this file.
;Please DO NOT distribute modified versions without my permission (unless you use
;the GPL licensing option, in which case your entire program MUST be GPLed)! Just
;include the header file as is and link to the static library as is and it should
;work.
;
;A68k ASSEMBLY DEVELOPERS:
;Just include the header file (h220xtsr.h from the ASM subfolder) at the beginning
;of your program (assuming _nostub mode) just before the first instruction of your
;program and then continue your program as normally. You will also have to link to
;the static library h220xtsr.a, either by adding it to your TIGCC IDE project, or
;by compiling your program using: "tigcc yourprog.asm h220xtsr.a".
;Right after the header file, d0.l will contain the value returned by the h220xTSR
;function. Also, note that for backwards compatibility reasons, the assembly
;version will automatically exit on a return value of 0 (installation failed).
;Do not use jmp or jsr instructions to labels in your program. Use bra or
;bsr instead!
;
;GCC C DEVELOPERS:
;Use #include "h220xtsr.h" (from the C subfolder) and call the function
;h220xTSR();. You will also have to link to the static library h220xtsr.a, either
;by adding it to your TIGCC IDE project, or by compiling your program using:
;"tigcc yourprog.c h220xtsr.a".
;The h220xTSR() function returns a value which you might want to read in your
;program.
;Use it only in your main function and, if you do not use it at the end, you will
;have to relocate your program to the ghost space if it was not already there.
;For an event hook installer, I recommend the following sequence:
;void _main(void)
;{
;...
;if (!h220xTSR()) {ST_helpMsg("h220xTSR installation failed");return;};
;*EV_hook=...;
;ST_helpMsg("Success message");
;}

 include "os.h" ;You need the version included with TIGCC.

h220xTSR_FAILED equ 0
h220xTSR_SUCCESS equ 1
h220xTSR_SUCCESS_UPDATE equ 2
h220xTSR_HW1 equ -1
h220xTSR_AMS1 equ -2
h220xTSR_PATCHED equ -3
h220xTSR_ALREADY equ -4
h220xTSR_PATCHED_HW3 equ -5

 xdef h220xTSR_internal ;export the function
h220xTSR_internal: ;(internal) function name
 movem.l a2-a6/d3-d7,-(a7) ;save all registers
;detect the hardware version
;Thanks to Julien Muchembled for the C version listed in the TI-GCC FAQ.
;Converted to assembly by Kevin Kofler
 move.l $c8,d0
 and.l #$E00000,d0 ;get the ROM base
 move.l d0,a0
 move.l 260(a0),a1 ;get the pointer to the hardware parameter block
 add.l #$10000,a0
 cmp.l a0,a1 ;check if the hardware parameter block is near enough
 bcc hw1 ;if it is too far, it is HW1
 cmp.w #22,(a1) ;check if the parameter block contains the hardware version
 bls hw1 ;if it is too small, it is HW1
 cmp.l #1,22(a1) ;check the hardware version
 beq hw1 ;if 1, it is HW1
 cmp.l #2,22(a1) ;check the hardware version
 bne hw3 ;if not 2, it is an unsupported hardware version
;end of hardware version detection routine
 move.l $c8,a0
 cmp.l #1000,-4(a0) ;check if more than 1000 entries
 bcs ams1 ;if no, it is AMS 1.xx
 ROM_CALL2 EX_stoBCD
 tst.w 92(a4) ;check for HW2Patch (ROM resident)
 beq patched ;if it is installed, refuse installation
 cmp.l #$100,$ac ;check for HW2Patch (RAM resident)
 beq patched ;if it is installed, refuse installation
 clr.b d4 ;set to "first install" mode
 bsr enter_the_ghost_space ;unprotect and enter the ghost space
 cmp.l #$200000,$ac ;check if trap #$b points to the ROM
 bcs already ;if no, it is already installed
 cmp.l #$200000,$90 ;check if trap #4 points to the ROM
 bcs trap4_already ;if no, it is already hooked
continue:
 move.l $ac,oldtrapb ;save the old trap #$B and call it from the new one
 move.l $90,oldtrap4 ;save the old trap #$4 and call it from the new one
 move.l #(endtrap4-newtrapb),-(a7)
 ROM_CALL HeapAllocHigh ;allocate a handle for the new trap #$B
 addq.l #2,a7
 tst.w d0 ;check if NULL handle
 beq nomem ;if yes, display "no mem" error message
 move.w d0,(a7)
 ROM_CALL HeapDeref ;get ("dereference") the address
 move.l a0,a3 ;save the address to a3 for further use
 subq.l #2,a7
 move.l #(endtrap4-newtrapb),(a7)
 pea.l newtrapb(PC)
 move.l a0,-(a7)
 ROM_CALL memcpy ;copy the trap #$B routine to the handle
 lea.l 12(a7),a7 ;shorter as add(a).l #12,a7

 move.l $c8,a0
 cmp.l #$607,-4(a0) ;check if more than $607 entries
 bcs ams200to205 ;if no, it is not AMS 2.07
 lea.l ams207patch1-newtrapb(a3),a0
 move.w #$4e69,(a0) ;move.l usp,a1
 move.l #$b1e90008,2(a0) ;cmp.l 8(a1),a0
 move.w #$ca9,ams207patch2-ams207patch1(a0) ;cmpi.l #imm,d(a1)
 move.w #8,ams207patch2-ams207patch1+6(a0) ;d=8
 move.w #$6a9,ams207patch3-ams207patch1(a0) ;addi.l #imm,d(a1)
 move.w #8,ams207patch3-ams207patch1+6(a0) ;d=8
 move.l #$22690008,ams207patch4-ams207patch1(a0) ;move.l 8(a1),a1
 move.l #$3029fffe,ams207patch4-ams207patch1+4(a0) ;move.w -2(a1),d0
 move.w #$d089,ams207patch4-ams207patch1+8(a0) ;add.l a1,d0
 move.w #$2f09,ams207patch5-ams207patch1(a0) ;move.l a1,-(a7)
 
ams200to205:
 add.l #$40008,a3 ;add: - $40000 for HW2 AMS 2.0x without
                  ;       HW2Patch
                  ;     - $8 to skip the uninstall
                  ;       information (need the start of
                  ;       the executable code here)
 move.l a3,$400ac ;install the trap #$B
 adda.w #newtrap4-newtrapb,a3 ;new trap #$4
 move.l a3,$40090 ;install the trap #$4
 tst.b d4 ;check if update mode
 bne update
 moveq.l #h220xTSR_SUCCESS,d0
return:
 movem.l (a7)+,a2-a6/d3-d7 ;restore all registers
 move.l (a7)+,d1 ;pick up the return address
 bset.l #18,d1 ;make it point to ghost space (same as or.l #$40000,d1)
 move.l d1,a0 ;move it to a0
 jmp (a0) ;jump to it (return, but now in the ghost space)
update:
 moveq.l #h220xTSR_SUCCESS_UPDATE,d0
 bra return
hw1:
 moveq.l #h220xTSR_HW1,d0
 bra return
ams1:
 moveq.l #h220xTSR_AMS1,d0
 bra return
patched:
 moveq.l #h220xTSR_PATCHED,d0
 bra return
patched_hw3:
 moveq.l #h220xTSR_PATCHED_HW3,d0
return_nonghost:
 movem.l (a7)+,a2-a6/d3-d7 ;restore all registers
 moveq.l #0,d1 ;tell the C header that we aren't in the ghost space
 rts ;return (NOT in the ghost space!)
hw3:
 ROM_CALL2 EX_stoBCD
 tst.w 92(a4) ;check for HW3Patch (ROM resident)
 beq patched_hw3 ;if it is installed, return h220xTSR_PATCHED_HW3
 cmp.l #$100,$ac ;check for HW3Patch (RAM resident)
 beq patched_hw3 ;if it is installed, return h220xTSR_PATCHED_HW3
 move.l #$10000,-(a7)
 pea.l hw3DL(PC)
 pea.l hw3DLT(PC) ;"unsupported hardware version" error message 
 ROM_CALL DlgMessage ;display error dialog
 lea.l 12(a7),a7 ;restore the stack
 moveq.l #h220xTSR_FAILED,d0
 bra return_nonghost
already:
 move.l $ac,a0 ;check for previous h220xTSR installation
 cmp.l #$40000,a0 ;if <$40000, it is not h220xTSR (because that would not work
 bcs already5     ;reliably on HW2)
 sub.l #$40008,a0  ;remove: * $40000 for HW2 AMS 2.0x without HW2Patch
                   ;        * $8 to get the beginning of the handle (if
                   ;          compatible)
 cmp.l #'2TSR',(a0) ;check signature
 bne already2 ;if it is not the old one, check for version 1.03-1.05a
 cmp.l #'2Tsr',$6e(a0) ;check for version 1.03/4 (trap 4 signature)
 beq already3 ;if it is 2Tsr, it is h220xTSR 1.03/1.04 with a broken signature
 cmp.l #$200000,$90 ;check if trap #4 points to the ROM
 bcs trap4_already ;if no, it is already hooked
already4:
 st.b d4 ;set to update mode
 move.l 4(a0),$400ac ;restore old trap #$b
 move.l a0,-(a7)
 ROM_CALL HeapPtrToHandle ;get the handle number
 addq.l #2,a7
 move.w d0,(a7)
 ROM_CALL HeapFree ;free (unallocate) the handle
 addq.l #2,a7
 bra continue ;continue the installation
already3:
 move.l #'2Tsr',(a0) ;fix signature
 st.b d4 ;set to update mode
already2:
 cmp.l #'2Tsr',(a0) ;check signature
 bne already5 ;if it is not the new one, it is not h220xTSR
not_trap4_yet: ;look for the second signature (trap 4 hook)
 addq.l #2,a0 ;only search word for word, as code is word-aligned
 cmp.l #'2Tsr',(a0) ;check signature
 bne not_trap4_yet ;otherwise continue searching
 cmp.w #$5111,-2(a0) ;check for versions older than 1.11
 bcc already5 ;if no, do not update
 move.l $90,a0 ;check for other trap 4 hook
 cmp.l #$40000,a0  ;if <$40000, it is not h220xTSR (because that would not work
 bcs trap4_already ;reliably on HW2)
 sub.l #$40008,a0  ;remove: * $40000 for HW2 AMS 2.0x without HW2Patch
                   ;        * $8 to get the beginning of the handle (if
                   ;          compatible)
 cmp.l #'2Tsr',(a0) ;check signature
 bne trap4_already ;if it is not the new one, it is not h220xTSR
 cmp.w #$5111,-2(a0) ;check for versions older than 1.11
 bcc already5 ;if no, do not update
 move.l 4(a0),$40090 ;restore old trap #4
 move.l $ac,a0 ;get trap #$B address again
 sub.l #$40008,a0  ;remove: * $40000 for HW2 AMS 2.0x without HW2Patch
                   ;        * $8 to get the beginning of the handle (if
                   ;          compatible)
 bra already4
already5:
 moveq.l #h220xTSR_ALREADY,d0
 bra return
trap4_already:
 move.l #$10000,-(a7)
 pea.l trap4DL(PC)
 pea.l trap4DLT(PC) ;"trap 4 already hooked" error message 
 bra showmsg
nomem:
 subq.l #2,a7 ;adjust the stack
 move.l #$10000,(a7)
 pea.l nomemDL(PC)
 pea.l nomemDLT(PC) ;"memory" error message 
showmsg:
 ROM_CALL DlgMessage ;display error dialog
 lea.l 12(a7),a7 ;restore the stack
 moveq.l #h220xTSR_FAILED,d0
 bra return

;Thanks to Zeljko Juric for the following function:
;(I have slightly adapted it to fit my needs, and fixed a few minor glitches. The
;fixes have been submitted to TIGCC, of which I am now a team member, as well.)
enter_the_ghost_space:
 bsr.w \ghost_space_0 ;push the current PC on the stack
\ghost_space_0:
 move.l (a7)+,d0 ;pop it to d0
 cmpi.l #$40000,d0 ;check if it is in the ghost space
 bcc.s \ghost_space_2 ;if it is, skip
 movem.l d3-d7/a2-a6,-(a7) ;save non-call-clobbered registers
 lea -20(a7),a7 ;allocate some space on the stack
 move.l #$3e000,a3 ;address of the zone to unprotect ($3e000) for the trap #$b
 move.l $c8,d0  ;get the address of the jump table
 andi.l #$E00000,d0 ;use it to compute ROM_base
                    ;($200000 on the TI89, $400000 on the TI92+)
 addi.l #$20000,d0 ;now d0 points to somewhere in the AMS
 move.l d0,12(a7) ;fool the routine into believing that it is called from AMS
 move.l d0,16(a7)
 trap #$c ;enter supervisor mode
 move.w #$2700,sr ;disable all interrupts (while staying in supervisor mode)
 move.l #$f,d3 ;function number ($f) for the trap #$b
 pea.l \ghost_space_1(pc) ;push the return PC for the indirect trap #$b call
 bset.b #2,1(a7) ;make it point to ghost space (same as or.l #$40000,(a7))
 clr.w  -(a7) ;push the return SR (0 = ints enabled, user mode) for the trap #$b
 move.l $ac,a0 ;get the vector for the trap #$B
 jmp (a0) ;enter into the trap #$B indirectly

; Now, trap #$B will unprotect the 8K/24K area starting from $3E000.
; This includes the last page of the RAM too, so executing from the
; the ghost space is enabled too. The stack is set up on such way,
; that when the trap #$B is finished, the "rte" will transfer 
; execution to the address \ghost_space_1+$40000, so the execution
; continues at the label "\ghost_space_1", now in the "ghost space":

\ghost_space_1:
 lea 20(a7),a7 ;free the allocated stack space
 movem.l (a7)+,d3-d7/a2-a6 ;restore non-call-clobbered registers
\ghost_space_2:
 move.l (a7)+,d0 ;pick up the return address
 bset.l #18,d0 ;make it point to ghost space (same as or.l #$40000,d0)
 move.l d0,a0 ;move it to a0
 jmp (a0) ;jump to it (return, but now in the ghost space)

newtrapb:
 dc.b '2Tsr' ;signature
oldtrapb: dc.l 0 ;This is a placeholder for the original trap #$B address.
 cmp.l #$f,d3 ;check if function $f
 bne callold ;if no, just call the original trap #$B
 cmp.l #$200000,2(a7) ;check if enter_ghost_space
 bcs alreadyghost ;if yes, do nothing (program execution will be at PC+$80000)
                  ;which is still in the ghost space (ghost of ghost)

ams207patch1:
 nop
 nop
 cmp.l a2,a0 ;check if Exec command
;For AMS 2.07:
;move.l usp,a1
;cmp.l 8(a1),a0 ;check if Exec command

 bne exec ;if yes, special treatement
;The address of the program to execute is stored in a2 by AMS 2.0x.

ams207patch2:
 cmp.l #$40000,a2 ;check if already in the ghost space
 nop
;For AMS 2.07:
;cmp.l #$40000,8(a1) ;check if already in the ghost space

 bcc alreadyghost ;if yes, do nothing

ams207patch3:
 add.l #$40000,a2 ;add $40000 to a2 if it is not already in the ghost space
 nop
;For AMS 2.07:
;add.l #$40000,8(a1) ;add $40000 to 8(a1) if it is not already in the ghost space

 moveq.l #0,d0 ;get the end of the program

ams207patch4:
 nop
 nop
 move.w -2(a2),d0
 add.l a2,d0
;For AMS 2.07:
;move.l 8(a1),a1
;move.w -2(a1),d0
;add.l a1,d0

 subq.l #1,d0
 move.l d0,-(a7)

ams207patch5:
 move.l a2,-(a7)
;For AMS 2.07:
;move.l a1,-(a7)

common: ;common for ASM and Exec
 move.l $C8,a0
 move.l EX_patch*4(a0),a0 ;relocate the program again:
 jsr (a0)                 ;call EX_patch without destroying a4
 addq.l #8,a7
alreadyghost:
 rte
exec:
 cmp.l a5,a0 ;check if really Exec command
 bne alreadyghost ;if no, do nothing!!!
;The address of the STR_TAG of the exec string is stored in a2 by AMS 2.0x.
;The program address is stored in a5 by AMS 2.0x.
 add.l #$40000,a5 ;add $40000 to a5 if it is not already in the ghost space
 moveq.l #0,d0 ;get the end of the program
 lea.l -1(a2),a1 ;not to change a2 in order to respect the calling convention
execnext:
 addq.l #1,d0
 tst.b -(a1)
 bne execnext
 lsr.l #1,d0
 add.l a5,d0
 move.l d0,-(a7)
 move.l a5,-(a7) 
 bra common
callold:
 move.l oldtrapb(PC),-(a7) ;get the original trap #$B address (on the stack)
 rts ;jump to it (from the stack, in order not to destroy any registers)

;Version identification: This is the best place to hide it so that older versions
;                        of UnIn2TSR won't get confused.
;This will mean less detection work for future updaters.
 dc.w $5112 ;5 = signature (to make it bigger than $4e75=rts which was there in
            ;               previous versions)
            ;112 = version 1.12
;Changes in the memory resident part will ALWAYS induce a version number increase.
;Only changes which do not touch the memory resident part get lettered numbers
;(such as "1.05a"). This was always my policy.

newtrap4:
 dc.b '2Tsr' ;signature
oldtrap4: dc.l 0 ;This is a placeholder for the original trap #$4 address.
 movem.l d0-d7/a0-a6,-(a7) ;save destroyed registers
 move.l $ac,-(a7) ;save the new trap #$B
 lea.l reenter_ghost_space-finishtrap4(a7),a7 ;save unprotected zone to the stack
 pea.l finishtrap4-reenter_ghost_space
 pea.l $5fc0
 pea.l 8(a7)
 move.l $c8,a0
 move.l memcpy*4(a0),a0 
 jsr (a0) ;call memcpy without destroying a4
 lea.l 12(a7),a7 ;restore a7
 pea.l finishtrap4(PC) ;push end of routine to the stack
 move.w #$2700,-(a7) ;push SR for end of routine to the stack
 move.l oldtrapb(PC),$400ac ;reset the trap #$B to the original value
 pea.l finishtrap4-reenter_ghost_space
 pea.l reenter_ghost_space(PC)  ;copy middle of routine to
 pea.l $5fc0                    ;unprotected zone
 move.l $c8,a0
 move.l memcpy*4(a0),a0
 jsr (a0)                 ;call memcpy without destroying a4
 lea.l 12(a7),a7
 pea.l $5fc0 ;push address of middle of routine to the stack
 move.w #$2700,-(a7) ;push SR for middle of routine to the stack
 move.l oldtrap4(PC),-(a7) ;get the original trap #$4 address (on the stack)
 rts ;jump to it (from the stack, in order not to destroy any registers)
reenter_ghost_space: ;This will be in supervisor mode! It will be at $5fc0!
                     ;This is again an adaptation of Zeljko Juric's routine.
 move.l usp,a0
 lea -20(a0),a0 ;make some space on stack
 move.l $C8,d0 ;TIOS jump table in d0
 andi.l #$E00000,d0 ;=$200000 for TI89, =$400000 for TI92+
 addi.l #$20000,d0 ;now d0 points somewhere in TIOS
 move.l d0,12(a0) ;fool the routine to believe that it is
 move.l d0,16(a0) ;called somewhere from TIOS
 move.l a0,usp
 move.l #$F,d3 ;prepare for calling trap #$B indirectly
 move.l #$3e000,a3 ;pass $3e000 to the trap #$B
 move.l $AC,a0 ;the vector for trap #$B
 jmp (a0) ;enter into trap #$B indirectly
finishtrap4: ;This will be in supervisor mode!
 move.l usp,a0
 lea.l 20(a0),a0 ;free the stack space of reenter_ghost_space
 move.l a0,usp
 pea.l finishtrap4-reenter_ghost_space ;restore the unprotected zone
 pea.l 4(a7)
 pea.l $5fc0
 move.l $c8,a0
 move.l memcpy*4(a0),a0 
 jsr (a0) ;call memcpy without destroying a4 
 lea.l finishtrap4-reenter_ghost_space+12(a7),a7 ;clean the stack up
 move.l (a7)+,$400ac ;restore the new trap #$B
 movem.l (a7)+,d0-d7/a0-a6 ;restore destroyed registers
 rte ;return
endtrap4:

;error messages:

hw3DL: dc.b 'HW3Patch needed on hardware version 3 or higher',0
hw3DLT: dc.b 'ERROR: Unsupported hardware version',0
trap4DL: dc.b 'Please temporarily uninstall any memory resident keyboard '
         dc.b 'auto-repeat accelerators or password programs before '
         dc.b 'installing or updating h220xTSR.',0
trap4DLT: dc.b 'ERROR: Trap 4 already hooked',0
nomemDL: dc.b 'Not enough memory to install h220xTSR.',0
nomemDLT: dc.b 'ERROR: Not enough memory',0

 END
