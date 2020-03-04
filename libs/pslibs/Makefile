CC=tigcc
ASM=tigcc
RM=rm -f
MV=mv -f
CP=cp

INCLUDES=-WA,-i../../sdk/include

.PHONY: all clean

all: clean gray4lib gray7lib util hufflib triglib linelib

distclean: clean

clean:
	$(RM) *.89z *.9xz *.v2z *.89Z *.9XZ *.V2Z *~
	$(RM) gray4lib gray7lib util hufflib linelib triglib

gray4lib: gray4lib.asm
	$(ASM) $(INCLUDES) gray4lib.asm 
	$(CP) gray4lib.9xz gray4lib

gray7lib: gray7lib.asm
	$(ASM) $(INCLUDES) gray7lib.asm 
	$(CP) gray7lib.9xz gray7lib

util:	util.asm
	$(ASM) $(INCLUDES) util.asm
	$(CP) util.9xz util

hufflib: hufflib.asm
	$(ASM) $(INCLUDES) hufflib.asm
	$(CP) hufflib.9xz hufflib

triglib: triglib.asm
	$(ASM) $(INCLUDES) triglib.asm
	$(CP) triglib.9xz triglib

linelib: linelib.asm
	$(ASM) $(INCLUDES) linelib.asm
	$(CP) linelib.9xz linelib
