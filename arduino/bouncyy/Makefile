PROGRAMMER=usbasp
TARGET=bouncyy
OBJS=main.o
PART_PROG=t25
PART_GCC=attiny25

CC=/usr/bin/avr-gcc
CFLAGS=-g -Os -Wall -mcall-prologues -mmcu=$(PART_GCC)
OBJ2HEX=/usr/bin/avr-objcopy
DUDE=/usr/bin/avrdude

all: $(TARGET).hex

upload : $(TARGET).hex
	$(DUDE) -p $(PART_PROG) -c $(PROGRAMMER) -y -U flash:w:$(TARGET).hex

fuses:
	# default fuse values for ATTiny25/45 are E:FF, H:DF, L:62
	# need to switch off CKDIV8 bit only, USBasp has to be slowed down (using -B 3)
	# as by default it is too fast for default 1 MHz clock
	$(DUDE) -p $(PART_PROG) -c $(PROGRAMMER) -B 3 -U lfuse:w:0xE2:m -U hfuse:w:0xDF:m

%.elf : $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@

%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@

%.hex : %.elf
	$(OBJ2HEX) -R .eeprom -O ihex $< $@

clean :
	rm -f *.hex *.elf *.o *~
