#!/usr/bin/env python3

import yaml # type: ignore
from dataclasses import dataclass, field
from typing import Any
from enum import Enum, auto

from .pin import Mux, MuxPin, SimplePin, Level, PinUsage
from .devices import GPRegister, DeviceBase, ALU, FlagsRegister, RAM, TempRegister, WORegister, Clock, StepCounter, ProgramCounter, TransferRegister
from .pseudo_devices import RamProxy


@dataclass
class PinConfig:
    @staticmethod
    def load_from_yaml(filename: str) -> 'PinConfig':
        with open(filename) as stream:
            yconf = yaml.safe_load(stream)
            return PinConfig(**yconf)

    def __init__(self, muxes: list[dict[str, Any]], shared_pins: list[dict[str, Any]], devices: list[dict[str, Any]]) -> None:
        self.muxes = {m['name']: Mux(**m) for m in muxes}
        self.shared = {}
        for s in shared_pins:
            self.shared[s['name']] = SimplePin(s['pin'], Level[s['level']], PinUsage.SHARED, s['name'])
        self.devices: dict[str, DeviceBase] = {}

        for d in devices:
            name = d['name']
            args = {'name': name}
            if 'pins' in d:
                for pn, p in d['pins'].items():
                    if p.get('mux') is not None:
                        mux = MuxPin(self.muxes[p['mux']], p['pin'])
                        args[pn] = mux
                    else:
                        if isinstance(p['pin'], str):
                            if p['pin'] in self.shared:
                                pin = self.shared[p['pin']]
                            else:
                                raise ValueError(f"Unknown shared pin {p['pin']} in device {name}")
                        else:
                            if 'level' not in p:
                                raise ValueError(f"Missing level for pin {pn} in device {name}")
                            pin = SimplePin(p['pin'], Level[p.get('level')], PinUsage.EXCLUSIVE)
                        args[pn] = pin

            match d['type']:
                case 'GPRegister':
                    self.devices[name] = GPRegister(**args)
                case 'ALU':
                    self.devices[name] = ALU(**args)
                case "FlagsRegister":
                    self.devices[name] = FlagsRegister(**args)
                case "RAM":
                    self.devices[name] = RAM(**args)
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

