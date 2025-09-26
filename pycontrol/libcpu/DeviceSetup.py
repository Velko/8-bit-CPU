from . import devices as dev
from .pseudo_devices import RamProxy
from .pin import SimplePin, Level, Mux, MuxPin, PinUsage
from .pin_cfg import PinConfig
import os.path

class DeviceSetup:
    def __init__(self) -> None:
        self.muxes: dict[str, Mux] = {}
        self.devices: dict[str, dev.DeviceBase] = {}
        self.PC: dev.ProgramCounter = None # type: ignore[assignment]
        self.transfer: dict[str, dev.TransferRegister] = {}
        self.LR: dev.AddressRegister | None = None
        self.ACalc: dev.AddressCalculator | None = None
        self.IOCtl: dev.IOController | None = None

    def get(self, key: str) -> dev.DeviceBase | None:
        if key in self.devices:
            return self.devices[key]
        elif key == "PC":
            return self.PC
        elif key in self.transfer:
            return self.transfer[key]
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
        devices.append(self.PC)
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

        AluAltFn = SimplePin(13, Level.HIGH, PinUsage.SHARED, "Alu.alt")

        AddrRegInc = SimplePin(22, Level.LOW, PinUsage.SHARED, "Addr.inc")
        AddrRegDec = SimplePin(23, Level.LOW, PinUsage.SHARED, "Addr.dec")

        self.devices = p_cfg.devices

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

        self.devices["SP"] = dev.StackPointer("SP",
            out = MuxPin(AddrOutMux, 3),
            load = MuxPin(AddrLoadMux, 3),
            inc = AddrRegInc,
            dec = AddrRegDec)

        self.devices["SDP"] = dev.StackPointer("SDP",
            out = MuxPin(AddrOutMux, 1),
            load = MuxPin(AddrLoadMux, 1),
            inc = AddrRegInc,
            dec = AddrRegDec)

        self.devices["TDP"] = dev.StackPointer("TDP",
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
            signed = SimplePin(28, Level.HIGH, PinUsage.EXCLUSIVE))

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

    def alu(self, name: str) -> dev.ALU:
        d = self.devices.get(name)
        if isinstance(d, dev.ALU):
            return d
        else:
            raise ValueError(f"Device {name} is not an ALU")

    def flags(self) -> dev.FlagsRegister:
        d = self.devices.get("F")
        if isinstance(d, dev.FlagsRegister):
            return d
        raise ValueError("No FlagsRegister found")

    def ram(self) -> dev.RAM:
        d = self.devices.get("Ram")
        if isinstance(d, dev.RAM):
            return d
        raise ValueError("No RAM found")

    def prog_mem(self) -> RamProxy:
        d = self.devices.get("ProgMem")
        if isinstance(d, RamProxy):
            return d
        raise ValueError("No ProgMem (RamProxy) found")

    def ir(self) -> dev.WORegister:
        d = self.devices.get("IR")
        if isinstance(d, dev.WORegister):
            return d
        else:
            raise ValueError(f"Device IR is not a WORegister")

    def clock(self) -> dev.Clock:
        d = self.devices.get("Clock")
        if isinstance(d, dev.Clock):
            return d
        else:
            raise ValueError(f"Device Clock is not a Clock")

    def step_counter(self) -> dev.StepCounter:
        d = self.devices.get("StepCounter")
        if isinstance(d, dev.StepCounter):
            return d
        else:
            raise ValueError(f"Device StepCounter is not a StepCounter")

    def a_ptr(self, name: str) -> dev.StackPointer:
        d = self.devices.get(name)
        if isinstance(d, dev.StackPointer):
            return d
        else:
            raise ValueError(f"Device {name} is not an AddressPointer")


hardware = DeviceSetup()
hardware.setup_devices()


