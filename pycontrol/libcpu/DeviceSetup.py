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

        self.A = self.get_typed_dev("A", dev.GPRegister)
        self.B = self.get_typed_dev("B", dev.GPRegister)
        self.C = self.get_typed_dev("C", dev.GPRegister)
        self.D = self.get_typed_dev("D", dev.GPRegister)

        self.AddSub = self.get_typed_dev("AddSub", dev.ALU)
        self.F = self.get_typed_dev("F", dev.FlagsRegister)
        self.RAM = self.get_typed_dev("Ram", dev.RAM)
        self.ProgMem = self.get_typed_dev("ProgMem", RamProxy)
        self.IR = self.get_typed_dev("IR", dev.WORegister)
        self.Clock = self.get_typed_dev("Clock", dev.Clock)
        self.StepCounter = self.get_typed_dev("StepCounter", dev.StepCounter)
        self.PC = self.get_typed_dev("PC", dev.ProgramCounter)
        self.TX = self.get_typed_dev("TX", dev.TransferRegister)
        self.TL = self.get_typed_dev("TL", dev.TransferRegister)
        self.TH = self.get_typed_dev("TH", dev.TransferRegister)
        self.LR = self.get_typed_dev("LR", dev.AddressRegister)
        self.ACalc = self.get_typed_dev("ACalc", dev.AddressCalculator)
        self.IOCtl = self.get_typed_dev("IOCtl", dev.IOController)

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

    def a_ptr(self, name: str) -> dev.StackPointer:
        d = self.devices.get(name)
        if isinstance(d, dev.StackPointer):
            return d
        else:
            raise ValueError(f"Device {name} is not an StackPointer")

hardware = HardwareSetup()


