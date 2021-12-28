all: cmd_handler.vvp serial_cmd.vpi

include ../cpu-modules/Modules.mk

run: cmd_handler.vvp serial_cmd.vpi
	vvp -M. -mserial_cmd cmd_handler.vvp

serial_cmd.vpi: serial_cmd.cpp serial_host.cpp arduino_string.cpp
	iverilog-vpi $^

CMDSRC=$(CPUSRC) cmd_handler.v

cmd_handler.vvp: $(CMDSRC)
	iverilog -Wall $^ -o $@

clean:
	rm -rf *.vpi *.o *.vvp
