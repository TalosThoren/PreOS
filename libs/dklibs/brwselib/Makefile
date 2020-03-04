CC=tigcc
ASM=tigcc
RM=rm -f
MV=mv -f
CP=cp

INCLUDES=-WA,-i../../../sdk/include

.PHONY: all clean

all: clean brwselib

distclean: clean

clean:
	$(RM) *.89z *.9xz *.v2z *.89Z *.9XZ *.V2Z *~
	$(RM) brwselib

brwselib: brwselib.asm
	$(ASM) $(INCLUDES) brwselib.asm 
	$(CP) brwselib.9xz brwselib
