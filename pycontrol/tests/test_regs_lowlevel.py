#!/usr/bin/python3

import pytest

from libcpu.DeviceSetup import hardware
from libcpu.cpu_helper import CPUHelper
from collections.abc import Iterator
from libcpu.ctrl_word import CtrlWord, DEFAULT_CW

pytestmark = pytest.mark.hardware

A = hardware.gp_reg("A")
B = hardware.gp_reg("B")
alu = hardware.alu("AddSub")
IR = hardware.IR
TX = hardware.transfer["TX"]
TH = hardware.transfer["TH"]
TL = hardware.transfer["TL"]

def test_reg_a_latch(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg8(A, 54)
    cpu_helper.load_reg8(B, 0)

    # Load another value into A, but "forget" to pulse the
    # inverted clock
    cpu_helper.client.bus_set(40)
    control = CtrlWord()\
        .enable(A.load)
    cpu_helper.client.ctrl_commit(control.c_word)

    cpu_helper.client.clock_pulse()
    #backend.client.clock_inverted()

    cpu_helper.client.off(DEFAULT_CW.c_word)

    # Not try to sense what it sends to ALU by enabling it and
    # reading value on the bus
    control = CtrlWord()\
        .enable(alu.out)\
        .enable(A.alu_l)\
        .enable(B.alu_r)
    cpu_helper.client.ctrl_commit(control.c_word)
    value = cpu_helper.client.bus_get()

    cpu_helper.client.off(DEFAULT_CW.c_word)

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
    cpu_helper.client.ctrl_commit(control.c_word)
    cpu_helper.client.clock_tick()

    readback = cpu_helper.client.ir_get()

    cpu_helper.client.off(DEFAULT_CW.c_word)

    assert readback == expected

def test_tx_load(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg8(TH, 0x12)
    cpu_helper.load_reg8(TL, 0x34)


    loaded = cpu_helper.read_reg16(TX)

    assert loaded == 0x1234
