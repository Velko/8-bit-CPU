from . import devices as dev
from .pseudo_devices import RamProxy
from .pin import SimplePin, Level, Mux, MuxPin, PinUsage
from .pin_cfg import PinConfig
import os.path

class DeviceSetup:
    def __init__(self) -> None:
        self.muxes: dict[str, Mux] = {}
        self.devices: dict[str, dev.DeviceBase] = {}

    def get(self, key: str) -> dev.DeviceBase | None:
        if key in self.devices:
            return self.devices[key]
        else:
            return None

    def all_devices(self) -> list[dev.DeviceBase]:
        devices: list[dev.DeviceBase] = []
        devices.extend(self.devices.values())
        return devices

    def setup_devices(self) -> None:
        yaml_path = os.path.join(os.path.dirname(__file__), "../../include/pins.yaml")

        p_cfg = PinConfig.load_from_yaml(yaml_path)
        self.muxes = p_cfg.muxes
        self.devices = p_cfg.devices

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

    def pc(self) -> dev.ProgramCounter:
        d = self.devices.get("PC")
        if isinstance(d, dev.ProgramCounter):
            return d
        else:
            raise ValueError(f"Device PC is not a ProgramCounter")

    def transfer(self, name: str) -> dev.TransferRegister:
        d = self.devices.get(name)
        if isinstance(d, dev.TransferRegister):
            return d
        else:
            raise ValueError(f"Device {name} is not a TransferRegister")

    def lr(self) -> dev.AddressRegister:
        d = self.devices.get("LR")
        if isinstance(d, dev.AddressRegister):
            return d
        else:
            raise ValueError(f"Device LR is not an AddressRegister")

    def a_ptr(self, name: str) -> dev.StackPointer:
        d = self.devices.get(name)
        if isinstance(d, dev.StackPointer):
            return d
        else:
            raise ValueError(f"Device {name} is not an StackPointer")

    def acalc(self) -> dev.AddressCalculator:
        d = self.devices.get("ACalc")
        if isinstance(d, dev.AddressCalculator):
            return d
        else:
            raise ValueError(f"Device ACalc is not an AddressCalculator")

    def io_controller(self) -> dev.IOController:
        d = self.devices.get("IOCtl")
        if isinstance(d, dev.IOController):
            return d
        else:
            raise ValueError(f"Device IOCtl is not an IOController")

hardware = DeviceSetup()
hardware.setup_devices()


