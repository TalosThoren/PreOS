;filelib from the doorsteam , commented by C.Couffignal & Xavier VASSOR

; Fix the WriteFile bug (Line 235) By Michel Tran Ngoc
; Fix the InUse bug  by PpHd

; Improve hsymprep

    include tios.h

    xdef	_library
    xdef	_ti89
    xdef	_ti89ti
    xdef	_ti92plus
    xdef	_v200
    
    xdef    filelib@0000    ;func sortlist
    xdef    filelib@0001    ;func delete
    xdef    filelib@0002    ;func copy
    xdef    filelib@0003    ;func move
    xdef    filelib@0004    ;func rename
    xdef    filelib@0005    ;func createfolder
    xdef    filelib@0006    ;func protect
    xdef    filelib@0007    ;func hide
    xdef    filelib@0008    ;func unhide
    xdef    filelib@0009    ;func hdltoindex
    xdef    filelib@000A    ;func gettype
    xdef    filelib@000B    ;func search
    xdef    filelib@000C    ;func createfile
    xdef    filelib@000D    ;func resizefile
    xdef    filelib@000E    ;func readfile    (VAT Entry,position,nb)
    xdef    filelib@000F    ;func writefile    (VAT Entry,position,nb)
    xdef    filelib@0010    ;func archive
    xdef    filelib@0011    ;func unarchive
    xdef    filelib@0012    ;func FindSymEntry
    xdef    filelib@0013    ;func topath


	DEFINE	_version01
	
filelib@0013
topath:
;input : d0/d1 as usual, a0 : pointer to a free 20 bytes buffer.
;output: d0 : nonzero => ok, 0 => failed
	movem.l	d1-d7/a0-a6,-(sp)
	bsr	hsymprep
	pea	(a0)
	move.l	d6,-(a7)
	jsr	tios::HSYMtoName
	addq.l	#8,a7
	movem.l	(sp)+,d1-d7/a0-a6
	rts

filelib@0012:
FindSymEntry:
;parameters are pushed in the stack in that order
;1 : adress to the name of the symbol to look for
;2 : handle of the list you look in
	movem.l	d0-d7/a1-a6,-(a7)
	move.l	62(a7),a1        ; a1 : name of the entry we look for
	move.w	60(a7),d0        ; d0 : handle of the list we look into
	
	DEREF	d0,a0            ; a0 : contents of the list
	addq.l	#2,a0            ; skips the 1st word
	move.w	(a0)+,d5        ; d5 = nb items in the list
	beq.s	\false            ; -> not found
	subq.w	#1,d5            ; - 1 for dbra
\search
	movem.l	a0/a1,-(a7)
	jsr	tios::SymCmp	; compares the strings a0 & a1
	movem.l	(a7)+,a0/a1	; restores a0&a1
	tst.w	d0		; (a0) = (a1) ?
	beq.s	\end            ; -> found !
	lea	SYM_ENTRY.sizeof(a0),a0        ; else VAT pointer += 14
	dbra	d5,\search        ; search again
\false	suba.l	a0,a0            ; a0 = 0, entry not found
\end    movem.l (a7)+,d0-d7/a1-a6
	rts


filelib@0011:
unarchive:
;--------------------------------------------------------------
;unarchive(folder,file)
;
;    Unarchives the file
;
;Input: d0.w = hanle of the folder containing the file
;     d1.w = index of the file
;
;Output:
;    d2.w = result
;--------------------------------------------------------------
	movem.l	d0/d1/d3-d7/a0-a6,-(a7)
	bsr	inuse
	cmp.w	#tios::FolderListHandle,d0
	beq	error
	bsr.s	hsymprep    ; prepare d6 = Sym info for the ROM CALL
	move.l	d6,-(a7)    ; pushes d6
	clr.l	-(a7)        ; the 2nd arg is unused here
	jsr	tios::EM_moveSymFromExtMem    ; Unarchive !
	addq.l	#8,a7
	tst.w	d0        ; did it work ?
	beq	memory        ; no -> memory error
	bra	normalend    ; else -> normalend

hsymprep:
;	moveq	#0,d6
;	move.w	d0,d6			; d6.w = handle of the folder
;	swap	d6			; d6.w = 0, the other word of d6 contains the handle of the folder
;	moveq	#4,d5	        ; d5 will be the displacement from the beginning of the list
;	mulu	#SYM_ENTRY.sizeof,d1	; d5 = 4 + (14 * index)
;	add.w	d1,d5
;;	move.w	d5,d6        ; stores d5
;	rts
	move.w	d0,d6
	swap	d6
	mulu	#SYM_ENTRY.sizeof,d1
	move.w	d1,d6
	addq.w	#4,d6
	rts

filelib@0010:
archive:
;--------------------------------------------------------------
;archive(folder,file)
;
;    Archives the file
;
;Input: d0.w = handle of the folder containing the file
;     d1.w = index of the file
;
;Output:
;    d2.w = result
;--------------------------------------------------------------

	movem.l	d0/d1/d3-d7/a0-a6,-(a7)
	bsr	inuse
	cmp.w	#tios::FolderListHandle,d0
	beq	error
	bsr	hsymprep    ; prepare d6 = Sym info for the ROM CALL
	move.l	d6,-(a7)    ; pushes d6
	clr.l	-(a7)        ; the 2nd arg is unused here
	jsr	tios::EM_moveSymToExtMem    ; Archive !
	addq.l	#8,a7
	tst.w	d0        ; did it work ?
	beq	memory        ; no -> memory error
	bra	normalend    ; else -> normalend

filelib@000E
readfile:
;--------------------------------------------------------------
;readfile(VAT entry adress, size, position, buffer)
;
;    Reads a file
;
;Input: a0.l = VAT entry adress of the file (you get it with filelib::FindSymEntry or filelib::search)
;     d0.w = nb of bytes to read (>0)
;     d1.w = position of the first byte of the file to read
;     a1.l = pointer to the buffer where to place all read bytes
;
;Output: d0.w = nb of bytes correctly read
;    NO REGISTERS DESTROYED
;--------------------------------------------------------------
    movem.l    d1-d7/a0-a6,-(a7)        ;save registers in the stack
    move.w    d0,d2            ;d2=nb of bytes to read 
    ble.s    \zero            ;if d0 less than 0 or equal 

    move.w    12(a0),d0            ;a0:vat address, see the description of vat on doors' homepage;a0+12:handle of the file
    DEREF    d0,a6            ;a6 :address of the start of the file
    move.w    (a6)+,d3            ;size of the file in d3

    move.w    d1,d4            ;d4 = position
    add.w    d2,d1            ;d1 = min size of the file
    cmp.w    d1,d3
    bge.s    \OK            ;if d3 greater than d1 (min size) or equal
    sub.w    d3,d1            ;d1 = shortfall of bytes
    sub.w    d1,d2            ;d2 = new nb of bytes to read
    bgt.s    \OK
\zero    clr.w    d0
    beq.s    \fin            ;quit if 0>d0
\OK    add.w    d4,a6            ;a6:address of the first byte to read
    move.w    d2,d0
    subq.w    #1,d2            ;d2=nb of bytes to read-1 for the dbra    
\read    move.b    (a6)+,(a1)+        ;copy a6 (address of the byte(s) to read) to a1 (buffer) and increase a6 and a1
    dbra.s    d2,\read
    
\fin    movem.l    (a7)+,d1-d7/a0-a6        ;restore registers
    rts                ; quit func

filelib@000F
writefile:
;--------------------------------------------------------------
;writefile(VAT entry adress, size, position, buffer)
;
;    Writes to a file, automatically tries to enlarge the file needed
;
;Input: a0.l = VAT entry adress of the file (you get it with filelib::FindSymEntry or filelib::search)
;     d0.w = nb of bytes to write (>0)
;     d1.w = position of the first byte of the file to write
;     a1.l = pointer to the buffer containing the bytes to write
;
;Output: d0.w = nb of bytes correctly written
;    NO REGISTERS DESTROYED
;--------------------------------------------------------------


    movem.l    d1-d7/a0-a6,-(a7)        ;save registers in the stack
    move.w    d0,d2            ;d2=nb of bytes to read 
    ble.s    \zero            ;if d0 less than 0 or equal 

    move.w    12(a0),d0            ;a0:vat address, see the description of vat on doors' homepage;a0+12:handle of the file
    DEREF    d0,a6            ;a6 :address of the start of the file
    move.w    (a6)+,d3            ;size of the file in d3

    move.w    d1,d4            ;d4 = position
    add.w    d2,d1            ;d1 = min size of the file
    cmp.w    d1,d3
    bge.s    \OK            ;if d3 greater than d1 (min size) or equal

                    ; d1 necessary size for the file
                    ; a0=address of the file in vat
    move.w    d1,d0
    bsr    resizefile
    cmp.w    d1,d0	; d0:new size
    beq.s    \OK	; if new size=d1

    sub.w    d3,d1            ;d1 = shortfall of bytes
    sub.w    d1,d2            ;d2 = new nb of bytes to read
    bgt.s    \OK
\zero
    clr.w    d0
    beq.s    \fin            ;quit if 0>d0

\OK
; VOILA CE QUE J'AI AJOUTé 
; Un petit commentaire: après le bsr resizefile, 
; a6 pointe sur l'ancienne adresse de la variable 'resizée',
; donc ici on récupère le nouveau ou ancien(si pas de changement de taille) handle,
; on DEREF et... ça marche
	move.w SYM_ENTRY.hVal(a0),d0
	DEREF	d0,a6 
	add.w	d4,a6		; a6:address of the first byte to read
	addq.l	#2,a6		; il faut sauter les octets qui indiquent la taille de la variable (en effet) 
; fin de l'ajout 
    move.w    d2,d0
    subq.w    #1,d2            ;d2=nb of bytes to read-1 for the dbra    
\write
	move.b	(a1)+,(a6)+        ;copy a1 (address of buffer to a1 (address of the bytes to write) and increase a6 and a1
	dbra	d2,\write
    
\fin
    movem.l    (a7)+,d1-d7/a0-a6        ;restore registers
    rts

filelib@000D:
resizefile:

;--------------------------------------------------------------
;resizefile(VAT Entry adress, size)
;
;    Resizes a file
;
;Input: a0.l = VAT entry adress of the file (you get it with filelib::FindSymEntry or filelib::search)
;     d0.w = new size of the file
;
;Output: d0.w = size of the file
;    NO REGISTERS DESTROYED
;--------------------------------------------------------------

    movem.L    d1-d7/a0-a6,-(a7)
    ext.l        d0        ;d0=longword
    move.w        12(a0),d1        ;d1=handle of the file
    DEREF        d1,a5            ;a5 :address of the start of the file
    move.w        (a5),d7        ;d7 : old size of the file

    addq.l        #2,d0        ; warning!
    move.l        d0,d6        ;d6 : new size

    move.l        d0,-(a7)        ;move the LONGWORD d0:new size to the stack
    move.w        12(a0),-(a7)    ;handle of the file in stack
    jsr    tios::HeapRealloc    ;resize the handle
    addq.l        #6,a7
    tst.w        d0        ;d0=0 if it doesn't work ,else handle resized
    bne.s        \OK
    move.w        d7,d0        ;d0=old size
    bra.s        \fin
\OK    subq.l        #2,d6
    move.w        d0,d1
    DEREF        d1,a5        ;a5:address of the resized handle
    move.w        d6,(a5)        ;write in the header of the file its new size
    move.w        d6,d0        ;d0=new size
\fin    movem.l    (a7)+,d1-d7/a0-a6        ;restore registers
    rts                ;quit func


filelib@000B
search:

;--------------------------------------------------------------
;search(file)
;
;looks in all folders if the file exists, and then returns its VAT entry adress in a0
;
;Input: a0.l: pointer to the name of the file
;    d1.w : filelib::search will run d1 searches before returning, so that if different 
;    folders have the same file name, not only the first file will be found
;
;Output: a0.l: adress of the VAT entry of the file
;    d0.w:    handle of the folder of the file
;--------------------------------------------------------------

    movem.l    d1-d7/a1-a6,-(a7)
    move.w        d1,d6        ;saves d1
    move.l        a0,a5        ;  "    a0
    move.w        #tios::FolderListHandle,d0    ; d0 = folder list handle
    bsr        d0toa6        ; a6 points to the folder list
    addq.l        #2,a6
    move.w        (a6)+,d7        ;d7 = nb folders
    subq.w        #1,d7        ; -1 for dbra
\look    move.l        a5,-(a7)        ; name of the file we look for
    move.w        12(a6),-(a7)    ; handle of the folder
    bsr        FindSymEntry   ; search..
    addq.l        #6,a7
    cmp.l        #0,a0        ; a0 = 0 ?
    bne.s        \found        ; -> found
    lea        SYM_ENTRY.sizeof(a6),a6        ; next file
    dbra.s        d7,\look        ; search again
    clr.w        d0        ; we found nothing. -> d0 = 0
    bra.s        \no        ; exit
\found
    dbra.s        d6,\look        ; we found something. if d6 > 0, we have to search again
    move.w        12(a6),d0        ; else d0 = handle of the folder containing the file
                    ; a0 points to the VAT entry adress of the file because of the FindSymEntry call
\no    movem.l    (a7)+,d1-d7/a1-a6
    rts

filelib@000C
createfile:

;--------------------------------------------------------------
;createfile(name,folder)
;
;    Creates a new file (0 bytes long)
;
;Input: a0.l = name of the file
;    d0.w  = folder handle
;
;Output: a0.l = VAT entry adress of the file
;
;    if d2.w = 0, the file was succesfully created, else:
;    1    -> Not enough memory
;    2    -> File already exists
;    3    -> Invalid name of the file
;    NO REGISTERS DESTROYED
;--------------------------------------------------------------

    movem.l    d0/d1/d3-d7/a0-a6,-(a7)
    moveq.w    #3,d2            ; 3: invalid name
    cmp.b        #97,(a0)        ; valid name ?
    blt.s        \exit        ; no -> exit

    bsr        findadress    ; searches for a file with that name..
    move.l        a0,d0        ; d0 = result
    tst.l        d0        ; d0 = 0 ?
    beq.s        \yes        ; -> yes: no file with that name
    
    moveq.w     #2,d2            ; 2: already exists
    bra.s        \exit        ; exits
\yes    movem.l    (a7),d0/d1/d3-d7/a0-a6    ;restore all regs, but keeps them on the stack

    move.l        a0,a3        ;saves a0
    move.w        d0,d4        ;saves d0
    move.l        #2,-(a7)        ; creates a 2 bytes memory block
    jsr        tios::HeapAlloc ; as for the contents of the file
    addq.l        #4,a7
    tst.w        d0        ; d0 = 0?
    beq.s        \mem        ; -> yes -> not enough mem
    bsr        d0toa6        ; a6 points to the contents of the file
    clr.w        (a6)        ; size of the file: 0 bytes
    lsr.w        #2,d0        ; restores d0 after d0toa0

    move.l        a3,a0        ; restores a0
    exg.w        d4,d0        ; -> d0=handle of the folder
    bsr        CreateItem    ; creates a VAT entry in this folder, with name (a0)
    tst.w        d0        ; d0 = 0 ?
    beq.s        \del        ; -> yes -> not enough mem
    move.w        d4,-(a3)        ; writes the handle
    clr.l        -(a3)        ; flags for a normal file
    bsr        sortlist        ; sorts the list
    clr.w        d2        ; d2 = 0 -> everything's Ok!
\exit
    movem.l    (a7)+,d0/d1/d3-d7/a0-a6
    bsr        findadress    ; a0 = VAT adress of the created file
    rts
\mem
    moveq    #1,d2            ; 1: not enough mem
    bra.s    \exit
\del
    move.w    d4,-(a7)            ; deletes the handle previously created
    jsr    tios::HeapFree      ;
    addq.l    #2,a7
    bra.s    \mem            ; exits, code: not enough mem

findadress:
;a0/d0
    movem.l    d0-d7/a1-a6,-(a7)
    move.l        a0,-(a7)        ;a0 = pointer to the name to search
    move.w        d0,-(a7)        ;d0 = folder handle
    bsr        FindSymEntry    ; Finds the VAT entry adress
    addq.l        #6,a7
    movem.l    (a7)+,d0-d7/a1-a6
    rts


;**********************************************************************
;  preparea3
;
; input :
;    d0 = folder handle
;    d1 = item index (0 -> nbitems - 1)
; output: a3 = pointer to the VAT entry
;    (a2)  = nb files
;**********************************************************************
preparea3:
    bsr        d0toa6
    move.l        a6,a3        ;deref d0,a3
    lsr.l        #2,d0        ;restores d0
    addq.l        #2,a3        ; skips the 1st word
    move.w        d1,d3        ; d3 = d1 = index
    tst.w        d3        ; d3 < 0 ?
    blt.s        \range        ; -> yes -> out of range
    move.l        a3,a2        ; (a2) = nbfiles
    cmp.w        (a3)+,d3        ; d3 > nbfiles ?
    bgt.s        \range        ; -> yes -> out of range
    mulu        #SYM_ENTRY.sizeof,d3        ; index * 14
    adda.l        d3,a3        ; + a3 -> a3 points to the VAT adress of the item
    rts
\range    addq.l    #4,a7            ; cancelles the normal return adress
    bra    error            ; exits with an error code

d0toa6: tios::DEREF     d0,a6
    rts

;******************************************************************
;     Resizes the list (handle d0)
;output:
;    d0=0 -> not enough mem
;*******************************************************************
resize:

;--------------------------------------------------------------
;resizefile(VAT Entry adress, size)
;
;    Resizes a file
;
;Input: a0.l = VAT entry adress of the file (you get it with filelib::FindSymEntry or filelib::search)
;     d0.w = new size of the file
;
;Output: d0.w = size of the file
;    NO REGISTERS DESTROYED
;--------------------------------------------------------------


    movem.l    d1-d7/a0-a6,-(a7)
    clr.l    d1            ;index=0
    bsr    preparea3        ;a3=VAT address of the first file in the folder
    subq.l    #4,a3
    move.w    (a3),d2             ;d2: max number of files
    cmp.w    (a2),d2             ;cmp maxfiles,nbfiles
    bge.s    \lower            ;if inf or equal -> list is big enough
    add.w    #10,(a3)             ;else resize:+10 to maxfiles
\res    move.w    (a3),d1
    mulu    #SYM_ENTRY.sizeof,d1            ; a file requires 14 bytes in VAT: d1*14 bytes needed for d1 files
    addq.l    #4,d1            ; 2 bytes for nbfiles and 2 for maxfiles
    move.l    d1,-(a7)             ; new size of the handle in stack
    move.w    d0,-(a7)             ; hdl of the fold in stack
    jsr    tios::HeapRealloc    ; resizes the list
    addq.l    #6,a7
\OK
    movem.l    (a7)+,d1-d7/a0-a6
    rts
\lower
    sub.w    #10,(a3)            ;-10 to maxfiles
    move.w    (a3),d2
    cmp.w    (a2),d2            ;test if it's possible to decrease maxfiles
    bge.s    \res    
    add.w    #10,(a3)            ;else OK: add again
    bra.s    \OK

CreateItem:
;-------------------------------------------------------------- 
;input:
;    a0: points to a VAT Entry
;    d0: hdl of a list of files or folders
;
; output: a3 points to the next VAT entry
;--------------------------------------------------------------
    move.l    d1,-(a7)            ;saves d1
    clr.l    d1            ;index =0
    bsr    preparea3        ;a3=VAT     address of the first file or folder 
    move.w    (a2),d1            ;d1:nbfiles
    addq.w    #1,(a2)            ;nbfiles + 1
    bsr    resize            ;resizes the list if needed
    tst.w    d0            ; enough mem ?
    bne.s    \OK            ; -> yes
    subq.w    #1,(a2)            ;if it doesn't work
    bra.s    \fin
\OK                    ;d1=nbfiles
    bsr    preparea3        ;a3: VAT address of the last item
    move.w    #SYM_ENTRY.sizeof-1,d1            ;14 bytes to copy
\cpy
    move.b    (a0)+,(a3)+        ;copy (a0) to the new VAT entry
    dbra.s    d1,\cpy
\fin
    move.l    (a7)+,d1            ;restores d1
    rts

DeleteItem:

;--------------------------------------------------------------
;d0:hdl of a fold or table hdl
;d1:index of the item to delete
;--------------------------------------------------------------

    bsr    preparea3        ;VAT address of the item
    move.w    (a2),d2            ;d2:nbfiles
    subq.w    #1,d2            ;d2:index of the last item
    bsr    exchg            ;exchange the last item and the item to delete
    subq.w    #1,(a2)            ;-1 to nbfiles
    bsr    sortlist            ;sort then the list
    bsr    resize            ;and resize
    rts

filelib@0000:
sortlist:
;--------------------------------------------------------------
;sortlist(list handle)
;
;   Sorts file/folder list d0 in alphabetical order
;
;Input:    d0.w = file/folder list handle
;
;Output: nothing
;
;    NO REGISTERS DESTROYED
;--------------------------------------------------------------

    movem.l    d0-d7/a0-a6,-(a7)
    clr.w        d2
\suite
	move.w        d2,d1        ;first index=d2
    bsr        preparea3    	;a3=VAT address of the item with index d2
    cmp.w        #1,(a2)        ;if one item:end
    ble.s        \fin
    move.l        a3,a1        ;else save a3 in a1
    addq.w        #1,d1        ;next index
    move.w        (a2),d5        ;d5:nbitem
    subx.w        d1,d5        
    subq.w        #1,d5        ;d5 nbitem to compare with
    bsr        preparea3    ;a3=VAT address of the item with index d2+1
\loop
    move.l        (a3),d4
    cmp.l        (a1),d4        ;compare the two names: A:65 B:66,.. so B is greater than A     
    beq.s        \again        ;If the four letters are the same: again, for example Doors and tios
    bls.s        \echan        ;if item with index d2+1 have a name smaller than the item with index d2:exchange them
\ret
    addq.w        #1,d1        ; else next index in d1
    lea        SYM_ENTRY.sizeof(a3),a3        ; next VAT address
    dbra.s        d5,\loop
    addq.w        #2,d2
    cmp.w        (a2),d2        ;verify if it exists at least d2+2 item: else no need to continue 
    beq.s        \fin
    subq.w        #1,d2        ;next first index
    bra.s        \suite
\fin
    movem.l    (a7)+,d0-d7/a0-a6
    rts
\echan
    bsr        exchg
    bra.s        \ret
\again
    move.l        4(a3),d4        ;a3=address of the next longword of the name of the file with index d2+1
    cmp.l        4(a1),d4        ;a4=address of the next longword of the name of the file with index d2
    blt.s        \echan        ;if item with index d2+1 have a name smaller than the item with index d2:exchange the two
    bra.s        \ret

exchg:
    movem.l    d0-d4/a0-a4,-(a7)
    bsr        preparea3;
    move.l        a3,a4        ;a4=VAT address of the item with index d2+1
    move.w        d2,d1    
    bsr        preparea3    ;a3=VAT address of the item with index d2+1
    move.w    #SYM_ENTRY.sizeof-1,d2            ;14 bytes to exchg
\echange
    move.b    (a4),d1
    move.b        (a3),(a4)+
    move.b        d1,(a3)+    
    dbra        d2,\echange

    movem.l    (a7)+,d0-d4/a0-a4
    rts

filelib@0001
delete:
;--------------------------------------------------------------
;delete(folder,file/folder)
;
;    Deletes the file/folder d1 in folder d0
;
;Input: d0.w = folder handle
;    d1.w = file/folder index
;
;Output: d2.w    = result
:    
;    NO REGISTERS DESTROYED
;--------------------------------------------------------------

    movem.l    d0-d1/d3-d7/a0-a6,-(a7)
    bsr        locked        ;file is locked?
    bsr        inuse        ;file is in use?
    bsr        preparea3    ;a3:VAT address of the item
    cmp.w        #tios::FolderListHandle,d0    ; is it a folder ?
    beq.s        \fold        ; -> yes
    btst        #1,10(a3)    ; is it archived ?
    bne.s        \arch        ; yes -> arch
\del
    move.w        12(a3),-(a7)    ; handle of the item in stack
    jsr        tios::HeapFree    ;delete the hdl
    addq.l        #2,a7
\archdel
    movem.l    (a7),d0-d1/d3-d7/a0-a6    ;restore all the params
    bsr        DeleteItem
    bra        normalend

\fold    move.w        12(a3),d0
    bsr        d0toa6        ;a6 address of the start of the fold
    tst.w	2(a6)        ; no file in the folder ?
    bne.s        \full        ; -> folder non empty
;    moveq.w    #$8,d0
    bra.s        \del
\arch
	bsr	unarchive
	tst.w	d2
	beq	error
	bsr	delete
	bra	normalend

\full	move.w	#150,-(a7)
	bra	tiosERROR

filelib@0002
copy:
;--------------------------------------------------------------
;copy(folder,file,newfolder)
;
;   Copies the file d1 in folder d0 to folder d2
;
;Input:d0.w = source folder handle
;    d1.w = file index
;    d2.w = dest folder handle
;
;Output: d2.w    = result
;    NO OTHER REGISTERS DESTROYED
;--------------------------------------------------------------

    movem.l    d0-d1/d3-d7/a0-a6,-(a7)
	cmp.w        #tios::FolderListHandle,d0    ; if folder ->exit
    beq        error
    bsr        locked
    bsr        inuse
    bsr        alreadyexist2    ; file with this name already exists in new folder ?
    exg.w        d0,d2        ; restore d0-d2 because of alreadyexist2
    bsr        preparea3    ; a3=VAT address of the item to copy
    movem.l    d1/d2,-(a7)        ; save d1-d2
    move.w        12(a3),d0        ; d0=hdl of the file to copy
    bsr        d0toa6        ; a6:address
    move.l        a6,a2
    moveq.l    #2,d5
    add.w        (a2),d5        ; d5=size of the handle to copy +2 for the size
    move.l        d5,-(a7) 
    jsr        tios::HeapAlloc    ; creates the new hdl
    addq.l        #4,a7
    movem.l    (a7)+,d1/d2        ;restore d1-d2
    tst.w        d0        ;not enough mem ?
    beq        memory        ;->exit
    move.w        d0,d4        ;save hdl in d4
    bsr        d0toa6        ;deref d0,a6
    subq.w        #1,d5        ;for the dbra
\hdlcopy     
    move.b        (a2)+,(a6)+    ;copy a2 (address of the start of the file to copy ) in a6(address of the new one)
    dbra.s        d5,\hdlcopy 
    move.w        d2,d0        ;d0=hdl of the new fold
    move.l        a3,a0        ;a0= pointer to the name of the file to copy
    bsr        CreateItem
    tst.w        d0
    beq        delhdl        ;if it doesn't work
    move.w        d4,-(a3)        ;new handle of the file in VAT 
    clr.l        -(a3)        ;flags
    bsr        sortlist        ;sort the list
normalend: 
	moveq	#1,d2
fin:	movem.l	(a7)+,d0-d1/d3-d7/a0-a6
	rts
error:	moveq	#0,d2
	bra.s	fin

filelib@0003
move:
;--------------------------------------------------------------
;move(folder,file,newfolder)
;
;   Moves the file d1 in folder d0 to folder d2
;
;Input:d0.w = source folder handle
;    d1.w = file index
;    d2.w = dest folder handle
;
;Output:d2.w = result
;    NO REGISTERS DESTROYED
;
;--------------------------------------------------------------

    movem.l    d0-d1/d3-d7/a0-a6,-(a7)
    cmp.w        #tios::FolderListHandle,d0    ;list of folder ?
    beq        error
    bsr        locked        ; locked ?
    bsr        inuse        ;inuse ?
    bsr        preparea3    ;a3=VAT address of  the file
    move.l        a3,a0
    bsr        alreadyexist2    ;does the file exist in the new fold ?
    bsr        CreateItem    ; Creates the VAT entry
    tst.w        d0
    beq        memory        ; not enough mem..
    bsr        sortlist    ; sorts the list
    exg.w        d0,d2        ;restore d0 and d2:see alreadyexist2
    bsr        DeleteItem    ; deletes the entry in the other list
    bra        normalend
alreadyexist2:
    movem.l    d1/d3-d7/a1-a6,-(a7)
    bsr        preparea3
    move.l        a3,a0        ; a0=pointer to the name of the file
    exg.w        d2,d0        ; search now in the fold with hdl d2
    movem.l    (a7)+,d1/d3-d7/a1-a6

alreadyexist:
;d0/a0
    movem.l    d0-d7/a0-a6,-(a7)    
    bsr        findadress    ;file exist ?
    move.l        a0,d0
    tst.l        d0        ;d0=0: file doesn't exist
    beq        subfin
    movem.l    (a7)+,d0-d7/a0-a6
    addq.l        #4,a7
    move.w        #270,-(a7)
    bra        tiosERROR    ;error:file already exists in the new fold

filelib@0004
rename:
;--------------------------------------------------------------
;rename(folder,file/folder,newname)
;
;    Renames the file/folder d1 in folder d0 with new name a0
;
;Input: d0.w = folder handle
;    d1.w = file/folder index
;    a0.l = adress of the new name
;
;Output: d2.w = result
;    NO REGISTERS DESTROYED
;--------------------------------------------------------------

    movem.l    d0/d1/d3-d7/a0-a6,-(a7)
    bsr    inuse            ;in use ?
    bsr    valid            ;valid name ?
    bsr    locked            ;locked
    bsr    alreadyexist        ;exist ?
    bsr    preparea3        ;a3= VAT address of the file
    clr.l    (a3)+
    clr.l    (a3)+            ;erase the name:8 bytes ( see VAT description on the Doors homepage )
    bsr    preparea3        ;restore a3
\cpy
    tst.b    (a0)            ;end of the name ? (name ends with a 0 )
    beq.s    \fin
    move.b    (a0)+,(a3)+        ;copy the name
    bra.s    \cpy
\fin    bsr    sortlist            ;sort the list
    bra    normalend

filelib@0005
createfolder:

;--------------------------------------------------------------
;createfolder(name)
;
;    Creates a new folder
;
;Input: a0.l = name of the folder
;
;Output: d2.w    = result
;
;    NO REGISTERS DESTROYED
;--------------------------------------------------------------

    movem.l    d0/d1/d3-d7/a0-a6,-(a7)
    bsr        valid        ;valid name ?
    move.w    #tios::FolderListHandle,d0            ;list of fold ? 
    bsr        alreadyexist    ;exist ?
    move.l        a0,a3        ;save a0
    pea		(144).w    ;144 bytes: 10files:14 bytes for a file +2bytes:nb of files +2bytes:nb max of files
    jsr        tios::HeapAlloc         ;create the list of the files associated with the folder
    addq.l        #4,a7
    tst.w        d0
    beq        memory        ;not enough mem ?
    bsr        d0toa6        ;a6=address of the start of the the associated list
    move.l        #$000A0000,(a6)    ;write:000A:maxfiles, 0000:nb of files
    lsr.w        #2,d0        ;restore d0
    move.l        a3,a0        ;restore a0
    move.w        #tios::FolderListHandle,d4     ;d0=FolderListHandle
    exg.w        d4,d0        ;d4=handle of the list, d0:hdl of the list of folders
    bsr        CreateItem
    tst.w        d0        ;not enough mem ?
    beq        delhdl        ;so destroy hdl
    move.w        d4,-(a3)        ;else store the handle of the list in VAT
    move.l        #$00030080,-(a3)    ;then the flags
    bsr        sortlist        ;sort the list
    bra        normalend

delhdl:
    move.w    d4,-(a7)            ;hdl of the list in stack
    jsr    tios::HeapFree        ;destroy the list
    addq.l    #2,a7
    bra    memory            ;error mem

filelib@0006
protect:                    ; protects or unprotects a file
;-------------------------------------------------------------
;protect(folder,file/folder)
;
;   Protects the file/folder d1 in folder d0 so that this file
; is unreacheable in TI OS and quite invisible in ASM programs
;   You can access it again only with the Doors shell
;
;Input: d0.w = folder handle
;    d1.w = file/folder index
;
;Output: d2.w = result
;    NO REGISTERS DESTROYED
;--------------------------------------------------------------

    movem.l    d0/d1/d3-d7/a0-a6,-(a7)
    bsr        inuse        ; in use ?
    cmp.w        #tios::FolderListHandle,d0    ; protect/unprotect a folder ?
    bne.s        \file        ; no -> \file
    move.w        d0,d6        ; we will check that no file is in use in the folder we want to protect
    move.w        d1,d7        ; backup d0&d1
    bsr        preparea3
    move.w        SYM_ENTRY.hVal(a3),d0        ; d0 = folder handle
    bsr        d0toa6        ; a6 points to the file list
    lsr.l        #2,d0        ; restore d0 = folder handle
    addq.l        #2,a6
    move.w        (a6)+,d2        ; d2 = nbfiles
    tst.w        d2
    beq.s        \nofiles
    clr.l        d1        ; index = 0
\again    bsr        inuse        ; file in use ?
    addq.w        #1,d1        ; index++
    cmp.w        d1,d2        ; index == nbfiles ?
    bne.s        \again        ; no -> check again
\nofiles
    move.w        d6,d0        ; restore d0 & d1
    move.w        d7,d1
\file    bsr        preparea3    ; a3 points to the VAT entry adress of the file
    move.b        (a3),d3    ; d3 = first character
    tst.b        d3        ; d3 == 0 ? -> file/folder is protected
    beq.s        \unprot    ; -> we will unprotect it
    bsr        hide        ; hides the item
\goon    move.b        8(a3),(a3)    ; first character = 8(a3)
    move.b        d3,8(a3)    ; 8(a3) = first character
    bra        normalend    ; exit
\unprot
    bsr        unhide
    bra.s        \goon

filelib@0007
hide:    
;--------------------------------------------------------------
;hide(folder,file/folder)
;
;    used on a file, this function makes it disappear from TIOS
;    used on a folder, this function hides it in the Var-Link
;   But the file is always appears in ASM programs
;Input:    d0.w = folder handle
;        d1.w = file/folder index
;
;Output: nothing
;--------------------------------------------------------------

    movem.l    d0-d1/d3-d7/a0-a6,-(a7)
    bsr        preparea3
    bset        #4,11(a3)        ; changes the flag. 4th bit set -> file is hidden
    bra        normalend

filelib@0008
unhide:
    
;--------------------------------------------------------------
;unhide(folder,file/folder)
;
;    Cancelles the effects of hide
;
;Input:    d0.w = folder handle
;        d1.w = file/folder index
;
;Output: nothing
;--------------------------------------------------------------

    movem.l    d0-d1/d3-d7/a0-a6,-(a7)
    bsr        preparea3
    bclr        #4,11(a3)        ; changes the flag. 4th bit clear -> file is not hidden
    btst        #1,10(a3)        ; is it archived ?
    bne        normalend    ; -> yes -> exit
    bclr        #3,11(a3)        ; -> no: clear the 'lock' flag too.
    bra        normalend    ; exit

filelib@0009
hdltoindex:
;--------------------------------------------------------------
;hdltoindex(file/folder handle)
;
;   Returns the index of the file given its handle
;   It searches in all folders.
;   This function is very useful if you want to use filelib and you only 
;   possess the handle of a file
;
;Input:d2.w =file/folder handle to search
;
;Output: d1.w = file index
;    d0.w = folder handle (=0 -> the handle wasn't found)
;    NO OTHER REGISTERS DESTROYED
;--------------------------------------------------------------

    movem.l    d2-d7/a0-a6,-(a7)
    move.w        #tios::FolderListHandle,d0    ; d0 = folder list handle
    bsr        hdl2        ; search in this list
    tst.l        d1        ; was found ?
    bge.s        \fin        ; -> yes
    bsr        d0toa6        ; else: a6 points to the folder list
    addq.l        #2,a6
    move.w        (a6)+,d7        ; d7 = nb folders
    subq.w        #1,d7        ; -1 for dbra
\look    move.w        SYM_ENTRY.hVal(a6),d0        ; d0 = folder handle
    bsr        hdl2        ; search in this folder
    tst.l        d1        ; was found ?
    blt.s        \no        ; -> no
    bra.s        \fin        ; -> yes !
\no    lea        SYM_ENTRY.sizeof(a6),a6        ; next folder
    dbra.s        d7,\look        ; search again
    clr.l        d0        ; not found -> d0 = 0
\fin    movem.l    (a7)+,d2-d7/a0-a6
    rts


hdl2:    movem.l    d0/d2-d7/a0-a6,-(a7)
    tst.w        d0        ; handle is NULL
    beq.s        \fail        ; -> not found
    bsr        d0toa6        
    addq.l        #2,a6
    move.w        (a6)+,d0        ; d0 = nb files
    tst.w        d0        ; d0 = 0 ?
    beq.s        \fail        ; can't find
    subq.w        #1,d0        ; -1 for dbra

    moveq.l    #-1,d1            ; d1 = 0 - 1 (for the addq.l  #1,d1 to come)
\test
    lea        SYM_ENTRY.hVal(a6),a6        ; a6 points to the handle to compare
    addq.l        #1,d1        ; index++
    cmp.w        (a6)+,d2        ; compares with the handle we look for
    beq.s        \OK        ; equal ! -> we found
    dbra.s        d0,\test        ; search again
\fail    moveq.l    #-1,d1            ; not found -> d1 = -1
\OK    movem.l    (a7)+,d0/d2-d7/a0-a6
    rts

filelib@000A
gettype:
;--------------------------------------------------------------
;gettype(folder,file)
;
;    returns the type of the file d1 in folder d0
;
;Input: d0.w = folder handle
;    d1.w = file index
;
;Output: d2.w = type of the file
;
;The values for d2 are:
;
;ASM    ->0
;LIB    ->1
;PROG    ->2
;FUNC    ->3
;MAT    ->4
;LIST    ->5
;MACR    ->6
;TEXT    ->7
;STR    ->8
;DATA    ->9
;FIG    ->10
;PIC    ->11
;GDB    ->12
;EXPR    ->13
;OTHER ->14
;    NO OTHER REGISTERS DESTROYED
;--------------------------------------------------------------


    movem.l    d0-d1/d3-d7/a0-a6,-(a7)
    cmp.w        #tios::FolderListHandle,d0    ; is it a folder ?
    beq.s        \OTH        ; yes -> OTHER
    bsr        preparea3    ; a3 points to the VAT adress of the list
    move.w        SYM_ENTRY.hVal(a3),d0    ; d0 : file handle
    beq.s        \OTH        ; if NULL, then -> OTHER
    bsr        d0toa6        ; a6 points to the beginning of the file
    clr.l        d2        ; d2 = 0
    move.w        (a6),d2    ; d2 = file size
    cmp.b        #$D9,1(a6,d2.l)    ; check the MATR/DATA tag
    beq        \MATR

    clr.w        d3            ; d3 = 0
    cmp.b        #$DC,1(a6,d2.l)    ; check the PROG/FUNC tag
    beq.s        \PROG
    cmp.b        #$F3,1(a6,d2.l)    ; check the ASM tag
    beq.s        \ASM
    cmp.b        #$F8,1(a6,d2.l)    ; is it an 'OTHER' file type ?
    beq.s        \OTH
    lea        listtype(pc),a0    ; loads the 'tag' list in a0
    moveq.w    #12,d3            ; type = 13
    move.b        1(a6,d2.l),d4        ; loads the file tag
\search
    cmp.b        (a0)+,d4        ; is it in the list ?
    beq.s        \fin            ; yes -> \fin
    cmp.w        #6,d3            ; did we find it ?
    beq.s        \expr            ; no -> expr
    dbra.s        d3,\search        ; loop..
\ASM
    cmp.l        #"PSv1",6(a6)        ; old plusshell ID
    bne.s        \noasm            ; no -> \noasm
    cmp.b        #"L",11(a6)        ; is it a plusshell lib ?
    beq.s        \plus1            ; yes -> \plus 1
\noasm
    cmp.l        #$36386B4C,6(a6)    ; is it a tios/Plusshell lib ?
    bne.s        \fin            ; no -> it is an ASM -> \fin
    bra.s        \plus1            ; yes -> plus1
\OTH
    moveq.w    #14,d3            ; type = 14
    add.l        d2,a6            ; a6 points to the end of the file
    tst.b        (a6)            ; is it 0 ?
    bne.s        \fin            ; no
    cmp.b        #$50,-(a6)        ; 'P' ?
    bne.s        \fin            ; no
    cmp.b        #$49,-(a6)        ; 'I'
    bne.s        \fin            ; no
    cmp.b        #$5A,-(a6)        ; 'Z'
    bne.s        \fin            ; no
    tst.b        -(a6)            ; 0 ?
    bne.s        \fin            ; no
    addq.l        #4,a6
    sub.l        d2,a6            ; a6 points to the beginning of the file
    move.b        2(a6),d3        ; d3 = type of the compressed file
    bra.s        \fin
\PROG
    cmp.b        #$19,-5(a6,d2.l)     ; FUNC -> +3
    bne.s        \plus3
    bra.s        \plus2            ; PRGM -> +2
\expr    addq.w        #4,d3
\plus3    addq.w        #1,d3
\plus2    addq.w        #1,d3
\plus1    addq.w        #1,d3
\fin    move.w        d3,d2
    cmp.w        #13,d2            ; did we find an EXPR ?
    beq.s        \graypic        ; yes -> is it a pic ?
    cmp.w        #8,d2            ; did we find a STR ?
    beq.s        \UGP            ; yes -> is it an UGP picture ?
    bra        fin
\UGP
    cmp.l        #$55475000,2(a6)    ; 2(a6) = "UGP",0 ?
    bne        fin            ; no -> fin
    moveq.w    #11,d2            ; type = 11 -> PIC
    bra        fin
\graypic
    cmp.w        #"PV",2(a6)        ; check the ID
    bne        fin            ; not a picture
    moveq.w    #11,d2            ; type = 11 -> PIC
    bra        fin
\MATR
    moveq.w    #4,d3
    cmp.b        #$D9,0(a6,d2.l)    ; is it a MATR ?
    bne.s        \plus1
    bra.s        \fin

listtype    dc.b     $de,$df,$e1,$dd,$2d,$e0,$e2        ; tag list


memory:    move.w        #670,-(a7)    ; code for a memory error
tiosERROR:
	jsr	tios::ERD_dialog        ; displays a TIOS dialog box
	addq.l	#2,a7			; Pop error code
	bra	error			; exit

arch:
	movem.l	d0-d7/a0-a6,-(a7)        ; checks if the file/folder is archived
	bsr	preparea3
	btst.b	#1,10(a3)
	beq.s	subfin
	bra.s	lock

locked:
	movem.l	d0-d7/a0-a6,-(a7)        ; checks if the file/folder is locked or hidden
	bsr	preparea3
	btst	#1,SYM_ENTRY.flags(a3)        ; tests the 'archived' flag
	bne.s	\arch            ; if it is archived, then we don't test the 'lock' flag
	btst	#3,SYM_ENTRY.flags+1(a3)        ; tests the 'lock' flag
	bne.s	lock            ; -> 'locked' !
\arch	btst.s	#4,SYM_ENTRY.flags+1(a3)        ; tests the 'hide' flag
	beq.s	subfin            ; no -> subfin
lock:	movem.l	(a7)+,d0-d7/a0-a6
	addq.l	#4,a7            ; removes the return adress from the stack
	move.w	#980,-(a7)        ; error code: 'file is locked..'
	bra	tiosERROR        ; display a dialog box & exit
subfin:
	movem.l	(a7)+,d0-d7/a0-a6        ; exit this function
	rts

inuse:
	movem.l	d0-d7/a0-a6,-(a7)		; check if the file is in use
	cmp.w	#tios::FolderListHandle,d0	; is it a folder ?
	beq.s	subfin				; then exit
	bsr	gettype				; get the variable type
	cmp.w	#1,d2				; type > 1 ? cannot be 'in use'
	bgt.s	subfin				; -> exit
	bsr	preparea3			; else: a3 points to the VAT adress of the file
;	move.w	12(a3),d0			; d0 = handle of the file
;	bsr	d0toa6				; a6 points to the contents of the file
;	cmp.l	#$36386B50,6(a6)		; is it a tios/Plusshell program ?
;	beq.s	\doors				; -> yes
;	cmp.l	#$36386B4C,6(a6)		; or is it a tios/Plusshell library ?
;	bne.s	subfin				; -> no
;\doors
;	tst.w	10(a6)        ; tests the relocation counter of the program/lib: if nonzero, it is in use
;	beq.s	subfin        ; else -> exit
	; Other BETTER solutions : test if the handle is locked ! (Works with nostub)
	move.w	SYM_ENTRY.hVal(a3),d0		; d0 = handle of the file
	bsr	d0toa6				; a6 points to the contents of the file
	cmp.l	#$200000,a6
	bhi.s	subfin				; Archived File : not inUse
	move.w	SYM_ENTRY.hVal(a3),-(a7)
	jsr	tios::HeapGetLock
	addq.l	#2,a7
	tst.w	d0
	beq.s	subfin
	movem.l	(a7)+,d0-d7/a0-a6
	addq.l	#4,a7				; Pop return address
	move.w	#970,-(a7)			; code: file in use
	bra	tiosERROR			; display the dialog box

valid:
	movem.l	d0-d7/a0-a6,-(a7)		;check if the name is valid
	cmp.b	#97,(a0)			; 1st character >= 90 ?
	bge.s	subfin				; yes -> exit
	movem.l	(a7)+,d0-d7/a0-a6
	addq.l	#4,a7				; Pop return address
	move.w	#620,-(a7)			; code: 'invalid name'
	bra	tiosERROR			; display the dialog box

adress    dc.l    0
result    dc.l    0

    end
