##############################################################################
### PREOS MAKEFILE ###########################################################
##############################################################################

CC=tigcc
ASM=tigcc
RM=rm -f
MV=mv -f
CP=cp
HW2TSR=-WA,-vhw2tsr hw2tsr/h220xtsr.a

### GENERAL RULES #############################################################


.PHONY: all clean

all: clean preos

distclean: clean

clean:
	$(RM) preos.89z preos.9xz preos.v2z *~
	$(RM) preos

hw2tsr/h220xtsr.a: hw2tsr/h220xtsr.asm hw2tsr/h220xtsr.h
	cd hw2tsr && $(ASM) h220xtsr.asm -ar

preos:	check.asm  install.asm  parser.asm  preos.asm  sams.asm  sld.asm  svector.asm  uninstal.asm hw2tsr/h220xtsr.a
	$(ASM) preos.asm $(HW2TSR)
	$(CP) preos.9xz preos
	$(MV) preos.89z preos.9xz preos.v2z ..
