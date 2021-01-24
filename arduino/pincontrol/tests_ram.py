#!/usr/bin/python3

import sys, serial, unittest

import random

from libpins import asm
from libpins.PinClient import PinClient
from libpins.DeviceSetup import *
from libpins.ctrl_word import CtrlWord

control = CtrlWord()

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=3)
pins = PinClient(ser)


class RamLoadOut(unittest.TestCase):

    def set_mar(self, value):
        Mar.load.enable()
        pins.bus_set(value)
        pins.ctrl_commit(control.c_word)
        pins.clock_pulse()
        pins.clock_inverted()

        control.reset()
        pins.off(control.default)

    def write_ram(self, value):
        Ram.buff_oe.enable()
        Ram.ram_oe.enable() # meaning is opposite, we actually turn it off by 'enabling'
        Ram.ram_we.enable()
        pins.bus_set(value)

        # current version of RAM is unclocked that will change soon
        pins.ctrl_commit(control.c_word)
        control.reset()
        pins.off(control.default)


    def read_ram(self):
        Ram.buff_oe.enable()

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

    # PySerial is not ready directly after connecting
    # try a single operation before proceeding with tests
    pins.identify()
    unittest.main()
