from . import devices as dev
from .pseudo_devices import RamProxy
from .pin import Pin, NullPin, Level, Mux, MuxPin

OutMux = Mux([0, 1, 2, 3], 15) # bits 0-3 in Control Word, defaults to 15
LoadMux = Mux([8, 9, 10, 11], 15)
AddrOutMux = Mux([23, 24, 25], 7)
AddrLoadMux = Mux([27, 28, 29], 7)
AluArgA = Mux([16, 17], 4)
AluArgB = Mux([18, 19, 20], 0)

AluAltFn = Pin(4, Level.HIGH)

RegA = dev.GPRegister("A",
    out = MuxPin(OutMux, 0),
    load = MuxPin(LoadMux, 0),
    alu_a = MuxPin(AluArgA, 0),
    alu_b = MuxPin(AluArgB, 4))

RegB = dev.GPRegister("B",
    out = MuxPin(OutMux, 1),
    load = MuxPin(LoadMux, 1),
    alu_a = MuxPin(AluArgA, 1),
    alu_b = MuxPin(AluArgB, 5))

RegC = dev.GPRegister("C",
    out = MuxPin(OutMux, 8),
    load = MuxPin(LoadMux, 8),
    alu_a = MuxPin(AluArgA, 2),
    alu_b = MuxPin(AluArgB, 6))

RegD = dev.GPRegister("D",
    out = MuxPin(OutMux, 9),
    load = MuxPin(LoadMux, 9),
    alu_a = MuxPin(AluArgA, 3),
    alu_b = MuxPin(AluArgB, 7))

AddSub = dev.ALU("AddSub",
    out = MuxPin(OutMux, 2),
    alt = AluAltFn)

AndOr = dev.ALU("AndOr",
    out = MuxPin(OutMux, 6),
    alt = AluAltFn)

XorNot = dev.ALU("XorNot",
    out = MuxPin(OutMux, 10),
    alt = AluAltFn)

ShiftSwap = dev.ALU("ShiftSwap",
    out = MuxPin(OutMux, 7),
    alt = AluAltFn)

Flags = dev.Flags("F",
    out = MuxPin(OutMux, 4),
    load = MuxPin(LoadMux, 7),
    calc = Pin(6, Level.LOW),
    carry = Pin(14, Level.HIGH))

Ram = dev.RAM("Ram",
    out = MuxPin(OutMux, 3),
    write = MuxPin(LoadMux, 3))

ProgMem = RamProxy("ProgMem",
    ram = Ram)

IR = dev.Register("IR",
    out = NullPin(-1, Level.LOW),
    load = MuxPin(LoadMux, 4))

Clock = dev.Clock("Clock",
    halt = Pin(13, Level.LOW),
    brk = Pin(26, Level.HIGH))

StepCounter = dev.StepCounter("Steps",
    reset = Pin(7, Level.LOW))

IRFetch = dev.IRFetch("IRFetch",
    load = Pin(12, Level.LOW))

PC = dev.ProgramCounter("PC",
    out = MuxPin(AddrOutMux, 5),
    load = MuxPin(AddrLoadMux, 5),
    count = Pin(5, Level.HIGH))

SP = dev.StackPointer("SP",
    out = MuxPin(AddrOutMux, 11),
    load = MuxPin(AddrLoadMux, 11),
    inc = Pin(21, Level.LOW),
    dec = Pin(22, Level.LOW))

#DP = dev.Register("DP",
#    out = MuxPin(OutMux, 14),
#    load = MuxPin(LoadMux, 14))

LR = dev.ProgramCounter("LR",
    out = MuxPin(AddrOutMux, 12),
    load = MuxPin(AddrLoadMux, 12),
    count = NullPin(-1, Level.LOW))

PSW = dev.PCLR("PCLR",
    swap = Pin(15, Level.HIGH))

OutPort = dev.Register("Out",
    out = NullPin(-1, Level.LOW),
    load = MuxPin(LoadMux, 6))

COutPort = dev.Register("Cout",
    out = NullPin(-1, Level.LOW),
    load = MuxPin(LoadMux, 10))

TX = dev.TransferRegister("TX",
    out = MuxPin(AddrOutMux, 0),
    load = MuxPin(AddrLoadMux, 0),
    add = NullPin(-1, Level.HIGH))

TH = dev.TransferRegister("TH",
    out = MuxPin(OutMux, 5),
    load = MuxPin(LoadMux, 5),
    add = NullPin(-1, Level.HIGH))

TL = dev.TransferRegister("TL",
    out = MuxPin(OutMux, 11),
    load = MuxPin(LoadMux, 11),
    add = Pin(30, Level.HIGH))