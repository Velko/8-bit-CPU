all: microcode digits

MCODE_OBJS=microcode.o microcode_eeproms.o
DIG_OBJS=segment_digits.o

CFLAGS=-g -Og
LD=gcc
LDFLAGS=-g

microcode: $(MCODE_OBJS)
	$(LD) $(LDFLAGS) $(MCODE_OBJS) -o $@

digits: $(DIG_OBJS)
	$(LD) $(LDFLAGS) $(DIG_OBJS) -o $@

clean:
	rm -rf *.o microcode digits


