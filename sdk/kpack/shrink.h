/*
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
*/

/*
 * Header file of the compression/extraction module `SHRINK.C'.
 *
 */


/**
 *    Compression
 *
 * Create a Shrink - Archive.
 * Archives consist of one or more sections. Each section can be uncompressed
 * separated from the others, although they  partially use the same compression
 * data. The sections may represent different input files, like you know it
 * from other archiving programs.
 *
 *   Arguments:
 *
 * inputs     List of pointers to input data. Each pointer's data are put into
 *            an extra archive section.
 * inputSizes A list containing the number of bytes that belong to the pointers
 *            of `inputs'.
 * inputNum   The number of input sedctions. (the size of the lists `inputs'
 *            and `outputs')
 * output     A pointer to the pointer that points to the compression's output
 *            archive. You will typically pass an arguments like `&ArchivePtr'.
 *            The output memory is allocated by `Compress'. `Compress' will
 *            set `*output' to point to that memory after compression has been
 *            done. You may free that memory by `free'.
 *
 *   Return Value:
 *
 * The size of the archive at `*output' (bytes) or -1 on error. In case of an
 * error `Compress' sets the global variable `ShrinkError' (see below) to the
 * error number.
 */
long Compress (unsigned char *inputs[], long inputSizes[], int inputNum,
               unsigned char **output);

/**
 *    Easy Compression
 *
 * Create a Shrink - Archive, consisting of only one section. This routine is
 * meant to be used by text compressions (like used by TXTSurf and XeTaL).
 *
 *   Arguments:
 *
 * input     Pointer to the input data.
 * number    Number of bytes in the input data.
 * output    Pointer to the output-data-pointer. The output-data-pointer is
 *           adjusted to point to the memory allocated for the output archive.
 *           You may free that memory by `free'. You will typically pass an
 *           argument such as `&ArchivePtr'.
 *
 *   Return Value:
 *
 * The number of bytes in the output archive or -1 on error. If an error
 * occures, `ShrinkError' (see below) is set to the corresponding error
 * number.
 */
long EasyCompress (unsigned char *input, long number, unsigned char **output);

#define  MAX_FILES 256     /* maximum number of files in an archive */


/**
 *    Extraction
 *
 * Extract one section from an archive, created by `Compress' or
 * `EasyCompress'.
 *
 *   Arguments:
 *
 * input     Pointer to the input archive.
 * fileN     number of the section to uncompress (0 = 1st section, 1 = 2nd...)
 * output    Pointer to the output-pointer. The output-pointer is adjusted
 *           to point to the memory region that has been allocated by
 *           `Extract' to hold the extracted section. You may free that memory
 *           by `free'. A typical value is `&ExtractedFile'
 *
 *   Return Value:
 *
 * The number of bytes in `*output' or -1 on error. If an error occures
 * `ShrinkError' (see below) is set to the corresponding error number.
 */
long Extract (unsigned char *input, int fileN, unsigned char **output);

/**
 *    Compression/Extraction Error Number
 */
extern enum ERROR_NUM
{
   NO_ERROR = 0,    // there is no error
   MEMORY,          // not enough memory
   TOO_MANY_FILES,  // too many input files (compression only)
   INPUT_SIZE,      // an input file is too big (compression only)
   OUTPUT_SIZE,     // the output archive is too big (compression only)

   FORMAT,          // illegal archive format (extraction only)
} ShrinkError;


/**
 *    Compression Callback Routine Pointer
 *
 * Can be used for displaying progress indicator and compression ratios for
 * each file. The argument of the callback routine is:
 *
 *   progress:       a value between 0 and 1000 that indicates the compression
 *                   progress: 0= compression begin, 1000= end of compression
 *
 * By default this pointer points to `DefaultComprInfo'. (see below)
 * If you don't want any information to be displayed, set the pointer to NULL.
 */
extern void  (*ComprInfo) (int progress);

/**
 *    Default Compression Callback Routine
 *
 * Just output progress information to stdout.
 */
void DefaultComprInfo (int);
