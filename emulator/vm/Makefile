VPATH=../vpi

all: launcher.vvp serial_conn.vpi

include ../cpu-modules/Modules.mk
include ../vpi/Makefile

run: launcher.vvp serial_conn.vpi control_rom*.hex
	vvp -M. -mserial_conn launcher.vvp

control_rom%.hex:
	../../pycontrol/tools/microcode.py

CMDSRC=$(CPUSRC) launcher.v

launcher.vvp: $(CMDSRC)
	iverilog -Wall $^ -o $@

clean:
	rm -rf *.vpi *.o *.vvp
