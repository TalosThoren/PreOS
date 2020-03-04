CC=tigcc
ASM=tigcc
RM=rm -f
MV=mv -f
CP=cp

.PHONY: all clean

all: 
	cd kpack ; make
	cd zpack ; make
	cd makeprgm ; make

distclean: clean

clean:
	cd kpack ; make clean
	cd zpack ; make clean
	cd makeprgm ; make clean
	$(RM) *~
