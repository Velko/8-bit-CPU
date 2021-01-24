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

%.elf : $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@

%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@

%.hex : %.elf
	$(OBJ2HEX) -R .eeprom -O ihex $< $@

clean :
	rm -f *.hex *.elf *.o *~
