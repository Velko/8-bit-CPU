OBJS=xmclient.o cmd.o serial.o pexec.o

CFLAGS=-g -Og
LD=gcc
LDFLAGS=-g


all: xmclient

xmclient: $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@


clean:
	rm -rf *.o xmclient