#!/usr/bin/python3

import unittest

from libcpu.cpu import *
from libcpu.devices import Flags
from libcpu.PyAsmExec import pins, control

class AluOperations(unittest.TestCase):
    def test_add_ab_result_small(self):
        ldi(A, 24)
        ldi(B, 18)

        add(A, B)

        value = peek(A)
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

        value = peek(A)
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

        value = peek(A)
        self.assertEqual(1, value)

    def test_sub_flags_small(self):
        ldi(A, 4)
        ldi(B, 3)

        sub(A, B)

        flags = Flags.decode(pins.flags_get())
        self.assertEqual("----", flags)

    def test_sub_result_zero(self):
        ldi(A, 4)
        ldi(B, 4)

        sub(A, B)

        value = peek(A)
        self.assertEqual(0, value)

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

        value = peek(A)
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

    def test_sub_flags_zero(self):
        ldi(A, 20)
        ldi(B, 20)

        sub(A, B)

        flags = Flags.decode(pins.flags_get())
        self.assertEqual("--Z-", flags)

    @unittest.expectedFailure
    def test_sub_ba_result_small(self):
        ldi(A, 3)
        ldi(B, 4)

        sub(B, A)

        value = peek(B)
        self.assertEqual(1, value)



class FlagsOutSameAsFlagsGet(unittest.TestCase):
    def test_flags_out_n(self):
        ldi(A, 230)
        ldi(B, 5)
        add(A, B)

        f = peek(F)

        flags = Flags.decode(f)
        self.assertEqual("---N", flags)

    def test_flags_out_z(self):
        ldi(A, 5)
        ldi(B, 5)
        sub(A, B)

        f = peek(F)

        flags = Flags.decode(f)
        self.assertEqual("--Z-", flags)

    def test_flags_out_c(self):
        ldi(A, 230)
        ldi(B, 40)
        add(A, B)

        f = peek(F)

        flags = Flags.decode(f)
        self.assertEqual("-C--", flags)

    def test_flags_out_v(self):
        ldi(A, 140)
        ldi(B, 20)
        sub(A, B)

        f = peek(F)

        flags = Flags.decode(f)
        self.assertEqual("V---", flags)

    def test_result_adc_ab_c_set(self):
        ldi (F, 0b0100)
        ldi (A, 5)
        ldi (B, 3)

        adc(A, B)

        value = peek(A)
        self.assertEqual(9, value)

    def test_result_adc_ab_c_clear(self):
        ldi (F, 0)
        ldi (A, 5)
        ldi (B, 3)

        adc(A, B)

        value = peek(A)
        self.assertEqual(8, value)

    def test_result_sbb_ab_c_set(self):
        ldi (F, 0b0100)
        ldi (A, 5)
        ldi (B, 3)

        sbb(A, B)

        value = peek(A)
        self.assertEqual(1, value)

    def test_result_sbb_ab_c_clear(self):
        ldi (F, 0)
        ldi (A, 5)
        ldi (B, 3)

        sbb(A, B)

        value = peek(A)
        self.assertEqual(2, value)


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