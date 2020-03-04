CC=gcc
CFLAGS=-O2 -fomit-frame-pointer -Wall
ASM=tigcc
RM=rm -f
MV=mv -f
CP=cp

INCLUDES=-WA,-i../../../sdk/include

.PHONY: all clean

all: clean pk92lib

distclean: clean

clean:
	$(RM) *.89z *.9xz *.v2z *.89Z *.9XZ *.V2Z *~
	$(RM) pk92lib

pk92lib: pk92lib.asm
	$(ASM) $(INCLUDES) pk92lib.asm 
	$(CP) pk92lib.9xz pk92lib

# TODO: Build packer92. Needs sources.
