#!/usr/bin/python3

import sys, serial, unittest

from libpins import asm
from libpins.PinClient import PinClient
from libpins.cpu import CPU
from libpins.devices import Flags

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=3)
pins = PinClient(ser)
cpu = CPU(pins)

# Common test cases for registers
# see RegisterALoadOut, RegisterBLoadOut
# for actual usage
class RegisterLoadOutCommon:
    def load_test_value(self, value):

        ldi (self.register, value)
        received = out(self.register)

        self.assertEqual(value, received)

    def test_load_0(self):
        self.load_test_value(0)

    # Check each bit separately
    def test_load_1(self):
        self.load_test_value(1)

    def test_load_2(self):
        self.load_test_value(2)

    def test_load_4(self):
        self.load_test_value(4)

    def test_load_8(self):
        self.load_test_value(8)

    def test_load_16(self):
        self.load_test_value(16)

    def test_load_32(self):
        self.load_test_value(32)

    def test_load_64(self):
        self.load_test_value(64)

    def test_load_128(self):
        self.load_test_value(128)

    def test_load_255(self):
        self.load_test_value(255)


class RegisterALoadOut(unittest.TestCase, RegisterLoadOutCommon):
    def setUp(self):
        self.register = A

class RegisterBLoadOut(unittest.TestCase, RegisterLoadOutCommon):
    def setUp(self):
        self.register = B


class AluOperations(unittest.TestCase):
    def test_add_ab_result_small(self):
        ldi(A, 24)
        ldi(B, 18)

        add(A, B)

        value = out(A)
        self.assertEqual(42, value)

    def test_add_ab_flags_small(self):
        ldi(A, 24)
        ldi(B, 18)

        add(A, B)

        flags = Flags.decode(pins.flags_get())
        self.assertEqual("----", flags)

    def test_add_ab_result_wraparound(self):
        ldi(A, 245)
        ldi(B, 18)

        add(A, B)

        value = out(A)
        self.assertEqual(7, value)

    def test_add_ab_flags_carry(self):
        ldi(A, 245)
        ldi(B, 18)

        add(A, B)

        flags = Flags.decode(pins.flags_get())
        self.assertEqual("-C--", flags)

    def test_add_ab_flags_overflow_to_negative(self):
        ldi(A, 126)
        ldi(B, 4)

        add(A, B)

        flags = Flags.decode(pins.flags_get())
        self.assertEqual("V--N", flags)

    def test_add_ab_flags_overflow_to_positive(self):
        ldi(A, 226)
        ldi(B, 145)

        add(A, B)

        flags = Flags.decode(pins.flags_get())
        self.assertEqual("VC--", flags)

    def test_add_ab_flags_zero(self):
        ldi(A, 246)
        ldi(B, 10)

        add(A, B)

        flags = Flags.decode(pins.flags_get())
        self.assertEqual("-CZ-", flags)

    def test_sub_result_small(self):
        ldi(A, 4)
        ldi(B, 3)

        sub(A, B)

        value = out(A)
        self.assertEqual(1, value)

    def test_sub_flags_small(self):
        ldi(A, 4)
        ldi(B, 3)

        sub(A, B)

        flags = Flags.decode(pins.flags_get())
        self.assertEqual("----", flags)

    def test_sub_flags_zero(self):
        ldi(A, 4)
        ldi(B, 4)

        sub(A, B)

        flags = Flags.decode(pins.flags_get())
        self.assertEqual("--Z-", flags)

    def test_sub_result_carry(self):
        ldi(A, 3)
        ldi(B, 5)

        sub(A, B)

        value = out(A)
        self.assertEqual(254, value)

    def test_sub_flags_carry(self):
        ldi(A, 3)
        ldi(B, 5)

        sub(A, B)

        flags = Flags.decode(pins.flags_get())
        self.assertEqual("-C-N", flags)

    def test_sub_overflow_to_positive(self):
        ldi(A, 140)
        ldi(B, 20)

        sub(A, B)

        flags = Flags.decode(pins.flags_get())
        self.assertEqual("V---", flags)

    def test_sub_overflow_to_negative(self):
        ldi(A, 120)
        ldi(B, 130)

        sub(A, B)

        flags = Flags.decode(pins.flags_get())
        self.assertEqual("VC-N", flags)

    def test_sub_flags_zero_(self):
        ldi(A, 20)
        ldi(B, 20)

        sub(A, B)

        flags = Flags.decode(pins.flags_get())
        self.assertEqual("--Z-", flags)




if __name__ == "__main__":

    # PySerial is not ready directly after connecting
    # try a single operation before proceeding with tests
    pins.identify()
    asm.export_isa(cpu, globals())
    unittest.main()
