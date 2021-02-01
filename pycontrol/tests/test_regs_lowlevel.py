#!/usr/bin/python3

import pytest

from libcpu.cpu import *
from libcpu.DeviceSetup import AddSub as alu


def test_reg_a_latch(cpu_backend_real):
        backend = cpu_backend_real

        ldi(A, 54)
        ldi(B, 0)

        # Load another value into A, but "forget" to pulse the
        # inverted clock
        backend.client.bus_set(40)
        A.load.enable()
        backend.client.ctrl_commit(backend.control.c_word)

        backend.client.clock_pulse()
        #backend.client.clock_inverted()

        backend.control.reset()
        backend.client.off(backend.control.default)

        # Not try to sense what it sends to ALU by enabling it and
        # reading value on the bus
        alu.out.enable()
        A.alu_a.enable()
        B.alu_b.enable()
        backend.client.ctrl_commit(backend.control.c_word)
        value = backend.client.bus_get()

        backend.control.reset()
        backend.client.off(backend.control.default)

        # should have kept the old value
        assert value == 54
