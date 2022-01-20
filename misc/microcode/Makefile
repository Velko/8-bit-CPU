all: microcode

MCODE_OBJS=microcode.o microcode_eeproms.o

CFLAGS=-g -Og
LD=gcc
LDFLAGS=-g

microcode: $(MCODE_OBJS)
	$(LD) $(LDFLAGS) $(MCODE_OBJS) -o $@

clean:
	rm -rf *.o microcode


