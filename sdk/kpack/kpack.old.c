/*
 * KPACK - for Ti-89ti/Ti-89/Ti-92+/V200.
 * Copyright (C) 2003, 2004, 2005 PpHd
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

/* TODO: Don't use system command... */

#define SHRNKLIB_VERSION  3
#define SHRNKLIB_FUNCTION 3
#define SHRNKLIB_NAME "shrnklib"

#define MAX_FILE	256

int	n = 0;
FILE	*FNAME = NULL;

int	s = 0;
char	StaticArc[MAX_FILE];

unsigned char	DummyFile[4] = {2,0,0,0xF8};

void    add_file(char *folder, char *name)
{
  int i;
  fprintf (FNAME, " dc.b \"");
  for (i = 0; i < 8 && *name; i++, name++)
    fputc(tolower(*name), FNAME);
  fprintf (FNAME, "\",0\n");
}

FILE	*xfopen(const char *Name, const char *arg)
{
  FILE *F;
  if (!(F=fopen(Name,arg)))
    {
      printf("Error : can't open %s with %s \n",Name,arg);
      exit(-1);
    }
  return F;
}

void	*xmalloc(size_t num)
{
  static	int total=0;
  void	*a0;
  if (!(a0=malloc(sizeof(char)*num)))
    {
      printf("Error : can't allocate %u bytes (%u bytes allocated)\n",num,total);
      exit(-1);
    }
  total+=(long) num;
  return a0;
}

void    extract_header(const char *file) {
  FILE *F;
  char *a0;
  char *tampon;
  char str[100];
  long num;
  
  a0 = 86 + (tampon = (char *) xmalloc(sizeof(char) * 70000));
  
  if (*file != '!')
    {
      F = xfopen(file,"rb");				// Read file 
      num = fread(tampon, sizeof(char), 70000, F);
      fclose(F);
      
      sprintf(str,"temp%d.$$$",n);				// Nom
      add_file(tampon + 10, tampon + 64);			// Ajoute nom fichier		
      StaticArc[n++] = 0;
    }
  else	{	/* It is a static non compressed files. */
    F = xfopen(file+1,"rb");				// Read file 
    num = fread(tampon, sizeof(char), 70000, F);
    fclose(F);
    sprintf(str,"temp%d.$$$",n);		// Add a dummy file
    F = xfopen(str,"wb");			// To avoid some problems in the uncompress function
    fwrite(DummyFile, sizeof(char), 4, F);
    fclose(F);
    sprintf(str,"static%d.$$$",n);		// Add static file
    fprintf(FNAME, " dc.b '!',(Static%d-MainRef)&255,(Static%d-MainRef)/256 \n", n, n);
    add_file(tampon + 10, tampon + 64);			// Ajoute nom fichier		
    StaticArc[n++] = 1;
  }		
  if (num<86) {
    printf("Error : input file %s too small !", file);
    exit(-2);
  }
  F = xfopen(str,"wb");			
  fwrite(a0,sizeof(char),num - 86 - 2,F);
  fclose(F);
  free(tampon);						// Libere memoire
}

int main(int argc, char *argv[]) {
  char command_str[10000] = "shrink92 -v -oout.$$$";
  char tampon[1000];
  int i;

  printf("Create asm auto-extractible program or archive files using shrink92 for Ti-89/Ti-92+.\n"
	 "VERSION 3 - Preos 0.72\n"
	 "Usage: kpack infile1 infile2 infile... outfile\n"
	 "Example: kpack graphlib.9xz userlib.9xz filelib.9xz ziplib.9xz doorslib\n"
	 "If a file is preceded by '!', it won't be compressed.\n");
  
  if (argc < 3) {
    printf("Bad number of arguments.\n");
    exit (1);
  }
  
  /* Starting to work */
  sprintf(tampon, "%s.tmp", argv[argc-1]);
  FNAME = xfopen(tampon,"w");
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
	   argc-2, SHRNKLIB_VERSION, SHRNKLIB_FUNCTION, SHRNKLIB_NAME);
  
  /* Extract the programs */
  for(i = 1 ; i < argc-1 ; i++)
    extract_header (argv[i]);
  fprintf (FNAME, 
	   "            EVEN\n"
	   "            incbin \"out.$$$\"\n");

  /* Add the static files */
  for(i = 1 ; i < n ; i++)
    if (StaticArc[i])
      fprintf(FNAME, 
	      "          EVEN\n"
	      "Static%d: incbin \"static%d.$$$\"\n", i, i);
  fprintf(FNAME, " END\n");
  fclose(FNAME);

  for(i = 0 ; i < n ; i++) {
    sprintf(tampon," temp%d.$$$",i);
    strcat(command_str, tampon);
  }

  /* Compress data */
  printf("EXE: %s\n", command_str);
  system(command_str);

  /* Build the program */
  sprintf(tampon, "a68k -g -t %s.tmp", argv[argc-1]);
  system(tampon);
  sprintf(tampon, "tigcc %s.o", argv[argc-1]);
  system(tampon);	
  system("del *.$$$");
  printf("That's all, folks !\n");

  return 0;
}
