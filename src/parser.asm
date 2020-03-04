;*
;* PreOs - Launcher - for Ti-89ti/Ti-89/Ti-92+/V200.
;* Copyright (C) 2004 PpHd
;*
;* This program is free software ; you can redistribute it and/or modify it under the
;* terms of the GNU General Public License as published by the Free Software Foundation;
;* either version 2 of the License, or (at your option) any later version. 
;* 
;* This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
;* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
;* See the GNU General Public License for more details. 
;* 
;* You should have received a copy of the GNU General Public License along with this program;
;* if not, write to the 
;* Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 

	include "include/romcalls.h"

parser:
	move.l	top_estack*4(a5),a2
	move.l	(a2),a2
	moveq	#0,d5				; Action to do
\Loop:		cmpi.b	#$E5,(a2)
		beq.s	\end
		cmpi.b	#$2D,(a2)
		bne.s	\fatal
		bsr.s	\NextArg

		moveq	#(\EndTab-\Tab)/4-1,d3
		lea	\Tab(pc),a4
\ScanLoop:		move.w	(a4)+,d0
			pea	(a3)
			pea	\Tab(pc,d0.w)
			FAST_ROM_CALL strcmp,a5
			addq.l	#8,a7
			tst.w	d0
			beq.s	\found
			addq.l	#2,a4
			dbf	d3,\ScanLoop
\fatal:	moveq	#5,d5				; Invalid command (Display help)
\end	rts

\Tab:	dc.w	install_cmd-\Tab,\install-\Tab
	dc.w	uninstall_cmd-\Tab,\uninstall-\Tab
	dc.w	check_cmd-\Tab,\check-\Tab
	;dc.w	update_cmd-\Tab,\update-\Tab
	;dc.w	help_cmd-\Tab,\help-\Tab
	dc.w	sysdir_cmd-\Tab,\sysdir-\Tab
	dc.w	shell_cmd-\Tab,\shell-\Tab
	;dc.w	launch_cmd-\Tab,\launch-\Tab
\EndTab:

\NextArg:
	subq.l	#2,a2			; Skip 0, $2D
\BeLoop		tst.b	-(a2)
		bne.s	\BeLoop
	lea	1(a2),a3		; String Arg
	subq.l	#1,a2			; a2 -> Next arg
	rts

\found:	move.w	(a4)+,d0
	jsr	\Tab(pc,d0.w)
	bra.s	\Loop
	
\install:	moveq	#1,d5
		rts
\uninstall:	moveq	#2,d5
		rts
\check:		moveq	#3,d5
		rts
;\update:	moveq	#4,d5
;		rts
;\help:		moveq	#5,d5
;		rts
\sysdir:	cmpi.b	#$2D,(a2)
		bne.s	\fatal
		bsr.s	\NextArg
		lea	system_str(pc),a0
		moveq	#8-1,d0
\CopyLoop		move.b	(a3)+,(a0)+
			dbf	d0,\CopyLoop	
		rts
\shell:		cmpi.b	#$2D,(a2)
\fatal2		bne.s	\fatal
		lea	ShellSymStr(pc),a0
		lea	-1(a2),a1
		moveq	#18-1,d0
\CopyLoop2		move.b	-(a1),-(a0)
			dbf	d0,\CopyLoop2
		bra.s	\NextArg

;\launch:	cmpi.b	#$2D,(a2)
;		bne.s	\fatal2
;		bsr.s	\NextArg
;		moveq	#6,d5
;		move.l	a3,a6
;		rts
