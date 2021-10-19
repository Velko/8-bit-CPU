include ../cpu-modules/Modules.mk

VPATH=obj_dir/

all: engine

SRC=main.cpp cpu.cpp


engine: $(CPUSRC) $(SRC)
	verilator --cc --exe -Wall --build --top-module cpu $^


clean:
	rm -rf obj_dir/ *.o engine
