/*
 * KPACK - for Ti-89ti/Ti-89/Ti-92+/V200.
 * Copyright (C) 2005, 2009 Patrick Pélissier
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the 
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version. 
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details. 
 *
 * You should have received a copy of the GNU General Public License 
 * along with this program; if not, write to the 
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA 
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "shrink.h"

#define SHRNKLIB_VERSION  3
#define SHRNKLIB_FUNCTION 3
#define SHRNKLIB_NAME "shrnklib"

#define MAX_FILE	256
#define MAX_FILESIZE    70000

#define TI_HEADER_BEGIN_SIZE 86
#define TI_HEADER_END_SIZE    2

FILE	*FNAME = NULL;

/* The smallest usuable FILE for TI */
const unsigned char DummyFile[4] = {0, 2, 0, 0xF8};

/* Add a file to be compressed */
int numfiles = 0;
const unsigned char *fileData[MAX_FILE];
long           fileSizes[MAX_FILE];
const unsigned char *fileOrgData[MAX_FILE];
long           fileOrgSizes[MAX_FILE];
char	       StaticArc[MAX_FILE];

void *xmalloc (size_t num)
{
  void	*a0;
  a0 = malloc (num);
  if (a0 == NULL)
    {
      fprintf (stderr, "Error: can't allocate %lu bytes\n", 
	       (unsigned long) num);
      abort ();
    }
  return a0;
}

void Add (const char *name) {
  FILE *f;
  unsigned char *buffer;
  long num;
  char static_flag;
  int i;

  /* Alloc buffer for file */
  buffer = xmalloc (MAX_FILESIZE);

  /* Open file */
  static_flag = *name == '!';
  f = fopen (name + static_flag, "rb");
  if (f == NULL) {
    fprintf (stderr, "Can't open file %s\n", name);
    exit (-2);
  }
  num = fread (buffer, sizeof(char), MAX_FILESIZE, f);
  fclose (f);
  if (num >= MAX_FILESIZE) {
    fprintf (stderr, "Filesize %s is too big\n", name);
    exit (-3);
  }
  if (num < TI_HEADER_BEGIN_SIZE)
    {
      fprintf (stderr, "Error : input file %s too small!", name);
      exit (-4);
    }

  /* Add File in FILE list */
  if (static_flag)
    fprintf(FNAME," dc.b '!',(Static%d-MainRef)&255,(Static%d-MainRef)/256,\"",
	    numfiles, numfiles);
  else
    fprintf (FNAME, " dc.b \"");
  name = (char*) buffer + 64;
  for (i = 0; i < 8 && *name; i++, name++)
    fputc(tolower (*name), FNAME);
  fprintf (FNAME, "\",0\n");

  /* Setup it */
  fileOrgData[numfiles] = buffer + TI_HEADER_BEGIN_SIZE;
  fileOrgSizes[numfiles] = num - TI_HEADER_BEGIN_SIZE - TI_HEADER_END_SIZE;
  StaticArc[numfiles] = static_flag;
  if (static_flag)
    {
      fileData[numfiles] = DummyFile;
      fileSizes[numfiles] = sizeof DummyFile;
    }
  else
    {
      fileData[numfiles] = buffer + TI_HEADER_BEGIN_SIZE;
      fileSizes[numfiles] = num - TI_HEADER_BEGIN_SIZE - TI_HEADER_END_SIZE;
    }

  numfiles ++;
  if (numfiles >= MAX_FILE)
    {
      fprintf (stderr, "Too many file in archive.\n");
      exit (-5);
    }
}

void AddBinary (const char *label, const unsigned char *data, long num)
{
  long i, k;
  fprintf (FNAME, "  EVEN\n%s:\n", label);
  k = 0;
  for (i = 0 ; i < num ; i++, k--)
    {
      if (k == 0)
	{
	  fprintf (FNAME, "\n  dc.b ");
	  k = 16;
	}
      else
	fprintf (FNAME, ",");
      fprintf (FNAME, "%d", data[i]);
    }
  fprintf (FNAME, "\n\n");
}

void BeginFile (const char *filename, int num)
{
  FNAME = fopen (filename, "w");
  if (FNAME == NULL)
    {
      fprintf (stderr, "Can't open '%s' for writting.\n", filename);
      exit (-6);
    }

  fprintf (FNAME,
	   "_nostub:    xdef _nostub   \n"
	   "_ti89:      xdef _ti89     \n"
	   "_ti92plus:  xdef _ti92plus \n"
	   "_v200:      xdef _v200     \n"
	   "_ti89ti:    xdef _ti89ti   \n\n"
	   "            bsr.s  Loader  \n"
	   "MainRef:    dc.l   '68cA'  \n"
	   "Loader:     move.l ($50).w,-(a7) \n"
	   "            bne.s  Go      \n"
	   "            addq.l #8,a7   \n"
	   "Go:         rts            \n\n"
	   "            dc.b   %d,%d,%d\n"
	   "            dc.b   \"%s\",0\n",
	   num, SHRNKLIB_VERSION, SHRNKLIB_FUNCTION, SHRNKLIB_NAME);
}

void EndFile (void)
{
  unsigned char *compressed_data;
  long num;
  char Buffer[100];
  int i;

  /* Compress the data */
  num = Compress ((unsigned char **) fileData, fileSizes, numfiles, &compressed_data);
  if (num == -1) {
    fprintf (stderr, "Error while compressing. ShrinkError=%d\n", (int)ShrinkError);
    exit (-8);
  }

  /* Check */
  unsigned char*file0;
  long file0_s = Extract (compressed_data, 0, &file0);
  if (file0_s != fileSizes[0]
      || memcmp (fileData[0], file0, file0_s) != 0) {
    fprintf (stderr, "FATAL INTERNAL ERROR while compressing. ShrinkError=%d\n", (int)ShrinkError);
    exit (-9);
  }
  free (file0);

  /* Add it */
  AddBinary ("compress", compressed_data, num);
  free (compressed_data);

  /* Add the static archive */
  for(i = 0 ; i < numfiles ; i++)
    if (StaticArc[i])
      {
	sprintf (Buffer, "Static%d", i);
	AddBinary (Buffer, fileOrgData[i], fileOrgSizes[i]);
      }
  fprintf(FNAME, " END\n");
  fclose (FNAME);
}

int main(int argc, char *argv[]) {
  char tampon[1000];
  int i;

  printf ("Create asm auto-extractible program or archive files (shrink92)\n"
	  "VERSION 3 - Preos 0.72\n"
	  "Usage:   kpack infile1 infile2 infile... outfile\n"
	  "Example: kpack graphlib.9xz userlib.9xz doorslib\n"
	  "If a file is preceded by '!', it won't be compressed.\n");

  if (argc < 3) {
    printf("Bad number of arguments.\n");
    exit (1);
  }

  BeginFile ("_kpack.asm", argc-2);
  for (i = 1 ; i < argc-1 ; i++)
    Add (argv[i]);
  EndFile ();

  sprintf (tampon, "tigcc _kpack.asm -o %s", argv[argc-1]);

  return system (tampon);
}
