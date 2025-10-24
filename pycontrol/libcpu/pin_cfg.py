#!/usr/bin/env python3

import yaml # type: ignore
from dataclasses import dataclass, field
from typing import Any
from enum import Enum, auto

from .pin import Mux, MuxPin, SimplePin, Level, PinUsage, Pin
from .devices import GPRegister, DeviceBase, ALU, FlagsRegister, RAM, ROM, TempRegister, WORegister, Clock, StepCounter, ProgramCounter, TransferRegister, StackPointer, AddressRegister, AddressCalculator, IOController
from .pseudo_devices import RamProxy
import copy


@dataclass
class PinConfig:
    @staticmethod
    def load_from_yaml(filename: str) -> 'PinConfig':
        with open(filename) as stream:
            yconf = yaml.safe_load(stream)
            return PinConfig(**yconf)

    def __init__(self, muxes: list[dict[str, Any]], shared_pins: list[dict[str, Any]], devices: list[dict[str, Any]]) -> None:
        self.muxes = {m['name']: Mux(**m) for m in muxes}
        self.shared = self.create_shared_pins(shared_pins)
        self.devices: dict[str, DeviceBase] = {}

        for d in devices:
            name = d['name']
            args = {'name': name}

            if 'pins' in d:
                args.update(self.resolve_pins(d['pins'], name))

            match d['type']:
                case 'GPRegister':
                    self.devices[name] = GPRegister(**args)
                case 'ALU':
                    self.devices[name] = ALU(**args)
                case "FlagsRegister":
                    self.devices[name] = FlagsRegister(**args)
                case "RAM":
                    self.devices[name] = RAM(**args)
                case "ROM":
                    self.devices[name] = ROM(**args)
                case "Alias":
                    alias_of = d.get('alias_of')
                    if alias_of is None:
                        raise ValueError(f"Alias device {name} missing 'alias_of' field")
                    if alias_of not in self.devices:
                        raise ValueError(f"Alias device {name} references unknown device {alias_of}")
                    if alias_of == "Ram":
                        self.devices[name] = RamProxy(name, ram = self.devices[alias_of]) # type: ignore[arg-type]
                    else:
                        raise ValueError(f"Alias device {name} references unsupported device {alias_of}")
                case "TempRegister":
                    self.devices[name] = TempRegister(**args)
                case "WORegister":
                    self.devices[name] = WORegister(**args)
                case "Clock":
                    self.devices[name] = Clock(**args)
                case "StepCounter":
                    self.devices[name] = StepCounter(**args)
                case "ProgramCounter":
                    self.devices[name] = ProgramCounter(**args)
                case "TransferRegister":
                    self.devices[name] = TransferRegister(**args)
                case "StackPointer":
                    self.devices[name] = StackPointer(**args)
                case "AddressRegister":
                    self.devices[name] = AddressRegister(**args)
                case "AddressCalculator":
                    self.devices[name] = AddressCalculator(**args)
                case "IOController":
                    self.devices[name] = IOController(**args)

    def create_shared_pins(self, shared_pins: list[dict[str, Any]]) ->  dict[str, Pin]:
        shared: dict[str, Pin] = {}
        for s in shared_pins:
            if (pin_name := s.get('name')) is None:
                raise ValueError(f"Missing pin for shared pin definition: {s}")

            if (pin_def := s.get('pin')) is None:
                raise ValueError(f"Missing pin definition for shared pin {pin_name}")

            if (mux_name := s.get('mux')) is not None:
                shared[pin_name] = MuxPin(self.muxes[mux_name], pin_def, PinUsage.SHARED, pin_name)
            else:
                shared[pin_name] = SimplePin(s['pin'], Level[s['level']], PinUsage.SHARED, pin_name)
        return shared

    def resolve_pins(self, pindef: dict[str, Any], name: str) -> dict[str, Pin]:
        args: dict[str, Pin] = {}
        for pn, p in pindef.items():
            # There are three possibilities:
            # 1. MuxPin: mux and numeric pin specified
            # 2. Shared Pin: shared pin name specified
            # 3. Exclusive SimplePin: numeric pin and level specified

            if (pin_def := p.get('pin')) is None:
                raise ValueError(f"Missing pin definition for pin {pn} in device {name}")

            if (mux_name := p.get('mux')) is not None:
                mux = MuxPin(self.muxes[mux_name], pin_def, PinUsage.EXCLUSIVE)
                args[pn] = mux
            else:
                if isinstance(pin_def, str):
                    if pin_def in self.shared:
                        pin = copy.copy(self.shared[pin_def])
                    else:
                        raise ValueError(f"Unknown shared pin {pin_def} in device {name}")
                else:
                    if (level_name := p.get('level')) is None:
                        raise ValueError(f"Missing level for pin {pn} in device {name}")
                    pin = SimplePin(pin_def, Level[level_name], PinUsage.EXCLUSIVE)
                args[pn] = pin
        return args

