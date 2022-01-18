#
# Target's name
#
TARGET=xmprog

#
# Object files
#
OBJS=main.o uart.o ctimer.o xmprog.o addr_port.o data_port.o flash_hw.o flash_ops.o

#
# MCU name for GCC
#
MCU_GCC=atmega328p

#
# MCU name for programming software
#
MCU_PROG=m328p

#
# Programming hardware and software
#
PROG_HW=arduino
PROG_SW=/usr/bin/avrdude
PROG_PORT=/dev/ttyACM0


CC=/usr/bin/avr-gcc
CXX=/usr/bin/avr-g++
LD=/usr/bin/avr-gcc
CFLAGS=-g -Os -Wall -mcall-prologues -mmcu=$(MCU_GCC)
OBJ2HEX=/usr/bin/avr-objcopy


all: $(TARGET).hex

upload: $(TARGET).hex
	$(PROG_SW) -p $(MCU_PROG) -P $(PROG_PORT) -c $(PROG_HW) -U flash:w:$(TARGET).hex

%.elf: $(OBJS)
	$(LD) $(CFLAGS) $(OBJS) -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

%.o: %.cpp
	$(CXX) -c $(CFLAGS) $< -o $@


%.hex: %.elf
	$(OBJ2HEX) -R .eeprom -O ihex $< $@

clean :
	rm -f $(TARGET).hex $(TARGET).elf $(OBJS)
