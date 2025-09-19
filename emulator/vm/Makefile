VPATH=../vpi

all: launcher.vvp hdb_comm.vpi

include ../cpu-modules/Modules.mk
include ../vpi/Makefile

run: launcher.vvp hdb_comm.vpi control_rom*.hex
	vvp -M. -mhdb_comm launcher.vvp

control_rom%.hex:
	../../pycontrol/tools/microcode.py

CMDSRC=$(CPUSRC) launcher.v

launcher.vvp: $(CMDSRC)
	iverilog -Wall $^ -o $@

clean:
	rm -rf *.vpi *.o *.vvp
