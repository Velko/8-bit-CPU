#!/usr/bin/python3

import unittest

from libcpu.cpu import *
from libcpu.devices import Flags
from libcpu.PyAsmExec import pins, control

class RegisterOutputLatches(unittest.TestCase):

    def test_a_latch(self):

        from libcpu.DeviceSetup import AddSub as alu

        ldi(A, 54)
        ldi(B, 0)

        # Load another value into A, but "forget" to pulse the
        # inverted clock
        pins.bus_set(40)
        A.load.enable()
        pins.ctrl_commit(control.c_word)

        pins.clock_pulse()
        #pins.clock_inverted()

        control.reset()
        pins.off(control.default)

        # Not try to sense what it sends to ALU by enabling it and
        # reading value on the bus
        alu.out.enable()
        A.alu_a.enable()
        B.alu_b.enable()
        pins.ctrl_commit(control.c_word)
        value = pins.bus_get()

        control.reset()
        pins.off(control.default)

        # should have kept the old value
        self.assertEqual(54, value)

if __name__ == "__main__":

    from libcpu import PyAsmExec
    PyAsmExec.setup()

    unittest.main()
