#!/usr/bin/python3

import pytest

from libcpu.cpu import *
from libcpu.DeviceSetup import IR, IRFetch
from libcpu.test_helpers import CPUHelper
from libcpu.DeviceSetup import AddSub as alu
from typing import Iterator

pytestmark = pytest.mark.hardware

def test_reg_a_latch(cpu_helper: CPUHelper) -> None:
        backend = cpu_helper.backend

        cpu_helper.load_reg8(A, 54)
        cpu_helper.load_reg8(B, 0)

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


def singlebit_vals() -> Iterator[int]:
    yield 255
    for b in range(8):
        yield 1 << b
    yield 0

@pytest.mark.parametrize("expected", singlebit_vals())
def test_ir_load(cpu_helper: CPUHelper, expected: int) -> None:
    backend = cpu_helper.backend

    backend.client.bus_set(expected)
    IR.load.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    backend.client.clock_tick()

    backend.control.reset()
    IRFetch.load.enable()

    readback = backend.client.ir_get(backend.control.c_word)

    backend.control.reset()
    backend.client.off(backend.control.default)

    assert readback == expected
