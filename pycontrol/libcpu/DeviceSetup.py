from .devices import *
from .pin import Pin, NullPin, Level, Mux, MuxPin

OutMux = Mux([5, 6, 7], 7) # bits 5-7 in Control Word, defaults to 7
LoadMux = Mux([13, 14, 15], 7)

RegA = Register("A",
    out = MuxPin(OutMux, 0),
    load = MuxPin(LoadMux, 0),
    alu_a = NullPin(10, Level.LOW),
    alu_b = NullPin(11, Level.LOW))

RegB = Register("B",
    out = MuxPin(OutMux, 1),
    load = MuxPin(LoadMux, 1),
    alu_a = NullPin(12, Level.LOW),
    alu_b = NullPin(13, Level.LOW))

AddSub = ALU("AddSub",
    out = MuxPin(OutMux, 2),
    sub = Pin(4, Level.HIGH))

Flags = Flags("F",
    load = Pin(1, Level.LOW),
    use_carry = Pin(3, Level.HIGH),
    bus_out = MuxPin(OutMux, 4),
    bus_in = Pin(9, Level.HIGH))

# Note: pins overlap with currently unused ones for RegA and RegB
Mar = Register("MAR",
    out = NullPin(-1, Level.LOW),
    load = MuxPin(LoadMux, 2),
    alu_a = NullPin(-1, Level.LOW),
    alu_b = NullPin(-1, Level.LOW))

Ram = RAM("Ram",
    out = MuxPin(OutMux, 3),
    write = MuxPin(LoadMux, 3))

IR = Register("IR",
    out = NullPin(-1, Level.LOW),
    load = MuxPin(LoadMux, 4),
    alu_a = NullPin(-1, Level.LOW),
    alu_b = NullPin(-1, Level.LOW))

Clock = Clock("Clock",
    halt = Pin(8, Level.LOW))

StepCounter = StepCounter("Steps",
    reset = Pin(0, Level.LOW))

IRFetch = IRFetch("IRFetch",
    load = Pin(12, Level.LOW))

PC = ProgramCounter("PC",
    out = MuxPin(OutMux, 5),
    load = MuxPin(LoadMux, 5),
    count = Pin(2, Level.HIGH))
