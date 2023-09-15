all: cmd_handler.vvp serial_conn.vpi
VPATH=../vpi

all: cmd_handler.vvp serial_conn.vpi

include ../cpu-modules/Modules.mk
include ../vpi/Makefile

run: cmd_handler.vvp serial_conn.vpi control_rom*.hex
	vvp -M. -mserial_conn cmd_handler.vvp

control_rom%.hex:
	../../pycontrol/tools/microcode.py

CMDSRC=$(CPUSRC) cmd_handler.v cword.vinc

cmd_handler.vvp: $(CMDSRC)
	iverilog -Wall $^ -o $@

clean:
	rm -rf *.vpi *.o *.vvp
