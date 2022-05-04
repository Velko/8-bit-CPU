from . import devices as dev
from .pseudo_devices import RamProxy
from .pin import Pin, NullPin, Level, Mux, MuxPin

OutMux = Mux("OutMux", [0, 1, 2, 3], 15) # bits 0-3 in Control Word, defaults to 15
LoadMux = Mux("LoadMux", [4, 5, 6, 7], 15)

AluArgL = Mux("AluArgL", [8, 9], 4)
AluArgR = Mux("AluArgR", [10, 11, 12], 6)

AddrOutMux = Mux("AddrOutMux", [16, 17, 18], 7)
AddrLoadMux = Mux("AddrLoadMux", [19, 20, 21], 7)

AluAltFn = Pin(13, Level.HIGH)

RegA = dev.GPRegister("A",
    out = MuxPin(OutMux, 0),
    load = MuxPin(LoadMux, 0),
    alu_l = MuxPin(AluArgL, 0),
    alu_r = MuxPin(AluArgR, 0))

RegB = dev.GPRegister("B",
    out = MuxPin(OutMux, 1),
    load = MuxPin(LoadMux, 1),
    alu_l = MuxPin(AluArgL, 1),
    alu_r = MuxPin(AluArgR, 1))

RegC = dev.GPRegister("C",
    out = MuxPin(OutMux, 2),
    load = MuxPin(LoadMux, 2),
    alu_l = MuxPin(AluArgL, 2),
    alu_r = MuxPin(AluArgR, 2))

RegD = dev.GPRegister("D",
    out = MuxPin(OutMux, 3),
    load = MuxPin(LoadMux, 3),
    alu_l = MuxPin(AluArgL, 3),
    alu_r = MuxPin(AluArgR, 3))

AddSub = dev.ALU("AddSub",
    out = MuxPin(OutMux, 5),
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
    calc = Pin(14, Level.LOW),
    carry = Pin(15, Level.HIGH))

Ram = dev.RAM("Ram",
    out = MuxPin(OutMux, 9),
    write = MuxPin(LoadMux, 9))

ProgMem = RamProxy("ProgMem",
    ram = Ram)

IR = dev.Register("IR",
    out = NullPin(),
    load = MuxPin(LoadMux, 8))

Clock = dev.Clock("Clock",
    halt = Pin(26, Level.LOW),
    brk = Pin(27, Level.HIGH))

StepCounter = dev.StepCounter("Steps",
    reset = Pin(24, Level.LOW),
    extended = Pin(25, Level.LOW))

PC = dev.ProgramCounter("PC",
    out = MuxPin(AddrOutMux, 5),
    load = MuxPin(AddrLoadMux, 5),
    inc = NullPin())

SP = dev.StackPointer("SP",
    out = MuxPin(AddrOutMux, 3),
    load = MuxPin(AddrLoadMux, 3),
    inc = Pin(22, Level.LOW),
    dec = Pin(23, Level.LOW))

#DP = dev.Register("DP",
#    out = MuxPin(OutMux, 14),
#    load = MuxPin(LoadMux, 14))

LR = dev.ProgramCounter("LR",
    out = MuxPin(AddrOutMux, 4),
    load = MuxPin(AddrLoadMux, 4),
    inc = NullPin())

TX = dev.TransferRegister("TX",
    out = MuxPin(AddrOutMux, 0),
    load = MuxPin(AddrLoadMux, 0))

TH = dev.TransferRegister("TH",
    out = MuxPin(OutMux, 12),
    load = MuxPin(LoadMux, 12))

TL = dev.TransferRegister("TL",
    out = MuxPin(OutMux, 11),
    load = MuxPin(LoadMux, 11))

ACalc = dev.AddressCalculator("ACal",
    out = MuxPin(AddrOutMux, 2),
    load = MuxPin(AddrLoadMux, 2))

IOCtl = dev.IOController("IOCtl",
    laddr = MuxPin(LoadMux, 4),
    to_dev = MuxPin(LoadMux, 5),
    from_dev = MuxPin(OutMux, 8))