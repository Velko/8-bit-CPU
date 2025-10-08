from . import devices as dev
from .pseudo_devices import RamProxy
from .pin import SimplePin, Level, Mux, MuxPin, PinUsage
from .pin_cfg import PinConfig
import os.path

from typing import TypeVar, Type, cast

T = TypeVar('T')


class HardwareSetup:
    def __init__(self) -> None:
        yaml_path = os.path.join(os.path.dirname(__file__), "../../include/pins.yaml")

        p_cfg = PinConfig.load_from_yaml(yaml_path)
        self.muxes = p_cfg.muxes
        self.devices = p_cfg.devices


        self.AddSub = self.get_typed_dev("AddSub", dev.ALU)
        self.F = self.get_typed_dev("F", dev.FlagsRegister)
        self.RAM = self.get_typed_dev("Ram", dev.RAM)
        self.ProgMem = self.get_typed_dev("ProgMem", RamProxy)
        self.IR = self.get_typed_dev("IR", dev.WORegister)
        self.Clock = self.get_typed_dev("Clock", dev.Clock)
        self.StepCounter = self.get_typed_dev("StepCounter", dev.StepCounter)

    def get_typed_dev(self, name: str, expected_type: Type[T]) -> T:
        device = self.devices.get(name)
        if not isinstance(device, expected_type):
            raise TypeError(f"Expected type {expected_type.__name__} for key '{name}', got {type(device).__name__}")
        return cast(T, device)

    def get(self, key: str) -> dev.DeviceBase | None:
        if key in self.devices:
            return self.devices[key]
        else:
            return None

    def all_devices(self) -> list[dev.DeviceBase]:
        devices: list[dev.DeviceBase] = []
        devices.extend(self.devices.values())
        return devices

    def gp_reg(self, name: str) -> dev.GPRegister:
        d = self.devices.get(name)
        if isinstance(d, dev.GPRegister):
            return d
        else:
            raise ValueError(f"Device {name} is not a GPRegister")

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

hardware = HardwareSetup()


