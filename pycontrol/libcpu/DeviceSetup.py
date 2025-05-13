from . import devices as dev
from .pseudo_devices import RamProxy
from .pin import SimplePin, Level, Mux, MuxPin, SharedSimplePin

OutMux = Mux("OutMux", [0, 1, 2, 3], 15) # bits 0-3 in Control Word, defaults to 15
LoadMux = Mux("LoadMux", [4, 5, 6, 7], 15)

AluArgL = Mux("AluArgL", [8, 9], 4)
AluArgR = Mux("AluArgR", [10, 11, 12], 6)

AddrOutMux = Mux("AddrOutMux", [16, 17, 18], 7)
AddrLoadMux = Mux("AddrLoadMux", [19, 20, 21], 7)

AluAltFn = SharedSimplePin(13, Level.HIGH, "Alu.alt")

AddrRegInc = SharedSimplePin(22, Level.LOW, "Addr.inc")
AddrRegDec = SharedSimplePin(23, Level.LOW, "Addr.dec")

class DeviceSetup:
    def __init__(self) -> None:
        self.gp_registers: dict[str, dev.GPRegister] = {}
        self.alu: dict[str, dev.ALU] = {}
        self.F: dev.FlagsRegister = None # type: ignore[assignment]
        self.ram: dev.RAM = None # type: ignore[assignment]
        self.prog_mem: RamProxy = None # type: ignore[assignment]
        self.T: dev.TempRegister | None = None
        self.IR: dev.WORegister = None # type: ignore[assignment]
        self.Clock: dev.Clock | None = None
        self.StepCounter: dev.StepCounter = None # type: ignore[assignment]
        self.PC: dev.ProgramCounter = None # type: ignore[assignment]

    def get(self, key: str) -> dev.DeviceBase | None:
        if key in self.gp_registers:
            return self.gp_registers[key]
        elif key in self.alu:
            return self.alu[key]
        elif key == "F":
            return self.F
        elif key == "Ram":
            return self.ram
        elif key == "ProgMem":
            return self.prog_mem
        elif key == "T":
            return self.T
        elif key == "IR":
            return self.IR
        elif key == "Clock":
            return self.Clock
        elif key == "StepCounter":
            return self.StepCounter
        elif key == "PC":
            return self.PC
        else:
            return None

    def all_devices(self) -> list[dev.DeviceBase]:
        devices: list[dev.DeviceBase] = []
        devices.extend(self.gp_registers.values())
        devices.extend(self.alu.values())
        devices.append(self.F)
        devices.append(self.ram)
        devices.append(self.prog_mem)
        if self.T is not None:
            devices.append(self.T)
        devices.append(self.IR)
        if self.Clock is not None:
            devices.append(self.Clock)
        devices.append(self.StepCounter)
        devices.append(self.PC)
        return devices

    def setup_devices(self) -> None:
        self.gp_registers["A"] = dev.GPRegister("A",
            out = MuxPin(OutMux, 0),
            load = MuxPin(LoadMux, 0),
            alu_l = MuxPin(AluArgL, 0),
            alu_r = MuxPin(AluArgR, 0))

        self.gp_registers["B"] = dev.GPRegister("B",
            out = MuxPin(OutMux, 1),
            load = MuxPin(LoadMux, 1),
            alu_l = MuxPin(AluArgL, 1),
            alu_r = MuxPin(AluArgR, 1))

        self.gp_registers["C"] = dev.GPRegister("C",
            out = MuxPin(OutMux, 2),
            load = MuxPin(LoadMux, 2),
            alu_l = MuxPin(AluArgL, 2),
            alu_r = MuxPin(AluArgR, 2))

        self.gp_registers["D"] = dev.GPRegister("D",
            out = MuxPin(OutMux, 3),
            load = MuxPin(LoadMux, 3),
            alu_l = MuxPin(AluArgL, 3),
            alu_r = MuxPin(AluArgR, 3))

        self.alu["AddSub"] = dev.ALU("AddSub",
            out = MuxPin(OutMux, 5),
            alt = AluAltFn)

        self.alu["AndOr"] = dev.ALU("AndOr",
            out = MuxPin(OutMux, 6),
            alt = AluAltFn)

        self.alu["XorNot"] = dev.ALU("XorNot",
            out = MuxPin(OutMux, 10),
            alt = AluAltFn)

        self.alu["ShiftSwap"] = dev.ALU("ShiftSwap",
            out = MuxPin(OutMux, 7),
            alt = AluAltFn)

        self.F = dev.FlagsRegister("F",
            out = MuxPin(OutMux, 4),
            load = MuxPin(LoadMux, 7),
            calc = SimplePin(14, Level.LOW),
            carry = SimplePin(15, Level.HIGH))

        self.ram = dev.RAM("Ram",
            out = MuxPin(OutMux, 9),
            write = MuxPin(LoadMux, 9))

        self.prog_mem = RamProxy("ProgMem",
            ram = self.ram)

        self.T = dev.TempRegister("T",
            load = MuxPin(LoadMux, 6),
            alu_r = MuxPin(AluArgR, 4))

        self.IR = dev.WORegister("IR",
            load = MuxPin(LoadMux, 8))

        self.Clock = dev.Clock("Clk",
            halt = SimplePin(26, Level.LOW),
            brk = SimplePin(27, Level.HIGH))

        self.StepCounter = dev.StepCounter("Steps",
            reset = SimplePin(24, Level.LOW),
            extended = SimplePin(25, Level.LOW))

        self.PC = dev.ProgramCounter("PC",
            out = MuxPin(AddrOutMux, 5),
            load = MuxPin(AddrLoadMux, 5),
            inc = AddrRegInc)




hardware = DeviceSetup()
hardware.setup_devices()

SP = dev.StackPointer("SP",
    out = MuxPin(AddrOutMux, 3),
    load = MuxPin(AddrLoadMux, 3),
    inc = AddrRegInc,
    dec = AddrRegDec)

SDP = dev.StackPointer("SDP",
    out = MuxPin(AddrOutMux, 1),
    load = MuxPin(AddrLoadMux, 1),
    inc = AddrRegInc,
    dec = AddrRegDec)

TDP = dev.StackPointer("TDP",
    out = MuxPin(AddrOutMux, 6),
    load = MuxPin(AddrLoadMux, 6),
    inc = AddrRegInc,
    dec = AddrRegDec)

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
