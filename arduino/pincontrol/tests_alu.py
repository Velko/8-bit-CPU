#!/usr/bin/python3

import sys, serial, unittest

from libpins import asm
from libpins.PinClient import PinClient
from libpins.cpu import CPU
from libpins.devices import Flags

ser = serial.Serial("/dev/ttyACM0", 9600, timeout=3)
pins = PinClient(ser)
cpu = CPU(pins)


class RegisterLoadOut(unittest.TestCase):

    def load_test_value(self, register, value):

        ldi (register, value)
        received = out(register)

        self.assertEqual(value, received)

    # Register A
    def test_load_A_0(self):
        self.load_test_value(A, 0)

    def test_load_A_1(self):
        self.load_test_value(A, 1)

    def test_load_A_2(self):
        self.load_test_value(A, 2)

    def test_load_A_4(self):
        self.load_test_value(A, 4)

    def test_load_A_8(self):
        self.load_test_value(A, 8)

    def test_load_A_16(self):
        self.load_test_value(A, 16)

    def test_load_A_32(self):
        self.load_test_value(A, 32)

    def test_load_A_64(self):
        self.load_test_value(A, 64)

    def test_load_A_128(self):
        self.load_test_value(A, 128)

    def test_load_A_255(self):
        self.load_test_value(A, 255)


    # Register B
    def test_load_B_0(self):
        self.load_test_value(B, 0)

    def test_load_B_1(self):
        self.load_test_value(B, 1)

    def test_load_B_2(self):
        self.load_test_value(B, 2)

    def test_load_B_4(self):
        self.load_test_value(B, 4)

    def test_load_B_8(self):
        self.load_test_value(B, 8)

    def test_load_B_16(self):
        self.load_test_value(B, 16)

    def test_load_B_32(self):
        self.load_test_value(B, 32)

    def test_load_B_64(self):
        self.load_test_value(B, 64)

    def test_load_B_128(self):
        self.load_test_value(B, 128)

    def test_load_B_255(self):
        self.load_test_value(B, 255)

    #ALU operations
    def test_add_ab_result_small(self):
        ldi(A, 24)
        ldi(B, 18)

        add(A)

        value = out(A)
        self.assertEqual(42, value)

    def test_add_ab_flags_small(self):
        ldi(A, 24)
        ldi(B, 18)

        add(A)

        flags = Flags.decode(pins.flags_get())
        self.assertEqual("----", flags)

    def test_add_ab_result_carry(self):
        ldi(A, 245)
        ldi(B, 18)

        add(A)

        value = out(A)
        self.assertEqual(7, value)

    def test_add_ab_flags_carry(self):
        ldi(A, 245)
        ldi(B, 18)

        add(A)

        flags = Flags.decode(pins.flags_get())
        self.assertEqual("-C--", flags)



if __name__ == "__main__":

    # PySerial is not ready directly after connecting
    # try a single operation before proceeding with tests
    pins.identify()
    asm.export_isa(cpu, globals())
    unittest.main()
