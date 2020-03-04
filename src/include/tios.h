; 'Kernel' include files
	ifnd	_library
	
_library
_ti89ti
_ti89
_ti92plus
_v200
_mistub
_readonly
_install_preos


tios::ST_showHelp	equ	_ROM_CALL_0E6
tios::DrawTo		equ	_ROM_CALL_19C
tios::DrawStrXY		equ	_ROM_CALL_1A9
tios::reset_link	equ	_ROM_CALL_24C
tios::flush_link	equ	_ROM_CALL_24D
tios::receive		equ	_ROM_CALL_24F
tios::transmit		equ	_ROM_CALL_250
tios::tx_free		equ	_ROM_CALL_252
tios::ArchiveWrite 	equ	_ROM_CALL_171
;tios::DrawCharXY	equ	_ROM_CALL_1a4		; Args are ina different order

tios::FirstWindow	equ	_ROM_CALL_0
tios::WinActivate	equ	_ROM_CALL_1
tios::WinAttr	equ	_ROM_CALL_2
tios::WinBackupToScr	equ	_ROM_CALL_3
tios::WinBackground	equ	_ROM_CALL_4
tios::WinBegin	equ	_ROM_CALL_5
tios::WinBitmapGet	equ	_ROM_CALL_6
tios::WinBitmapPut	equ	_ROM_CALL_7
tios::WinBitmapSize	equ	_ROM_CALL_8
tios::WinCharXY	equ	_ROM_CALL_9
tios::WinChar	equ	_ROM_CALL_a
tios::WinClose	equ	_ROM_CALL_b
tios::WinClr	equ	_ROM_CALL_c
tios::WinDeactivate	equ	_ROM_CALL_d
tios::WinDupStat	equ	_ROM_CALL_e
tios::WinEllipse	equ	_ROM_CALL_f
tios::WinFill	equ	_ROM_CALL_10
tios::WinFillLines2	equ	_ROM_CALL_11
tios::WinFillTriangle	equ	_ROM_CALL_12
tios::WinFont	equ	_ROM_CALL_13
tios::WinGetCursor	equ	_ROM_CALL_14
tios::WinHide	equ	_ROM_CALL_15
tios::WinHome	equ	_ROM_CALL_16
tios::WinLine	equ	_ROM_CALL_17
tios::WinLineNC	equ	_ROM_CALL_18
tios::WinLineTo	equ	_ROM_CALL_19
tios::WinLineRel	equ	_ROM_CALL_1a
tios::WinMoveCursor	equ	_ROM_CALL_1b
tios::WinMoveTo	equ	_ROM_CALL_1c
tios::WinMoveRel	equ	_ROM_CALL_1d
tios::WinOpen	equ	_ROM_CALL_1e
tios::WinPixGet	equ	_ROM_CALL_1f
tios::WinPixSet	equ	_ROM_CALL_20
tios::WinRect	equ	_ROM_CALL_21
tios::WinReOpen	equ	_ROM_CALL_22
tios::WinScrollH	equ	_ROM_CALL_23
tios::WinScrollV	equ	_ROM_CALL_24
tios::WinStr	equ	_ROM_CALL_25
tios::WinStrXY	equ	_ROM_CALL_26
tios::DrawWinBorder	equ	_ROM_CALL_27
tios::ScrRectDivide	equ	_ROM_CALL_28
tios::RectWinToWin	equ	_ROM_CALL_29
tios::RectWinToScr	equ	_ROM_CALL_2a
tios::UpdateWindows	equ	_ROM_CALL_2b
tios::MakeWinRect	equ	_ROM_CALL_2c
tios::ScrToWin	equ	_ROM_CALL_2d
tios::ScrToHome	equ	_ROM_CALL_2e
tios::ScrRect	equ	_ROM_CALL_2f
tios::Dialog	equ	_ROM_CALL_30
tios::NoCallBack	equ	_ROM_CALL_31
tios::DialogDo	equ	_ROM_CALL_32
tios::DialogAdd	equ	_ROM_CALL_33
tios::DialogNew	equ	_ROM_CALL_34
tios::DrawStaticButton	equ	_ROM_CALL_35
tios::MenuBegin	equ	_ROM_CALL_36
tios::MenuCheck	equ	_ROM_CALL_37
tios::MenuEnd	equ	_ROM_CALL_38
tios::MenuKey	equ	_ROM_CALL_39
tios::MenuOn	equ	_ROM_CALL_3a
tios::MenuPopup	equ	_ROM_CALL_3b
tios::MenuSubStat	equ	_ROM_CALL_3c
tios::MenuTopStat	equ	_ROM_CALL_3d
tios::MenuTopSelect	equ	_ROM_CALL_3e
tios::MenuTopRedef	equ	_ROM_CALL_3f
tios::MenuGetTopRedef	equ	_ROM_CALL_40
tios::MenuAddText	equ	_ROM_CALL_41
tios::MenuAddIcon	equ	_ROM_CALL_42
tios::MenuNew	equ	_ROM_CALL_43
tios::PopupAddText	equ	_ROM_CALL_44
tios::PopupNew	equ	_ROM_CALL_45
tios::PopupClear	equ	_ROM_CALL_46
tios::PopupDo	equ	_ROM_CALL_47
tios::PopupText	equ	_ROM_CALL_48
tios::MenuUpdate	equ	_ROM_CALL_49
tios::Parse2DExpr	equ	_ROM_CALL_4a
tios::Parse2DMultiExpr	equ	_ROM_CALL_4b
tios::Print2DExpr	equ	_ROM_CALL_4c
tios::Parms2D	equ	_ROM_CALL_4d
tios::display_statements	equ	_ROM_CALL_4e
tios::Parse1DExpr	equ	_ROM_CALL_4f
tios::pushkey	equ	_ROM_CALL_50
tios::ngetchx	equ	_ROM_CALL_51
tios::kbhit	equ	_ROM_CALL_52
tios::sprintf	equ	_ROM_CALL_53
tios::getcalc	equ	_ROM_CALL_54
tios::sendcalc	equ	_ROM_CALL_55
tios::LIO_Send	equ	_ROM_CALL_56
tios::LIO_Get	equ	_ROM_CALL_57
tios::LIO_Receive	equ	_ROM_CALL_58
tios::LIO_GetMultiple	equ	_ROM_CALL_59
tios::LIO_SendData	equ	_ROM_CALL_5a
tios::LIO_RecvData	equ	_ROM_CALL_5b
tios::SymAdd	equ	_ROM_CALL_5c
tios::SymAddMain	equ	_ROM_CALL_5d
tios::SymDel	equ	_ROM_CALL_5e
tios::HSymDel	equ	_ROM_CALL_5f
tios::SymFind	equ	_ROM_CALL_60
tios::SymFindMain	equ	_ROM_CALL_61
tios::SymFindHome	equ	_ROM_CALL_62
tios::SymMove	equ	_ROM_CALL_63
tios::FolderAdd	equ	_ROM_CALL_64
tios::FolderCur	equ	_ROM_CALL_65
tios::FolderDel	equ	_ROM_CALL_66
tios::FolderFind	equ	_ROM_CALL_67
tios::FolderGetCur	equ	_ROM_CALL_68
tios::FolderOp	equ	_ROM_CALL_69
tios::FolderRename	equ	_ROM_CALL_6a
tios::FolderCount	equ	_ROM_CALL_6b
tios::SymFindFirst	equ	_ROM_CALL_6c
tios::SymFindNext	equ	_ROM_CALL_6d
tios::SymFindPrev	equ	_ROM_CALL_6e
tios::SymFindFoldername	equ	_ROM_CALL_6f
tios::AddSymToFolder	equ	_ROM_CALL_70
tios::FindSymInFolder	equ	_ROM_CALL_71
tios::FolderCurTemp	equ	_ROM_CALL_72
tios::FolderAddTemp	equ	_ROM_CALL_73
tios::FolderDelTemp	equ	_ROM_CALL_74
tios::FolderDelAllTemp	equ	_ROM_CALL_75
tios::TempFolderName	equ	_ROM_CALL_76
tios::IsMainFolderStr	equ	_ROM_CALL_77
tios::ParseSymName	equ	_ROM_CALL_78
tios::DerefSym	equ	_ROM_CALL_79
tios::HSYMtoName	equ	_ROM_CALL_7a
tios::StrToTokN	equ	_ROM_CALL_7b
tios::TokToStrN	equ	_ROM_CALL_7c
tios::CheckGraphRef	equ	_ROM_CALL_7d
tios::ClearUserDef	equ	_ROM_CALL_7e
tios::CheckLinkLockFlag	equ	_ROM_CALL_7f
tios::TokenizeSymName	equ	_ROM_CALL_80
tios::SymCmp	equ	_ROM_CALL_81
tios::SymCpy	equ	_ROM_CALL_82
tios::SymCpy0	equ	_ROM_CALL_83
tios::ValidateSymName	equ	_ROM_CALL_84
tios::VarRecall	equ	_ROM_CALL_85
tios::VarStore	equ	_ROM_CALL_86
tios::VarStoreLink	equ	_ROM_CALL_87
tios::QSysProtected	equ	_ROM_CALL_88
tios::CheckSysFunc	equ	_ROM_CALL_89
tios::GetSysGraphRef	equ	_ROM_CALL_8a
tios::CheckReservedName	equ	_ROM_CALL_8b
tios::SymSysVar	equ	_ROM_CALL_8c
tios::ValidateStore	equ	_ROM_CALL_8d
tios::ResetSymFlags	equ	_ROM_CALL_8e

tios::HeapAvail	equ	_ROM_CALL_8f		;
tios::HeapAlloc	equ	_ROM_CALL_90		;
tios::HeapAllocESTACK	equ	_ROM_CALL_91	; !!
tios::HeapAllocHigh	equ	_ROM_CALL_92	;
tios::HeapAllocThrow	equ	_ROM_CALL_93	;
tios::HeapAllocHighThrow	equ	_ROM_CALL_94	;
tios::HeapCompress	equ	_ROM_CALL_95	;
tios::HeapDeref	equ	_ROM_CALL_96		;
tios::HeapFree	equ	_ROM_CALL_97		;
tios::HeapFreeIndir	equ	_ROM_CALL_98	;
tios::HLock	equ	_ROM_CALL_99		;
tios::HeapLock	equ	_ROM_CALL_9a		;
tios::HeapGetLock	equ	_ROM_CALL_9b		;
tios::HeapMax	equ	_ROM_CALL_9c		;
tios::HeapRealloc	equ	_ROM_CALL_9d		;
tios::HeapSize	equ	_ROM_CALL_9e		;
tios::HeapUnlock	equ	_ROM_CALL_9f		;
tios::HeapMoveHigh	equ	_ROM_CALL_a0	;
tios::HeapEnd	equ	_ROM_CALL_a1		; !!
tios::HeapAllocPtr	equ	_ROM_CALL_a2	;
tios::HeapFreePtr	equ	_ROM_CALL_a3		;
tios::NeedStack	equ	_ROM_CALL_a4		; !!

tios::TE_close	equ	_ROM_CALL_a5
tios::TE_checkSlack	equ	_ROM_CALL_a6
tios::TE_empty	equ	_ROM_CALL_a7
tios::TE_focus	equ	_ROM_CALL_a8
tios::TE_handleEvent	equ	_ROM_CALL_a9
tios::TE_indicateReadOnly	equ	_ROM_CALL_aa
tios::TE_isBlank	equ	_ROM_CALL_ab
tios::TE_open	equ	_ROM_CALL_ac
tios::TE_openFixed	equ	_ROM_CALL_ad
tios::TE_pasteText	equ	_ROM_CALL_ae
tios::TE_reopen	equ	_ROM_CALL_af
tios::TE_reopenPlain	equ	_ROM_CALL_b0
tios::TE_select	equ	_ROM_CALL_b1
tios::TE_shrinkWrap	equ	_ROM_CALL_b2
tios::TE_unfocus	equ	_ROM_CALL_b3
tios::TE_updateCommand	equ	_ROM_CALL_b4

tios::_bcd_math	equ	_ROM_CALL_b5
tios::bcdadd	equ	_ROM_CALL_b6
tios::bcdsub	equ	_ROM_CALL_b7
tios::bcdmul	equ	_ROM_CALL_b8
tios::bcddiv	equ	_ROM_CALL_b9
tios::bcdneg	equ	_ROM_CALL_ba
tios::bcdcmp	equ	_ROM_CALL_bb
tios::bcdlong	equ	_ROM_CALL_bc
tios::bcdbcd	equ	_ROM_CALL_bd
tios::EX_getArg	equ	_ROM_CALL_be
tios::EX_getBCD	equ	_ROM_CALL_bf
tios::EX_stoBCD	equ	_ROM_CALL_c0
tios::CB_replaceTEXT	equ	_ROM_CALL_c1
tios::CB_fetchTEXT	equ	_ROM_CALL_c2
tios::CU_restore	equ	_ROM_CALL_c3
tios::CU_start	equ	_ROM_CALL_c4
tios::CU_stop	equ	_ROM_CALL_c5
tios::EV_captureEvents	equ	_ROM_CALL_c6
tios::EV_clearPasteString	equ	_ROM_CALL_c7
tios::EV_getc	equ	_ROM_CALL_c8
tios::EV_getSplitRect	equ	_ROM_CALL_c9
tios::EV_notifySwitchGraph	equ	_ROM_CALL_ca
tios::EV_paintOneWindow	equ	_ROM_CALL_cb
tios::EV_paintWindows	equ	_ROM_CALL_cc
tios::EV_restorePainting	equ	_ROM_CALL_cd
tios::EV_sendEvent	equ	_ROM_CALL_ce
tios::EV_sendEventSide	equ	_ROM_CALL_cf
tios::EV_sendString	equ	_ROM_CALL_d0
tios::EV_setCmdCheck	equ	_ROM_CALL_d1
tios::EV_setCmdState	equ	_ROM_CALL_d2
tios::EV_setFKeyState	equ	_ROM_CALL_d3
tios::EV_startApp	equ	_ROM_CALL_d4
tios::EV_startSide	equ	_ROM_CALL_d5
tios::EV_startTask	equ	_ROM_CALL_d6
tios::EV_suspendPainting	equ	_ROM_CALL_d7
tios::EV_switch	equ	_ROM_CALL_d8
tios::MO_currentOptions	equ	_ROM_CALL_d9
tios::MO_defaults	equ	_ROM_CALL_da
tios::MO_digestOptions	equ	_ROM_CALL_db
tios::MO_isMultigraphTask	equ	_ROM_CALL_dc
tios::MO_modeDialog	equ	_ROM_CALL_dd
tios::MO_notifyModeChange	equ	_ROM_CALL_de
tios::MO_sendQuit	equ	_ROM_CALL_df
tios::ST_angle	equ	_ROM_CALL_e0
tios::ST_batt	equ	_ROM_CALL_e1
tios::ST_busy	equ	_ROM_CALL_e2
tios::ST_eraseHelp	equ	_ROM_CALL_e3
tios::ST_folder	equ	_ROM_CALL_e4
tios::ST_graph	equ	_ROM_CALL_e5
tios::ST_helpMsg	equ	_ROM_CALL_e6
tios::ST_modKey	equ	_ROM_CALL_e7
tios::ST_precision	equ	_ROM_CALL_e8
tios::ST_readOnly	equ	_ROM_CALL_e9
tios::ST_stack	equ	_ROM_CALL_ea
tios::ST_refDsp	equ	_ROM_CALL_eb

tios::OSCheckBreak	equ	_ROM_CALL_ec
tios::OSClearBreak	equ	_ROM_CALL_ed
tios::OSEnableBreak	equ	_ROM_CALL_ee
tios::OSDisableBreak	equ	_ROM_CALL_ef

tios::OSRegisterTimer	equ	_ROM_CALL_f0
tios::OSFreeTimer	equ	_ROM_CALL_f1
tios::OSTimerCurVal	equ	_ROM_CALL_f2
tios::OSTimerExpired	equ	_ROM_CALL_f3
tios::OSTimerRestart	equ	_ROM_CALL_f4

tios::acos	equ	_ROM_CALL_f5
tios::asin	equ	_ROM_CALL_f6
tios::atan	equ	_ROM_CALL_f7
tios::atan2	equ	_ROM_CALL_f8
tios::cos	equ	_ROM_CALL_f9
tios::sin	equ	_ROM_CALL_fa
tios::tan	equ	_ROM_CALL_fb
tios::cosh	equ	_ROM_CALL_fc
tios::sinh	equ	_ROM_CALL_fd
tios::tanh	equ	_ROM_CALL_fe
tios::exp	equ	_ROM_CALL_ff
tios::log	equ	_ROM_CALL_100
tios::log10	equ	_ROM_CALL_101
tios::modf	equ	_ROM_CALL_102
tios::pow	equ	_ROM_CALL_103
tios::sqrt	equ	_ROM_CALL_104
tios::ceil	equ	_ROM_CALL_105
tios::fabs	equ	_ROM_CALL_106
tios::floor	equ	_ROM_CALL_107
tios::fmod	equ	_ROM_CALL_108

tios::top_estack	equ	_ROM_CALL_109

tios::next_expression_index	equ	_ROM_CALL_10a

tios::gr_active	equ	_ROM_CALL_10b
tios::gr_other	equ	_ROM_CALL_10c
tios::ABT_dialog	equ	_ROM_CALL_10d
tios::HomeExecute	equ	_ROM_CALL_10e
tios::HomePushEStack	equ	_ROM_CALL_10f
tios::SP_Define	equ	_ROM_CALL_110
tios::store_data_var	equ	_ROM_CALL_111
tios::recall_data_var	equ	_ROM_CALL_112
tios::CharNumber	equ	_ROM_CALL_113
tios::spike_optionD	equ	_ROM_CALL_114
tios::spike_geo_titles	equ	_ROM_CALL_115
tios::spike_in_editor	equ	_ROM_CALL_116
tios::dv_create_graph_titles	equ	_ROM_CALL_117
tios::spike_titles_in_editor	equ	_ROM_CALL_118
tios::dv_findColumn	equ	_ROM_CALL_119
tios::spike_chk_gr_dirty	equ	_ROM_CALL_11a
tios::GetStatValue	equ	_ROM_CALL_11b
tios::partial_len	equ	_ROM_CALL_11c
tios::paint_all_except	equ	_ROM_CALL_11d
tios::EQU_select	equ	_ROM_CALL_11e
tios::EQU_setStyle	equ	_ROM_CALL_11f
tios::EQU_getNameInfo	equ	_ROM_CALL_120
tios::checkCurrent	equ	_ROM_CALL_121
tios::BN_power17Mod	equ	_ROM_CALL_122
tios::BN_powerMod	equ	_ROM_CALL_123
tios::BN_prodMod	equ	_ROM_CALL_124
tios::CAT_dialog	equ	_ROM_CALL_125
tios::caddcert	equ	_ROM_CALL_126
tios::cdecrypt	equ	_ROM_CALL_127
tios::ceof	equ	_ROM_CALL_128
tios::cfindcertfield	equ	_ROM_CALL_129
tios::cfindfield	equ	_ROM_CALL_12a
tios::cgetc	equ	_ROM_CALL_12b
tios::cgetcert	equ	_ROM_CALL_12c
tios::cgetflen	equ	_ROM_CALL_12d
tios::cgetfnl	equ	_ROM_CALL_12e
tios::cgetnl	equ	_ROM_CALL_12f
tios::cgetns	equ	_ROM_CALL_130
tios::cgetvernum	equ	_ROM_CALL_131
tios::copen	equ	_ROM_CALL_132
tios::copensub	equ	_ROM_CALL_133
tios::cputhdr	equ	_ROM_CALL_134
tios::cputnl	equ	_ROM_CALL_135
tios::cputns	equ	_ROM_CALL_136
tios::cread	equ	_ROM_CALL_137
tios::ctell	equ	_ROM_CALL_138
tios::cwrite	equ	_ROM_CALL_139
tios::cacos	equ	_ROM_CALL_13a
tios::casin	equ	_ROM_CALL_13b
tios::catan	equ	_ROM_CALL_13c
tios::cacosh	equ	_ROM_CALL_13d
tios::casinh	equ	_ROM_CALL_13e
tios::catanh	equ	_ROM_CALL_13f
tios::ccos	equ	_ROM_CALL_140
tios::csin	equ	_ROM_CALL_141
tios::ctan	equ	_ROM_CALL_142
tios::ccosh	equ	_ROM_CALL_143
tios::csinh	equ	_ROM_CALL_144
tios::ctanh	equ	_ROM_CALL_145
tios::csqrt	equ	_ROM_CALL_146
tios::cln	equ	_ROM_CALL_147
tios::clog10	equ	_ROM_CALL_148
tios::cexp	equ	_ROM_CALL_149
tios::CustomBegin	equ	_ROM_CALL_14a
tios::CustomMenuItem	equ	_ROM_CALL_14b
tios::CustomEnd	equ	_ROM_CALL_14c
tios::ReallocExprStruct	equ	_ROM_CALL_14d
tios::SearchExprStruct	equ	_ROM_CALL_14e
tios::handleRclKey	equ	_ROM_CALL_14f
tios::CustomFree	equ	_ROM_CALL_150
tios::ERD_dialog	equ	_ROM_CALL_151
tios::ERD_process	equ	_ROM_CALL_152
tios::ER_throwVar	equ	_ROM_CALL_153
tios::ER_catch	equ	_ROM_CALL_154
tios::ER_success	equ	_ROM_CALL_155
tios::EV_centralDispatcher	equ	_ROM_CALL_156
tios::EV_defaultHandler	equ	_ROM_CALL_157
tios::EV_eventLoop	equ	_ROM_CALL_158
tios::EV_registerMenu	equ	_ROM_CALL_159
tios::EX_patch	equ	_ROM_CALL_15a

tios::EM_abandon	equ	_ROM_CALL_15b
tios::EM_blockErase	equ	_ROM_CALL_15c
tios::EM_blockVerifyErase	equ	_ROM_CALL_15d
tios::EM_delete	equ	_ROM_CALL_15e
tios::EM_findEmptySlot	equ	_ROM_CALL_15f
tios::EM_GC	equ	_ROM_CALL_160

tios::EM_moveSymFromExtMem	equ	_ROM_CALL_161
tios::EM_moveSymToExtMem	equ	_ROM_CALL_162
tios::EM_open	equ	_ROM_CALL_163
tios::EM_put	equ	_ROM_CALL_164
tios::EM_survey	equ	_ROM_CALL_165
tios::EM_twinSymFromExtMem	equ	_ROM_CALL_166
tios::EM_write	equ	_ROM_CALL_167
tios::EM_writeToExtMem	equ	_ROM_CALL_168

tios::FL_addCert	equ	_ROM_CALL_169
tios::FL_download	equ	_ROM_CALL_16a
tios::FL_getHardwareParmBlock	equ	_ROM_CALL_16b
tios::FL_getCert	equ	_ROM_CALL_16c
tios::FL_getVerNum	equ	_ROM_CALL_16d
tios::EQU_deStatus	equ	_ROM_CALL_16e
tios::cmpstri	equ	_ROM_CALL_16f
tios::fix_loop_displacements	equ	_ROM_CALL_170
tios::FL_write	equ	_ROM_CALL_171
tios::fpisanint	equ	_ROM_CALL_172
tios::fpisodd	equ	_ROM_CALL_173
tios::round12	equ	_ROM_CALL_174
tios::round14	equ	_ROM_CALL_175
tios::GD_Circle	equ	_ROM_CALL_176
tios::GD_Line	equ	_ROM_CALL_177
tios::GD_HVLine	equ	_ROM_CALL_178
tios::GD_Pen	equ	_ROM_CALL_179
tios::GD_Eraser	equ	_ROM_CALL_17a
tios::GD_Text	equ	_ROM_CALL_17b
tios::GD_Select	equ	_ROM_CALL_17c
tios::GD_Contour	equ	_ROM_CALL_17d
tios::GKeyIn	equ	_ROM_CALL_17e
tios::GKeyDown	equ	_ROM_CALL_17f
tios::GKeyFlush	equ	_ROM_CALL_180
tios::HelpKeys	equ	_ROM_CALL_181
tios::QModeKey	equ	_ROM_CALL_182
tios::QSysKey	equ	_ROM_CALL_183
tios::WordInList	equ	_ROM_CALL_184
tios::BitmapGet	equ	_ROM_CALL_185
tios::BitmapInit	equ	_ROM_CALL_186
tios::BitmapPut	equ	_ROM_CALL_187
tios::BitmapSize	equ	_ROM_CALL_188
tios::ScrRectFill	equ	_ROM_CALL_189
tios::ScrRectOverlap	equ	_ROM_CALL_18a
tios::ScrRectScroll	equ	_ROM_CALL_18b
tios::ScrRectShift	equ	_ROM_CALL_18c
tios::QScrRectOverlap	equ	_ROM_CALL_18d
tios::FontGetSys	equ	_ROM_CALL_18e
tios::FontSetSys	equ	_ROM_CALL_18f
tios::FontCharWidth	equ	_ROM_CALL_190
tios::DrawClipChar	equ	_ROM_CALL_191
tios::DrawClipEllipse	equ	_ROM_CALL_192
tios::DrawClipLine	equ	_ROM_CALL_193
tios::DrawClipPix	equ	_ROM_CALL_194
tios::DrawClipRect	equ	_ROM_CALL_195
tios::DrawMultiLines	equ	_ROM_CALL_196
tios::DrawStrWidth	equ	_ROM_CALL_197
tios::FillTriangle	equ	_ROM_CALL_198
tios::FillLines2	equ	_ROM_CALL_199
tios::SetCurAttr	equ	_ROM_CALL_19a
tios::SetCurClip	equ	_ROM_CALL_19b
tios::LineTo	equ	_ROM_CALL_19c
tios::MoveTo	equ	_ROM_CALL_19d
tios::ScreenClear	equ	_ROM_CALL_19e
tios::GetPix	equ	_ROM_CALL_19f
tios::SaveScrState	equ	_ROM_CALL_1a0
tios::RestoreScrState	equ	_ROM_CALL_1a1
tios::PortSet	equ	_ROM_CALL_1a2
tios::PortRestore	equ	_ROM_CALL_1a3
tios::DrawChar	equ	_ROM_CALL_1a4
tios::DrawFkey	equ	_ROM_CALL_1a5
tios::DrawIcon	equ	_ROM_CALL_1a6
tios::DrawLine	equ	_ROM_CALL_1a7
tios::DrawPix	equ	_ROM_CALL_1a8
tios::DrawStr	equ	_ROM_CALL_1a9
tios::GM_Value	equ	_ROM_CALL_1aa
tios::GM_Intersect	equ	_ROM_CALL_1ab
tios::GM_Integrate	equ	_ROM_CALL_1ac
tios::GM_Inflection	equ	_ROM_CALL_1ad
tios::GM_TanLine	equ	_ROM_CALL_1ae
tios::GM_Math1	equ	_ROM_CALL_1af
tios::GM_Derivative	equ	_ROM_CALL_1b0
tios::GM_DistArc	equ	_ROM_CALL_1b1
tios::GM_Shade	equ	_ROM_CALL_1b2
tios::YCvtFtoWin	equ	_ROM_CALL_1b3
tios::DlgMessage	equ	_ROM_CALL_1b4
tios::SetGraphMode	equ	_ROM_CALL_1b5
tios::Regraph	equ	_ROM_CALL_1b6
tios::GrAxes	equ	_ROM_CALL_1b7
tios::gr_xres_pixel	equ	_ROM_CALL_1b8
tios::CptFuncX	equ	_ROM_CALL_1b9
tios::XCvtPtoF	equ	_ROM_CALL_1ba
tios::YCvtPtoF	equ	_ROM_CALL_1bb
tios::YCvtFtoP	equ	_ROM_CALL_1bc
tios::XCvtFtoP	equ	_ROM_CALL_1bd
tios::GrLineFlt	equ	_ROM_CALL_1be
tios::FuncLineFlt	equ	_ROM_CALL_1bf
tios::GrClipLine	equ	_ROM_CALL_1c0
tios::CptDeltax	equ	_ROM_CALL_1c1
tios::CptDeltay	equ	_ROM_CALL_1c2
tios::CkValidDelta	equ	_ROM_CALL_1c3
tios::GR_Pan	equ	_ROM_CALL_1c4
tios::FindFunc	equ	_ROM_CALL_1c5
tios::FindGrFunc	equ	_ROM_CALL_1c6
tios::grFuncName	equ	_ROM_CALL_1c7
tios::gr_initCondName	equ	_ROM_CALL_1c8
tios::CptIndep	equ	_ROM_CALL_1c9
tios::gr_CptIndepInc	equ	_ROM_CALL_1ca
tios::gr_del_locals	equ	_ROM_CALL_1cb
tios::gr_DelFolder	equ	_ROM_CALL_1cc
tios::gr_openFolder	equ	_ROM_CALL_1cd
tios::setup_more_graph_fun	equ	_ROM_CALL_1ce
tios::unlock_more_graph_fun	equ	_ROM_CALL_1cf
tios::execute_graph_func	equ	_ROM_CALL_1d0
tios::cpt_gr_fun	equ	_ROM_CALL_1d1
tios::cpt_gr_param	equ	_ROM_CALL_1d2
tios::cpt_gr_polar	equ	_ROM_CALL_1d3
tios::gr_execute_seq	equ	_ROM_CALL_1d4
tios::CountGrFunc	equ	_ROM_CALL_1d5
tios::FirstSeqPlot	equ	_ROM_CALL_1d6
tios::cleanup_seq_mem	equ	_ROM_CALL_1d7
tios::time_loop	equ	_ROM_CALL_1d8
tios::InitTimeSeq	equ	_ROM_CALL_1d9
tios::seqWebInit	equ	_ROM_CALL_1da
tios::run_one_seq	equ	_ROM_CALL_1db
tios::gr_seq_value	equ	_ROM_CALL_1dc
tios::StepCk	equ	_ROM_CALL_1dd
tios::seqStepCk	equ	_ROM_CALL_1de
tios::rngLen	equ	_ROM_CALL_1df
tios::gdb_len	equ	_ROM_CALL_1e0
tios::gdb_store	equ	_ROM_CALL_1e1
tios::gdb_recall	equ	_ROM_CALL_1e2
tios::gr_DispLabels	equ	_ROM_CALL_1e3
tios::GraphOrTableCmd	equ	_ROM_CALL_1e4
tios::ck_valid_float	equ	_ROM_CALL_1e5
tios::CreateEmptyList	equ	_ROM_CALL_1e6
tios::QSkipGraphErr	equ	_ROM_CALL_1e7
tios::gr_find_de_result	equ	_ROM_CALL_1e8
tios::InitDEAxesRng	equ	_ROM_CALL_1e9
tios::InitDEMem	equ	_ROM_CALL_1ea
tios::de_loop	equ	_ROM_CALL_1eb
tios::cleanup_de_mem	equ	_ROM_CALL_1ec
tios::gr_de_value	equ	_ROM_CALL_1ed
tios::gr_find_func_index	equ	_ROM_CALL_1ee
tios::CptLastIndepDE	equ	_ROM_CALL_1ef
tios::de_initRes	equ	_ROM_CALL_1f0
tios::gr_del_vars_in_folder	equ	_ROM_CALL_1f1
tios::gr_de_axes_lbl	equ	_ROM_CALL_1f2
tios::gr_execute_de	equ	_ROM_CALL_1f3
tios::gr_delete_fldpic	equ	_ROM_CALL_1f4
tios::gr_remove_fldpic	equ	_ROM_CALL_1f5
tios::gr_add_fldpic	equ	_ROM_CALL_1f6
tios::gr_stopic	equ	_ROM_CALL_1f7
tios::gr_find_el	equ	_ROM_CALL_1f8
tios::deStepCk	equ	_ROM_CALL_1f9
tios::gr_ck_solvergraph	equ	_ROM_CALL_1fa
tios::GR3_addContours	equ	_ROM_CALL_1fb
tios::GraphActivate	equ	_ROM_CALL_1fc
tios::GR3_freeDB	equ	_ROM_CALL_1fd
tios::GR3_handleEvent	equ	_ROM_CALL_1fe
tios::GR3_paint3d	equ	_ROM_CALL_1ff
tios::GR3_xyToWindow	equ	_ROM_CALL_200
tios::GS_PlotTrace	equ	_ROM_CALL_201
tios::GS_PlotAll	equ	_ROM_CALL_202
tios::PlotDel	equ	_ROM_CALL_203
tios::PlotPut	equ	_ROM_CALL_204
tios::PlotGet	equ	_ROM_CALL_205
tios::PlotInit	equ	_ROM_CALL_206
tios::PlotDup	equ	_ROM_CALL_207
tios::PlotSize	equ	_ROM_CALL_208
tios::PlotLookup	equ	_ROM_CALL_209
tios::QActivePlots	equ	_ROM_CALL_20a
tios::QPlotActive	equ	_ROM_CALL_20b
tios::GT_BackupToScr	equ	_ROM_CALL_20c
tios::GT_CalcDepVals	equ	_ROM_CALL_20d
tios::GT_CenterGraphCursor	equ	_ROM_CALL_20e
tios::GT_CursorKey	equ	_ROM_CALL_20f
tios::GT_DspFreeTraceCoords	equ	_ROM_CALL_210
tios::GT_DspTraceCoords	equ	_ROM_CALL_211
tios::GT_DspMsg	equ	_ROM_CALL_212
tios::GT_Error	equ	_ROM_CALL_213
tios::GT_Format	equ	_ROM_CALL_214
tios::GT_FreeTrace	equ	_ROM_CALL_215
tios::GT_IncXY	equ	_ROM_CALL_216
tios::GT_KeyIn	equ	_ROM_CALL_217
tios::GT_QFloatCursorsInRange	equ	_ROM_CALL_218
tios::GT_Regraph	equ	_ROM_CALL_219
tios::GT_Regraph_if_neccy	equ	_ROM_CALL_21a
tios::GT_Open	equ	_ROM_CALL_21b
tios::GT_SaveAs	equ	_ROM_CALL_21c
tios::GT_SelFunc	equ	_ROM_CALL_21d
tios::GT_SetGraphRange	equ	_ROM_CALL_21e
tios::GT_SetCursorXY	equ	_ROM_CALL_21f
tios::GT_ShowMarkers	equ	_ROM_CALL_220
tios::GT_Trace	equ	_ROM_CALL_221
tios::GT_ValidGraphRanges	equ	_ROM_CALL_222
tios::GT_WinBound	equ	_ROM_CALL_223
tios::GT_WinCursor	equ	_ROM_CALL_224
tios::GYcoord	equ	_ROM_CALL_225
tios::GXcoord	equ	_ROM_CALL_226
tios::round12_err	equ	_ROM_CALL_227
tios::GT_Set_Graph_Format	equ	_ROM_CALL_228
tios::GT_PrintCursor	equ	_ROM_CALL_229
tios::GT_DE_Init_Conds	equ	_ROM_CALL_22a
tios::GZ_Box	equ	_ROM_CALL_22b
tios::GZ_Center	equ	_ROM_CALL_22c
tios::GZ_Decimal	equ	_ROM_CALL_22d
tios::GZ_Fit	equ	_ROM_CALL_22e
tios::GZ_InOut	equ	_ROM_CALL_22f
tios::GZ_Integer	equ	_ROM_CALL_230
tios::GZ_Previous	equ	_ROM_CALL_231
tios::GZ_Recall	equ	_ROM_CALL_232
tios::GZ_SetFactors	equ	_ROM_CALL_233
tios::GZ_Square	equ	_ROM_CALL_234
tios::GZ_Standard	equ	_ROM_CALL_235
tios::GZ_Stat	equ	_ROM_CALL_236
tios::GZ_Store	equ	_ROM_CALL_237
tios::GZ_Trig	equ	_ROM_CALL_238
tios::HeapGetHandle	equ	_ROM_CALL_239
tios::HeapPtrToHandle	equ	_ROM_CALL_23a
tios::FreeHandles	equ	_ROM_CALL_23b
tios::HS_chopFIFO	equ	_ROM_CALL_23c
tios::HS_countFIFO	equ	_ROM_CALL_23d
tios::HS_deleteFIFONode	equ	_ROM_CALL_23e
tios::HS_freeAll	equ	_ROM_CALL_23f
tios::HS_freeFIFONode	equ	_ROM_CALL_240
tios::HS_getAns	equ	_ROM_CALL_241
tios::HS_getEntry	equ	_ROM_CALL_242
tios::HS_getFIFONode	equ	_ROM_CALL_243
tios::HS_popEStack	equ	_ROM_CALL_244
tios::HS_newFIFONode	equ	_ROM_CALL_245
tios::HS_pushFIFONode	equ	_ROM_CALL_246
tios::HToESI	equ	_ROM_CALL_247

tios::OSInitKeyInitDelay	equ	_ROM_CALL_248
tios::OSInitBetweenKeyDelay	equ	_ROM_CALL_249
tios::OSCheckSilentLink	equ	_ROM_CALL_24a
tios::OSLinkCmd	equ	_ROM_CALL_24b
tios::OSLinkReset	equ	_ROM_CALL_24c
tios::OSLinkOpen	equ	_ROM_CALL_24d
tios::OSLinkClose	equ	_ROM_CALL_24e
tios::OSReadLinkBlock	equ	_ROM_CALL_24f
tios::OSWriteLinkBlock	equ	_ROM_CALL_250
tios::OSLinkTxQueueInquire	equ	_ROM_CALL_251
tios::OSLinkTxQueueActive	equ	_ROM_CALL_252
tios::LIO_SendProduct	equ	_ROM_CALL_253
tios::MD5Init	equ	_ROM_CALL_254
tios::MD5Update	equ	_ROM_CALL_255
tios::MD5Final	equ	_ROM_CALL_256
tios::MD5Done	equ	_ROM_CALL_257
tios::convert_to_TI_92	equ	_ROM_CALL_258
tios::gen_version	equ	_ROM_CALL_259
tios::is_executable	equ	_ROM_CALL_25a
tios::NG_RPNToText	equ	_ROM_CALL_25b
tios::NG_approxESI	equ	_ROM_CALL_25c
tios::NG_execute	equ	_ROM_CALL_25d
tios::NG_graphESI	equ	_ROM_CALL_25e
tios::NG_rationalESI	equ	_ROM_CALL_25f
tios::NG_tokenize	equ	_ROM_CALL_260
tios::NG_setup_graph_fun	equ	_ROM_CALL_261
tios::NG_cleanup_graph_fun	equ	_ROM_CALL_262
tios::push_END_TAG	equ	_ROM_CALL_263
tios::push_LIST_TAG	equ	_ROM_CALL_264
tios::tokenize_if_TI_92_or_text	equ	_ROM_CALL_265
tios::setjmp	equ	_ROM_CALL_266
tios::longjmp	equ	_ROM_CALL_267
tios::VarGraphRefBitsClear	equ	_ROM_CALL_268
tios::VarInit	equ	_ROM_CALL_269
tios::memcpy	equ	_ROM_CALL_26a
tios::memmove	equ	_ROM_CALL_26b
tios::strcpy	equ	_ROM_CALL_26c
tios::strncpy	equ	_ROM_CALL_26d
tios::strcat	equ	_ROM_CALL_26e
tios::strncat	equ	_ROM_CALL_26f
tios::memcmp	equ	_ROM_CALL_270
tios::strcmp	equ	_ROM_CALL_271
tios::strncmp	equ	_ROM_CALL_272
tios::memchr	equ	_ROM_CALL_273
tios::strchr	equ	_ROM_CALL_274
tios::strcspn	equ	_ROM_CALL_275
tios::strpbrk	equ	_ROM_CALL_276
tios::strrchr	equ	_ROM_CALL_277
tios::strspn	equ	_ROM_CALL_278
tios::strstr	equ	_ROM_CALL_279
tios::strtok	equ	_ROM_CALL_27a
tios::_memset	equ	_ROM_CALL_27b
tios::memset	equ	_ROM_CALL_27c
tios::strerror	equ	_ROM_CALL_27d
tios::strlen	equ	_ROM_CALL_27e
tios::SymAddTwin	equ	_ROM_CALL_27f
tios::SymDelTwin	equ	_ROM_CALL_280
tios::LoadSymFromFindHandle	equ	_ROM_CALL_281
tios::MakeHsym	equ	_ROM_CALL_282
tios::SymFindPtr	equ	_ROM_CALL_283
tios::OSVRegisterTimer	equ	_ROM_CALL_284
tios::OSVFreeTimer	equ	_ROM_CALL_285
tios::sincos	equ	_ROM_CALL_286
tios::asinh	equ	_ROM_CALL_287
tios::acosh	equ	_ROM_CALL_288
tios::atanh	equ	_ROM_CALL_289
tios::itrig	equ	_ROM_CALL_28a
tios::trig	equ	_ROM_CALL_28b
tios::VarOpen	equ	_ROM_CALL_28c
tios::VarSaveAs	equ	_ROM_CALL_28d
tios::VarNew	equ	_ROM_CALL_28e
tios::VarCreateFolderPopup	equ	_ROM_CALL_28f
tios::VarSaveTitle	equ	_ROM_CALL_290
tios::WinWidth	equ	_ROM_CALL_291
tios::WinHeight	equ	_ROM_CALL_292
tios::XR_stringPtr	equ	_ROM_CALL_293
tios::OSReset	equ	_ROM_CALL_294
tios::SumStoChkMem	equ	_ROM_CALL_295
tios::OSContrastUp	equ	_ROM_CALL_296
tios::OSContrastDn	equ	_ROM_CALL_297
tios::OSKeyScan	equ	_ROM_CALL_298
tios::OSGetStatKeys	equ	_ROM_CALL_299

tios::off	equ	_ROM_CALL_29a
tios::idle	equ	_ROM_CALL_29b
tios::OSSetSR	equ	_ROM_CALL_29c

tios::AB_prodid	equ	_ROM_CALL_29d
; renvoie l'ID du produit, a0 = le 0 de cette chaine

tios::AB_prodname	equ	_ROM_CALL_29e
; a0 : nom du produit
tios::AB_serno	equ	_ROM_CALL_29f
; je pense que c le serial, mais je peux pas tester sur emu

tios::cgetcertrevno	equ	_ROM_CALL_2a0
tios::cgetsn	equ	_ROM_CALL_2a1

tios::de_rng_no_graph	equ	_ROM_CALL_2a2
tios::EV_hook	equ	_ROM_CALL_2a3
tios::_ds16u16	equ	_ROM_CALL_2a4
tios::_ms16u16	equ	_ROM_CALL_2a5
tios::_du16u16	equ	_ROM_CALL_2a6
tios::_mu16u16	equ	_ROM_CALL_2a7
tios::_ds32s32	equ	_ROM_CALL_2a8
tios::_ms32s32	equ	_ROM_CALL_2a9
tios::_du32u32	equ	_ROM_CALL_2aa
tios::_mu32u32	equ	_ROM_CALL_2ab
; All following rom calls are not accessible on TI92+ 1.00

tios::assign_between	equ	_ROM_CALL_2ac
tios::did_push_var_val	equ	_ROM_CALL_2ad
tios::does_push_fetch	equ	_ROM_CALL_2ae
tios::delete_list_element	equ	_ROM_CALL_2af
tios::push_ans_entry	equ	_ROM_CALL_2b0
tios::index_after_match_endtag	equ	_ROM_CALL_2b1
tios::push_indir_name	equ	_ROM_CALL_2b2
tios::push_user_func	equ	_ROM_CALL_2b3
tios::store_func_def	equ	_ROM_CALL_2b4
tios::store_to_subscripted_element	equ	_ROM_CALL_2b5
tios::index_below_display_expression_aux	equ	_ROM_CALL_2b6
tios::get_key_ptr	equ	_ROM_CALL_2b7
tios::get_list_indices	equ	_ROM_CALL_2b8
tios::get_matrix_indices	equ	_ROM_CALL_2b9
tios::init_list_indices	equ	_ROM_CALL_2ba
tios::init_matrix_indices	equ	_ROM_CALL_2bb
tios::push_float_qr_fact	equ	_ROM_CALL_2bc
tios::push_lu_fact	equ	_ROM_CALL_2bd
tios::push_symbolic_qr_fact	equ	_ROM_CALL_2be
tios::are_expressions_identical	equ	_ROM_CALL_2bf
tios::compare_expressions	equ	_ROM_CALL_2c0
tios::find_error_message	equ	_ROM_CALL_2c1
tios::check_estack_size	equ	_ROM_CALL_2c2
tios::delete_between	equ	_ROM_CALL_2c3
tios::deleted_between	equ	_ROM_CALL_2c4
tios::delete_expression	equ	_ROM_CALL_2c5
tios::deleted_expression	equ	_ROM_CALL_2c6
tios::estack_to_short	equ	_ROM_CALL_2c7
tios::estack_to_ushort	equ	_ROM_CALL_2c8
tios::factor_base_index	equ	_ROM_CALL_2c9
tios::factor_exponent_index	equ	_ROM_CALL_2ca
tios::GetValue	equ	_ROM_CALL_2cb
tios::im_index	equ	_ROM_CALL_2cc
tios::index_numeric_term	equ	_ROM_CALL_2cd
tios::index_of_lead_base_of_lead_term	equ	_ROM_CALL_2ce
tios::index_main_var	equ	_ROM_CALL_2cf
tios::is_advanced_tag	equ	_ROM_CALL_2d0
tios::is_antisymmetric	equ	_ROM_CALL_2d1
tios::is_complex_number	equ	_ROM_CALL_2d2
tios::is_complex0	equ	_ROM_CALL_2d3
tios::is_free_of_tag	equ	_ROM_CALL_2d4
tios::is_independent_of	equ	_ROM_CALL_2d5
tios::is_independent_of_de_seq_vars	equ	_ROM_CALL_2d6
tios::is_independent_of_tail	equ	_ROM_CALL_2d7
tios::is_independent_of_elements	equ	_ROM_CALL_2d8
tios::is_monomial	equ	_ROM_CALL_2d9
tios::is_monomial_in_kernel	equ	_ROM_CALL_2da
tios::is_narrowly_independent_of	equ	_ROM_CALL_2db
tios::is_symmetric	equ	_ROM_CALL_2dc
tios::is_tail_independent_of	equ	_ROM_CALL_2dd
tios::lead_base_index	equ	_ROM_CALL_2de
tios::lead_exponent_index	equ	_ROM_CALL_2df
tios::lead_factor_index	equ	_ROM_CALL_2e0
tios::lead_term_index	equ	_ROM_CALL_2e1
tios::main_gen_var_index	equ	_ROM_CALL_2e2
tios::map_unary_over_comparison	equ	_ROM_CALL_2e3
tios::min_quantum	equ	_ROM_CALL_2e4
tios::move_between_to_top	equ	_ROM_CALL_2e5
tios::moved_between_to_top	equ	_ROM_CALL_2e6
tios::numeric_factor_index	equ	_ROM_CALL_2e7

tios::push_between	equ	_ROM_CALL_2e8
; push_between(end_EXPR *, end_EXPR*)

tios::push_expr_quantum	equ	_ROM_CALL_2e9
tios::push_expr2_quantum	equ	_ROM_CALL_2ea
tios::push_next_arb_int	equ	_ROM_CALL_2eb
tios::push_next_arb_real	equ	_ROM_CALL_2ec
tios::push_next_internal_var	equ	_ROM_CALL_2ed
tios::push_quantum	equ	_ROM_CALL_2ee
tios::push_quantum_pair	equ	_ROM_CALL_2ef
tios::reductum_index	equ	_ROM_CALL_2f0
tios::remaining_factors_index	equ	_ROM_CALL_2f1
tios::re_index	equ	_ROM_CALL_2f2
tios::reset_estack_size	equ	_ROM_CALL_2f3
tios::reset_control_flags	equ	_ROM_CALL_2f4
tios::can_be_approxed	equ	_ROM_CALL_2f5
tios::compare_complex_magnitudes	equ	_ROM_CALL_2f6
tios::compare_Floats	equ	_ROM_CALL_2f7
tios::did_push_cnvrt_Float_to_integer	equ	_ROM_CALL_2f8
tios::estack_number_to_Float	equ	_ROM_CALL_2f9
tios::float_class	equ	_ROM_CALL_2fa
tios::frexp10	equ	_ROM_CALL_2fb
tios::gcd_exact_whole_Floats	equ	_ROM_CALL_2fc
tios::init_float	equ	_ROM_CALL_2fd
tios::is_Float_exact_whole_number	equ	_ROM_CALL_2fe
tios::is_float_infinity	equ	_ROM_CALL_2ff
tios::is_float_negative_zero	equ	_ROM_CALL_300
tios::is_float_positive_zero	equ	_ROM_CALL_301
tios::is_float_signed_infinity	equ	_ROM_CALL_302
tios::is_float_transfinite	equ	_ROM_CALL_303
tios::is_float_unsigned_inf_or_nan	equ	_ROM_CALL_304
tios::is_float_unsigned_zero	equ	_ROM_CALL_305
tios::is_nan	equ	_ROM_CALL_306
tios::likely_approx_to_complex_number	equ	_ROM_CALL_307
tios::likely_approx_to_number	equ	_ROM_CALL_308
tios::norm1_complex_Float	equ	_ROM_CALL_309
tios::push_Float	equ	_ROM_CALL_30a
tios::push_Float_to_nonneg_int	equ	_ROM_CALL_30b
tios::push_Float_to_rat	equ	_ROM_CALL_30c
tios::push_cnvrt_integer_if_whole_nmb	equ	_ROM_CALL_30d
tios::push_overflow_to_infinity	equ	_ROM_CALL_30e
tios::push_pow	equ	_ROM_CALL_30f
tios::push_round_Float	equ	_ROM_CALL_310
tios::should_and_did_push_approx_arg2	equ	_ROM_CALL_311
tios::signum_Float	equ	_ROM_CALL_312
tios::did_push_to_polar	equ	_ROM_CALL_313
tios::push_degrees	equ	_ROM_CALL_314
tios::push_format	equ	_ROM_CALL_315
tios::push_getkey	equ	_ROM_CALL_316
tios::push_getfold	equ	_ROM_CALL_317
tios::push_getmode	equ	_ROM_CALL_318
tios::push_gettype	equ	_ROM_CALL_319
tios::push_instring	equ	_ROM_CALL_31a
tios::push_mrow_aux	equ	_ROM_CALL_31b
tios::push_part	equ	_ROM_CALL_31c
tios::push_pttest	equ	_ROM_CALL_31d
tios::push_pxltest	equ	_ROM_CALL_31e
tios::push_rand	equ	_ROM_CALL_31f
tios::push_randpoly	equ	_ROM_CALL_320
tios::push_setfold	equ	_ROM_CALL_321
tios::push_setgraph	equ	_ROM_CALL_322
tios::push_setmode	equ	_ROM_CALL_323
tios::push_settable	equ	_ROM_CALL_324
tios::push_str_to_expr	equ	_ROM_CALL_325
tios::push_string	equ	_ROM_CALL_326
tios::push_switch	equ	_ROM_CALL_327
tios::push_to_cylin	equ	_ROM_CALL_328
tios::push_to_sphere	equ	_ROM_CALL_329
tios::cmd_andpic	equ	_ROM_CALL_32a
tios::cmd_blddata	equ	_ROM_CALL_32b
tios::cmd_circle	equ	_ROM_CALL_32c
tios::cmd_clrdraw	equ	_ROM_CALL_32d
tios::cmd_clrerr	equ	_ROM_CALL_32e
tios::cmd_clrgraph	equ	_ROM_CALL_32f
tios::cmd_clrhome	equ	_ROM_CALL_330
tios::cmd_clrio	equ	_ROM_CALL_331
tios::cmd_clrtable	equ	_ROM_CALL_332
tios::cmd_copyvar	equ	_ROM_CALL_333
tios::cmd_cubicreg	equ	_ROM_CALL_334
tios::cmd_custmoff	equ	_ROM_CALL_335
tios::cmd_custmon	equ	_ROM_CALL_336
tios::cmd_custom	equ	_ROM_CALL_337
tios::cmd_cycle	equ	_ROM_CALL_338
tios::cmd_cyclepic	equ	_ROM_CALL_339
tios::cmd_delfold	equ	_ROM_CALL_33a
tios::cmd_delvar	equ	_ROM_CALL_33b
tios::cmd_dialog	equ	_ROM_CALL_33c
tios::cmd_disp	equ	_ROM_CALL_33d
tios::cmd_dispg	equ	_ROM_CALL_33e
tios::cmd_disphome	equ	_ROM_CALL_33f
tios::cmd_disptbl	equ	_ROM_CALL_340
tios::cmd_drawfunc	equ	_ROM_CALL_341
tios::cmd_drawinv	equ	_ROM_CALL_342
tios::cmd_drawparm	equ	_ROM_CALL_343
tios::cmd_drawpol	equ	_ROM_CALL_344
tios::cmd_else	equ	_ROM_CALL_345
tios::cmd_endfor	equ	_ROM_CALL_346
tios::cmd_endloop	equ	_ROM_CALL_347
tios::cmd_endtry	equ	_ROM_CALL_348
tios::cmd_endwhile	equ	_ROM_CALL_349
tios::cmd_exit	equ	_ROM_CALL_34a
tios::cmd_expreg	equ	_ROM_CALL_34b
tios::cmd_fill	equ	_ROM_CALL_34c
tios::cmd_fnoff	equ	_ROM_CALL_34d
tios::cmd_fnon	equ	_ROM_CALL_34e
tios::cmd_for	equ	_ROM_CALL_34f
tios::cmd_get	equ	_ROM_CALL_350
tios::cmd_getcalc	equ	_ROM_CALL_351
tios::cmd_goto	equ	_ROM_CALL_352
tios::cmd_graph	equ	_ROM_CALL_353
tios::cmd_if	equ	_ROM_CALL_354
tios::cmd_ifthen	equ	_ROM_CALL_355
tios::cmd_input	equ	_ROM_CALL_356
tios::cmd_inputstr	equ	_ROM_CALL_357
tios::cmd_line	equ	_ROM_CALL_358
tios::cmd_linehorz	equ	_ROM_CALL_359
tios::cmd_linetan	equ	_ROM_CALL_35a
tios::cmd_linevert	equ	_ROM_CALL_35b
tios::cmd_linreg	equ	_ROM_CALL_35c
tios::cmd_lnreg	equ	_ROM_CALL_35d
tios::cmd_local	equ	_ROM_CALL_35e
tios::cmd_lock	equ	_ROM_CALL_35f
tios::cmd_logistic	equ	_ROM_CALL_360
tios::cmd_medmed	equ	_ROM_CALL_361
tios::cmd_movevar	equ	_ROM_CALL_362
tios::cmd_newdata	equ	_ROM_CALL_363
tios::cmd_newfold	equ	_ROM_CALL_364
tios::cmd_newpic	equ	_ROM_CALL_365
tios::cmd_newplot	equ	_ROM_CALL_366
tios::cmd_newprob	equ	_ROM_CALL_367
tios::cmd_onevar	equ	_ROM_CALL_368
tios::cmd_output	equ	_ROM_CALL_369
tios::cmd_passerr	equ	_ROM_CALL_36a
tios::cmd_pause	equ	_ROM_CALL_36b
tios::cmd_plotsoff	equ	_ROM_CALL_36c
tios::cmd_plotson	equ	_ROM_CALL_36d
tios::cmd_popup	equ	_ROM_CALL_36e
tios::cmd_powerreg	equ	_ROM_CALL_36f
tios::cmd_printobj	equ	_ROM_CALL_370
tios::cmd_prompt	equ	_ROM_CALL_371
tios::cmd_ptchg	equ	_ROM_CALL_372
tios::cmd_ptoff	equ	_ROM_CALL_373
tios::cmd_pton	equ	_ROM_CALL_374
tios::cmd_pttext	equ	_ROM_CALL_375
tios::cmd_pxlchg	equ	_ROM_CALL_376
tios::cmd_pxlcircle	equ	_ROM_CALL_377
tios::cmd_pxlhorz	equ	_ROM_CALL_378
tios::cmd_pxlline	equ	_ROM_CALL_379
tios::cmd_pxloff	equ	_ROM_CALL_37a
tios::cmd_pxlon	equ	_ROM_CALL_37b
tios::cmd_pxltext	equ	_ROM_CALL_37c
tios::cmd_pxlvert	equ	_ROM_CALL_37d
tios::cmd_quadreg	equ	_ROM_CALL_37e
tios::cmd_quartreg	equ	_ROM_CALL_37f
tios::cmd_randseed	equ	_ROM_CALL_380
tios::cmd_rclgdb	equ	_ROM_CALL_381
tios::cmd_rclpic	equ	_ROM_CALL_382
tios::cmd_rename	equ	_ROM_CALL_383
tios::cmd_request	equ	_ROM_CALL_384
tios::cmd_return	equ	_ROM_CALL_385
tios::cmd_rplcpic	equ	_ROM_CALL_386
tios::cmd_send	equ	_ROM_CALL_387
tios::cmd_sendcalc	equ	_ROM_CALL_388
tios::cmd_sendchat	equ	_ROM_CALL_389
tios::cmd_shade	equ	_ROM_CALL_38a
tios::cmd_showstat	equ	_ROM_CALL_38b
tios::cmd_sinreg	equ	_ROM_CALL_38c
tios::cmd_slpline	equ	_ROM_CALL_38d
tios::cmd_sorta	equ	_ROM_CALL_38e
tios::cmd_sortd	equ	_ROM_CALL_38f
tios::cmd_stogdb	equ	_ROM_CALL_390
tios::cmd_stopic	equ	_ROM_CALL_391
tios::cmd_style	equ	_ROM_CALL_392
tios::cmd_table	equ	_ROM_CALL_393
tios::cmd_text	equ	_ROM_CALL_394
tios::cmd_toolbar	equ	_ROM_CALL_395
tios::cmd_trace	equ	_ROM_CALL_396
tios::cmd_try	equ	_ROM_CALL_397
tios::cmd_twovar	equ	_ROM_CALL_398
tios::cmd_unlock	equ	_ROM_CALL_399
tios::cmd_while	equ	_ROM_CALL_39a
tios::cmd_xorpic	equ	_ROM_CALL_39b
tios::cmd_zoombox	equ	_ROM_CALL_39c
tios::cmd_zoomdata	equ	_ROM_CALL_39d
tios::cmd_zoomdec	equ	_ROM_CALL_39e
tios::cmd_zoomfit	equ	_ROM_CALL_39f
tios::cmd_zoomin	equ	_ROM_CALL_3a0
tios::cmd_zoomint	equ	_ROM_CALL_3a1
tios::cmd_zoomout	equ	_ROM_CALL_3a2
tios::cmd_zoomprev	equ	_ROM_CALL_3a3
tios::cmd_zoomrcl	equ	_ROM_CALL_3a4
tios::cmd_zoomsqr	equ	_ROM_CALL_3a5
tios::cmd_zoomstd	equ	_ROM_CALL_3a6
tios::cmd_zoomsto	equ	_ROM_CALL_3a7
tios::cmd_zoomtrig	equ	_ROM_CALL_3a8
tios::OSenqueue	equ	_ROM_CALL_3a9
tios::OSdequeue	equ	_ROM_CALL_3aa
tios::OSqinquire	equ	_ROM_CALL_3ab
tios::OSqhead	equ	_ROM_CALL_3ac
tios::OSqclear	equ	_ROM_CALL_3ad
tios::did_push_divide_units	equ	_ROM_CALL_3ae
tios::has_unit_base	equ	_ROM_CALL_3af
tios::init_unit_system	equ	_ROM_CALL_3b0
tios::is_units_term	equ	_ROM_CALL_3b1
tios::push_auto_units_conversion	equ	_ROM_CALL_3b2
tios::push_unit_system_list	equ	_ROM_CALL_3b3
tios::setup_unit_system	equ	_ROM_CALL_3b4
tios::all_tail	equ	_ROM_CALL_3b5
tios::any_tail	equ	_ROM_CALL_3b6
tios::is_matrix	equ	_ROM_CALL_3b7
tios::is_square_matrix	equ	_ROM_CALL_3b8
tios::is_valid_smap_aggregate	equ	_ROM_CALL_3b9
tios::last_element_index	equ	_ROM_CALL_3ba
tios::map_tail	equ	_ROM_CALL_3bb
tios::map_tail_Int	equ	_ROM_CALL_3bc
tios::push_list_plus	equ	_ROM_CALL_3bd
tios::push_list_times	equ	_ROM_CALL_3be
tios::push_reversed_tail	equ	_ROM_CALL_3bf
tios::push_sq_matrix_to_whole_number	equ	_ROM_CALL_3c0
tios::push_transpose_aux	equ	_ROM_CALL_3c1
tios::push_zero_partial_column	equ	_ROM_CALL_3c2
tios::remaining_element_count	equ	_ROM_CALL_3c3
tios::push_offset_array	equ	_ROM_CALL_3c4
tios::push_matrix_product	equ	_ROM_CALL_3c5
tios::is_pathname	equ	_ROM_CALL_3c6
tios::next_token	equ	_ROM_CALL_3c7
tios::nonblank	equ	_ROM_CALL_3c8
tios::push_parse_prgm_or_func_text	equ	_ROM_CALL_3c9
tios::push_parse_text	equ	_ROM_CALL_3ca


; The RAM_CALLS !
CALCULATOR		equ	_RAM_CALL_000
LCD_WIDTH		equ	_RAM_CALL_001
LCD_HEIGHT		equ	_RAM_CALL_002
tios::ROM_base		equ	_RAM_CALL_003
LCD_LINE_BYTES		equ	_RAM_CALL_004
KEY_LEFT		equ	_RAM_CALL_005
KEY_RIGHT		equ	_RAM_CALL_006
KEY_UP			equ	_RAM_CALL_007
KEY_DOWN		equ	_RAM_CALL_008
KEY_UPRIGHT		equ	_RAM_CALL_009
KEY_DOWNLEFT		equ	_RAM_CALL_00A
KEY_DIAMOND		equ	_RAM_CALL_00B
LCD_SIZE		equ	_RAM_CALL_00C
KEY_SHIFT		equ	_RAM_CALL_00D
tios::font_medium	equ	_RAM_CALL_00E
ReturnValue		equ	_RAM_CALL_00F
tios::kb_globals	equ	_RAM_CALL_010
tios::Heap		equ	_RAM_CALL_011
tios::FolderListHandle	equ	_RAM_CALL_012
tios::MainHandle	equ	_RAM_CALL_013
ROM_VERSION		equ	_RAM_CALL_014
kernel::Idle		equ	_RAM_CALL_015
kernel::Exec		equ	_RAM_CALL_016
kernel::Ptr2Hd		equ	_RAM_CALL_017
kernel::Hd2Sym		equ	_RAM_CALL_018
kernel::LibsBegin	equ	_RAM_CALL_019
kernel::LibsEnd		equ	_RAM_CALL_01A
kernel::LibsCall	equ	_RAM_CALL_01B
kernel::LibsPtr		equ	_RAM_CALL_01C
kernel::LibsExec	equ	_RAM_CALL_01D
kernel::HdKeep		equ	_RAM_CALL_01E
kernel::ExtractFromPack	equ	_RAM_CALL_01F
kernel::ExtractFile	equ	_RAM_CALL_020
LCD_MEM 		equ 	_RAM_CALL_021
tios::font_small	equ	_RAM_CALL_022
tios::font_large	equ	_RAM_CALL_023
tios::SYM_ENTRY.name	equ	_RAM_CALL_024
tios::SYM_ENTRY.compat	equ	_RAM_CALL_025
tios::SYM_ENTRY.flags	equ	_RAM_CALL_026
tios::SYM_ENTRY.hVal	equ	_RAM_CALL_027
tios::SYM_ENTRY.sizeof	equ	_RAM_CALL_028
kernel::ExtractFileFromPack	equ	_RAM_CALL_029
kernel::exit		equ	_RAM_CALL_02A
kernel::atexit		equ	_RAM_CALL_02B
kernel::RegisterVector	equ	_RAM_CALL_02C
GHOST_SPACE		equ	_RAM_CALL_02D
KERNEL_SPACE		equ	_RAM_CALL_02E
kernel::SystemDir	equ	_RAM_CALL_02F


; Vars derivated by the RAM_CALLS
tios::FOLDER_LIST_HANDLE equ	tios::FolderListHandle
Idle			equ	kernel::Idle
HW_VERSION		equ	CALCULATOR+1
EMULATOR		equ	CALCULATOR+3


tios::kb_vars		equ 	tios::kb_globals
KEY_PRESSED_FLAG	equ	tios::kb_vars+$1c
GETKEY_CODE		equ	tios::kb_vars+$1e

tios::main_lcd		equ	LCD_MEM
tios::globals		equ	LCD_MEM

; Sym Entry struct
SYM_ENTRY.name		equ tios::SYM_ENTRY.name
SYM_ENTRY.compat	equ tios::SYM_ENTRY.compat
SYM_ENTRY.flags 	equ tios::SYM_ENTRY.flags
SYM_ENTRY.hVal 		equ tios::SYM_ENTRY.hVal
SYM_ENTRY.sizeof	equ tios::SYM_ENTRY.sizeof

; Flags value :
SF_GREF1 equ $0001
SF_GREF2 equ $0002 
SF_STATVAR equ $0004 
SF_LOCKED equ $0008 
SF_HIDDEN equ $0010 
SF_OPEN equ $0010 
SF_CHECKED equ $0020 
SF_OVERWRITTEN equ $0040 
SF_FOLDER equ $0080 
SF_INVIEW equ $0100 
SF_ARCHIVED equ $0200 
SF_TWIN equ $0400 
SF_COLLAPSED equ $0800 
SF_LOCAL equ $4000 
SF_BUSY equ $8000

; Queue structure
QUEUE.head	EQU	0
QUEUE.tail	EQU	2
QUEUE.size	EQU	4
QUEUE.used	EQU	6
QUEUE.data	EQU	8

; Window Structure
WINDOW.Flags		EQU	0	;/* Window flags */ 
WINDOW.CurFont		EQU	2	; unsigned char CurFont; /* Current font */ 
WINDOW.CurAttr		EQU	3	; unsigned char CurAttr; /* Current attribute */ 
WINDOW.Background	EQU	4	; unsigned char Background; /* Current background attribute */ 
WINDOW.TaskId		EQU	6	; short TaskId; /* Task ID of owner */ 
WINDOW.CurX		EQU	8	; short CurX
WINDOW.CurY		EQU	10	; short CurY; /* Current (x,y) position (relative coordinates) */ 
WINDOW.CursorX		EQU	12	; short CursorX
WINDOW.CursorY		EQU	14	; short CursorY; /* Cursor (x,y) position */ 
WINDOW.Client		EQU	16	; SCR_RECT Client; /* Client region of the window (excludes border) */ 
WINDOW.Window		EQU	20	; SCR_RECT Window; /* Entire window region including border */ 
WINDOW.Clip		EQU	24	; SCR_RECT Clip; /* Current clipping region */ 
WINDOW.Port		EQU	28	; SCR_RECT Port; /* Port region for duplicate screen */ 
WINDOW.DupScr		EQU	34	; unsigned short DupScr; /* Handle of the duplicated or saved screen area */ 
WINDOW.Next		EQU	36	; struct WindowStruct *Next; /* Pointer to the next window in the linked list */ 
WINDOW.Title		EQU	40	; char *Title; /* Pointer to the (optional) title */ 
WINDOW.savedScrState	EQU	44	; SCR_STATE savedScrState; /* Saved state of the graphics system */ 

; ???
;tios::MaxHandles	equ	tios::Heap-$16
;tios::TopHeap   	equ     tios::Heap-$C
;tios::FirstFreeByte	equ	tios::Heap-$14
;tios::OSOnBreak		equ	tios::globals+$F02

tios::NULL		equ	0
tios::H_NULL		equ	0
tios::RAND_MAX		equ	$7fff

; codes for ST_busy()
ACTIVITY_IDLE		equ	0
ACTIVITY_BUSY equ 1
ACTIVITY_PAUSED equ 2

; codes for ER_throw()
tios::ER_STOP equ 2
tios::ER_DIMENSION equ 230
tios::ER_MEMORY equ 670
tios::ER_MEMORY_DML equ 810

KEY_2ND		equ	4096

; tags
tios::ASM_TAG 		equ $F3
tios::UNDEFINED_TAG 	equ $2a
tios::LIST_TAG 		equ $d9
tios::MATRIX_TAG 	equ $db
tios::END_TAG 		equ $e5

CALC_TI89TI		equ	-1
CALC_TI89		equ	0
CALC_TI92PLUS		equ	1
CALC_TI92		equ	2
CALC_V200		equ	3

EXTRA_RAM_TABLE	macro
_extraram:	xdef	_extraram
		endm

EXTRA_RAM_ADDR macro
    dc.w \3
    dc.w \4
\2 equ _extraramaddr@\1
    endm

tios::DEREF     macro   ; Dn,An
	lsl.w	#2,\1
        move.l  (tios::Heap).w,\2
	move.l	0(\2,\1.w),\2
		endm

DEREF macro
 tios::DEREF \1,\2
 endm

handle_ptr macro
 tios::DEREF \1,\2
 endm

tios::DEREF_SYM macro
 move.l \1,-(sp)
 jsr tios::DerefSym
 addq.l #4,sp
 endm

ROM_THROW macro
 dc.w $F800+\1
 endm

ER_throw macro
 dc.w $A000+\1
 endm

tios::ER_throw macro
 dc.w $A000+\1
 endm

SetFont		macro
	move.w	#\1,-(a7)
	jsr	tios::FontSetSys
	addq.l	#2,a7
		endm

WriteStr	macro	;x,y,col,str
	move.w	\3,-(a7)
	pea	\4(pc)
	move.w	\2,-(a7)
	move.w	\1,-(a7)
	jsr	tios::DrawStrXY
	lea	10(a7),a7
                endm

WriteStrA	macro	;x,y,col,An
	move.w	\3,-(a7)
	move.l	\4,-(a7)
	move.w	\2,-(a7)
	move.w	\1,-(a7)
	jsr	tios::DrawStrXY
	lea	10(a7),a7
                endm

GetKeyStat	MACRO
		move.w		#$FFFE,d0
		move.b		\1,d1
		rol.w 		d1,d0
		move.w		d0,($600018)
		moveq	#$58,d2
\\@wait		dbf	d2,\\@wait
		move.b		($60001B),d0
		ENDM

HALT	MACRO
	bra	*
	ENDM

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
	