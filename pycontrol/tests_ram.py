#!/usr/bin/python3

import unittest

import random

from libcpu.cpu import *
from libcpu.devices import Flags
from libcpu.PyAsmExec import pins, control


class RamLoadOut(unittest.TestCase):

    def set_mar(self, value):
        Mar.load.enable()
        pins.bus_set(value)
        pins.ctrl_commit(control.c_word)
        pins.clock_tick()

        control.reset()
        pins.off(control.default)

    def write_ram(self, value):
        Ram.write.enable()
        pins.bus_set(value)

        pins.ctrl_commit(control.c_word)

        # clocked RAM write
        pins.clock_tick()

        control.reset()
        pins.off(control.default)


    def read_ram(self):
        Ram.out.enable()

        pins.ctrl_commit(control.c_word)
        val = pins.bus_get()

        control.reset()
        pins.off(control.default)

        return val

    def test_load_quick(self):
        self.set_mar(0x80)
        self.write_ram(0x55)

        actual = self.read_ram()

        self.assertEqual(0x55, actual)

    def test_load_all(self):

        data = []

        for addr in range(256):
            value = random.randrange(256)
            data.append(value)

            self.set_mar(addr)
            self.write_ram(value)

        for addr, expected in enumerate(data):
            with self.subTest():
                self.set_mar(addr)

                actual = self.read_ram()

                self.assertEqual(expected, actual)

        self.set_mar(0)

if __name__ == "__main__":

    from libcpu import PyAsmExec
    PyAsmExec.setup()

    unittest.main()
