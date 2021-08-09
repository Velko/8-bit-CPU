from . import devices as dev
from .pseudo_devices import RamProxy
from .pin import Pin, NullPin, Level, Mux, MuxPin

OutMux = Mux("OutMux", [0, 1, 2], 7) # bits 5-7 in Control Word, defaults to 7
LoadMux = Mux("LoadMux", [8, 9, 10], 7)

RegA = dev.GPRegister("A",
    out = MuxPin(OutMux, 0),
    load = MuxPin(LoadMux, 0),
    alu_l = NullPin(),
    alu_r = NullPin())

RegB = dev.GPRegister("B",
    out = MuxPin(OutMux, 1),
    load = MuxPin(LoadMux, 1),
    alu_l = NullPin(),
    alu_r = NullPin())

AddSub = dev.ALU("AddSub",
    out = MuxPin(OutMux, 2),
    alt = Pin(4, Level.HIGH))

Flags = dev.Flags("F",
    calc = Pin(6, Level.LOW),
    carry = Pin(11, Level.HIGH),
    out = MuxPin(OutMux, 4),
    load = Pin(3, Level.HIGH))

Mar = dev.Register("MAR",
    out = NullPin(),
    load = MuxPin(LoadMux, 2))

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
    out = NullPin(),
    load = MuxPin(LoadMux, 4))

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
    out = NullPin(),
    load = MuxPin(LoadMux, 6))
