from . import devices as dev
from .pseudo_devices import RamProxy
from .pin import SimplePin, Level, Mux, MuxPin, SharedSimplePin
from .pin_cfg import PinConfig
import os.path

class DeviceSetup:
    def __init__(self) -> None:
        self.muxes: dict[str, Mux] = {}
        self.devices: dict[str, dev.DeviceBase] = {}
        self.alu: dict[str, dev.ALU] = {}
        self.F: dev.FlagsRegister = None # type: ignore[assignment]
        self.ram: dev.RAM = None # type: ignore[assignment]
        self.prog_mem: RamProxy = None # type: ignore[assignment]
        self.T: dev.TempRegister | None = None
        self.IR: dev.WORegister = None # type: ignore[assignment]
        self.Clock: dev.Clock | None = None
        self.StepCounter: dev.StepCounter = None # type: ignore[assignment]
        self.PC: dev.ProgramCounter = None # type: ignore[assignment]
        self.transfer: dict[str, dev.TransferRegister] = {}
        self.apointers: dict[str, dev.StackPointer] = {}
        self.LR: dev.AddressRegister | None = None
        self.ACalc: dev.AddressCalculator | None = None
        self.IOCtl: dev.IOController | None = None

    def get(self, key: str) -> dev.DeviceBase | None:
        if key in self.devices:
            return self.devices[key]
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
        elif key in self.transfer:
            return self.transfer[key]
        elif key in self.apointers:
            return self.apointers[key]
        elif key == "LR":
            return self.LR
        elif key == "ACalc":
            return self.ACalc
        elif key == "IOCtl":
            return self.IOCtl
        else:
            return None

    def all_devices(self) -> list[dev.DeviceBase]:
        devices: list[dev.DeviceBase] = []
        devices.extend(self.devices.values())
        if self.T is not None:
            devices.append(self.T)
        devices.extend(self.alu.values())
        devices.append(self.F)
        devices.append(self.ram)
        devices.append(self.prog_mem)
        devices.append(self.IR)
        if self.Clock is not None:
            devices.append(self.Clock)
        devices.append(self.StepCounter)
        devices.append(self.PC)
        devices.extend(self.apointers.values())
        if self.LR is not None:
            devices.append(self.LR)
        devices.extend(self.transfer.values())
        if self.ACalc is not None:
            devices.append(self.ACalc)
        if self.IOCtl is not None:
            devices.append(self.IOCtl)
        return devices

    def setup_devices(self) -> None:
        yaml_path = os.path.join(os.path.dirname(__file__), "../../include/pins.yaml")

        p_cfg = PinConfig.load_from_yaml(yaml_path)
        self.muxes = p_cfg.muxes

        OutMux = p_cfg.muxes["OutMux"]
        LoadMux = p_cfg.muxes["LoadMux"]

        AluArgL = p_cfg.muxes["AluArgL"]
        AluArgR = p_cfg.muxes["AluArgR"]

        AddrOutMux = p_cfg.muxes["AddrOutMux"]
        AddrLoadMux = p_cfg.muxes["AddrLoadMux"]

        AluAltFn = SharedSimplePin(13, Level.HIGH, "Alu.alt")

        AddrRegInc = SharedSimplePin(22, Level.LOW, "Addr.inc")
        AddrRegDec = SharedSimplePin(23, Level.LOW, "Addr.dec")

        self.devices = p_cfg.devices

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

        self.transfer["TX"] = dev.TransferRegister("TX",
            out = MuxPin(AddrOutMux, 0),
            load = MuxPin(AddrLoadMux, 0))

        self.transfer["TH"] = dev.TransferRegister("TH",
            out = MuxPin(OutMux, 12),
            load = MuxPin(LoadMux, 12))

        self.transfer["TL"] = dev.TransferRegister("TL",
            out = MuxPin(OutMux, 11),
            load = MuxPin(LoadMux, 11))

        self.apointers["SP"] = dev.StackPointer("SP",
            out = MuxPin(AddrOutMux, 3),
            load = MuxPin(AddrLoadMux, 3),
            inc = AddrRegInc,
            dec = AddrRegDec)

        self.apointers["SDP"] = dev.StackPointer("SDP",
            out = MuxPin(AddrOutMux, 1),
            load = MuxPin(AddrLoadMux, 1),
            inc = AddrRegInc,
            dec = AddrRegDec)

        self.apointers["TDP"] = dev.StackPointer("TDP",
            out = MuxPin(AddrOutMux, 6),
            load = MuxPin(AddrLoadMux, 6),
            inc = AddrRegInc,
            dec = AddrRegDec)

        self.LR = dev.AddressRegister("LR",
            out = MuxPin(AddrOutMux, 4),
            load = MuxPin(AddrLoadMux, 4))

        self.ACalc = dev.AddressCalculator("ACalc",
            out = MuxPin(AddrOutMux, 2),
            load = MuxPin(AddrLoadMux, 2),
            signed = SimplePin(28, Level.HIGH))

        self.IOCtl = dev.IOController("IOCtl",
            laddr = MuxPin(LoadMux, 4),
            to_dev = MuxPin(LoadMux, 5),
            from_dev = MuxPin(OutMux, 8))

    def gp_reg(self, name: str) -> dev.GPRegister:
        d = self.devices.get(name)
        if isinstance(d, dev.GPRegister):
            return d
        else:
            raise ValueError(f"Device {name} is not a GPRegister")


hardware = DeviceSetup()
hardware.setup_devices()


