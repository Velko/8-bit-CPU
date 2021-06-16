#!/usr/bin/env python3

from libcpu.devices import Register
from libcpu.cpu_exec import CPUBackendControl
from libcpu.DeviceSetup import Flags, Ram
from libcpu.markers import InitializedBuffer


class CPUHelper:
    def __init__(self, backend: CPUBackendControl) -> None:
        self.backend = backend

    def load_reg16(self, reg: Register, value: int) -> None:
        self.backend.control.reset()
        reg.load.enable()
        self.backend.client.addr_set(value)
        self.backend.client.ctrl_commit(self.backend.control.c_word)
        self.backend.client.clock_tick()

        self.backend.client.off(self.backend.control.default)


    def read_reg16(self, reg: Register) -> int:
        # fire inverted clock to latch PC value into secondary
        self.backend.client.clock_inverted()

        self.backend.control.reset()
        reg.out.enable()
        self.backend.client.ctrl_commit(self.backend.control.c_word)
        value = self.backend.client.addr_get()

        self.backend.client.off(self.backend.control.default)

        return value


    def read_ram(self, addr: int) -> int:
        self.backend.client.addr_set(addr)
        self.backend.control.reset()
        Ram.out.enable()
        self.backend.client.ctrl_commit(self.backend.control.c_word)

        value = self.backend.client.bus_get()

        self.backend.control.reset()
        self.backend.client.off(self.backend.control.default)

        return value

    def write_ram(self, addr: int, value: int) -> None:
        self.backend.control.reset()
        Ram.write.enable()
        self.backend.client.ctrl_commit(self.backend.control.c_word)

        self.backend.client.addr_set(addr)
        self.backend.client.bus_set(value)

        self.backend.client.clock_tick()

        self.backend.control.reset()
        self.backend.client.off(self.backend.control.default)

    def write_data(self, data: InitializedBuffer) -> None:
        for i in range(data.size):
            self.write_ram(data.start + i, data.data[i]);

    def get_flags(self) -> int:
        return self.backend.client.flags_get()

    def get_flags_s(self) -> str:
        return Flags.decode(self.get_flags())

    def read_reg8(self, reg: Register) -> int:
        self.backend.control.reset()
        reg.out.enable()
        self.backend.client.ctrl_commit(self.backend.control.c_word)
        value = self.backend.client.bus_get()

        self.backend.client.off(self.backend.control.default)

        return value

    def load_reg8(self, reg: Register, value: int) -> None:
        self.backend.control.reset()
        reg.load.enable()
        self.backend.client.bus_set(value)
        self.backend.client.ctrl_commit(self.backend.control.c_word)
        self.backend.client.clock_tick()
        self.backend.control.reset()
        self.backend.client.off(self.backend.control.default)
