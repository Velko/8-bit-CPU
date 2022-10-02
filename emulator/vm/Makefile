all: cmd_handler.vvp serial_conn.vpi

include ../cpu-modules/Modules.mk

run: cmd_handler.vvp serial_conn.vpi
	vvp -M. -mserial_conn cmd_handler.vvp

serial_conn.vpi: serial_cmd.c registration.c serial_host.c
	iverilog-vpi --name=serial_conn $^

CMDSRC=$(CPUSRC) cmd_handler.v cword.vinc

cmd_handler.vvp: $(CMDSRC)
	iverilog -Wall $^ -o $@

clean:
	rm -rf *.vpi *.o *.vvp
