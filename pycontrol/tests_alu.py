#!/usr/bin/python3

import unittest

from libcpu.cpu import *
from libcpu.devices import Flags
from libcpu.PyAsmExec import pins, control

@unittest.skip("unsupported with hardwired ALU inputs")
class AluOperationsSwitchableInputs(unittest.TestCase):
    def test_sub_b_a_small(self):
        ldi(A, 3)
        ldi(B, 4)

        sub(B, A)

        value = peek(B)
        self.assertEqual(1, value)

    def test_add_a_a(self):
        ldi(A, 21)

        add(A, A)

        value = peek(A)
        self.assertEqual(42, value)

    def test_add_b_b(self):
        ldi(B, 18)

        add(B, B)

        value = peek(B)
        self.assertEqual(36, value)

    def test_sub_a_a(self):
        ldi(A, 32)

        sub(A, A)

        value = peek(A)
        self.assertEqual(0, value)

    def test_sub_b_b(self):
        ldi(B, 63)

        sub(B, B)

        value = peek(B)
        self.assertEqual(0, value)

class RegisterMov(unittest.TestCase):
    def test_mov_a_b(self):
        ldi(A, 0)
        ldi(B, 42)

        mov(A, B)

        value = peek(A)
        self.assertEqual(42, value)

    def test_mov_b_a(self):
        ldi(A, 34)
        ldi(B, 0)

        mov(B, A)

        value = peek(B)
        self.assertEqual(34, value)

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

class StoreRecall(unittest.TestCase):
    def test_store_load(self):
        ldi (B, 42)
        ldi (A, 11)

        st (5, B)
        ld (A, 5)

        val = peek (A)

        self.assertEqual(42, val)

if __name__ == "__main__":

    from libcpu import PyAsmExec
    PyAsmExec.setup()

    unittest.main()
