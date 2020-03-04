###############################################################################
### GENLIB MAKEFILE ###########################################################
###############################################################################

CC=tigcc
CFLAGS=-Os -fomit-frame-pointer -Wall
CPPFLAGS=-I../include/c/
ASM=tigcc
RM=rm -f
MV=mv -f
CP=cp

all: clean zpack zunpack

distclean: clean

clean:
	$(RM) *.89z *.9xz *.v2z *~
	$(RM) zpack zunpack

zpack:	zpack.c
	$(CC) $(CFLAGS) $(CPPFLAGS) zpack.c
	$(CP) zpack.89z zpack

zunpack: zunpack.c
	$(CC) $(CFLAGS) $(CPPFLAGS) zunpack.c
	$(CP) zunpack.89z zunpack
