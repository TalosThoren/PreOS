RM=rm -f
MV=mv -f
CP=cp -f
MKDIR=mkdir -f
ZIP=zip -rq
VERSION=1.0.9

.PHONY: all clean

all: 
	cd src ; make
	cd sdk ; make
	cd libs ; make

distclean: clean

clean:
	cd src ; make clean
	cd sdk ; make clean
	cd libs ; make clean
	$(RM) *~ *.89z *.9xz *.v2z *.89Z *.9xZ *.V2Z

dist: all
	$(RM) -r preos-$(VERSION)
	mkdir preos-$(VERSION)
	$(CP) *.89z *.9xz *.v2z preos-$(VERSION)/
	$(CP) preos.txt ChangeLog.txt COPYING.LIB COPYING.txt preos-$(VERSION)/
	$(ZIP) preos-$(VERSION).zip preos-$(VERSION)
	$(RM) -r preos-$(VERSION)

