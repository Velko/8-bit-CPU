all: digits

DIG_OBJS=segment_digits.o

CFLAGS=-g -Og
LD=gcc
LDFLAGS=-g

digits: $(DIG_OBJS)
	$(LD) $(LDFLAGS) $(DIG_OBJS) -o $@

clean:
	rm -rf *.o digits


