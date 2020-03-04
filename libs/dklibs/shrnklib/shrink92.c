/*
; SHRINK92 - Copyright 1998, 1999 David Kuehling
; Adaptation for TI-89/92+ - Copyright 2002, 2003, 2004, 2005 Patrick Pelissier
; Fix portability issue - COpyright 2005 Patrick Pelissier
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
 * This is the source file of the command line interface for `SHRINK.C's
 * compression routines. Watch `SHRINK.C' and `SHRINK.H' for more information.
 *
 */

/****************************************************************************/
#include "shrink.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <stdarg.h>
#include <time.h>
#include <ctype.h>
/****************************************************************************/


#define VERSION "1.00"

/****************************************************************************/
char    OutputName[512] = "",   // name of output file
        *InputNames[MAX_FILES], // names of input files
        IncludeName[512] = "";  // name of include file to create

int     Verify = 0,             // `-v' - option is specified
        Merge = 0,              // `-m' - option is specified
        InputNameNum = 0,       // number of input file names
        ArchiveParts;           // number of sections in the archive

long    FileLengths[MAX_FILES], // lengths of the input files
        InputLengths[MAX_FILES],// lengths of the input data
        InputOffsets[MAX_FILES];// offsets of the input files, in case that
                                // they've been merged (`-v' - option)
/****************************************************************************/

void *xmalloc (size_t num)
{
  void  *a0;
  a0 = malloc (num);
  if (a0 == NULL)
    {
      fprintf (stderr, "Error: can't allocate %lu bytes\n", 
               (unsigned long) num);
      abort ();
    }
  return a0;
}

char *strupr (char *string)
{
  char *org = string;
  while (*string)
    *string++ = toupper (*string);
  return org;
}

/**
 * Return size of file. This routine requires `filelength' from `io.h'. If
 * that routine isn't supported by your C-compiler, replace `FileLength' by
 * a routine, that seeks to the end of a file, stores that file position,
 * restores the previous position and returns the stored value.
 */
long FileLength (FILE *h)
{
  long orgpos, len;

  orgpos = ftell (h);
  fseek (h, 0, SEEK_END);
  len = ftell (h);
  fseek (h, orgpos, SEEK_SET);
  return len;
  /* return (filelength (fileno (h))); */
}

/**
 * Print an error message in printf - format and exit with exit code 1.
 */
void ErrorExit (char *format, ...)
{
  va_list arg;

  va_start (arg, format);
  fputs ("\nERROR: ", stderr);
  vfprintf (stderr, format, arg);
  va_end (arg);
  fputs ("\n\n", stderr);
  exit (1);
}

/**
 * Read all the input files, given by `InputNames' into the array of pointers
 * `data'. Set `sizes' to the sizes of the files. Return the sum of the sizes.
 */
long ReadFiles (unsigned char *data[], long sizes[])
{
  int  I;
  long sum = 0;
  FILE *h;
  
  for (I = 0; I < InputNameNum; I++)
    {
      if ((h = fopen (InputNames[I], "rb")) == NULL)
	ErrorExit ("Can't open file `%s': %s", InputNames[I], strerror (errno));
      
      sum += (sizes[I] =  FileLength (h));
      data[I] = malloc (sizes[I]);
      
      
      if (fread (data[I], 1, sizes[I], h) == -1)
	ErrorExit ("Can't read file `%s' : %s", InputNames[I], strerror (errno));
      
      fclose (h);
    }
  
  return (sum);
}

/**
 * Merge the data from `data' with the lengths `sizes', set `*merged' to the
 * memory location where the merged data are. Also set `offsets' to the
 * offsets of each of the data within the merged data. The data of `data'
 * are freed, using `free'.
 * It is expected that data contains as many entries as `InputNameNum'.
 */
void MergeData (unsigned char *data[], long sizes[],
                unsigned char **merged, long offsets[])
{
   unsigned char *mergedData;
   long          offset,        // current offset
                 sum;           // sum of `sizes'
   int           I;

   for (I = sum = 0; I < InputNameNum; sum += sizes[I++]);

   mergedData = malloc (sum);

   for (I = offset = 0; I < InputNameNum; I++)
   {
      memcpy (mergedData+offset, data[I], sizes[I]);
      free (data[I]);
      offsets[I] = offset;
      offset += sizes[I];
   }

   *merged = mergedData;
}

/**
 * Verify, whether the data `data' are the same as in the archive `arc'.
 * (The number of files in the archive is expected to be `InputNameNum'.
 */
void VerifyArchive (unsigned char *data[], unsigned char *arc)
{
   int I;
   unsigned char *extr;          // extracted archive section
   long          extrSize;       // size of extracted archive section

   static char   *errors[] = {   // extraction error strings
      "",
      "Not enough memory for extraction during verification.",
      "",
      "",
      "",
      "Created archive is invalid. Please contact me."
   };

   for (I = 0; I < ArchiveParts; I++)
   {
      printf ("  Extracting section #%i of archive...", I); fflush (stdout);
      extrSize = Extract (arc, I, &extr);
      if (extrSize == -1)
         ErrorExit (errors[ShrinkError]);

      printf (" checking..."); fflush (stdout);
      if (memcmp (extr, data[I], extrSize))
         ErrorExit ("Extracted section doesn't match source. Please contact me.");

      printf (" ok.\n");
      free (extr);
   }
}

/**
 * Output the archive `arc' with the size `size' to `OutputName'.
 */
void OutputArchive (unsigned char *arc, long size)
{
   FILE *h;

   if ((h = fopen (OutputName, "wb")) == NULL)
      ErrorExit ("Can't create archive `%s': %s", OutputName, strerror (errno));

   if (fwrite (arc, 1, size, h) == -1)
      ErrorExit ("Can't write to archive '%s': %s", OutputName, strerror (errno));

   fclose (h);
}

/**
 * Compress the files, given by `InputNames' to `OutputName'.
 * If `IncludeName' is not NULL also create an include file.
 */
void CompressFiles ()
{
   unsigned char *inputData[MAX_FILES], // file contents
                 *archive;              // archive contents
   int           I;

   static char   *errors[] = {          // compression error strings
      "",
      "Not enough memory for compression.",
      "Too many input files.",
      "Input file too long (greater than 65535 bytes).",
      "Archive became too long (an offset overflowed 65535)."
   };

   long          archiveSize,
                 totalSize;

   printf ("Reading file%s...\n", InputNameNum > 1 ? "s" : "");
   totalSize = ReadFiles (inputData, FileLengths);
   ArchiveParts = InputNameNum;
   memcpy (InputLengths, FileLengths, sizeof(FileLengths));

   if (Merge)
   {
      printf ("Merging files...\n");
      MergeData (inputData, InputLengths, inputData, InputOffsets);
      ArchiveParts = 1;
      InputLengths[0] = totalSize;
   }

   archiveSize = Compress (inputData, InputLengths, ArchiveParts, &archive);

   if (archiveSize == -1)
      /** there was a compression error */
      ErrorExit (errors[ShrinkError]);

   if (Verify)
   {
      printf ("Verifying archive...\n");
      VerifyArchive (inputData, archive);
   }

   printf ("Creating archive `%s'...\n", OutputName);
   OutputArchive (archive, archiveSize);

   printf ("  %li bytes in %i file%s compressed to %li bytes in %i archive section%s.\n  Total ratio: %3.2f%%\n",
            totalSize, InputNameNum, InputNameNum > 1 ? "s" : "",
            archiveSize, ArchiveParts, ArchiveParts > 1 ? "s" : "",
            (double) (totalSize-archiveSize)*100 / totalSize);

   /** free memory */
   free (archive);
   for (I = 0; I < ArchiveParts; free (inputData[I++]));
}

/**
 * Create the include file for archive access.
 */
void CreateIncludeFile ()
{
   FILE *h;
   int  I;
   char *name;  // pointer to name-component of an archive input file's path
   time_t now;

   if ((h = fopen (IncludeName, "wt")) == NULL)
      ErrorExit ("Can't create include-file `%s': %s", IncludeName, strerror (errno));

   time(&now);
   fprintf (h, ";=============================================================================\n");
   fprintf (h, "; Include file automatically created by SHRINK92   %s", asctime(localtime(&now)));
   fprintf (h, "; Purpose: access of archive `%s'\n", OutputName);
   fprintf (h, "; That archive consists of %i file%s in %i section%s.\n",
                  InputNameNum, InputNameNum > 1 ? "s" : "",
                  ArchiveParts, ArchiveParts > 1 ? "s" : "");
   fprintf (h, ";=============================================================================\n\n");

   for (I = 0; I < InputNameNum; I++)
   {
      /** get name component of input file name */
      name = strrchr (InputNames[I], '/');
      name = name == NULL ? strrchr (InputNames[I], '\\') : name;
      name = name == NULL ? strrchr (InputNames[I], ':') : name;
      name = name == NULL ? InputNames[I] : name+1;
      name = strupr (strcpy (malloc (512), strdup (name)));

      /** output equates for that file name */
      if (Merge)
         fprintf (h, "%-16s   EQU   %5li  ; offset of file in archive section #0\n", name, InputOffsets[I]);
      else
         fprintf (h, "%-16s   EQU   %5i  ; index of archive section\n", name, I);

      fprintf (h, "%-16s   EQU   %5li  ; length of file\n", strcat (name, "_LEN"), FileLengths[I]);
   }

   fclose (h);
}

/**
 * Print a command line help
 */
void Help ()
{
   static char *text[] =
   {
      "SHRINK92 filename [filename filename ...] [-m] [-v] [-i...] [-o...] [-p...]",
      "  filename   Name of input file, may contain wildcards.",
      "  -m         Create archive with one section that contains all files merged.",
      "  -v         Verify archive: extract each section and compare it with it's",
      "             source.",
      "  -i<name>   Create an include-file named `name', containing some equates",
      "             that will help you to access the archive. A different kind of",
      "             include-file is created when you use the `-m' switch.",
      "  -o<name>   Specify the name of the archive to create.",
      NULL
   };
   int I;

   for (I = 0; text[I]; I++)
      puts (text[I]);

   exit (0);
}

/**
 * Read command line arguments and set the corresponding global variables.
 */
int main (int argn, char *argv[])
{
   int I;

   puts ("\t----------------------------------------------------------------");
   puts ("\t          SHRINK92 v"VERSION"  --  by David KÅhling 1998/99");
   puts ("\t----------------------------------------------------------------\n");

   /** read the arguments */
   for (I = 1; I < argn; I++)
   {
      /** options */
      if (argv[I][0] == '-')
      {
         if (sscanf (argv[I]+1, "o%s", OutputName) == 1);
         else if (sscanf (argv[I]+1, "i%s", IncludeName) == 1);
         else if (!strcmp ("v", argv[I]+1)) Verify = 1;
         else if (!strcmp ("m", argv[I]+1)) Merge = 1;
         else if (!strcmp ("?", argv[I]+1)) Help ();
         else
            ErrorExit ("Invalid argument: `%s'\nType SHRINK92 -? for help", argv[I]);
      }
      /** input file names */
      else
      {
         InputNames[InputNameNum] = argv[I];
         if (++InputNameNum > MAX_FILES)
            ErrorExit ("Too many input files.");
      }
   }

   /** do some argument checking... */
   if (!InputNameNum)
      ErrorExit ("No input files specified.");
   if (!OutputName[0])
      ErrorExit ("No output file specified.");
   if (Merge && InputNameNum == 1)
      ErrorExit ("File merging is futile with one input file.");
   if (Merge && !IncludeName[0])
      printf ("WARNING: merged files can't be accessed separated without an include-file.\n");

   CompressFiles ();
   if (IncludeName[0])
   {
      printf ("Creating include file `%s'...\n", IncludeName);
      CreateIncludeFile ();
   }

   return (0);
}


