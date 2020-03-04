; 'NoStub' Include file

	ifnd	FirstWindow

_nostub
	
ST_showHelp		equ	$0E6
DrawTo	equ	$19C
DrawStrXY	equ	$1A9
reset_link	equ	$24C
flush_link	equ	$24D
receive	equ	$24F
transmit	equ	$250
tx_free	equ	$252
ArchiveErase equ $16A+$10
ArchiveWrite equ $171

FirstWindow	equ	$0
WinActivate	equ	$1
WinAttr	equ	$2
WinBackupToScr	equ	$3
WinBackground	equ	$4
WinBegin	equ	$5
WinBitmapGet	equ	$6
WinBitmapPut	equ	$7
WinBitmapSize	equ	$8
WinCharXY	equ	$9
WinChar	equ	$a
WinClose	equ	$b
WinClr	equ	$c
WinDeactivate	equ	$d
WinDupStat	equ	$e
WinEllipse	equ	$f
WinFill	equ	$10
WinFillLines2	equ	$11
WinFillTriangle	equ	$12
WinFont	equ	$13
WinGetCursor	equ	$14
WinHide	equ	$15
WinHome	equ	$16
WinLine	equ	$17
WinLineNC	equ	$18
WinLineTo	equ	$19
WinLineRel	equ	$1a
WinMoveCursor	equ	$1b
WinMoveTo	equ	$1c
WinMoveRel	equ	$1d
WinOpen	equ	$1e
WinPixGet	equ	$1f
WinPixSet	equ	$20
WinRect	equ	$21
WinReOpen	equ	$22
WinScrollH	equ	$23
WinScrollV	equ	$24
WinStr	equ	$25
WinStrXY	equ	$26
DrawWinBorder	equ	$27
ScrRectDivide	equ	$28
RectWinToWin	equ	$29
RectWinToScr	equ	$2a
UpdateWindows	equ	$2b
MakeWinRect	equ	$2c
ScrToWin	equ	$2d
ScrToHome	equ	$2e
ScrRect	equ	$2f
Dialog	equ	$30
NoCallBack	equ	$31
DialogDo	equ	$32
DialogAdd	equ	$33
DialogNew	equ	$34
DrawStaticButton	equ	$35
MenuBegin	equ	$36
MenuCheck	equ	$37
MenuEnd	equ	$38
MenuKey	equ	$39
MenuOn	equ	$3a
MenuPopup	equ	$3b
MenuSubStat	equ	$3c
MenuTopStat	equ	$3d
MenuTopSelect	equ	$3e
MenuTopRedef	equ	$3f
MenuGetTopRedef	equ	$40
MenuAddText	equ	$41
MenuAddIcon	equ	$42
MenuNew	equ	$43
PopupAddText	equ	$44
PopupNew	equ	$45
PopupClear	equ	$46
PopupDo	equ	$47
PopupText	equ	$48
MenuUpdate	equ	$49
Parse2DExpr	equ	$4a
Parse2DMultiExpr	equ	$4b
Print2DExpr	equ	$4c
Parms2D	equ	$4d
display_statements	equ	$4e
Parse1DExpr	equ	$4f
pushkey	equ	$50
ngetchx	equ	$51
kbhit	equ	$52
sprintf	equ	$53
getcalc	equ	$54
sendcalc	equ	$55
LIO_Send	equ	$56
LIO_Get	equ	$57
LIO_Receive	equ	$58
LIO_GetMultiple	equ	$59
LIO_SendData	equ	$5a
LIO_RecvData	equ	$5b
SymAdd	equ	$5c
SymAddMain	equ	$5d
SymDel	equ	$5e
HSymDel	equ	$5f
SymFind	equ	$60
SymFindMain	equ	$61
SymFindHome	equ	$62
SymMove	equ	$63
FolderAdd	equ	$64
FolderCur	equ	$65
FolderDel	equ	$66
FolderFind	equ	$67
FolderGetCur	equ	$68
FolderOp	equ	$69
FolderRename	equ	$6a
FolderCount	equ	$6b
SymFindFirst	equ	$6c
SymFindNext	equ	$6d
SymFindPrev	equ	$6e
SymFindFoldername	equ	$6f
AddSymToFolder	equ	$70
FindSymInFolder	equ	$71
FolderCurTemp	equ	$72
FolderAddTemp	equ	$73
FolderDelTemp	equ	$74
FolderDelAllTemp	equ	$75
TempFolderName	equ	$76
IsMainFolderStr	equ	$77
ParseSymName	equ	$78
DerefSym	equ	$79
HSYMtoName	equ	$7a
StrToTokN	equ	$7b
TokToStrN	equ	$7c
CheckGraphRef	equ	$7d
ClearUserDef	equ	$7e
CheckLinkLockFlag	equ	$7f
TokenizeSymName	equ	$80
SymCmp	equ	$81
SymCpy	equ	$82
SymCpy0	equ	$83
ValidateSymName	equ	$84
VarRecall	equ	$85
VarStore	equ	$86
VarStoreLink	equ	$87
QSysProtected	equ	$88
CheckSysFunc	equ	$89
GetSysGraphRef	equ	$8a
CheckReservedName	equ	$8b
SymSysVar	equ	$8c
ValidateStore	equ	$8d
ResetSymFlags	equ	$8e

HeapAvail	equ	$8f		;
HeapAlloc	equ	$90		;
HeapAllocESTACK	equ	$91	; !!
HeapAllocHigh	equ	$92	;
HeapAllocThrow	equ	$93	;
HeapAllocHighThrow	equ	$94	;
HeapCompress	equ	$95	;
HeapDeref	equ	$96		;
HeapFree	equ	$97		;
HeapFreeIndir	equ	$98	;
HLock	equ	$99		;
HeapLock	equ	$9a		;
HeapGetLock	equ	$9b		;
HeapMax	equ	$9c		;
HeapRealloc	equ	$9d		;
HeapSize	equ	$9e		;
HeapUnlock	equ	$9f		;
HeapMoveHigh	equ	$a0	;
HeapEnd	equ	$a1		; !!
HeapAllocPtr	equ	$a2	;
HeapFreePtr	equ	$a3		;
NeedStack	equ	$a4		; !!

TE_close	equ	$a5
TE_checkSlack	equ	$a6
TE_empty	equ	$a7
TE_focus	equ	$a8
TE_handleEvent	equ	$a9
TE_indicateReadOnly	equ	$aa
TE_isBlank	equ	$ab
TE_open	equ	$ac
TE_openFixed	equ	$ad
TE_pasteText	equ	$ae
TE_reopen	equ	$af
TE_reopenPlain	equ	$b0
TE_select	equ	$b1
TE_shrinkWrap	equ	$b2
TE_unfocus	equ	$b3
TE_updateCommand	equ	$b4

_bcd_math	equ	$b5
bcdadd	equ	$b6
bcdsub	equ	$b7
bcdmul	equ	$b8
bcddiv	equ	$b9
bcdneg	equ	$ba
bcdcmp	equ	$bb
bcdlong	equ	$bc
bcdbcd	equ	$bd
EX_getArg	equ	$be
EX_getBCD	equ	$bf
EX_stoBCD	equ	$c0
CB_replaceTEXT	equ	$c1
CB_fetchTEXT	equ	$c2
CU_restore	equ	$c3
CU_start	equ	$c4
CU_stop	equ	$c5
EV_captureEvents	equ	$c6
EV_clearPasteString	equ	$c7
EV_getc	equ	$c8
EV_getSplitRect	equ	$c9
EV_notifySwitchGraph	equ	$ca
EV_paintOneWindow	equ	$cb
EV_paintWindows	equ	$cc
EV_restorePainting	equ	$cd
EV_sendEvent	equ	$ce
EV_sendEventSide	equ	$cf
EV_sendString	equ	$d0
EV_setCmdCheck	equ	$d1
EV_setCmdState	equ	$d2
EV_setFKeyState	equ	$d3
EV_startApp	equ	$d4
EV_startSide	equ	$d5
EV_startTask	equ	$d6
EV_suspendPainting	equ	$d7
EV_switch	equ	$d8
MO_currentOptions	equ	$d9
MO_defaults	equ	$da
MO_digestOptions	equ	$db
MO_isMultigraphTask	equ	$dc
MO_modeDialog	equ	$dd
MO_notifyModeChange	equ	$de
MO_sendQuit	equ	$df
ST_angle	equ	$e0
ST_batt	equ	$e1
ST_busy	equ	$e2
ST_eraseHelp	equ	$e3
ST_folder	equ	$e4
ST_graph	equ	$e5
ST_helpMsg	equ	$e6
ST_modKey	equ	$e7
ST_precision	equ	$e8
ST_readOnly	equ	$e9
ST_stack	equ	$ea
ST_refDsp	equ	$eb

OSCheckBreak	equ	$ec
OSClearBreak	equ	$ed
OSEnableBreak	equ	$ee
OSDisableBreak	equ	$ef

OSRegisterTimer	equ	$f0
OSFreeTimer	equ	$f1
OSTimerCurVal	equ	$f2
OSTimerExpired	equ	$f3
OSTimerRestart	equ	$f4

acos	equ	$f5
asin	equ	$f6
atan	equ	$f7
atan2	equ	$f8
cos	equ	$f9
sin	equ	$fa
tan	equ	$fb
cosh	equ	$fc
sinh	equ	$fd
tanh	equ	$fe
exp	equ	$ff
log	equ	$100
log10	equ	$101
modf	equ	$102
pow	equ	$103
sqrt	equ	$104
ceil	equ	$105
fabs	equ	$106
floor	equ	$107
fmod	equ	$108

top_estack	equ	$109

next_expression_index	equ	$10a

gr_active	equ	$10b
gr_other	equ	$10c
ABT_dialog	equ	$10d
HomeExecute	equ	$10e
HomePushEStack	equ	$10f
SP_Define	equ	$110
store_data_var	equ	$111
recall_data_var	equ	$112
CharNumber	equ	$113
spike_optionD	equ	$114
spike_geo_titles	equ	$115
spike_in_editor	equ	$116
dv_create_graph_titles	equ	$117
spike_titles_in_editor	equ	$118
dv_findColumn	equ	$119
spike_chk_gr_dirty	equ	$11a
GetStatValue	equ	$11b
partial_len	equ	$11c
paint_all_except	equ	$11d
EQU_select	equ	$11e
EQU_setStyle	equ	$11f
EQU_getNameInfo	equ	$120
checkCurrent	equ	$121
BN_power17Mod	equ	$122
BN_powerMod	equ	$123
BN_prodMod	equ	$124
CAT_dialog	equ	$125
caddcert	equ	$126
cdecrypt	equ	$127
ceof	equ	$128
cfindcertfield	equ	$129
cfindfield	equ	$12a
cgetc	equ	$12b
cgetcert	equ	$12c
cgetflen	equ	$12d
cgetfnl	equ	$12e
cgetnl	equ	$12f
cgetns	equ	$130
cgetvernum	equ	$131
copen	equ	$132
copensub	equ	$133
cputhdr	equ	$134
cputnl	equ	$135
cputns	equ	$136
cread	equ	$137
ctell	equ	$138
cwrite	equ	$139
cacos	equ	$13a
casin	equ	$13b
catan	equ	$13c
cacosh	equ	$13d
casinh	equ	$13e
catanh	equ	$13f
ccos	equ	$140
csin	equ	$141
ctan	equ	$142
ccosh	equ	$143
csinh	equ	$144
ctanh	equ	$145
csqrt	equ	$146
cln	equ	$147
clog10	equ	$148
cexp	equ	$149
CustomBegin	equ	$14a
CustomMenuItem	equ	$14b
CustomEnd	equ	$14c
ReallocExprStruct	equ	$14d
SearchExprStruct	equ	$14e
handleRclKey	equ	$14f
CustomFree	equ	$150
ERD_dialog	equ	$151
ERD_process	equ	$152
ER_throwVar	equ	$153
ER_catch	equ	$154
ER_success	equ	$155
EV_centralDispatcher	equ	$156
EV_defaultHandler	equ	$157
EV_eventLoop	equ	$158
EV_registerMenu	equ	$159
EX_patch	equ	$15a

EM_abandon	equ	$15b
EM_blockErase	equ	$15c
EM_blockVerifyErase	equ	$15d
EM_delete	equ	$15e
EM_findEmptySlot	equ	$15f
EM_GC	equ	$160

EM_moveSymFromExtMem	equ	$161
EM_moveSymToExtMem	equ	$162
EM_open	equ	$163
EM_put	equ	$164
EM_survey	equ	$165
EM_twinSymFromExtMem	equ	$166
EM_write	equ	$167
EM_writeToExtMem	equ	$168

FL_addCert	equ	$169
FL_download	equ	$16a
FL_getHardwareParmBlock	equ	$16b
FL_getCert	equ	$16c
FL_getVerNum	equ	$16d
EQU_deStatus	equ	$16e
cmpstri	equ	$16f
fix_loop_displacements	equ	$170
FL_write	equ	$171
fpisanint	equ	$172
fpisodd	equ	$173
round12	equ	$174
round14	equ	$175
GD_Circle	equ	$176
GD_Line	equ	$177
GD_HVLine	equ	$178
GD_Pen	equ	$179
GD_Eraser	equ	$17a
GD_Text	equ	$17b
GD_Select	equ	$17c
GD_Contour	equ	$17d
GKeyIn	equ	$17e
GKeyDown	equ	$17f
GKeyFlush	equ	$180
HelpKeys	equ	$181
QModeKey	equ	$182
QSysKey	equ	$183
WordInList	equ	$184
BitmapGet	equ	$185
BitmapInit	equ	$186
BitmapPut	equ	$187
BitmapSize	equ	$188
ScrRectFill	equ	$189
ScrRectOverlap	equ	$18a
ScrRectScroll	equ	$18b
ScrRectShift	equ	$18c
QScrRectOverlap	equ	$18d
FontGetSys	equ	$18e
FontSetSys	equ	$18f
FontCharWidth	equ	$190
DrawClipChar	equ	$191
DrawClipEllipse	equ	$192
DrawClipLine	equ	$193
DrawClipPix	equ	$194
DrawClipRect	equ	$195
DrawMultiLines	equ	$196
DrawStrWidth	equ	$197
FillTriangle	equ	$198
FillLines2	equ	$199
SetCurAttr	equ	$19a
SetCurClip	equ	$19b
LineTo	equ	$19c
MoveTo	equ	$19d
ScreenClear	equ	$19e
GetPix	equ	$19f
SaveScrState	equ	$1a0
RestoreScrState	equ	$1a1
PortSet	equ	$1a2
PortRestore	equ	$1a3
DrawChar	equ	$1a4
DrawFkey	equ	$1a5
DrawIcon	equ	$1a6
DrawLine	equ	$1a7
DrawPix	equ	$1a8
DrawStr	equ	$1a9
GM_Value	equ	$1aa
GM_Intersect	equ	$1ab
GM_Integrate	equ	$1ac
GM_Inflection	equ	$1ad
GM_TanLine	equ	$1ae
GM_Math1	equ	$1af
GM_Derivative	equ	$1b0
GM_DistArc	equ	$1b1
GM_Shade	equ	$1b2
YCvtFtoWin	equ	$1b3
DlgMessage	equ	$1b4
SetGraphMode	equ	$1b5
Regraph	equ	$1b6
GrAxes	equ	$1b7
gr_xres_pixel	equ	$1b8
CptFuncX	equ	$1b9
XCvtPtoF	equ	$1ba
YCvtPtoF	equ	$1bb
YCvtFtoP	equ	$1bc
XCvtFtoP	equ	$1bd
GrLineFlt	equ	$1be
FuncLineFlt	equ	$1bf
GrClipLine	equ	$1c0
CptDeltax	equ	$1c1
CptDeltay	equ	$1c2
CkValidDelta	equ	$1c3
GR_Pan	equ	$1c4
FindFunc	equ	$1c5
FindGrFunc	equ	$1c6
grFuncName	equ	$1c7
gr_initCondName	equ	$1c8
CptIndep	equ	$1c9
gr_CptIndepInc	equ	$1ca
gr_del_locals	equ	$1cb
gr_DelFolder	equ	$1cc
gr_openFolder	equ	$1cd
setup_more_graph_fun	equ	$1ce
unlock_more_graph_fun	equ	$1cf
execute_graph_func	equ	$1d0
cpt_gr_fun	equ	$1d1
cpt_gr_param	equ	$1d2
cpt_gr_polar	equ	$1d3
gr_execute_seq	equ	$1d4
CountGrFunc	equ	$1d5
FirstSeqPlot	equ	$1d6
cleanup_seq_mem	equ	$1d7
time_loop	equ	$1d8
InitTimeSeq	equ	$1d9
seqWebInit	equ	$1da
run_one_seq	equ	$1db
gr_seq_value	equ	$1dc
StepCk	equ	$1dd
seqStepCk	equ	$1de
rngLen	equ	$1df
gdb_len	equ	$1e0
gdb_store	equ	$1e1
gdb_recall	equ	$1e2
gr_DispLabels	equ	$1e3
GraphOrTableCmd	equ	$1e4
ck_valid_float	equ	$1e5
CreateEmptyList	equ	$1e6
QSkipGraphErr	equ	$1e7
gr_find_de_result	equ	$1e8
InitDEAxesRng	equ	$1e9
InitDEMem	equ	$1ea
de_loop	equ	$1eb
cleanup_de_mem	equ	$1ec
gr_de_value	equ	$1ed
gr_find_func_index	equ	$1ee
CptLastIndepDE	equ	$1ef
de_initRes	equ	$1f0
gr_del_vars_in_folder	equ	$1f1
gr_de_axes_lbl	equ	$1f2
gr_execute_de	equ	$1f3
gr_delete_fldpic	equ	$1f4
gr_remove_fldpic	equ	$1f5
gr_add_fldpic	equ	$1f6
gr_stopic	equ	$1f7
gr_find_el	equ	$1f8
deStepCk	equ	$1f9
gr_ck_solvergraph	equ	$1fa
GR3_addContours	equ	$1fb
GraphActivate	equ	$1fc
GR3_freeDB	equ	$1fd
GR3_handleEvent	equ	$1fe
GR3_paint3d	equ	$1ff
GR3_xyToWindow	equ	$200
GS_PlotTrace	equ	$201
GS_PlotAll	equ	$202
PlotDel	equ	$203
PlotPut	equ	$204
PlotGet	equ	$205
PlotInit	equ	$206
PlotDup	equ	$207
PlotSize	equ	$208
PlotLookup	equ	$209
QActivePlots	equ	$20a
QPlotActive	equ	$20b
GT_BackupToScr	equ	$20c
GT_CalcDepVals	equ	$20d
GT_CenterGraphCursor	equ	$20e
GT_CursorKey	equ	$20f
GT_DspFreeTraceCoords	equ	$210
GT_DspTraceCoords	equ	$211
GT_DspMsg	equ	$212
GT_Error	equ	$213
GT_Format	equ	$214
GT_FreeTrace	equ	$215
GT_IncXY	equ	$216
GT_KeyIn	equ	$217
GT_QFloatCursorsInRange	equ	$218
GT_Regraph	equ	$219
GT_Regraph_if_neccy	equ	$21a
GT_Open	equ	$21b
GT_SaveAs	equ	$21c
GT_SelFunc	equ	$21d
GT_SetGraphRange	equ	$21e
GT_SetCursorXY	equ	$21f
GT_ShowMarkers	equ	$220
GT_Trace	equ	$221
GT_ValidGraphRanges	equ	$222
GT_WinBound	equ	$223
GT_WinCursor	equ	$224
GYcoord	equ	$225
GXcoord	equ	$226
round12_err	equ	$227
GT_Set_Graph_Format	equ	$228
GT_PrintCursor	equ	$229
GT_DE_Init_Conds	equ	$22a
GZ_Box	equ	$22b
GZ_Center	equ	$22c
GZ_Decimal	equ	$22d
GZ_Fit	equ	$22e
GZ_InOut	equ	$22f
GZ_Integer	equ	$230
GZ_Previous	equ	$231
GZ_Recall	equ	$232
GZ_SetFactors	equ	$233
GZ_Square	equ	$234
GZ_Standard	equ	$235
GZ_Stat	equ	$236
GZ_Store	equ	$237
GZ_Trig	equ	$238
HeapGetHandle	equ	$239
HeapPtrToHandle	equ	$23a
FreeHandles	equ	$23b
HS_chopFIFO	equ	$23c
HS_countFIFO	equ	$23d
HS_deleteFIFONode	equ	$23e
HS_freeAll	equ	$23f
HS_freeFIFONode	equ	$240
HS_getAns	equ	$241
HS_getEntry	equ	$242
HS_getFIFONode	equ	$243
HS_popEStack	equ	$244
HS_newFIFONode	equ	$245
HS_pushFIFONode	equ	$246
HToESI	equ	$247

OSInitKeyInitDelay	equ	$248
OSInitBetweenKeyDelay	equ	$249
OSCheckSilentLink	equ	$24a
OSLinkCmd	equ	$24b
OSLinkReset	equ	$24c
OSLinkOpen	equ	$24d
OSLinkClose	equ	$24e
OSReadLinkBlock	equ	$24f
OSWriteLinkBlock	equ	$250
OSLinkTxQueueInquire	equ	$251
OSLinkTxQueueActive	equ	$252
LIO_SendProduct	equ	$253
MD5Init	equ	$254
MD5Update	equ	$255
MD5Final	equ	$256
MD5Done	equ	$257
convert_to_TI_92	equ	$258
gen_version	equ	$259
is_executable	equ	$25a
NG_RPNToText	equ	$25b
NG_approxESI	equ	$25c
NG_execute	equ	$25d
NG_graphESI	equ	$25e
NG_rationalESI	equ	$25f
NG_tokenize	equ	$260
NG_setup_graph_fun	equ	$261
NG_cleanup_graph_fun	equ	$262
push_END_TAG	equ	$263
push_LIST_TAG	equ	$264
tokenize_if_TI_92_or_text	equ	$265
setjmp	equ	$266
longjmp	equ	$267
VarGraphRefBitsClear	equ	$268
VarInit	equ	$269
memcpy	equ	$26a
memmove	equ	$26b
strcpy	equ	$26c
strncpy	equ	$26d
strcat	equ	$26e
strncat	equ	$26f
memcmp	equ	$270
strcmp	equ	$271
strncmp	equ	$272
memchr	equ	$273
strchr	equ	$274
strcspn	equ	$275
strpbrk	equ	$276
strrchr	equ	$277
strspn	equ	$278
strstr	equ	$279
strtok	equ	$27a
_memset	equ	$27b
memset	equ	$27c
strerror	equ	$27d
strlen	equ	$27e
SymAddTwin	equ	$27f
SymDelTwin	equ	$280
LoadSymFromFindHandle	equ	$281
MakeHsym	equ	$282
SymFindPtr	equ	$283
OSVRegisterTimer	equ	$284
OSVFreeTimer	equ	$285
sincos	equ	$286
asinh	equ	$287
acosh	equ	$288
atanh	equ	$289
itrig	equ	$28a
trig	equ	$28b
VarOpen	equ	$28c
VarSaveAs	equ	$28d
VarNew	equ	$28e
VarCreateFolderPopup	equ	$28f
VarSaveTitle	equ	$290
WinWidth	equ	$291
WinHeight	equ	$292
XR_stringPtr	equ	$293
OSReset	equ	$294
SumStoChkMem	equ	$295
OSContrastUp	equ	$296
OSContrastDn	equ	$297
OSKeyScan	equ	$298
OSGetStatKeys	equ	$299

off	equ	$29a
idle	equ	$29b
OSSetSR	equ	$29c

AB_prodid	equ	$29d
; renvoie l'ID du produit, a0 = le 0 de cette chaine

AB_prodname	equ	$29e
; a0 : nom du produit
AB_serno	equ	$29f
; je pense que c le serial, mais je peux pas tester sur emu

cgetcertrevno	equ	$2a0
cgetsn	equ	$2a1

de_rng_no_graph	equ	$2a2
EV_hook	equ	$2a3
_ds16u16	equ	$2a4
_ms16u16	equ	$2a5
_du16u16	equ	$2a6
_mu16u16	equ	$2a7
_ds32s32	equ	$2a8
_ms32s32	equ	$2a9
_du32u32	equ	$2aa
_mu32u32	equ	$2ab
; All following rom calls are not accessible on TI92+ 1.00

assign_between	equ	$2ac
did_push_var_val	equ	$2ad
does_push_fetch	equ	$2ae
delete_list_element	equ	$2af
push_ans_entry	equ	$2b0
index_after_match_endtag	equ	$2b1
push_indir_name	equ	$2b2
push_user_func	equ	$2b3
store_func_def	equ	$2b4
store_to_subscripted_element	equ	$2b5
index_below_display_expression_aux	equ	$2b6
get_key_ptr	equ	$2b7
get_list_indices	equ	$2b8
get_matrix_indices	equ	$2b9
init_list_indices	equ	$2ba
init_matrix_indices	equ	$2bb
push_float_qr_fact	equ	$2bc
push_lu_fact	equ	$2bd
push_symbolic_qr_fact	equ	$2be
are_expressions_identical	equ	$2bf
compare_expressions	equ	$2c0
find_error_message	equ	$2c1
check_estack_size	equ	$2c2
delete_between	equ	$2c3
deleted_between	equ	$2c4
delete_expression	equ	$2c5
deleted_expression	equ	$2c6
estack_to_short	equ	$2c7
estack_to_ushort	equ	$2c8
factor_base_index	equ	$2c9
factor_exponent_index	equ	$2ca
GetValue	equ	$2cb
im_index	equ	$2cc
index_numeric_term	equ	$2cd
index_of_lead_base_of_lead_term	equ	$2ce
index_main_var	equ	$2cf
is_advanced_tag	equ	$2d0
is_antisymmetric	equ	$2d1
is_complex_number	equ	$2d2
is_complex0	equ	$2d3
is_free_of_tag	equ	$2d4
is_independent_of	equ	$2d5
is_independent_of_de_seq_vars	equ	$2d6
is_independent_of_tail	equ	$2d7
is_independent_of_elements	equ	$2d8
is_monomial	equ	$2d9
is_monomial_in_kernel	equ	$2da
is_narrowly_independent_of	equ	$2db
is_symmetric	equ	$2dc
is_tail_independent_of	equ	$2dd
lead_base_index	equ	$2de
lead_exponent_index	equ	$2df
lead_factor_index	equ	$2e0
lead_term_index	equ	$2e1
main_gen_var_index	equ	$2e2
map_unary_over_comparison	equ	$2e3
min_quantum	equ	$2e4
move_between_to_top	equ	$2e5
moved_between_to_top	equ	$2e6
numeric_factor_index	equ	$2e7

push_between	equ	$2e8
; push_between(end_EXPR *, end_EXPR*)

push_expr_quantum	equ	$2e9
push_expr2_quantum	equ	$2ea
push_next_arb_int	equ	$2eb
push_next_arb_real	equ	$2ec
push_next_internal_var	equ	$2ed
push_quantum	equ	$2ee
push_quantum_pair	equ	$2ef
reductum_index	equ	$2f0
remaining_factors_index	equ	$2f1
re_index	equ	$2f2
reset_estack_size	equ	$2f3
reset_control_flags	equ	$2f4
can_be_approxed	equ	$2f5
compare_complex_magnitudes	equ	$2f6
compare_Floats	equ	$2f7
did_push_cnvrt_Float_to_integer	equ	$2f8
estack_number_to_Float	equ	$2f9
float_class	equ	$2fa
frexp10	equ	$2fb
gcd_exact_whole_Floats	equ	$2fc
init_float	equ	$2fd
is_Float_exact_whole_number	equ	$2fe
is_float_infinity	equ	$2ff
is_float_negative_zero	equ	$300
is_float_positive_zero	equ	$301
is_float_signed_infinity	equ	$302
is_float_transfinite	equ	$303
is_float_unsigned_inf_or_nan	equ	$304
is_float_unsigned_zero	equ	$305
is_nan	equ	$306
likely_approx_to_complex_number	equ	$307
likely_approx_to_number	equ	$308
norm1_complex_Float	equ	$309
push_Float	equ	$30a
push_Float_to_nonneg_int	equ	$30b
push_Float_to_rat	equ	$30c
push_cnvrt_integer_if_whole_nmb	equ	$30d
push_overflow_to_infinity	equ	$30e
push_pow	equ	$30f
push_round_Float	equ	$310
should_and_did_push_approx_arg2	equ	$311
signum_Float	equ	$312
did_push_to_polar	equ	$313
push_degrees	equ	$314
push_format	equ	$315
push_getkey	equ	$316
push_getfold	equ	$317
push_getmode	equ	$318
push_gettype	equ	$319
push_instring	equ	$31a
push_mrow_aux	equ	$31b
push_part	equ	$31c
push_pttest	equ	$31d
push_pxltest	equ	$31e
push_rand	equ	$31f
push_randpoly	equ	$320
push_setfold	equ	$321
push_setgraph	equ	$322
push_setmode	equ	$323
push_settable	equ	$324
push_str_to_expr	equ	$325
push_string	equ	$326
push_switch	equ	$327
push_to_cylin	equ	$328
push_to_sphere	equ	$329
cmd_andpic	equ	$32a
cmd_blddata	equ	$32b
cmd_circle	equ	$32c
cmd_clrdraw	equ	$32d
cmd_clrerr	equ	$32e
cmd_clrgraph	equ	$32f
cmd_clrhome	equ	$330
cmd_clrio	equ	$331
cmd_clrtable	equ	$332
cmd_copyvar	equ	$333
cmd_cubicreg	equ	$334
cmd_custmoff	equ	$335
cmd_custmon	equ	$336
cmd_custom	equ	$337
cmd_cycle	equ	$338
cmd_cyclepic	equ	$339
cmd_delfold	equ	$33a
cmd_delvar	equ	$33b
cmd_dialog	equ	$33c
cmd_disp	equ	$33d
cmd_dispg	equ	$33e
cmd_disphome	equ	$33f
cmd_disptbl	equ	$340
cmd_drawfunc	equ	$341
cmd_drawinv	equ	$342
cmd_drawparm	equ	$343
cmd_drawpol	equ	$344
cmd_else	equ	$345
cmd_endfor	equ	$346
cmd_endloop	equ	$347
cmd_endtry	equ	$348
cmd_endwhile	equ	$349
cmd_exit	equ	$34a
cmd_expreg	equ	$34b
cmd_fill	equ	$34c
cmd_fnoff	equ	$34d
cmd_fnon	equ	$34e
cmd_for	equ	$34f
cmd_get	equ	$350
cmd_getcalc	equ	$351
cmd_goto	equ	$352
cmd_graph	equ	$353
cmd_if	equ	$354
cmd_ifthen	equ	$355
cmd_input	equ	$356
cmd_inputstr	equ	$357
cmd_line	equ	$358
cmd_linehorz	equ	$359
cmd_linetan	equ	$35a
cmd_linevert	equ	$35b
cmd_linreg	equ	$35c
cmd_lnreg	equ	$35d
cmd_local	equ	$35e
cmd_lock	equ	$35f
cmd_logistic	equ	$360
cmd_medmed	equ	$361
cmd_movevar	equ	$362
cmd_newdata	equ	$363
cmd_newfold	equ	$364
cmd_newpic	equ	$365
cmd_newplot	equ	$366
cmd_newprob	equ	$367
cmd_onevar	equ	$368
cmd_output	equ	$369
cmd_passerr	equ	$36a
cmd_pause	equ	$36b
cmd_plotsoff	equ	$36c
cmd_plotson	equ	$36d
cmd_popup	equ	$36e
cmd_powerreg	equ	$36f
cmd_printobj	equ	$370
cmd_prompt	equ	$371
cmd_ptchg	equ	$372
cmd_ptoff	equ	$373
cmd_pton	equ	$374
cmd_pttext	equ	$375
cmd_pxlchg	equ	$376
cmd_pxlcircle	equ	$377
cmd_pxlhorz	equ	$378
cmd_pxlline	equ	$379
cmd_pxloff	equ	$37a
cmd_pxlon	equ	$37b
cmd_pxltext	equ	$37c
cmd_pxlvert	equ	$37d
cmd_quadreg	equ	$37e
cmd_quartreg	equ	$37f
cmd_randseed	equ	$380
cmd_rclgdb	equ	$381
cmd_rclpic	equ	$382
cmd_rename	equ	$383
cmd_request	equ	$384
cmd_return	equ	$385
cmd_rplcpic	equ	$386
cmd_send	equ	$387
cmd_sendcalc	equ	$388
cmd_sendchat	equ	$389
cmd_shade	equ	$38a
cmd_showstat	equ	$38b
cmd_sinreg	equ	$38c
cmd_slpline	equ	$38d
cmd_sorta	equ	$38e
cmd_sortd	equ	$38f
cmd_stogdb	equ	$390
cmd_stopic	equ	$391
cmd_style	equ	$392
cmd_table	equ	$393
cmd_text	equ	$394
cmd_toolbar	equ	$395
cmd_trace	equ	$396
cmd_try	equ	$397
cmd_twovar	equ	$398
cmd_unlock	equ	$399
cmd_while	equ	$39a
cmd_xorpic	equ	$39b
cmd_zoombox	equ	$39c
cmd_zoomdata	equ	$39d
cmd_zoomdec	equ	$39e
cmd_zoomfit	equ	$39f
cmd_zoomin	equ	$3a0
cmd_zoomint	equ	$3a1
cmd_zoomout	equ	$3a2
cmd_zoomprev	equ	$3a3
cmd_zoomrcl	equ	$3a4
cmd_zoomsqr	equ	$3a5
cmd_zoomstd	equ	$3a6
cmd_zoomsto	equ	$3a7
cmd_zoomtrig	equ	$3a8
OSenqueue	equ	$3a9
OSdequeue	equ	$3aa
OSqinquire	equ	$3ab
OSqhead	equ	$3ac
OSqclear	equ	$3ad
did_push_divide_units	equ	$3ae
has_unit_base	equ	$3af
init_unit_system	equ	$3b0
is_units_term	equ	$3b1
push_auto_units_conversion	equ	$3b2
push_unit_system_list	equ	$3b3
setup_unit_system	equ	$3b4
all_tail	equ	$3b5
any_tail	equ	$3b6
is_matrix	equ	$3b7
is_square_matrix	equ	$3b8
is_valid_smap_aggregate	equ	$3b9
last_element_index	equ	$3ba
map_tail	equ	$3bb
map_tail_Int	equ	$3bc
push_list_plus	equ	$3bd
push_list_times	equ	$3be
push_reversed_tail	equ	$3bf
push_sq_matrix_to_whole_number	equ	$3c0
push_transpose_aux	equ	$3c1
push_zero_partial_column	equ	$3c2
remaining_element_count	equ	$3c3
push_offset_array	equ	$3c4
push_matrix_product	equ	$3c5
is_pathname	equ	$3c6
next_token	equ	$3c7
nonblank	equ	$3c8
push_parse_prgm_or_func_text	equ	$3c9
push_parse_text	equ	$3ca
	
	ifnd	_library
_ti89
_ti89ti
_ti92plus
_v200

LCD_MEM equ $4c00
globals equ $4c00
OSOnBreak	equ	globals+$F02
ROMCALL_TABLE	equ	$C8

SYM_ENTRY.name equ 0
SYM_ENTRY.compat equ 8
SYM_ENTRY.flags equ 10
SYM_ENTRY.hVal equ 12
SYM_ENTRY.sizeof equ 14

NULL equ 0
H_NULL equ 0
RAND_MAX equ $7fff
ACTIVITY_IDLE equ 0
ACTIVITY_BUSY equ 1
ACTIVITY_PAUSED equ 2
ER_STOP equ 2
ER_DIMENSION equ 230
ER_MEMORY equ 670
ER_MEMORY_DML equ 810
UNDEFINED_TAG equ $2a
LIST_TAG equ $d9
MATRIX_TAG equ $db
END_TAG equ $e5
CALC_TI89 equ 0
CALC_TI92PLUS equ 1

ROM_CALL macro
 move.l ($C8),a0
 move.l \1*4(a0),a0
 jsr (a0)
 endm

ROM_PTR macro
 move.l ($C8),a0
 move.l \1*4(a0),a0
 endm

ROM_CALL2 macro
 move.l ($C8),a4
 move.l \1*4(a4),a4
 endm

FAST_ROM_CALL macro
	move.l	\1*4(\2),a0
	jsr	(a0)
	endm
	
FAST_ROM_PTR	macro
	move.l	\1*4(\2),a0
	endm
	
ROM_THROW macro
 dc.w $F800+\1
 endm

ER_throw macro
 dc.w $A000+\1
 endm

PUSH_LCD_MEM	macro
	lea	LCD_MEM,a0
	move.w	#3840/4-1,d0
\\@loop		move.l	(a0)+,-(a7)
		dbf	d0,\\@loop
		endm
		
POP_LCD_MEM	macro
	lea	LCD_MEM+3840,a0
	move.w	#3840/4-1,d0
\\@loop		move.l	(a7)+,-(a0)
		dbf	d0,\\@loop
		endm

DEFINE		macro
\1	xdef	\1
		endm

		
	endif
	endif	
