from . import devices as dev
from .pseudo_devices import RamProxy
from .pin import Pin, NullPin, Level, Mux, MuxPin

OutMux = Mux([0, 1, 2, 3], 15) # bits 0-3 in Control Word, defaults to 15
LoadMux = Mux([8, 9, 10, 11], 15)
AluArgA = Mux([16, 17], 4)
AluArgB = Mux([18, 19, 20], 7)

AluAltFn = Pin(4, Level.HIGH)

RegA = dev.Register("A",
    out = MuxPin(OutMux, 0),
    load = MuxPin(LoadMux, 0),
    alu_a = MuxPin(AluArgA, 0),
    alu_b = MuxPin(AluArgB, 0))

RegB = dev.Register("B",
    out = MuxPin(OutMux, 1),
    load = MuxPin(LoadMux, 1),
    alu_a = MuxPin(AluArgA, 1),
    alu_b = MuxPin(AluArgB, 1))

RegC = dev.Register("C",
    out = MuxPin(OutMux, 8),
    load = MuxPin(LoadMux, 8),
    alu_a = MuxPin(AluArgA, 2),
    alu_b = MuxPin(AluArgB, 2))

RegD = dev.Register("D",
    out = MuxPin(OutMux, 9),
    load = MuxPin(LoadMux, 9),
    alu_a = MuxPin(AluArgA, 3),
    alu_b = MuxPin(AluArgB, 3))

AddSub = dev.ALU("AddSub",
    out = MuxPin(OutMux, 2),
    alt = AluAltFn)

AndOr = dev.ALU("AndOr",
    out = MuxPin(OutMux, 6),
    alt = AluAltFn)

Flags = dev.Flags("F",
    calc = Pin(6, Level.LOW),
    carry = Pin(14, Level.HIGH),
    bus_out = MuxPin(OutMux, 4),
    bus_load = MuxPin(LoadMux, 7))

Mar = dev.Register("MAR",
    out = NullPin(-1, Level.LOW),
    load = MuxPin(LoadMux, 2),
    alu_a = NullPin(-1, Level.LOW),
    alu_b = NullPin(-1, Level.LOW))

# currently same as regular MAR, can be redefined for different
# hardware configuration. Will not require changes in instruction
# definitions
ProgMar = Mar

Ram = dev.RAM("Ram",
    out = MuxPin(OutMux, 3),
    write = MuxPin(LoadMux, 3))

ProgMem = RamProxy("ProgMem",
    ram = Ram)

IR = dev.Register("IR",
    out = NullPin(-1, Level.LOW),
    load = MuxPin(LoadMux, 4),
    alu_a = NullPin(-1, Level.LOW),
    alu_b = NullPin(-1, Level.LOW))

Clock = dev.Clock("Clock",
    halt = Pin(13, Level.LOW))

StepCounter = dev.StepCounter("Steps",
    reset = Pin(7, Level.LOW))

IRFetch = dev.IRFetch("IRFetch",
    load = Pin(12, Level.LOW))

PC = dev.ProgramCounter("PC",
    out = MuxPin(OutMux, 5),
    load = MuxPin(LoadMux, 5),
    count = Pin(5, Level.HIGH))

OutPort = dev.Register("Out",
    out = NullPin(-1, Level.LOW),
    load = MuxPin(LoadMux, 6),
    alu_a = NullPin(-1, Level.LOW),
    alu_b = NullPin(-1, Level.LOW))
