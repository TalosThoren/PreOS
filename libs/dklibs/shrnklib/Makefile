CC=gcc
CFLAGS=-O2 -fomit-frame-pointer -Wall
ASM=tigcc
RM=rm -f
MV=mv -f
CP=cp

INCLUDES=-WA,-i../../../sdk/include

.PHONY: all clean

all: clean shrnklib shrink92

distclean: clean

clean:
	$(RM) *.89z *.9xz *.v2z *.89Z *.9XZ *.V2Z *~
	$(RM) shrnklib shrink92

shrnklib: shrnklib.asm
	$(ASM) $(INCLUDES) shrnklib.asm 
	$(CP) shrnklib.9xz shrnklib

shrink92: shrink92.c shrink.c shrink.h
	$(CC) $(CFLAGS) shrink92.c shrink.c shrink.h -o shrink92
