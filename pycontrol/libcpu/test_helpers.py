#!/usr/bin/env python3

from libcpu.devices import Register
from libcpu.cpu_exec import CPUBackendControl
from libcpu.DeviceSetup import Has


class CPUHelper:
    def __init__(self, backend: CPUBackendControl) -> None:
        self.backend = backend

    def load_reg16(self, reg: Register, value: int) -> None:
        self.backend.control.reset()
        self.backend.client.bus_set(value >> 8)
        Has.load.enable()
        self.backend.client.ctrl_commit(self.backend.control.c_word)
        self.backend.client.clock_tick()

        self.backend.control.reset()
        self.backend.client.bus_set(value & 0xFF)
        Has.out.enable()
        reg.load.enable()
        self.backend.client.ctrl_commit(self.backend.control.c_word)
        self.backend.client.clock_tick()

        self.backend.control.reset()
        self.backend.client.off(self.backend.control.default)

    def read_reg16(self, reg: Register) -> int:
        self.backend.control.reset()
        reg.out.enable()
        Has.dir.enable()
        Has.load.enable()
        self.backend.client.ctrl_commit(self.backend.control.c_word)
        self.backend.client.clock_tick()
        value = self.backend.client.bus_get()

        self.backend.control.reset()
        Has.dir.enable()
        Has.out.enable()
        self.backend.client.ctrl_commit(self.backend.control.c_word)
        value |= self.backend.client.bus_get() << 8

        self.backend.client.off(self.backend.control.default)

        return value

