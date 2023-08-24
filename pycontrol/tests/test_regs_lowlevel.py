#!/usr/bin/python3

import pytest

from libcpu.cpu import *
from libcpu.DeviceSetup import IR, TH,TL, TX
from libcpu.cpu_helper import CPUHelper
from libcpu.DeviceSetup import AddSub as alu
from typing import Iterator
from libcpu.ctrl_word import CtrlWord, DEFAULT_CW

pytestmark = pytest.mark.hardware

def test_reg_a_latch(cpu_helper: CPUHelper) -> None:
        backend = cpu_helper.backend

        cpu_helper.load_reg8(A, 54)
        cpu_helper.load_reg8(B, 0)

        # Load another value into A, but "forget" to pulse the
        # inverted clock
        backend.client.bus_set(40)
        control = CtrlWord()\
            .enable(A.load)
        backend.client.ctrl_commit(control.c_word)

        backend.client.clock_pulse()
        #backend.client.clock_inverted()

        backend.client.off(DEFAULT_CW.c_word)

        # Not try to sense what it sends to ALU by enabling it and
        # reading value on the bus
        control = CtrlWord()\
            .enable(alu.out)\
            .enable(A.alu_l)\
            .enable(B.alu_r)
        backend.client.ctrl_commit(control.c_word)
        value = backend.client.bus_get()

        backend.client.off(DEFAULT_CW.c_word)

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
    control = CtrlWord()\
        .enable(IR.load)
    backend.client.ctrl_commit(control.c_word)
    backend.client.clock_tick()

    readback = backend.client.ir_get()

    backend.client.off(DEFAULT_CW.c_word)

    assert readback == expected

def test_tx_load(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg8(TH, 0x12)
    cpu_helper.load_reg8(TL, 0x34)


    loaded = cpu_helper.read_reg16(TX)

    assert loaded == 0x1234
