include ../cpu-modules/Modules.mk

VPATH=obj_dir/

all: engine

SRC=main.cpp cpu.cpp


engine: $(ALUBLOCKSRC) $(SRC)
	verilator --cc --exe -Wall --build --top-module alu_block $^


clean:
	rm -rf obj_dir/ *.o engine
