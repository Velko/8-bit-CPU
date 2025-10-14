#!/usr/bin/python3

import pytest

from libcpu.devmap import A, B, AddSub, IR, TH, TL, TX
from libcpu.cpu_helper import CPUHelper
from collections.abc import Iterator
from libcpu.ctrl_word import CtrlWord
from libcpu.DeviceSetup import hardware as hw

pytestmark = pytest.mark.hardware

def test_reg_a_latch(cpu_helper: CPUHelper) -> None:
    cpu_helper.regs.A = 54
    cpu_helper.regs.B = 0

    # Load another value into A, but "forget" to pulse the
    # inverted clock
    cpu_helper.client.bus_set(40)
    control = CtrlWord()\
        .enable(A.load)
    cpu_helper.client.ctrl_commit(control)

    cpu_helper.client.clock_pulse()
    #backend.client.clock_inverted()

    cpu_helper.client.off()

    # Not try to sense what it sends to ALU by enabling it and
    # reading value on the bus
    control = CtrlWord()\
        .enable(AddSub.out)\
        .enable(A.alu_l)\
        .enable(B.alu_r)
    cpu_helper.client.ctrl_commit(control)
    value = cpu_helper.client.bus_get()

    cpu_helper.client.off()

    # should have kept the old value
    assert value == 54


def singlebit_vals() -> Iterator[int]:
    yield 255
    for b in range(8):
        yield 1 << b
    yield 0

@pytest.mark.parametrize("expected", singlebit_vals())
def test_ir_load(cpu_helper: CPUHelper, expected: int) -> None:
    cpu_helper.client.bus_set(expected)
    control = CtrlWord()\
        .enable(IR.load)
    cpu_helper.client.ctrl_commit(control)
    cpu_helper.client.clock_tick()

    readback = cpu_helper.client.ir_get()

    cpu_helper.client.off()

    assert readback == expected

def test_tx_load(cpu_helper: CPUHelper) -> None:
    cpu_helper.regs.TH = 0x12
    cpu_helper.regs.TL = 0x34

    assert cpu_helper.regs.TX == 0x1234
