; SHRINK92 - Copyright 1998, 1999 David Kuehling
; Adaptation for TI-89/92+ - Copyright 2002, 2003, 2004, 2005 Patrick Pelissier
;
; This file is part of the SHRINK92 Library.
;
; The SHRINK92 Library is free software; you can redistribute it and/or modify
; it under the terms of the GNU Lesser General Public License as published by
; the Free Software Foundation; either version 2.1 of the License, or (at your
; option) any later version.
;
; The SHRINK92 Library is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
; License for more details.
;
; You should have received a copy of the GNU Lesser General Public License
; along with the MPFR Library; see the file COPYING.LIB.  If not, write to
; the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
; MA 02111-1307, USA.

;=============================================================================;
; shrnklib::OpenArchive							      ;
;-----------------------------------------------------------------------------;
; Opens a SHRINK92 - archive and returns the handle of the archive descriptor ;
; in d0. You need to open any archive with this routine before accessing it.  ;
; The descriptor contains all information, required for archive access. So    ;
; you don't need an archive's address any more after you've opend it.         ;
;-----------------------------------------------------------------------------;
; Input:  a0.l = pointer to the archive to be opened			      ;
; Output: d0.w = archive descriptor handle or zero on error		      ;
;=============================================================================;
shrnklib::OpenArchive	EQU	shrnklib@0000

;=============================================================================;
; shrnklib::CloseArchive						      ;
;-----------------------------------------------------------------------------;
; Closes a SHRINK92 - archive: Frees all memory used by the archive           ;
; descriptor whose handle is given by d0. You have to close any archive that  ;
; you've opened, else you will mess up the calculator's memory.               ;
;-----------------------------------------------------------------------------;
; Input:  d0.w = handle of archive descriptor				      ;
; Output: archive descriptor is destroyed, the archive descriptor handle      ;
;         becomes invalid and can't be used any more     		      ;
;=============================================================================;
shrnklib::CloseArchive	EQU	shrnklib@0001

;=============================================================================;
; shrnklib::Extract 							      ;
;-----------------------------------------------------------------------------;
; Extracts one section (file) from an archive. The destination memory region  ;
; is given by a0. If a0 is zero a new memory block with the correct size will ;
; be allocated and its handle be returned in d2.                              ;
;-----------------------------------------------------------------------------;
; Input:  d0.w = handle of archive descriptor				      ;
;	  d1.w = index of section to extract (0 = 1st, 1 = 2nd section etc.)  ;
;         a0.l = address of extraction destination			      ;
;                if it is zero, a new memory block is allocated an a0 is set  ;
;                to its address						      ;
; Output: a0.l = address of extraction destination or zero on error (not      ;
;                enough memory or invalid archive)			      ;
;         d2.w = if input-a0.l was zero: handle of allocated memory block     ;
;                else it stays unchanged				      ;
;=============================================================================;
shrnklib::Extract	EQU	shrnklib@0002


