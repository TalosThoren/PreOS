CC=tigcc
ASM=tigcc
RM=rm -f
MV=mv -f
CP=cp

INCLUDES=-WA,-i../../sdk/include

.PHONY: all clean

all: clean genclib

distclean: clean

clean:
	$(RM) genclib genclib.9xz genclib.89z genclib.v2z *~

genclib: genclib.asm
	$(ASM) $(INCLUDES) genclib.asm 
	$(CP) genclib.9xz genclib
