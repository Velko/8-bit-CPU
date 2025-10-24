from . import devices as dev
from .pin import Pin, SimplePin, Level, Mux, MuxPin, PinUsage
from .pin_cfg import PinConfig
from .ctrl_word import CtrlWord
import os.path

from collections.abc import Iterator
from typing import TypeVar, Type

T = TypeVar('T')


class HardwareSetup:
    def __init__(self) -> None:
        yaml_path = os.path.join(os.path.dirname(__file__), "../../include/pins.yaml")

        p_cfg = PinConfig.load_from_yaml(yaml_path)
        self.muxes = p_cfg.muxes
        self.devices = p_cfg.devices

        self.DEFAULT_CW = CtrlWord(self.all_pins())
        self.DEFAULT_CW.set_default()

        self.A = self.get_typed_dev("A", dev.GPRegister)
        self.B = self.get_typed_dev("B", dev.GPRegister)
        self.C = self.get_typed_dev("C", dev.GPRegister)
        self.D = self.get_typed_dev("D", dev.GPRegister)

        self.AddSub = self.get_typed_dev("AddSub", dev.ALU)
        self.XorNot = self.get_typed_dev("XorNot", dev.ALU)
        self.F = self.get_typed_dev("F", dev.FlagsRegister)
        self.RAM = self.get_typed_dev("Ram", dev.RAM)
        self.ProgMem = self.get_typed_dev("ProgMem", dev.ROM)
        self.IR = self.get_typed_dev("IR", dev.WORegister)
        self.Clock = self.get_typed_dev("Clock", dev.Clock)
        self.StepCounter = self.get_typed_dev("StepCounter", dev.StepCounter)
        self.PC = self.get_typed_dev("PC", dev.ProgramCounter)
        self.SP = self.get_typed_dev("SP", dev.StackPointer)
        self.SDP = self.get_typed_dev("SDP", dev.StackPointer)
        self.TDP = self.get_typed_dev("TDP", dev.StackPointer)
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
        return device

    def get(self, key: str) -> dev.DeviceBase | None:
        if key in self.devices:
            return self.devices[key]
        else:
            return None

    def all_devices(self) -> list[dev.DeviceBase]:
        devices: list[dev.DeviceBase] = []
        devices.extend(self.devices.values())
        return devices

    def a_ptr(self, name: str) -> dev.AddressRegister:
        d = self.devices.get(name)
        if isinstance(d, dev.AddressRegister):
            return d
        else:
            raise ValueError(f"Device {name} is not an AddressRegister")

    def all_pins(self) -> Iterator[tuple[str, Pin]]:
        dupe_filter = set()
        for dev in self.devices.values():
            pin_attrs = filter(lambda x: isinstance(x[1], Pin), vars(dev).items())
            for a_name, attr in pin_attrs:
                if attr.name is not None:
                    pin_name = f"{attr.name}"
                else:
                    pin_name = f"{dev.name}.{a_name}"
                if pin_name not in dupe_filter:
                    dupe_filter.add(pin_name)
                    yield pin_name, attr

    def simple_pins(self) -> Iterator[tuple[str, SimplePin]]:
        for name, pin in self.all_pins():
            if isinstance(pin, SimplePin):
                yield name, pin

    def all_muxes(self) -> Iterator[tuple[str, Mux]]:
        for v_name, var in self.muxes.items():
            if isinstance(var, Mux):
                yield v_name, var

    def mux_pins(self, mux: Mux) -> Iterator[tuple[str, MuxPin]]:
        for name, pin in self.all_pins():
            if isinstance(pin, MuxPin) and pin.mux == mux:
                yield name, pin

hardware = HardwareSetup()


