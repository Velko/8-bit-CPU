include ../cpu-modules/Modules.mk

VPATH=obj_dir/

all: cpu-server

SRVSRC=main.cpp cpu.cpp cmd_handler.cpp serial_host.cpp arduino_string.cpp
DEMOSRC=demo.cpp cpu.cpp


cpu-server: $(CPUSRC) $(SRVSRC)
	verilator --cc --exe -Wall --top-module cpu $^
	$(MAKE) -C obj_dir -f Vcpu.mk
	cp obj_dir/Vcpu cpu-server

demo: $(CPUSRC) $(DEMOSRC)
	verilator --cc --exe -Wall --top-module cpu $^
	$(MAKE) -C obj_dir -f Vcpu.mk
	cp obj_dir/Vcpu demo


clean:
	rm -rf obj_dir/ *.o demo cpu-server
