CC=tigcc
ASM=tigcc
RM=rm -f
MV=mv -f
CP=cp

INCLUDES=-WA,-i../../sdk/include

.PHONY: all clean

all: clean fargray

distclean: clean

clean:
	$(RM) *.89z *.9xz *.v2z *.89Z *.9XZ *.V2Z *~
	$(RM) fargray

fargray: fargray.asm
	$(ASM) $(INCLUDES) fargray.asm 
	$(CP) fargray.9xz fargray

