CC=tigcc
ASM=tigcc
RM=rm -f
MV=mv -f
CP=cp

INCLUDES=-WA,-i../../sdk/include

.PHONY: all clean

all: clean graphlib userlib filelib ziplib

distclean: clean

clean:
	$(RM) *.89z *.9xz *.v2z *.89Z *.9XZ *.V2Z *~
	$(RM) graphlib userlib filelib ziplib

graphlib: graphlib.asm
	$(ASM) $(INCLUDES) graphlib.asm 
	$(CP) graphlib.9xz graphlib

userlib: userlib.asm
	$(ASM) $(INCLUDES) userlib.asm
	$(CP) userlib.9xz userlib

filelib: filelib.asm
	$(ASM) $(INCLUDES) filelib.asm
	$(CP) filelib.9xz filelib

ziplib: ziplib.asm
	$(ASM) $(INCLUDES) ziplib.asm
	$(CP) ziplib.9xz ziplib

