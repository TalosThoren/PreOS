pk92lib@version01	xdef	pk92lib@version01

;************************************************************************
;*  Extract								*
;*----------------------------------------------------------------------*
;*  Extracts Packer92-packed archive, given its address			*
;*  Parameters:								*
;*    a0 = pointer to archives' begin					*
;*    for normal and divided archives: d0.w = number of file		*
;*  Return:                                                             *
;*    d0.b = 0 OK		                                        *
;*         = FF Error							*
;*    a1   = pointer to uncompressed file				*
;*    d1.w = handle of uncompressed file				*
;*    d2.l = Length of uncompressed file				*
;*  All other registers are stored, and restored				*
;************************************************************************
pk92lib::Extract	EQU	pk92lib@0000


;************************************************************************
;*  FreeMem								*
;*----------------------------------------------------------------------*
;*  Destroys the handle, which was used by the last uncompression.	*
;*  FreeMem saves all registers.					*
;*  Parameters: nothing                                                 *
;*  Return: nothing                                                     *
;************************************************************************
pk92lib::FreeMem	EQU	pk92lib@0001


;************************************************************************
;*  ExtractA								*
;*----------------------------------------------------------------------*
;*  Extracts Packer92-packed archive, given its address			*
;*  Parameters:								*
;*    a0 = pointer to archives' begin					*
;*    a1 = pointer to free buffer					*
;*    for normal and divided archives: d0.w = number of file		*
;*  Return:                                                             *
;*    d0.b = 0 OK		                                        *
;*         = FF Error							*
;*    a1   = pointer to uncompressed file				*
;*    d1.w = handle of uncompressed file				*
;*    d2.l = Length of uncompressed file				*
;*  All other registers are stored, and restored				*
;************************************************************************
pk92lib::ExtractA	EQU	pk92lib@0002
