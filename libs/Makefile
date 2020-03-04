CC=tigcc
ASM=tigcc
RM=rm -f
MV=mv -f
CP=cp

STDLIB=dolibs/filelib.9xz dolibs/graphlib.9xz dolibs/userlib.9xz \
       dolibs/ziplib.9xz t3libs/genlib.9xz t3libs/genalib.9xz    \
       t3libs/genclib.9xz dklibs/pk92lib/pk92lib.9xz hexlib.9xz  \
       dklibs/brwselib/brwselib.9xz dklibs/ugplib/ugplib.9xz     \
       pslibs/gray4lib.9xz pslibs/gray7lib.9xz pslibs/util.9xz   \
       pslibs/triglib.9xz pslibs/linelib.9xz pslibs/hufflib.9xz

INCLUDES=-WA,-i../sdk/include

.PHONY: all clean

all: clean hexlib shell stdlib

distclean: clean

clean:
	$(RM) *.89z *.9xz *.v2z *.89Z *.9XZ *.V2Z *~
	$(RM) hexlib shell _kpack.asm stdlib
	cd dolibs ; make clean 
	cd pslibs ; make clean
	cd dklibs/brwselib ; make clean
	cd dklibs/pk92lib ; make clean
	cd dklibs/shrnklib ; make clean
	cd dklibs/ugplib ; make clean
	cd fargray ; make clean
	cd t3libs ; make clean

hexlib:	hexlib.asm
	$(ASM) $(INCLUDES) hexlib.asm 
	$(CP) hexlib.9xz hexlib

shell: shell.asm
	$(ASM) $(INCLUDES) shell.asm
	$(CP) shell.9xz shell

stdlib: hexlib shell
	cd dolibs ; make graphlib userlib filelib ziplib
	cd pslibs ; make gray4lib gray7lib linelib triglib util hufflib
	cd dklibs/brwselib ; make brwselib
	cd dklibs/pk92lib ; make pk92lib
	cd dklibs/shrnklib ; make shrnklib
	cd dklibs/ugplib ; make ugplib
	cd fargray ; make fargray
	cd t3libs ; make genclib
	cd ../sdk/kpack ; make 
	../sdk/kpack/kpack shell.9xz $(STDLIB) !comment.9xs !dklibs/shrnklib/shrnklib.9xz stdlib
	$(CP) stdlib.9xz stdlib
	$(MV) stdlib.* ..
	$(RM) _kpack.asm
