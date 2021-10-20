include ../cpu-modules/Modules.mk

VPATH=obj_dir/

all: demo

DEMOSRC=demo.cpp cpu.cpp



demo: $(CPUSRC) $(DEMOSRC)
	verilator --cc --exe -Wall --build --top-module cpu $^
	cp obj_dir/Vcpu demo


clean:
	rm -rf obj_dir/ *.o demo
