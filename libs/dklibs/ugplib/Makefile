CC=gcc
CFLAGS=-O2 -fomit-frame-pointer -Wall
ASM=tigcc
RM=rm -f
MV=mv -f
CP=cp

INCLUDES=-WA,-i../../../sdk/include

.PHONY: all clean

all: clean ugpbrwse ugplib

distclean: clean

clean:
	$(RM) *.89z *.9xz *.v2z *.89Z *.9XZ *.V2Z *~
	$(RM) ugpbrwse ugplib

ugplib: ugplib.asm
	$(ASM) $(INCLUDES) ugplib.asm 
	$(CP) ugplib.9xz ugplib

ugpbrwse: ugpbrwse.asm
	$(ASM) $(INCLUDES) ugpbrwse.asm

