; PreOs - Shared Libraries linker for Ti-89ti/Ti-89/Ti-92+/V200.
; Copyright (C) 2004-2009 Patrick Pelissier
; 
; This program is free software ; you can redistribute it and/or modify it under the
; terms of the GNU General Public License as published by the Free Software Foundation;
; either version 2 of the License, or (at your option) any later version. 
; 
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
; See the GNU General Public License for more details. 
; 
; You should have received a copy of the GNU General Public License along with this program;
; if not, write to the 
; Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 

; BUG?: If it fail to realloc the table, it may forget to free some handles...

	include "include/romcalls.h"
	include "kheader.h"

; Define:	
;; 	WANT_REENTRANT_UNRELOCATION:	reloc/unreloc/run can be in a random order
;; 	PEDROM:				for PedroM internal structures
;; 	FLASH_CODE:			Code resides in Flash ROM

; *** Definition of a relocated library ref ***

LIBRARY.name    EQU     0
LIBRARY.org	EQU	8
LIBRARY.code    EQU     12
LIBRARY.data    EQU     16
LIBRARY.refcnt	EQU	20
LIBRARY.relocf	EQU	22
LIBRARY.sizeof  EQU     24
	

ER_KERNEL_PANICK 	EQU	1
ER_CRASH_INTERCEPTED	EQU	2
ER_LIB_NOT_FOUND	EQU	3
ER_WRONG_LIB_VERSION	EQU	4
ER_INVALID_RAMCALL	EQU	5
ER_INVALID_ROMCALL	EQU	6
ER_INVALID_STUB		EQU	7
ER_INVALID_LIB		EQU	8
ER_INVALID_PROGRAM	EQU	9
ER_MAX_KERNEL		EQU	10
ER_MEMORY_FULL		EQU	670

RELOC_MODE		EQU	0
UNRELOC_MODE		EQU	1

	ifnd	CALC_FLAG
CALC_FLAG	EQU	0
	endif

; Standards relocs functions for _nostub programs.
reloc:	movem.l	d1-d7/a1-a6,-(a7)
	lea	kernel::relocation(Pc),a4	; Relocation Mode selected
relocHd	move.w	d0,-(a7)			; Push handle
	ROM_THROW HeapDeref			; Get address
	addq.w	#2,a7				; Fix sp
	lea	2(a0),a5			; Program Ptr
relocDo	jsr	(a4)				; Relocation / Unrelocation
	lea	LibLastName-Ref(a6),a0
	movem.l	(a7)+,d1-d7/a1-a6	
	rts
reloc2:	movem.l	d1-d7/a1-a6,-(a7)
	lea	kernel::relocation(Pc),a4	; Relocation Mode selected
relocAn	move.l	a6,a5				; Get Program Ptr
	bra.s	relocDo				; Do relocation / unrelocation
unreloc	movem.l	d1-d7/a1-a6,-(a7)
	lea	kernel::unrelocation(Pc),a4	; UnRelocation Mode selected
	bra.s	relocHd				; UnRelocation of the selected handle
unreloc2 movem.l d1-d7/a1-a6,-(a7)
	lea	kernel::unrelocation(Pc),a4	; UnRelocation Mode selected
	bra.s	relocAn				; Unrelocation of the ptr


; Register an error.
; In:
;	d0.w = Error code
;	a2 -> Optionnal Library name
; Out:
;	nothing
; Destroy:
;	d0-d2/a0-a1
kernel::RegisterError:
	tst.w	Error-Ref(a6)			; Check if an error has been already be found
	bne.s	\No				; So that we don't destroy the real error
		move.w	d0,Error-Ref(a6)	; Save error code and check if success.
		lea	LibLastName-Ref(a6),a1
		move.l	a2,a0
		moveq	#8-1,d0			; 8x
\CopyName:		move.b	(a0)+,(a1)+	; Copy Name
			dbf	d0,\CopyName
\No	rts
	
	
; Reloc a program:
;       Create code section, data section and bss section if necessary.
;       Solve all relocations throught all the libraries-objects.
;       Add it in the relocated library table.
; In:
;       a5 -> Program (HeapDeref(h)+2).
; Out:
;       d0.w = 0 if Ok, else an error occured while relocating.
;       a5 -> Code Section
;	a6 -> Preos Data Ptr
; Algo:
;	GetDataPtr
;	LibIndex = LibIndexMax
;	TRY
;		reloc1 (addr)
;		For i = LibIndex to LibIndexMax-1
;			reloc2 (LibTable[i].code, RELOC)
;		ret = 0
;	ELSE
;		ret = error code
;		For i = LibIndex to LibIndexMax-1
;			If LibTable[i].data != 0=> free (LibTable[i].data)
;			If Hw2Tsr(LibTable[i].org) != LibTable[i].code => free (LibTable[i].code)
;		LibIndexMax = LibIndex
;		ResizeLibTable
;	ENDTRY
;	return ret
kernel::relocation:
	movem.l	d0-d7/a0-a4,-(a7)
	GET_DATA_PTR	                      ; Get a6 ptr
	move.w	LibTableNum-Ref(a6),d6		; Read current max
	clr.w	Error-Ref(a6)			; Clear Error code
	lea	-60(a7),a7
        pea	(a7)
        ROM_THROW	ER_catch		; TRY
	tst.w	d0
	bne.s	\Error

	bsr	kernel::reloc1			; Reloc Pass 1 (Do reloc2 after).
	bsr	kernel::FindLibAddr		; Get the lib ref of relocated program
	tst.b	LIBRARY.relocf(a0)		; Check if it has been relocated
	bne.s	\Ok				; In some rare cases, it could be unrelocated
		ER_throw ER_KERNEL_PANICK	; If it is not relocated, it was impossible!
\Ok	ROM_THROW	ER_success		; Success!
	lea	64(a7),a7
	movem.l	(a7)+,d0-d7/a0-a4
	move.w	Error-Ref(a6),d0		; Restore error code
	rts

\Error:	lea	64(a7),a7
	bsr.s	kernel::RegisterError
	ifd	WANT_REENTRANT_UNRELOCATION	; ******************
	bsr	kernel::GetLibTable
	move.l	a1,a0
	endif					; ****************** 
	bra.s	kernel::unrelocation2		; Unrelocation won't throw any errors.

	ifd	WANT_REENTRANT_UNRELOCATION
kernel::UnrefLibrary:	
	movem.l	a2/d5,-(a7)
	tst.w	LIBRARY.refcnt(a0)
	beq.s	\End
	subq.w	#1,LIBRARY.refcnt(a0)			; Dec reference counter
	bne.s	\End					; != 0: Some programs still use it.
	move.l	LIBRARY.code(a0),a0			; Get code section
	lea	KHEADER_size(a0),a2			; a2 -> Import Table
	move.w	(a2)+,d5				; d5.w = Number of used libraries
	beq.s	\End					; If no library, skip Library relocation
\LoopLib:	bsr	kernel::FindLibName		; Find (name=a2)
		move.l	a0,d0				; Check if library is found
		beq.s	\NextLib			; Maybe not (Not relocated)
		bsr.s	kernel::UnrefLibrary		; Recursively, unreference this library
\NextLib:	lea	10(a2),a2			; Next library name.
		subq.w	#1,d5				; Library Counter -1
		bne.s	\LoopLib			; If LibraryCounter>0, continue
\End:							; End of Libraries unref
	movem.l	(a7)+,a2/d5
	rts
	endif

; UnReloc a program (Undo relocation):
;       Solve all relocations throught all the libraries-objects to NULL.
;       Remove code section, data section and bss section if necessary.
;       Remove it in the relocated library table.
; In:
;       a5 -> Program (HeapDeref(h)+2).
; Out/Destroy:
;	d0 / a6
; Algo:
;	GetDataPtr
;	LibIndex = FindLibAddr(addr) => FAIL: 0
;	For i = LibIndex to LibIndexMax-1
;		reloc2 (LibTable[i].code, UNRELOC)
;	For i = LibIndex to LibIndexMax-1
;		If LibTable[i].data != 0=> free (LibTable[i].data)
;		If Hw2Tsr(LibTable[i].org) != LibTable[i].code => free (LibTable[i].code)
;	LibIndexMax = LibIndex
;	ResizeLibTable
kernel::unrelocation:
	movem.l	d0-d7/a0-a4,-(a7)		; Push registers
	GET_DATA_PTR				; Get a6 ptr
	bsr	kernel::FindLibAddr		; Search for this library in Relocated Library Table
	move.l	a0,d1				; Check if 

	ifnd	WANT_REENTRANT_UNRELOCATION	; Smaller variant
	beq.s	UnrelocDone			; found?
	subq.w	#1,LIBRARY.refcnt(a0)		; Dec referencre counter
	bne.s	UnrelocDone			; != 0: Some programs still use it.

	move.w	d0,d6				; Library index in Relocated Library Table
kernel::unrelocation2:				; Input: d6.w
	; Undo Pass 2: Unreloc all needed libraries
	move.w	d6,d5
\Loop1:		cmp.w	LibTableNum-Ref(a6),d6	; Check if end ?
		beq.s	\EndOfLoop1
		bsr	kernel::GetLibTable	; Get lib ref
		tst.b	LIBRARY.relocf(a1)	; Check if library has been relocated
		beq.s	\Next1			; No so skip it
		moveq	#UNRELOC_MODE,d7	; Yes so select unreloc mode
		move.l	LIBRARY.code(a1),a0	; Ptr to code section
		bsr	kernel::reloc2		; UnReloc Pass 2
\Next1		addq.w	#1,d6			; Next library
		bra.s	\Loop1			; Continue loop
\EndOfLoop1:
	; Undo Pass1: Free memory
	move.w	d5,d6				; Initial library
	subq.l	#2,a7				; Create Stack Frame
\Loop2:		cmp.w	LibTableNum-Ref(a6),d6	; Check if end of libraries to unrelocate?
		beq.s	\EndOfLoop2
		bsr	kernel::GetLibTable	; Get Relocated Library Table
		move.l	LIBRARY.data(a1),d0	; Check if this library
		beq.s	\NoFreeData		; has a data section
			move.l	d0,a0		; Yes so we need to free it
			bsr	kernel::Ptr2Hd	; Get Handle of data section
			move.w	d0,(a7)		; Push Handle
			beq.s	\NoFreeData
			ROM_THROW HeapFree	; Free data section
\NoFreeData:	bsr	kernel::GetLibTable	; Reget Relocated Library Table (may moved due to HeapFree)
		move.l	LIBRARY.code(a1),d0	; Get code section
		andi.l	#$0003FFFF,d0		; Avoid Ghost Space (TODO: Improve for RAM > 256K).
		cmp.l	LIBRARY.org(a1),d0	; Check if it is copy section
		beq.s	\NoFreeCode		
			move.l	d0,a0		; Yes so 
			bsr	kernel::Ptr2Hd	; get the handle of the code section
			move.w	d0,(a7)		; Push handle of code section
			beq.s	\NoFreeCode	
			ROM_THROW HeapFree	; Free code section		
\NoFreeCode	addq.w	#1,d6			; Next library
		bra.s	\Loop2			; Continue loop
\EndOfLoop2:
	endif

	ifd	WANT_REENTRANT_UNRELOCATION
	beq	UnrelocDone			; found?
kernel::unrelocation2:				; Input: a0->LibEntry
	; Update all unused libraries
	bsr.s	kernel::UnrefLibrary
	
	; Undo Pass 2: Unreloc all needed libraries, ie. with refcnt == 0
	move.w	LibTableHd-Ref(a6),-(a7)	; Push Library Table Handle
	ROM_THROW HLock				; Deref and lock it
	move.l	a0,a4				; Save it in a global ptr
	move.l	a0,a3
	move.w	LibTableNum-Ref(a6),d6		; Number of items in the table
	bra.s	\EndFor1
\Loop1:		tst.b	LIBRARY.relocf(a3)	; Check if library has been relocated
		beq.s	\Next1			; No so skip it
		tst.w	LIBRARY.refcnt(a3)	; Check if library is still in use.
		bne.s	\Next1			; Yes, so don't unreloc it.
		moveq	#UNRELOC_MODE,d7	; Now select unreloc mode
		move.l	LIBRARY.code(a3),a0	; Ptr to code section
		bsr	kernel::reloc2		; UnReloc Pass 2
\Next1		lea	LIBRARY.sizeof(a3),a3	; Next library
\EndFor1:	dbf	d6,\Loop1

	; Undo Pass1: Free memory and compact table
	moveq	#0,d5				; Number of items remaining in the table.
	move.l	a4,a3				; Reget begining of Library Table
	move.w	LibTableNum-Ref(a6),d6		; Number of items in the table
	bra.s	\EndFor2
\Loop2:		tst.w	LIBRARY.refcnt(a4)	; Check if the library is still in use
		bne.s	\KeepEntry		; Yes so don't delete it!
		move.l	LIBRARY.data(a4),d0	; Check if this library
		beq.s	\NoFreeData		; has a data section
			move.l	d0,a0		; Yes so we need to free it
			bsr	kernel::Ptr2Hd	; Get Handle of data section
			move.w	d0,(a7)		; Push Handle
			beq.s	\NoFreeData
			ROM_THROW HeapFree	; Free data section
\NoFreeData:	move.l	LIBRARY.code(a4),d0	; Get code section
		andi.l	#$0003FFFF,d0		; Avoid Ghost Space (TODO: Improve for RAM > 256K).
		cmp.l	LIBRARY.org(a4),d0	; Check if it is copy section
		beq.s	\NoFreeCode		
			move.l	d0,a0		; Yes so 
			bsr	kernel::Ptr2Hd	; get the handle of the code section
			move.w	d0,(a7)		; Push handle of code section
			beq.s	\NoFreeCode	
			ROM_THROW HeapFree	; Free code section		
\NoFreeCode	lea	LIBRARY.sizeof(a4),a4	;  Next entry
		bra.s	\EndFor2
\KeepEntry:	addq.w	#1,d5			; One more entry in the table.
		moveq	#LIBRARY.sizeof/4-1,d0	; Size of one entry
	\CopyLoop:	move.l	(a4)+,(a3)+	; Pack them
			dbf	d0,\CopyLoop
\EndFor2	dbf	d6,\Loop2
	
\EndOfLoop2:
	move.w	LibTableHd-Ref(a6),(a7)
	ROM_THROW HeapUnlock	
	endif

	addq.l	#2,a7				; Destroy stack frame
	move.w	d5,LibTableNum-Ref(a6)		; Save new value of current relocated libraries
	bsr	kernel::ReallocLibTable		; Realloc Relocated Library Table to its new size
UnrelocDone:
	movem.l	(a7)+,d0-d7/a0-a4		; Pop registers
	move.w	Error-Ref(a6),d0		; Return error code
	rts
	
; Reloc Pass1:
;	Search for the libraries of a program.
;	Alloc code section and data section for all.
;	Check for all possible errors.
;In:
;	a5 -> Program to relocate
;	a6 -> DataPtr
;Out:
;	a5 -> Code section
; Destroy:
;	a5
; Throw:
;	May throw various error codes.
; Algo:
;	lib = FindLibAddr => Return lib.code
;	Save all registers
;	Check format
;	Get library name
;		Purge cache name
;		Check if the library already exist with the same name
;	Add the library in the relocated libraries table (a2, a5, d5)
;	Prepare CODE section: copy it in RAM if needed.
;		Update code section in lib table
;	Prepare DATA section:
;		Update data section in descriptor
;	For each library
;		lib = FindNewLib (name)
;		reloc1 (lib)
;		check_reloc
;	Check ramcalls
;	Check romcalls
;	Check reloc
;	Check BSS
;	Do pass 2 / set reloc flag
kernel::reloc1:
	movem.l	d0-d7/a0-a4,-(a7)			; Push all registers

	ori.w	#$8000,-4(a5)				; Lock org ptr (FIXME: Use a more compatible way?)
	
	; Check if the library is already relocated by searching for it 
	bsr	kernel::FindLibAddr			; Search for the library in the Relocated Library Table.
	move.l	a0,d0					; Check if success
	beq.s	\RelocIt				; No so we have to relocate it
		addq.w	#1,LIBRARY.refcnt(a0)		; Yes, incremente reference counter
		move.l	LIBRARY.code(a0),a5		; And return code section 
		bra	\Reloc1End			; End of relocation 
\RelocIt

	; Check Library Format. Only KernelV4 supported yet.
	move.l	KHEADER_signa(a5),d0			; Get signature of Kernel V4 (Must be 68kP or 68kL)
	move.b	KHEADER_format(a5),d0			; Get internal format of KV4 (Must be 0)
	cmpi.l	#'68k'*256,d0				; Check if this program/library is supported
	beq.s	\FormatOk				;
		ER_throw 210				; Not supported, return ERROR: Data Type
\FormatOk

	; Get library name.
	lea	LibCacheName-Ref(a6),a2			; Get the cached Library Name
	move.b	LibCacheFlags-Ref(a6),d5		; Get the cached Library Flags
	cmp.l	LibCacheAddr-Ref(a6),a5			; Compare the address between original section and current cached library
	beq.s	\SetLibName				; Yes? => Use the cached flags && name
		; Check if format supports 'Library Name' field (KV4 doesn't support it, so skip this step).
		; Search file in the VAT so that we can get its name.
		move.l	a5,a0				; Input: a0
		bsr	kernel::Ptr2Hd			; Get Handle of File
		bsr	kernel::Hd2Sym			; Get SYM_ENTRY of file or NULL (Dummy name)
		moveq	#0,d5				; Flag: Nothing.
		move.l	a0,a2				; Save Name or NULL
\SetLibName

	; Purge cache name
	clr.l	LibCacheAddr-Ref(a6)

	; Check if the library already exist with the same name
	tst.b	(a2)					; Dummy name, skip duplicate name detection
	beq.s	\OkNotFound
		bsr	kernel::FindLibName		; Find a library with this name (can be possible)
		move.l	a0,d0				; Check if success
		beq.s	\OkNotFound			; Library with the same name has already been relocated?
			ER_throw ER_KERNEL_PANICK	; But it is a different library nevertheless! => Return Kernel Panick
\OkNotFound

	; Add the library in the relocated libraries table (a2, a5, d5)
	move.l	(a2)+,-(a7)				; Push Library Name (The cache or a sym should aligned).
	move.l	(a2)+,-(a7)				; Push Library Name (since the Heap may moved)
	move.w	LibTableNum-Ref(a6),d6			; Read number of entries in table
	addq.w	#1,LibTableNum-Ref(a6)			; UsedLibraryNum++
	bsr	kernel::ReallocLibTable			; Realloc handle and returns ptr to entry [d6]
	move.l	(a7)+,LIBRARY.name+4(a1)		; Save Lib Name
	move.l	(a7)+,LIBRARY.name(a1)			; Save Lib Name
	move.l	a5,LIBRARY.org(a1)			; Copy Lib Ptr (Org section)
	clr.l	LIBRARY.code(a1)			; Code section = NULL
	clr.l	LIBRARY.data(a1)			; Data section = NULL
	move.w	#1,LIBRARY.refcnt(a1)			; Set refcount of the library
	clr.b	LIBRARY.relocf(a1)			; Library has not been relocated yet
	tst.b	d5					; Copy=0 ?
	beq.s	\NotACopy				; It isn't the org section but a code section!
		clr.l	LIBRARY.org(a1)			; Copy Lib Ptr (Org section)
		move.l	a5,LIBRARY.code(a1)		; Copy Lib Ptr (Code section)
\NotACopy:
	
	; Prepare CODE section: copy it in RAM if needed.
	cmpa.l	#$200000,a5				; Check if section code is archived
	bls.s	\CodeSectionOk				; No, so it is ok!
	btst.b	#3,KHEADER_flags(a5)			; Test the Read Only flag.
	bne.s	\CodeSectionHW2Tsr			; If ro set, do not unarchive it ! and do not add Hw2Tsr patch!
		moveq	#2,d3				; Size + 2 to get the real size of the file
		add.w	-2(a5),d3			; d3 = File size
		move.l	d3,-(a7)			; Push File Size
		ROM_THROW HeapAllocHighThrow		; And alloc a new Handle for the copy.
		move.w	d0,(a7)				; Push Handle
		ROM_THROW HeapDeref			; and rederef it
		move.l	a0,a1				; Recopy the file in the created Handle
\CodeLoop:		move.b	(a5)+,(a1)+		; Copy File
			subq.w	#1,d3			; Better than subq+dbf (6 bytes)
			bne.s	\CodeLoop		; subq + bne = 4 bytes (but slower)
		addq.l	#4,a7		
		move.l	a0,a5				; New code section
\CodeSectionOk:

	; Update code section in descriptor
	HW2TSR_PATCH a5,d0	
\CodeSectionHW2Tsr
	bsr	kernel::GetLibTable			; Get Relocated Library Table at index d6 since it may move
	move.l	a5,LIBRARY.code(a1)			; Save new Code Section

	; Prepare DATA section:
	;	Merge BSS and DATA section.
	;	Alloc new section.
	;	Copy DATA section.
	; But KV4 doesn't have a data section.
	suba.l	a4,a4					; No data section
	move.w	KHEADER_impOff(a5),d0			; Offset of the BSS table in d0
	beq.s	\NoBSS					; if =0, there is no BSS section.
		lea	0(a5,d0.w),a2			; Address of the BSS reloc table in a2
		move.l	(a2)+,-(a7)			; Push the size of the BSS block (Long so we can have BSS section > 64K with Pedrom)
		ROM_THROW HeapAllocHighThrow		; Alloc it as High as possible (and lock it)
		move.w	d0,-(a7)			; Push the handle and 
		ROM_THROW HeapDeref			; Deref to get its adress
		HW2TSR_PATCH	a0,d0			; To prevent some problems if someone writes some code in the BSS section.
		move.l	a0,a4				; adress of the BSS block in a4
		clr.w	(a7)				; Fill with '0'
		pea	(a0)				; Push beginning address
		ROM_THROW memset			; Clear the allocated buffer
		lea	10(a7),a7			; Pop 10 (void *, Character, size)
\NoBSS

	; Update data section in descriptor
	bsr	kernel::GetLibTable			; Get Relocated Library Table at index d6 since it may move
	move.l	a4,LIBRARY.data(a1)			; Save new data section

	; Check the code section:
	; 	Read section size.
	; 	For each library:
	;		LibPtr = kernel::FindLib (Libname,LibVersion)
	;		LibPtr = kernel::reloc1 (LibPtr)
	;		RelocPtr = kernel::rcheck_reloc(CodePtr, CodeSize, RelocPtr, RELOC_MODE, RelocAddress)
	; 1. Importation of the libraries
	lea	KHEADER_size(a5),a3			; a3 -> Import Table
	move.w	(a3)+,d5				; d5.w = Number of used libraries
	beq.s	\NoLib					; If no library, skip Library relocation
		move.w	d5,d0				; Calcul the library offset table
		mulu.w	#10,d0				; d3=10*d5
		move.l	a3,a2				; Lib name ptr
		adda.l	d0,a3				; Advance ptr
\LibLoop:		move.b	9(a2),d3		; The program needs at least this version
			bsr	kernel::FindLib		; Find it (Unarchived, Uncompressed it and set cache and global vars).
			move.l	a0,d0			; a0 = Address of the lib
			bne.s	\good1
				ER_throw ER_LIB_NOT_FOUND
\good1:			exg.l	a0,a5			; Relocation of this library.
			bsr	kernel::reloc1
			exg.l	a0,a5			; The library has been relocated
\no_recur		move.l	a0,a1
			move.w	KHEADER_expOff(a1),d1	; Read offset to export table
			beq.s	\VeryBadLib
			adda.w	d1,a1			; Adress of the export table in a1
			move.w	(a1)+,d1		; Number of exported functions in d1
			move.w	(a3)+,d2		; Number of imported functions in d2
\LibFuncLoop			moveq	#0,d3		;
				move.w	(a3)+,d3	; Function Number in d3
				cmp.w	d1,d3		; Check if the function number is exported ?
				blt.s	\good2
					; If I want to register the library name, I must call
					; here RegisterError
\VeryBadLib:				moveq  #ER_WRONG_LIB_VERSION,d0
					bsr    kernel::RegisterError
					ER_throw ER_WRONG_LIB_VERSION
\good2:				bsr.s	kernel::check_reloc	; Reloc the function
				dbf	d2,\LibFuncLoop	; Reloc all the imported functions
			lea	10(a2),a2		; Next library name.
			subq.w	#1,d5			; Library Counter -1
			bne.s	\LibLoop		; If LibraryCounter>0, continue
\NoLib							; End of Libraries importation
	; 2. RomCalls Importation
	move.w	(a3)+,d5				; Is there any Rom Calls ?
	beq.s	\NoRomCalls				; No Rom Calls, go to RamCall
		move.l	($C8).l,a2			; ROM CALLS table 
		move.w	(a3)+,d5			; Number of imported RomCalls in d5.w
\RomCallLoop		moveq	#0,d3			; Clear
			move.w	(a3)+,d3		; Function number in d3
			cmp.l	-4(a2),d3		; Check if the RomCall exists
			blt.s	\ValidRomCall		; Yes, continue
				ER_throw ER_INVALID_ROMCALL
\ValidRomCall		bsr.s	kernel::check_reloc	; Reloc it
			dbf	d5,\RomCallLoop		; Continue for all romcalls
\NoRomCalls:						; End of RomCall importation
	;3. RAM relocation table
	move.w	(a3)+,d5				; Number of RAM_CALLS > 0 (But why do Xavier & Rusty have specify this word ???????)
	beq.s	\NoRamCalls				; No RAMCALL, skip
		;;  Check if address of Extra RamCall is even (Check also for NULL)
		btst.b  #0,KHEADER_extROff+1(a5)
		beq.s	\EvenExtraRamCall
			ER_throw ER_INVALID_STUB	; ExtraRamCall address is odd. Send ER_throw
\EvenExtraRamCall:	
		lea	RAM_TABLE(pc),a2		; a2 -> RamCall Table 
		move.w (a3)+,d5				; Number of different RAM_CALLS !
	
\RamCallLoop:		moveq	#0,d3
			move.w	(a3)+,d3		; Read RAM_CALL number
			move.l	d3,d2			; Copy (because we work on RAM_CALL & EXTRA_RAM_CALL)
			lsl.w	#2,d2			; d2*4 <= Values == adress or longs words.
							; & Remove the word flag & the extra_ram flag
			btst	#14,d3			; Look for EXTRA_RAM_ADDRESS ?
			bne.s	\ValidRamCall		; Yes => Do ExtraRamCall, but can't check for them.
			cmp.w	#MAX_RAMCALL*4-4,d2	; Check if valid RAM_CALL
			bls.s	\ValidRamCall
				ER_throw ER_INVALID_RAMCALL
\ValidRamCall		bsr.s	kernel::check_reloc
			dbf	d5,\RamCallLoop		; Continue for all the imported ramcalls
\NoRamCalls:						; End of RAM_CALL relocation

	; 4. Relocation table (the global variables)
	bsr.s	kernel::check_reloc			; Relocation of the variables

	; 5. Relocation of the BSS section
	move.w	KHEADER_impOff(a5),d0			; Offset of the BSS table in d0
	beq.s	\NoCheckBSS				; if =0, there is no BSS section.
		lea	4(a5,d0.w),a3			; Address of the BSS reloc table in a3
		bsr.s	kernel::check_reloc		; Relocation of the BSS section.
\NoCheckBSS						; End of relocating the BSS
	
	; 6. Now it is sure that we can reloc it completly without stopping anywhere.
	move.l	a5,a0				
	moveq	#RELOC_MODE,d7				; select reloc mode
	bsr.s	kernel::reloc2				; Do reloc PASS 2 (Can't throw any errorsà
	bsr	kernel::GetLibTable			; Get lib ref
	st.b	LIBRARY.relocf(a1)			; Library has been relocated

\Reloc1End
	movem.l	(a7)+,d0-d7/a0-a4
return	rts						; Return a5

; Check a reloc table by checking the parity of the offsets and control program overflow
; In: 
;	a3 -> Offset Table
;	a5 -> Program reference
; Out:
;	Nothing
; Destroy:
;	Nothing
kernel::check_reloc:
	moveq	#0,d0
\Loop:		move.w	(a3)+,d0			; Offset in d0
		beq.s	return				; No offset ? => End of reloc function
		cmp.w	-2(a5),d0			; Test overflow of the offset?
		bhi.s	\error
		btst.l	#0,d0				; Offset must be EVEN
		bne.s	\error
		bra.s	\Loop				; Continue
\error	ER_throw ER_INVALID_STUB

	
; Relocate a kernel program by patching it
; In:
;	a0 -> Code section
;	d7 = MODE relocate or unrelocate
; Out / Destroy / Throw
;	Nothing	
; algo:
;	For each library
;		lib = FindLibName (name)
;		do_reloc
;	do ramcalls
;	do romcalls
;	do reloc
;	do BSS
kernel::reloc2:
	movem.l	d0-d7/a0-a5,-(a7)
	move.l	a0,a5
	lea	KHEADER_size(a5),a3			; a3 -> Import Table

	; 1. Importation of the libraries
	move.w	(a3)+,d5				; d5.w = Number of used libraries
	beq.s	\EndOfLoopLib				; If no library, skip Library relocation
		move.w	d5,d0				; Calcul the library offset table
		mulu.w	#10,d0				; d3=10*d5
		move.l	a3,a2				; Lib name ptr
		adda.l	d0,a3				; Advance ptr
\LoopLib:		bsr	kernel::FindLibName	; Find (name=a2) -- MUST BE FOUND! ---
			move.l	LIBRARY.code(a0),a0	; Get code section
			move.l	a0,a1			;
			adda.w	KHEADER_expOff(a1),a1	; Get export table in a1 (Can't be null)
			move.w	(a1)+,d1		; Number of exported functions in d1
			move.w	(a3)+,d2		; Number of imported functions in d2
\LoopLibFunc			moveq	#0,d3		;
				move.w	(a3)+,d3	; Function Number in d3
				add.l	d3,d3		; Number x2
				move.w	0(a1,d3.l),d3	; Function offset (from the library start) in d3
				move.l	a0,d4		; Adress of the lib in d4
				add.l	d3,d4		; Adress of the function in d4
				bsr	kernel::do_reloc ; Reloc the function
				dbf	d2,\LoopLibFunc	; Reloc all the imported functions
			lea	10(a2),a2		; Next library name.
			subq.w	#1,d5			; Library Counter -1
			bne.s	\LoopLib		; If LibraryCounter>0, continue
\EndOfLoopLib						; End of Libraries importation

	; 2. RomCalls Importation
	move.w	(a3)+,d5				; Is there any Rom Calls ?
	beq.s	\EndOfLoopRom				; No Rom Calls, go to RamCall
		move.l	($C8).l,a2			; ROM CALLS table 
		move.w (a3)+,d5				; Number of imported RomCalls in d5.w
\LoopRom		moveq	#0,d3			; Clear
			move.w	(a3)+,d3		; Function number in d3
			lsl.l	#2,d3			; d3*4 -> d3
			move.l	0(a2,d3.l),d4		; Adress of the exported romcall in d4
			bsr.s	kernel::do_reloc	; Reloc the RomCall
			dbf	d5,\LoopRom		; Continue for all romcalls
\EndOfLoopRom:						; End of RomCall importation

	;3. RAM relocation table
	move.w	(a3)+,d5				; Number of RAM_CALLS > 0 (But why do Xavier & Rusty have specify this word ???????)
	beq.s	EndOfLoopRam				; No RAMCALL, skip
		lea	RAM_TABLE(pc),a2		; a2 -> RamCall Table 
		move.w (a3)+,d5				; Number of different RAM_CALLS !
LoopRAM:		moveq	#0,d3
			move.w	(a3)+,d3		; Read RAM_CALL number
			move.l	d3,d2			; Copy (because we work on RAM_CALL & EXTRA_RAM_CALL)
			lsl.w	#2,d2			; d2*4 <= Values == adress or longs words.
							; & Remove the word flag & the extra_ram flag
			move.l	0(a2,d2.w),d4		; RAMCALL value in d4

CalcFlag		btst.b	#CALC_FLAG,KHEADER_flags(a5)	; Check if program designed for calculator
			bne.s	\OkCalc			; Yes => skip it.
				tst.w	d2		; Check if RAMCALL 0
				bne.s	\OkCalc
					addq.l	#4,d4	; So set wrong calculator version
\OkCalc			
			btst	#14,d3			; Look for EXTRA_RAM_ADDRESS ?
			beq.s	DoRelocRam		; Yes => No ExtraRamCall
				add.w	KHEADER_extROff(a5),d2	; For ExtraRamTable, add to the function offset, the offset of the EXTRA_RAM_TABLE
				moveq	#0,d4			; And 
ExtraRamCalc			move.w	IS89_0_2(a5,d2.l),d4	; Read the value for 89 or 92 (The installation program will the constante IS89_0_2 to 0 on 89 and to 2 on 92+/V200).
DoRelocRam:		tst.w	d3
			blt.s	do_reloc_word
			bsr.s	kernel::do_reloc
DoRelocRamCont		dbra	d5,LoopRAM		; Continue for all the imported ramcalls
EndOfLoopRam						; End of RAM_CALL relocation

	; 4. Relocation table (the global variables)
	move.l	a5,d4					; Adress of the address to reloc in d4 (The beginning of the program).
	bsr.s	kernel::do_reloc			; Relocation of the variables

	; 5. Relocation of the BSS section
	move.w	KHEADER_impOff(a5),d0		; Offset of the BSS table in d0
	beq.s	\NoBSS				; if =0, there is no BSS section.
		lea	4(a5,d0.w),a3		; Address of the BSS reloc table in a3
		bsr	kernel::FindLibAddr	; Get lib descriptor
		move.l	LIBRARY.data(a0),d4	; Reloc address
		bsr.s	kernel::do_reloc	; Relocation of the BSS section.
\NoBSS:
	; 6. Patch for 89 Titanium
	ifd	TI89TI
	bsr	PatchTitanium
	endif
	movem.l	(a7)+,d0-d7/a0-a5
	rts

; Only RamCall uses word relocation, so it is called via a bra instead of bsr
;	a3 -> Offset Table
;	d4.l = Value to add (or to sub)
;	a5 -> Program reference
do_reloc_word:
	bsr.s	fix_d4
	moveq	#0,d0
\Loop:		move.w	(a3)+,d0		; Offset in d0
		beq.s	DoRelocRamCont		; No offset ? => End of reloc function
		add.w	d4,0(a5,d0.l)		; Reloc the address
		bra.s	\Loop			; Continue
			
; In:
;	a3 -> Offset Table
;	d4.l = Value to add 
;	a5 -> Program reference
;Out:
;	Program relocated
;	a3 -> Next section
; Destroy:
;	d0 / a3
kernel::do_reloc:
	bsr.s	fix_d4
	moveq	#0,d0
\RelocLoop:	move.w	(a3)+,d0			; Offset in d0
		beq.s	return2				; No offset ? => End of reloc function
		add.l	d4,0(a5,d0.l)			; Reloc the address
		bra.s	\RelocLoop			; Continue

fix_d4:	tst.b	d7					; Check if relocated mode
	beq.s	return2					; Yes => return
	neg.l	d4					; d4 = -d4
return2	rts	

; Clean all the relocated Kernel Programs (ie unreloc all kernel programs).
kernel::clean_up:
	GET_DATA_PTR					; Get Preos internal var ref
	tst.w	LibTableNum-Ref(a6)			; Check if there are some kernel programs
	beq.s	return2					; To remove
	moveq	#0,d6					; Start from library 0
	; Pass 1: Call the exit functions.
\Loop1:		GET_DATA_PTR				; Get Preos internal var ref
		cmp.w	LibTableNum-Ref(a6),d6		; Check for max library?
		beq.s	\EndOfLoop1			; End of loop?
		bsr	kernel::GetLibTable		; Get Relocated Library Table at index d6
		move.l	LIBRARY.code(a1),a0		; Get code section
		ifd	WANT_REENTRANT_UNRELOCATION
		move.w	#1,LIBRARY.refcnt(a1)		; Set one reference so that the library will
		endif					; be unrelocated
		moveq	#0,d0				;
		move.w	KHEADER_exit(a0),d0		; Get the _exit offset
		beq.s	\Next1				; No _exit function, skip it.
		cmpi.b	#$FF,KHEADER_reloc(a0)		; Test if we have already called this exit function?
		beq.s	\Next1				; Yes, so it has crashed. Do not call it again!
			st.b	KHEADER_reloc(a0)	; Protection against infinite call to exit point
			move.w	d6,-(a7)		; Push d6
			jsr	0(a0,d0.l)		; Call _exit function
			move.w	(a7)+,d6		; Pop d6
\Next1:		addq.w	#1,d6				; Next library
		bra.s	\Loop1				; Continue for all still relocated libraries
\EndOfLoop1:
	; Pass2: Unreloc all, ie unreloc main program.
	moveq	#0,d6					; Library index 0
	bsr.s	kernel::GetLibTable			; Get Relocated Library Table at index 0
	move.l	LIBRARY.code(a1),a5			; Get code section
	move.w	#1,LIBRARY.refcnt(a1)			; Set referencre counter to 1
	bra	kernel::unrelocation			; Unrelocated it
	


; Search in the relocated libraries for a program with code section == a5
; Returns NULL if not found.	
; In:
;	a5 -> Lib Addr
; Out:
;	a0 -> Lib descriptor or NULL
;	d0.w = Lib Index
; Destroy:
; 	d0-d2/a0-a1
kernel::FindLibAddr:
	ifd	PEDROM					; Check for internal library
		lea	PedroMLibraryEntry(Pc),a0
		cmp.l	#PedroMLibKernel,a5
		beq.s	\Done
	endif
	bsr.s	kernel::GetLibTable
	moveq	#0,d0
\Loop:		cmp.w	LibTableNum-Ref(a6),d0
		beq.s	\NotFound
		cmp.l	LIBRARY.org(a0),a5	; Check org section...
		beq.s	\Done
		cmp.l	LIBRARY.code(a0),a5	; Check code section...
		beq.s	\Done
		lea	LIBRARY.sizeof(a0),a0	; Next entry
		addq.w	#1,d0			; Next index
		bra.s	\Loop
\NotFound
	suba.l	a0,a0
\Done	rts

kernel::FreeLibTable:
	move.w	LibTableHd-Ref(a6),-(a7)	; Push handle
	beq.s	\NoFree
	ROM_THROW HeapFree			; Free Table
\NoFree	addq.l	#2,a7
	clr.w	LibTableHd-Ref(a6)		; Clear Handle Ref
	rts

; Realloc the table of the relocated libraries to the correct size.
; Could be 0, could no exist
kernel::ReallocLibTable:
	move.w	LibTableNum-Ref(a6),d0		; # of entries
	beq.s	kernel::FreeLibTable		; Free the Table if there is no more entry
	mulu.w	#LIBRARY.sizeof,d0		; x size of an entry
	move.l	d0,-(a7)			; Push the size (arg2 of HeapRealloc function)
	move.w	LibTableHd-Ref(a6),-(a7)	; Push handle
	ROM_THROW HeapRealloc			; Realloc table
	addq.l	#6,a7				; Fix stack ptr
	tst.w	d0				; Check if successfull? (Can't set UsedLibraryHd before)
	bne.s	\ok				; d0.w = 0 = Memory Error
		ER_throw 670			; Throw Memory error
\ok	move.w	d0,LibTableHd-Ref(a6)		; Save Handle (Useless except if the table wasn't defined before).

; Get the Library Table ptr
; In:
;	d6.w = Index in table
; Out:
;	a0 -> LibTable
;	a1 -> LibTable[d6]
; Destroy:
;	d0-d2/a0-a1
; WARNING in some case, it may return 0xFFFFFFFF (if not entries)
kernel::GetLibTable:
	move.w	LibTableHd-Ref(a6),-(a7)
	ROM_THROW HeapDeref
	addq.l	#2,a7
	move.w	d6,d0
	mulu.w	#LIBRARY.sizeof,d0
	lea	0(a0,d0.l),a1
	rts						

; Search in the relocated libraries for a library with name == a0
; Returns NULL if not found.	
; In:
;	a2 -> Lib Name (May be Odd)
; Out:
;	a0 -> Lib descriptor
; Destroy:
; 	d0-d2/a0-a1
kernel::FindLibName:
	move.w	d3,-(a7)
	pea	(a2)				; Push library name
	ifd	PEDROM				; Compare with 'pedrom' internal library
	pea	PedroMLibraryEntry(pc)
	ROM_THROW SymCmp
	move.l	(a7)+,a0
	tst.w	d0
	beq.s	\Ret
	endif
	bsr.s	kernel::GetLibTable
	move.w	LibTableNum-Ref(a6),d3		; Read number of entries in table.
	beq.s	\NotFound			; No entry => Not found.
\Loop:		pea	(a0)			; Push Entry Name
		ROM_THROW SymCmp		; Cmp Entries
		move.l	(a7)+,a0		; Reload entry
		tst.w	d0			; Same ?
		beq.s	\Ret
		lea	LIBRARY.sizeof(a0),a0
		subq.w	#1,d3			; Next entry
		bne.s	\Loop
\NotFound
	suba.l	a0,a0				; Error: Not found
\Ret	addq.l	#4,a7
	move.w	(a7)+,d3
	rts

; Find a library.
; Uncompress it if necessary and update the cache
; In:
;	a2 ->  Lib Name
;	d3.b = Min Library Version required
;	a6 -> Data Ptr
; Out:
;	a0 -> Lib (First line of code) or NULL.
kernel::FindLib:
	movem.l	d0-d7/a1-a5,-(a7)
	move.l	a7,a5
	
	moveq	#ER_LIB_NOT_FOUND,d7			; Normal error is "Not Found"

	; Find an already relocated library with given name.
	bsr.s	kernel::FindLibName
	move.l	a0,d0
	beq.s	\LibNoFoundInLibsTable
		; Check Lib version. Only V4 Kernel supported
		moveq	#ER_WRONG_LIB_VERSION,d7	; Error, if any, if wrong version
		move.l	LIBRARY.code(a0),a0
		cmp.b	KHEADER_version(a0),d3		; Check version number
		bls	\Quit
		bra.s	\LibNotFound
\LibNoFoundInLibsTable:

	; Find library in executable folder
	move.w	ExecFolderHd-Ref(a6),d0			; Folder of current executable
	bsr	kernel::Hd2Sym				; Get SYM of current folder
	move.l	a0,d0					; Check if failed
	beq.s	\skip					; should NEVER happens
	bsr	kernel::FindLibInFolder			; Search for the library in this folder
	move.l	a0,d0					; Check if success
	bne.s	\Quit					; found
\skip

	; Get current folder name
	lea	-10(a7),a7				; Stack frame
	pea	(a7)					; Push stack frame ptr
	ROM_THROW FolderGetCur				; Get current folder 
	move.l	(a7)+,a0				; Get folder name
	; Find library in current folder
	bsr.s	kernel::FindLibInFolder
	move.l	a0,d0
	bne.s	\Quit					; found
	
	; Find library in 'system' folder
	lea	system_str(pc),a0
	bsr.s	kernel::FindLibInFolder
	move.l	a0,d0
	bne.s	\Quit					; found

	; Find the library in the Pack Archive
	bsr	kernel::ExtractFile			; Search a compressed file with the given name.
	move.l	a0,a3					; Keep lib
	move.w	d0,(a7)					; Success ? Handle != 0?
	beq.s	\LibNotFound				; Error
		; Check it is a kernel prgm
		bsr	kernel::IsKernel		; Check if ok ?
		tst.b	d0
		bne.s	\Found				; Ok!
			; Not a kernel prgm: Free handle and quit with 'NotFound'
			ROM_THROW HeapFree
			bra.s	\LibNotFound
\Found		ROM_THROW HeapDeref			; Deref it
		addq.l	#2,a0				; Skip size
		st.b	LibCacheFlags-Ref(a6)		; Set copy
		; Read Only Library may be used directlty without creating RAM copies!
		btst.b	#3,KHEADER_flags(a0)		; Test the Read Only flag.
		beq.s	\QuitCopy			; If ro is no set, quit
		move.l	a3,d0				; See if org ptr is set
		beq.s	\QuitCopy
		cmp.l	#$200000,a3			; Only for ROM ptr (May move due to GC ?).
		bls.s	\QuitCopy
		ROM_THROW HeapFree			; Free copy
		lea	2(a3),a0			; Set Ptr to org 'uncompressed' file.
		bra.s	\Quit

	; Library is not found!
\LibNotFound
	move.w	d7,d0					; Register error d7
	bsr	kernel::RegisterError
	suba.l	a0,a0

	; Update the cache / Purge the cache
\Quit:
	clr.b	LibCacheFlags-Ref(a6)			; No special flags
\QuitCopy:
	move.l	a0,LibCacheAddr-Ref(a6)			; Save cache addr
	lea	LibCacheName-Ref(a6),a1
	moveq	#8-1,d0					; 8x
\CopyName2:	move.b	(a2)+,(a1)+			; Copy Name
		dbf	d0,\CopyName2
	move.l	a5,a7
	movem.l	(a7)+,d0-d7/a1-a5
	rts

; Find in a given folder for library 'libname' with minor version d3.
; In:
;	a0 -> Folder name (ANSI C str)
;	a2 -> Lib name (ANSI C str)
; Out:
;	a0 -> Lib or NULL
;	May change d7 to reflect the new nature of the error.
; Destroy:
;	d0-d2/a0-a1
kernel::FindLibInFolder:
	; Update folder name to be in Ti format
	lea	-20(a7),a7				; Stack frame
	pea	(a7)					; Push stack frame ptr
	pea	(a0)					; Push org lib name
	ROM_THROW StrToTokN				; Convert ANSI c to SYMSTR Ti 

	; Find library in 'system' folder
	move.w	#1,-(a7)				; One folder (FIXME: Don't skip twin ?)
	pea	(a0)					; Push given folder
	ROM_THROW SymFindFirst				; Get first Sym Ptr
\Loop:		; Check if it is the good file
		move.w	SYM_ENTRY.hVal(a0),(a7)		; Push Handle of file
		pea	(a0)				; Push current sym
		pea	(a2)				; Push searched file
		ROM_THROW SymCmp			; Compare the 2 files.
		addq.l	#8,a7				; Fix the stack
		tst.w	d0				; Is it the good file ?
		bne.s	\NextFile			; No, next file, please.
		; Check if it a Kernel Asm Program, check for the name, and the library version
		bsr.s	kernel::IsKernel		; First Check if it is a Kernel Program ?
		tst.b	d0				; with the good version number, too !
		beq.s	\Error				; No kernel Program => No lib file.
			ROM_THROW HeapDeref		; Deref the handle.
			addq.l	#2,a0			; Skip size
			bra.s	\EndFolder
\NextFile	ROM_THROW SymFindNext			; Next File
		move.l	a0,d0				; Check end of VAT ?
		bne.s	\Loop				; No => continue
\Error	suba.l	a0,a0
\EndFolder
	lea	20+8+6(a7),a7
	rts

; Check if it is a Kernel Program with a good version.
; In:
;	(a7).w -> Handle
;	d3.b = Min Library Version required
; Out:
;	d0 = 0 if it isn't a kernel program.
;	d7 = New error code if there may be an error
kernel::IsKernel:
	movem.l	d1-d2/a0-a1,-(a7)
	moveq	#ER_INVALID_LIB,d7			; If error, it is an "invalid library"
	move.w	(4+4*4)(a7),-(a7)			; Pushs handle on the stack
	ROM_THROW HeapDeref				; Deref the handle and get its address in a0
	clr.w	d0					; Default: Fail
	tst.w	(a7)+					; In case, there is no handle for the var (Local vars not init for example).
	beq.s	IsKernelFail				; So it fails.
IsKernelEntry	moveq	#0,d1				; Clear d1.l
		move.w	(a0)+,d1			; To read file size (File size is unsigned short).
		cmp.b	#$F3,-1(a0,d1.l)		; Check ASM TAG ?
		bne.s	IsKernelFail			; No, it isn't an ASM file.
		move.l	KHEADER_signa(a0),d1		; Read Magic Signature
		lsr.l	#8,d1				; 
		cmpi.l	#'68k',d1			; It must me be '68k?' where ? is a joker.
		bne.s	IsKernelFail			; 
		moveq	#ER_WRONG_LIB_VERSION,d7	; If errror, it is a wrong version.
		cmp.b	KHEADER_version(a0),d3		; Check version number
		sls.b	d0				; Set d0 according to the result of the test
IsKernelFail:
	movem.l	(a7)+,d1-d2/a0-a1
	rts

; Find a compressed file in one Pack Archive
; In:
;	a2 -> File Name
;	d0.w = Pack Archive Handle
; Out:
;	d0 = Handle
kernel::ExtractFileFromPack:
	movem.l	d3-d4/a3-a5,-(a7)
	move.l	a7,a4					; Save the stack Ptr
	clr.w	-(a7)					; Stop
	move.w	d0,-(a7)				; Push Handle
	bra.s	ExtractFileFromPack

; Find a compressed file throught all the Pack Archives
; In:
;	a2 -> File Name
; Out:
;	d0 = Handle
kernel::ExtractFile:
	movem.l	d3-d4/a3-a5,-(a7)
	move.l	a7,a4					; Save the stack Ptr
	; Search packages in all folders.
	move.w	#2,-(a7)				; Recurse (2)
	clr.l	-(a7)					;
	ROM_THROW SymFindFirst				; Start searching in all VAT (FIXME: Search only in Exec/Current/System folders?)
\loop		move.w	SYM_ENTRY.hVal(a0),-(a7)	; Push Handle of file/folder (May be HNull)
		beq.s	\popit				; Check if HNull
			ROM_THROW HeapDeref		; Deref it (Must be EVEN)
			cmp.l	#'68cA',2+2(a0)		; Check signature of KV5
			beq.s	\GoodKArch		; Good signature => Don't pop the handle
\popit		addq.l	#2,a7				; Pop the handle
\GoodKArch	ROM_THROW SymFindNext			; Next SYM_ENTRY
		move.l	a0,d0				; Check if NULL?
		bne.s	\loop				; No so continue the loop

ExtractFileFromPack:
\loop2	move.w	(a7),d0					; Check if done (HNull pushed)
	beq	\done					; Yes => Quit this loop
		ROM_THROW HLock				; Deref and lock this handle
		lea	2+2(a0),a5			; Get internal ptr
		moveq	#-1,d3				; File index (-1: first file is the compressed library to used!)
		clr.w	d4				; Clear d4.w to
		move.b	14(a5),d4			; Read Number of file
		lea	(17)(a5),a3			; First Filename (Compressed library)
\cmp_loop		cmpi.b	#'!',(a3)		; Check Static Archive flag
			bne.s	\CmpFile		; No Uncompressed archive
				addq.l	#3,a3		; Skip '!' + Offset
\CmpFile		pea	(a3)			; Push archive name
			pea	(a2)			; Push searched name
			ROM_THROW SymCmp		; Compare
			addq.l	#8,a7			; Fix stack ptr
			tst.w	d0			; Check if successfull
			beq.s	\found_name		; Yes => We found it!
\next				tst.b	(a3)+		; Next name
				bne.s	\next		; ANSI strings are null padded
			addq.w	#1,d3			; Next Index in PackArchive
			dbf	d4,\cmp_loop		; Next File
		ROM_THROW HeapUnlock			; Not found, Unlock the archive
		addq.l	#2,a7				; And skip it
		bra.s	\loop2				; Next handle

\found_name						; Found it!
	move.w	d3,d0					; Check if really success?
	blt.s	\next					; If -1, it was the compressed library: skip it and go throught the next files
	cmpi.b	#'!',-3(a3)				; Check Static Archive flag (FIXME: No true false detection?)
	beq.s	\NotCompressed				; Static archive => Handle uncompressed archive
		bsr.s	kernel::ExtractFromPack		; Extract Archive index d3
		move.w	d0,d4				; Move return value to d4
		suba.l	a3,a3				; No Org ptr (NULL)
		bra.s	\DoneUnlock			; End and unlock the PackArchive
\NotCompressed						; File not compressed
		moveq	#0,d4				; Read offset to uncompressed file
		move.b	-(a3),d4			; High 8bits Part (The offset is in Big Endian)
		lsl.w	#8,d4				; Remember it may be ODD.
		or.b	-(a3),d4			; Low 8bits Part
		add.l	a5,d4				; Get Ptr to internal file
		move.l	d4,a3				; A3 -> Sub-File.
		moveq	#2,d3				; Size + 2 to get the real size of the file
		add.w	(a3),d3				; d3 = File size
		move.l	d3,-(a7)			; Push File Size
		ROM_THROW HeapAllocHigh			; And alloc a new Handle for the copy (Lock handle).
		move.w	d0,(a7)				; Push Handle
		beq.s	\done				; Error Memory => Return H_NULL (Note: Archive may be kept locked...)
		ROM_THROW HeapDeref			; and rederef it
		move.l	a3,a1				; Recopy the file in the created Handle
\CodeLoop:		move.b	(a1)+,(a0)+
			subq.w	#1,d3			; Better than subq+dbf (6 bytes)
			bne.s	\CodeLoop		; subq + bne = 4 bytes (but slower)
		move.w	(a7)+,d4			; Reload HANDLE
		addq.l	#2,a7				; Fix stack
\DoneUnlock:
	ROM_THROW HeapUnlock				; Unlock the archive before quitting.
	move.w	d4,d0					; Restore handle
	move.l	a3,a0					; Set direct access in case of RO file
\done	move.l	a4,a7					; Restore the stack Ptr
	movem.l	(a7)+,d3-d4/a3-a5
	rts			

; Extract the file d0 from the pack a5 calling the right library to extract it.
; In:
;	a5 -> KArchive
;	d0 = # of file
; Out:
;	d0.w = handle
; Destroy:
;	d0-d2/a0-a1
kernel::ExtractFromPack:
	; Find the address of compressed data
	clr.w	d1
	lea	14(a5),a1				; Get ptr to data (Skip ASM header)
	move.b	(a1)+,d1				; Read Number of file
	lea	(17-15)(a1),a0				; Skip Version/Function
\loop:		cmpi.b	#'!',(a0)			; Check Static Archive flag
		bne.s	\loop2				; No compressed archive
			addq.l	#3,a0			; Skip '!' + Offset
\loop2:		tst.b	(a0)+				; Skip name
		bne.s	\loop2		
		dbf	d1,\loop			; Next name
	move.l	a0,d1					; The data are at the next EVEN address
	andi.w	#1,d1					; So EVEN the current 
	adda.w	d1,a0					; address

;	Call function x of lib 'bidulelib' with z version (kernel::LibsExec).
;		In:	d0 = # of file
;			a0 -> Package
;		Out:	Handle = d0 or H_NULL
	move.b	(a1)+,-(a7)				; Push Version
	move.b	(a1)+,d1				; d1.w = 0 or 1, so it is word clean.
	move.w	d1,-(a7)				; Push Function
	pea	(a1)					; Lib Name
	bsr.s	kernel::LibsExec			; Execute UnCompressing Library
	tst.l	(a7)					; Test error of LibsExec
	addq.l	#8,a7					; Does not affect the Z flag
	bne.s	\return
		clr.w	d0				; An Error occured when calling the uncompressing library
\return	rts

; It calls the function without modifying the registers, and it pops its argument 
; during the call (LIB_DESCRIPTOR, function, and version).
;	kernel::LibsExec(char name[], WORD function, BYTE version, ...)
kernel::LibsExec:
	movem.l	d0-d7/a0-a6,-(a7)			; 
	GET_DATA_PTR					; Get Preos Data Ptr
	lea	4*16(a7),a4				; a4 --> Argument pointer
	move.l	(a4),a2					; Get Library name
	move.b	(4+2)(a4),d3				; Minimum Library version
	clr.l	(a4)					; Set Error
	pea	(12).w					; Create a list (Next, RealReturnAddr, LibPtr)
	ROM_THROW HeapAllocPtr				; Alloc Node
	move.l	a0,(a7)					; Ok ?
	beq.s	\AllocError
	move.l	a0,a3					; Ptr to node
	move.l	(LibsExecList-Ref)(a6),(a3)+		; Save Next node in List 
	move.l	-4(a4),(a3)+				; Save Real Return Address
	move.l	a3,(LibsExecList-Ref)(a6)		; Update list head
	bsr	kernel::FindLib				; Find the library
	move.l	a0,(a3)					; Save the lib & Check for success
	beq.s	\FreeNode
	move.l	a0,a5					; Relocation of the library.
	bsr	kernel::relocation			; If it failed the library is free!
	tst.w	d0					; 
	bne.s	\FreeNode
	move.l	a5,(a3)					; Update Library Code section
	move.l	a5,a0
	move.w	(4*18)(a7),d0				; Function #
	bsr.s	kernel::LibsPtr				; Get the ptr to the required func
	move.l	a0,d0
	beq.s	\UnrelocLib
	move.l	a0,(a4)+				; New return address
	lea	\next(pc),a0
	move.l	a0,(a4)					; After it return here
	addq.l	#4,a7					; Pop Stack Frame
	movem.l	(a7)+,d0-d7/a0-a6
	addq.l	#4,a7					; Pop First Return Address
	rts						; Jump to the function and return \next

\next	subq.l	#8,a7					; Fix stack ptr.
	st.b	(a7)					; Set success
	movem.l	d0-d7/a0-a7,-(a7)			; Push a7 to increase Stack Frame
	GET_DATA_PTR					; Get a6 
	subq.l	#4,a7					; Create Stack Frame
\UnrelocLib:
	move.l	(LibsExecList-Ref)(a6),a3
	move.l	(a3),a5					; Read Lib Ptr
	bsr	kernel::unrelocation			; Unreloc & delete. 
\FreeNode:
	move.l	(LibsExecList-Ref)(a6),a3		; Kernel::relocation may destroy all registers if an error occured ! (execpt a6 & a5)
	move.l	-(a3),(4*16)(a7)			; Set Return Address
	move.l	-(a3),(LibsExecList-Ref)(a6)		; Set new head
	move.l	a3,(a7)
	ROM_THROW HeapFreePtr				; Free Node
\AllocError
	addq.l	#4,a7					; Fix stack
\end:	movem.l	(a7)+,d0-d7/a0-a6
	rts

;	kernel::LibsPtr(LIBS Descriptor a0, WORD function d0)
kernel::LibsPtr:
	movem.l	d0-d2,-(a7)

	move.l	KHEADER_signa(a0),d1			; Signature : 68kP, 68kL or 68kA
	lsr.l	#8,d1					; Get '68k?'
	cmp.l	#'68k',d1				; Check ?
	bne.s	\error

	move.l	a0,d1					; Save Library Pointer
	move.w	KHEADER_expOff(a0),d2			; Check offset to export table
	beq.s	\error
	adda.w	d2,a0					; Export table
	cmp.w	(a0)+,d0				; Out of range ?
	bcc.s	\error
	
	ext.l	d0					; Extension but d0.w <32K => d0.l = d0.w
	add.w	d0,d0					; x2
	move.w	0(a0,d0.w),d0				; Get offset to library
	add.l	d1,d0					; Org + Offset = address
	move.l	d0,a0					; Returns a0 = Function Ptr

\end	movem.l	(a7)+,d0-d2
	rts
\error	suba.l	a0,a0					; An error occured, returns NULL
	bra.s	\end

;	kernel::LibsCall(LIBS Descriptor, WORD function, ...)
kernel::LibsCall:
	movem.l	d0-d7/a0-a6,-(a7)			; 
	GET_DATA_PTR					; Get Preos Data Ptr
	moveq	#0,d7					; Set Error
	pea	(8).w					; Create a list node (Next, RealReturnAddr)
	ROM_THROW HeapAllocPtr				; Alloc Node
	move.l	a0,(a7)+				; Ok?
	beq.s	\AllocError				; Can't alloc a new node: error
	lea	4*15(a7),a1				; Get sub stack ptr
	move.l	(LibsExecList-Ref)(a6),(a0)+		; Save Next node in the created node 
	move.l	(a1)+,(a0)+				; Save Real Return Address
	move.l	a0,(LibsExecList-Ref)(a6)		; Update list head
	move.l	(a1)+,a0				; Get Library Descriptor ptr
	move.w	(a1),d0					; Get Function #
	bsr.s	kernel::LibsPtr				; Get the ptr to the required func
	move.l	a0,d0
	beq.s	\FreeNode
	lea	\next(pc),a2
	subq.l	#2,a1					; Due to misaligned
	move.l	a2,(a1)					; After it return here
	move.l	a0,-(a1)				; New return address
	movem.l	(a7)+,d0-d7/a0-a6			; Restore registers
	addq.l	#2,a7					; Pop Half Return Address
	rts						; Jump to the function and return to \next

\next	subq.l	#6,a7					; Fix stack
	movem.l	d0-d7/a0-a7,-(a7)			; Pop a7 to increase Stack Frame
	GET_DATA_PTR					; Get Preos Data Ptr
\FreeNode:
	move.l	(LibsExecList-Ref)(a6),a0
	move.l	-(a0),(4*15)(a7)			; Set Return Address
	move.l	-(a0),(LibsExecList-Ref)(a6)		; Set new head
	pea	(a0)					; Push Node
	ROM_THROW HeapFreePtr				; Free Node
	moveq	#1,d7					; Set no error
	addq.l	#4,a7					; Fix stack
\AllocError
	move.l	d7,(4*16)(a7)				; Set error flag
\end:	movem.l	(a7)+,d0-d7/a0-a6
	rts

;	HANDLE:d0 kernel::Ptr2Hd(void *a0)
kernel::Ptr2Hd:	;(In: a0 Out: d0)
	movem.l	d1-d3/a1-a3,-(a7)
	move.l	a0,d3
	; Get the address between 0 and 256 Kb if it was in RAM
	lea	$200000,a3				; Limit between FlashRom & Ram (on Titanium, it is GHOST_SPACE, but no one uses it, donc assume it is ROM)
	cmp.l	a3,d3					; Check if ptr is in the archives?
	bhi.s	\FlashRomAddr				; Yes, so don't unghost it
		andi.l	#$0003FFFF,d3			; Avoid Ghost Space FIXME: To update to use RAMCALL!
\FlashRomAddr:	
	; Get Heap Ptr
	move.l	RAM_TABLE+$11*4(Pc),a1			; Get Heap Ptr
	move.l	(a1),a1					; Fixme: Improve this?
	addq.l	#4,a1					; Skip the first entry (HNull entry)
	; Start scanning
	move.w	#MAX_HANDLES-2,d2			; Well, we assume there are 2000 entries even if it could be wrong (FIXME: Test it?).
	moveq	#1,d0					; First Handle = 1
\loop		move.l	(a1)+,a2			; Read address of handle
		move.l	a2,d1				; NULL? so skip this 
		beq.s	\next				;
		cmp.l	a2,d3				; Check if Ptr(HANDLE) <= SearchedAddress
		blt.s	\next				; No so next handle
		ifnd	PEDROM				; Get Size of Handle for AMS if it is in RAM
			moveq	#0,d1			; Archived files still supports this format
			move.w	-(a2),d1		; Read Handle sise/2
			add.w	d1,d1			; x2
		endif
		ifd	PEDROM				; Get Size of Handle for Pedrom if it is in RAM
			move.l	-6(a2),d1
			bne.s	\NoHeapCorrupted
				jmp	HeapCorrupted
\NoHeapCorrupted:
			subq.l	#6,d1
			cmp.l	a3,a2			; Is it an archived file ?
			blt.s	\RamFile
				moveq	#0,d1
				move.w	(a2),d1
				addq.l	#2,d1		; d1 = Size of the Handle if it is archived
		endif
\RamFile	add.l	d1,a2				; a2 -> End of file
		cmp.l	a2,d3				; Is SearchedAddress < Ptr(HANDLE)+Size(HANDLE) ?
		blt.s	\end				; Yes? Found it => Quit
\next		addq.w	#1,d0				; Next Handle
		dbf	d2,\loop	
		clr.w	d0				; Handle not found
\end:	movem.l	(a7)+,d1-d3/a1-a3	
	rts

; SYM_ENTRY:a0 kernel::Hd2Sym(HANDLE d0)
kernel::Hd2Sym:
	movem.l	d0-d3/a1-a2,-(a7)
	move.w	d0,d3					; Move seached HANDLE in d3
	move.w	#2,-(a7)				; Search in all the VAT the handle d3.w
	clr.l	-(a7)					;
	ROM_THROW SymFindFirst				; First SYM
	addq.l	#6,a7					;
\loop		cmp.w	SYM_ENTRY.hVal(a0),d3		; Check if it is the right HANDLE?
		beq.s	\sym_found			; Yes? Found it => End
		ROM_THROW SymFindNext			; No?  Next SYM
		move.l	a0,d0				; Check if end of VAT?
		bne.s	\loop				; No so continue the loop
	suba.l	a0,a0					; Can not find the handle in the VAT.
\sym_found
	movem.l	(a7)+,d0-d3/a1-a2
	rts
	
;	LIB_DESCRIPTOR:a0 kernel::LibsBegin(char name[] a0, VERSION d1.b)
kernel::LibsBegin:
	movem.l	d0-d7/a1-a6,-(a7)
	GET_DATA_PTR					; Get a6 ptr
	move.l	a0,a2					; Move name to a2
	move.b	d1,d3					; Move version to d3
	bsr	kernel::FindLib				; Find this library
	move.l	a0,d0					; Success ?
	beq.s	\end					; No, exit
		move.l	a0,a5				; Reloc the library
		bsr	kernel::relocation		; ...
		move.l	a5,a0				; New code section
		tst.w	d0				; Check if relocation was susccessfull?
		beq.s	\end
			suba.l	a0,a0			; Error (We don't have to free the lib copy since reloc calls unreloc, which frees the temp copies).
\end	movem.l	(a7)+,d0-d7/a1-a6
	rts
	
;	kernel::LibsEnd(LIB_DESCRIPTOR a0)
kernel::LibsEnd:
	movem.l	d0-d7/a0-a6,-(a7)
	move.l	a0,a5
	bsr	kernel::unrelocation			; Unrelocs and frees copies.
	movem.l	(a7)+,d0-d7/a0-a6
	rts

; The calc go idle.
; In:
;	SR = 
; Destroy:
;	d0-d2/a0-a1
kernel::idle:	
	trap	#12					; Go to Supervisor mode to get SR
	move.w	d0,d2					; Get old SR and save it
	move.w	SR,d0					; For calculus
	andi.w	#$0700,d0				; Get Interrupt Mask
	lsr.w	#8,d0					; Get int 
	ifnd	PEDROM_92P				; Can be call from Flash
		move.b	IntMaskTab(Pc,d0.w),$600005	; Stop procs until an int is trigered
	endif
	ifd	PEDROM_92P
		move.b	IntMaskTab(Pc,d0.w),d0		; We are in the Flash Rom
		jsr	IdleRam				; Must be done in RAM (Since we stop FlashRom too!)
	endif
	move.w	d2,SR					; Reset SR to its initial value.
	rts
IntMaskTab	dc.b	%11111,%11110,%11100,%11000,%10000,%00000,%00000,%00000


; Execute an ASM file.
; In:
;	d0.w = Handle of the file.
; Destroy:
;	d0-d2/a0-a1
kernel::exec:
	movem.l	d3-d7/a2-a6,-(a7)

        GET_DATA_PTR		                      	; Get a6 ptr

	clr.l	-(a7)
	clr.w	-(a7)					; Stack Frame
	move.w	d0,-(a7)				; Push HANDLE
	beq	RunFail					; No handle, just quit	
	ROM_THROW	HeapGetLock			; Get Lock of Handle
	move.w	d0,d7					; Save it in d7
	ROM_THROW	HLock				; Deref & lock files

	lea	2(a0),a5				; Save Program Ref in a5
	moveq	#0,d3					
	move.w	(a0),d3					; Read file size in d3.l (FIXME: Create a function?)

	; Check for the type of the file and tries to excute it.
	cmpi.b	#$F3,1(a0,d3.l)				; Is it an ASM ?
	bne.s	\NoAsm					; no -> Next type
		cmpi.l	#'68kP',KHEADER_signa+2(a0)	; Check for Kernel V4
		beq.s	RunKernelV4
		cmpi.l	#'68cA',KHEADER_signa(a0)	; Check for Kernel V5
		beq	RunKernelV5
		bra	RunNoStub			; So, NoStub Program
\NoAsm:

	; ****** FAIL TO EXECUTE THE HANDLE ******
RunFail:
	moveq	#-128,d4
	moveq	#ER_INVALID_PROGRAM,d0
	bsr	kernel::RegisterError
	bra	RunEnd

	; ****** Execute a kernel program V4 ******
RunKernelV4:
	move.w	(a7),d0					; Get HANDLE program
	bsr	kernel::Hd2Sym				; Get SYM of program
	bsr	kernel::Ptr2Hd				; Get HANDLE of folder
	move.w	ExecFolderHd-Ref(a6),-(a7)		; Save old EXEC Folder
	move.w	d0,ExecFolderHd-Ref(a6)			; Set new Exec Folder
	bsr	kernel::relocation			; First relocate the program
	tst.w	d0					;
	beq.s	\OkRun					; An error occurs.
		move.w	(a7)+,ExecFolderHd-Ref(a6)	; Restore EXEC folder
		bra.s	RunFail
\OkRun
	move.l	ExitStackPtr-Ref(a6),-(a7)		; Push Old Exit Stack Ptr
	lea	-4*PROGRAM_MAX_ATEXIT_FUNC(a7),a7	; Push atexit ptr tab
	pea	(a5)					; Push 'a5' program ref
	clr.w	-(a7)					; No atexit func
	move.l	a7,ExitStackPtr-Ref(a6)			; Save New Exit Stack Ptr
	ifd	PEDROM
		pea	ARGV				; Push ARGV
		move.w	ARGC,-(a7)			; Push argc
	endif
	ifnd	PEDROM
		clr.l	-(a7)				; Push ARGV (NULL)
		clr.w	-(a7)				; Push argc (0 arg)
	endif
	moveq	#0,d0					; 
	move.w	KHEADER_main(a5),d0			; Read offset to _main entry point.
	beq.s	kernel::exit
	ifd	PEDROM
		trap	#6				;  Potential BP
	endif
	jsr	0(a5,d0.l)				; Run it
kernel::exit:
        GET_DATA_PTR		                      	; Get a6 ptr
	move.l	ExitStackPtr-Ref(a6),a7			; Get stack ptr
	move.l	d0,d4					; Save return value
	ifd	PEDROM
		bsr	Short2Float			; Save Return value as a float
	endif
	move.w	(a7)+,d3				; Number of atexit func
	move.l	(a7)+,a5				; Pop 'a5' program ref (Doesnt' affect Z flag)
	beq.s	\Done					; No atexit function
		move.l	a7,a3				; atexit tab ptr
\Loop		move.l	(a3)+,a0			; Read atexit func ptr
		jsr	(a0)				; Call atexit func
		subq.w	#1,d3				; One more ?
		bne.s	\Loop				; Yes
\Done	lea	4*PROGRAM_MAX_ATEXIT_FUNC(a7),a7	; Pop frame
	move.l	(a7)+,ExitStackPtr-Ref(a6)		; 
	ifd	PEDROM
		btst.b	#2,KHEADER_flags(a5)		 ;  Check if we have to restore the screen
		bne.s	\NoClearScreen
			jsr clrscr
\NoClearScreen:		
	endif
	bsr	kernel::unrelocation			; Unrelocation (a5)
	move.w	(a7)+,ExecFolderHd-Ref(a6)		; Restore old Exec Folder
	bra	RunEnd
	
	; ****** Execute a kernel program V5 ******
RunKernelV5:
	addq.l	#2,a5					; Skip 
	moveq	#0,d0					; File 0 of archive
	bsr	kernel::ExtractFromPack			; Extract it
	move.w	d0,(a7)					; Push HANDLE
	beq	RunFail					; Check if not fail	
	lea	(17-2)(a5),a0				; First Filename (Library name)
\SkipLibName:	tst.b	(a0)+				; Skip the library name
		bne.s	\SkipLibName	
	lea	LibCacheName-Ref(a6),a1
	moveq	#8-1,d0					; 8x
\CopyName2:	move.b	(a0)+,(a1)+			; Copy Name
		dbf	d0,\CopyName2
	clr.b	LibCacheFlags-Ref(a6)			; Library Org Flags
	ROM_THROW HeapDeref				; Deref the file
	addq.l	#2,a0
	move.l	a0,LibCacheAddr-Ref(a6)			; Update cache addr
	move.w	(a7),d0					; Reload handle
	bsr	kernel::exec				; Exec the file.
	move.l	d0,d4					; Save return value
	ROM_THROW HeapFree				; Free the handle
	bra	RunEnd

	; ****** Execute a _nostub program ******
RunNoStub
	; Check if it is in-use...
	cmp.l	#$200000,a0				; Test if program is archived ?
	bcc.s	\NotLocked
		tst.w	d7				; Check if program was locked?
		bne	RunFail				; Already locked: do not run it!
\NotLocked
	; Try to find it in the VAT
	move.w	(a7),d0					; Get org handle
	bsr	kernel::Hd2Sym				; Find it in VAT
	move.l	a0,d2					; Push SYM_ENTRY *
	beq.s	\SymNotFound
		; Program Found! Execute as AMS does, otherwise it may fails ("tictex").
		bsr	kernel::Ptr2Hd
		move.l	d2,2(a7)			; Push SYM_ENTRY *
		move.w	d0,(a7)				; Push FOLDER Handle
		ROM_THROW MakeHsym			; Create HSym
		move.l	d0,4(a7)			; Push HSym
		clr.l	(a7)				; No SYM_STR
		ROM_THROW EM_twinSymFromExtMem		; Find the file and create a copy if it is archived.
		move.l	d0,(a7)				; Push the HSym and test if == NULL
		beq	RunFail
		move.l	d0,4(a7)			; Save HSym
		ROM_THROW DerefSym			; Get Sym Entry of the symbol
		move.w	SYM_ENTRY.hVal(a0),(a7) 	; Push handle
		bset.b	#0,SYM_ENTRY.flags(a0)		; Set InUse
		bra.s	\ExecNostub
\SymNotFound
	; Program not found in the VAT. Check if it is archived
	cmp.l	#$200000,a5
	blt.s	\ExecNostub
		; Unarchive the prog
		addq.l	#3,d3				; Add size of 'size' and 'type' to the handle size (FIXME: Sure?)
		move.l	d3,(a7)				; Push size to alloc
		ROM_THROW HeapAlloc			; Alloc in RAM
    		move.w	d0,(a7)				; Push the handle of the temp block for future use
		beq	RunFail
		move.w	d0,2(a7)			; Save temp HANDLE (bis)
		ROM_THROW HeapDeref			; Deref file
		move.w	-2(a5),(a0)+			; Copy org size
		subq.w	#3,d3
\Copy			move.b	(a5)+,(a0)+		; Copy it to RAM
			dbf	d3,\Copy
\ExecNostub:						; HERE: (a7)=Handle to execute 2(a7)=Temp Handle 4(a7)=HSym
	ROM_THROW HLock					; Lock the handle and get its address
	HW2TSR_PATCH a0,d0				; Hw2Tsr Patch
	moveq	#0,d0	
	move.w	(a0)+,d0				; Read size of the file.
	pea	-1(a0,d0.l)				; The end of the file
	pea	(a0)					; The start of the file
	ROM_THROW EX_patch				; Does the AMS relocation
	move.l	(a7)+,a0				; Read the start of the file	
	addq.l	#4,a7					; Pop the end of the file
	ifd	PEDROM
		trap	#6				; Potential BP
	endif
	jsr	(a0)					; Execute the program
	nop						; If a man call a nostub program
	nop						; with a Return Value (To do: Fix RetVal!)
	move.l	d0,d4					; Save return value
	ROM_THROW HeapUnlock				; UnLock the allocated handle

	move.l	4(a7),(a7)				; Push HSym
	beq.s	\NoSym
		ROM_THROW	DerefSym		; Rederef if (It may be wrong)
		move.l	a0,d0				; But at least it will be a file ptr
		beq.s	RunEnd				; not an unkown ptr.
		bclr.b	#0,SYM_ENTRY.flags(a0)		; Unset InUse
		btst.b	#2,SYM_ENTRY.flags(a0)		; check if it is a twin
		beq.s	RunEnd				; Delete properly a twin is a nightmare!
			ifnd	PEDROM			; Under PedroM, it is faster and cleaner.
			move.l	(a7),d0			; Get HSYM of file.
			lea	-18(a7),a7		; Buffer
			clr.w	-(a7)			; Beginning of buffer if filled with 0
			pea	2(a7)			; Push Buffer address
			move.l	d0,-(a7)		; Push HSym
			ROM_THROW HSYMtoName 		; Create the name
			lea	10(a7),a0		; -> ANSI C string
			\LoopS:	tst.b	(a0)+		; Convert to SYM_STR
				bne.s	\LoopS
			pea	-1(a0)			; Push SYM_STR
			ROM_THROW SymFindPtr
			lea	(4+4+4+2+18)(a7),a7
			endif
			move.l	a0,(a7)
			ROM_THROW SymDelTwin		; Delete Twin Symbol
			bra.s	RunEnd
\NoSym	move.w	2(a7),(a7)				; Push Temp HANDLE
	beq.s	RunEnd					; No temp handle
		ROM_THROW HeapFree			; Free copy handle
RunEnd	addq.w	#8,a7
	ROM_THROW GKeyFlush				; Clear Keys (It crashes sometimes !)
	ROM_THROW OSClearBreak				; Clear Break
	move.l	d4,d0
	movem.l	(a7)+,d3-d7/a2-a6 
	rts
	
	
;	kernel::HdKeep(HANDLE d0)
kernel::HdKeep:
	ifnd	PEDROM					; Pedrom doesn't erase any handle, execpt if the user asks for it.
	movem.l	a0/d0-d1,-(a7)
HdTable		move.w	#0,a0				; Read save table
	moveq	#7,d1					; Convert HANDLE number
	eor.w	d1,d0					; to an offset and a bit
	and.w	d0,d1					; -> Bit = (7 - 7 & Hd)
	lsr.w	#3,d0					; -> Offset
	bclr.b	d1,0(a0,d0.w)				; Clear it.
	movem.l	(a7)+,a0/d0-d1
	endif
	rts

; int kernel::atexit(FUNC a0)
kernel::atexit:
	ifd	PEDROM
		move.l	(ExitStackPtr).w,a1
	endif
	ifnd	PEDROM
		move.l	ExitStackPtr(pc),a1
	endif
	moveq	#1,d0					; Fail
	move.w	(a1),d2					; Number of registered functions
	cmpi.w	#PROGRAM_MAX_ATEXIT_FUNC,d2		; Check overflow
	bge.s	\Fail
		lsl.w	#2,d2				; xsizeof(ptr)
		move.l	a0,2+4(a1,d2.w)			; Save function
		addq.w	#1,(a1)				; One more
		clr.w	d0				; Success
\Fail	rts

;	kernel::RegisterVector(VECTOR d0.w, PTR a0)
kernel::RegisterVector
	ifnd	PEDROM					; Pedrom doesn't erase any handle, execpt if the user asks for it.
	move.w	HdTable+2(pc),a1			; Read save table
	neg.w	d0
	move.l	a0,-8(a1,d0.w)
	endif
	rts

;	Fix Ghost Space for Int1
;	Fix Ghost Space for Int5
;	Fix HW2TSR jump
;	Fix font_small	(font_medium+$800)
;	Fix font_large	(font_medium+$E00)
	ifd TI89TI
PatchTitanium:
	ifnd	PEDROM
	move.b	Calc-Ref(a6),d0				; Check if running on Titanium
	bge.s	\NoTitanium
	endif
	btst.b	#6,KHEADER_flags(a5)			; Check if program designed for Titanium
	bne.s	\NoTitanium
	tst.b	d7					; Check Reloc mode
	bne.s	\NoTitanium
		moveq	#$04,d6
		swap	d6				; d6= $40000
		sub.l	RAM_TABLE+$2D*4(pc),d6		; d6 = $40000 - GhostSpace
		moveq	#0,d4
		move.w	-2(a5),d4			; d4 = File Size
		lea	0(a5,d4.l),a4			; a4 -> End of File
		ifnd	PEDROM
		move.l	RAM_TABLE+$E*4(pc),a2		; a2.l = Font medium
		lea	$E00(a2),a3			; Wrong Huge Font
		lea	$800(a2),a2			; Wrong Small Font
		endif
\LoopFile		move.l	(a5),d0			; Read code
			ifnd	PEDROM
			cmp.l	a2,d0
			bne.s	\NoSmallFont
				move.l	RAM_TABLE+$22*4(pc),(a5)
				bra.s	\Next	
\NoSmallFont		cmp.l	a3,d0
			bne.s	\NoHugeFont
				move.l	RAM_TABLE+$23*4(pc),(a5)
				bra.s	\Next	
\NoHugeFont		
			endif
			cmpi.l	#$40064,d0		; Patch Int 1 ?
			beq.s	\Patch
			cmpi.l	#$40074,d0		; Patch Int 5 ?
			beq.s	\Patch
			cmp.l	#$40000,d0		; Execute in ghost space
			bne.s	\Next
			move.w	-2(a5),d0
			andi.w	#$F1FF,d0		; adda.l #xxx,an
			cmp.w	#$D1FC,d0
			bne.s	\Next
			clr.l	(a5)			; KERNEL Space is always 0 for titanium
			bra.s	\Next
\Patch			sub.l	d6,(a5)
\Next			addq.l	#2,a5
			cmp.l	a4,a5
			ble.s	\LoopFile		
\NoTitanium
	rts
	endif
	
