#!/usr/bin/env python3

import yaml # type: ignore
from dataclasses import dataclass, field
from typing import Any
from enum import Enum, auto

from .pin import Mux, MuxPin
from .devices import GPRegister, DeviceBase


@dataclass
class PinConfig:
    @staticmethod
    def load_from_yaml(filename: str) -> 'PinConfig':
        with open(filename) as stream:
            yconf = yaml.safe_load(stream)
            return PinConfig(**yconf)

    def __init__(self, muxes: list[dict[str, Any]], devices: list[dict[str, Any]]) -> None:
        self.muxes = {m['name']: Mux(**m) for m in muxes}
        self.devices: dict[str, DeviceBase] = {}

        for d in devices:
            name = d['name']
            args = {'name': name}
            for pn, p in d['pins'].items():
                if p.get('mux') is not None:
                    mux = MuxPin(self.muxes[p['mux']], p['pin'])
                args[pn] = mux

            match d['type']:
                case 'GPRegister':
                    self.devices[name] = GPRegister(**args)
