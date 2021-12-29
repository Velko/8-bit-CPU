all: cmd_handler.vvp vm_plugin.vpi

include ../cpu-modules/Modules.mk

run: cmd_handler.vvp vm_plugin.vpi
	vvp -M. -mvm_plugin cmd_handler.vvp

vm_plugin.vpi: serial_cmd.cpp control_words.cpp registration.cpp serial_host.cpp arduino_string.cpp
	iverilog-vpi --name=vm_plugin $^

CMDSRC=$(CPUSRC) cmd_handler.v

cmd_handler.vvp: $(CMDSRC)
	iverilog -Wall $^ -o $@

clean:
	rm -rf *.vpi *.o *.vvp
