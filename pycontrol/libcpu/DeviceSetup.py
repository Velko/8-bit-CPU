from . import devices as dev
from .pseudo_devices import RamProxy
from .pin import SimplePin, Level, Mux, MuxPin, AliasedPin

OutMux = Mux("OutMux", [0, 1, 2, 3], 15) # bits 0-3 in Control Word, defaults to 15
LoadMux = Mux("LoadMux", [4, 5, 6, 7], 15)

AluArgL = Mux("AluArgL", [8, 9], 4)
AluArgR = Mux("AluArgR", [10, 11, 12], 6)

AddrOutMux = Mux("AddrOutMux", [16, 17, 18], 7)
AddrLoadMux = Mux("AddrLoadMux", [19, 20, 21], 7)

AluAltFn = SimplePin(13, Level.HIGH)

A = dev.GPRegister("A",
    out = MuxPin(OutMux, 0),
    load = MuxPin(LoadMux, 0),
    alu_l = MuxPin(AluArgL, 0),
    alu_r = MuxPin(AluArgR, 0))

B = dev.GPRegister("B",
    out = MuxPin(OutMux, 1),
    load = MuxPin(LoadMux, 1),
    alu_l = MuxPin(AluArgL, 1),
    alu_r = MuxPin(AluArgR, 1))

C = dev.GPRegister("C",
    out = MuxPin(OutMux, 2),
    load = MuxPin(LoadMux, 2),
    alu_l = MuxPin(AluArgL, 2),
    alu_r = MuxPin(AluArgR, 2))

D = dev.GPRegister("D",
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

F = dev.FlagsRegister("F",
    out = MuxPin(OutMux, 4),
    load = MuxPin(LoadMux, 7),
    calc = SimplePin(14, Level.LOW),
    carry = SimplePin(15, Level.HIGH))

Ram = dev.RAM("Ram",
    out = MuxPin(OutMux, 9),
    write = MuxPin(LoadMux, 9))

ProgMem = RamProxy("ProgMem",
    ram = Ram)

IR = dev.WORegister("IR",
    load = MuxPin(LoadMux, 8))

Clock = dev.Clock("Clk",
    halt = SimplePin(26, Level.LOW),
    brk = SimplePin(27, Level.HIGH))

StepCounter = dev.StepCounter("Steps",
    reset = SimplePin(24, Level.LOW),
    extended = SimplePin(25, Level.LOW))

pc_out_inc = MuxPin(AddrOutMux, 5)

PC = dev.ProgramCounter("PC",
    out = pc_out_inc,
    load = MuxPin(AddrLoadMux, 5),
    inc = AliasedPin(pc_out_inc))

SP = dev.StackPointer("SP",
    out = MuxPin(AddrOutMux, 3),
    load = MuxPin(AddrLoadMux, 3),
    inc = SimplePin(22, Level.LOW),
    dec = SimplePin(23, Level.LOW))

#DP = dev.Register("DP",
#    out = MuxPin(OutMux, 14),
#    load = MuxPin(LoadMux, 14))

LR = dev.AddressRegister("LR",
    out = MuxPin(AddrOutMux, 4),
    load = MuxPin(AddrLoadMux, 4))

TX = dev.TransferRegister("TX",
    out = MuxPin(AddrOutMux, 0),
    load = MuxPin(AddrLoadMux, 0))

TH = dev.TransferRegister("TH",
    out = MuxPin(OutMux, 12),
    load = MuxPin(LoadMux, 12))

TL = dev.TransferRegister("TL",
    out = MuxPin(OutMux, 11),
    load = MuxPin(LoadMux, 11))

ACalc = dev.AddressCalculator("ACalc",
    out = MuxPin(AddrOutMux, 2),
    load = MuxPin(AddrLoadMux, 2),
    signed = SimplePin(28, Level.HIGH))

IOCtl = dev.IOController("IOCtl",
    laddr = MuxPin(LoadMux, 4),
    to_dev = MuxPin(LoadMux, 5),
    from_dev = MuxPin(OutMux, 8))
