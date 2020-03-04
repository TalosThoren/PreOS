CC=gcc
CXX=g++
CFLAGS=-O2 -fomit-frame-pointer -Wall -static
RM=rm -rf

all: kpack

clean:
	$(RM) kpack *~ _kpack.asm

distclean: clean

kpack: kpack.c shrink.c shrink.h
	$(CC) $(CFLAGS) kpack.c shrink.c -o kpack
