#!/usr/bin/python3

import pytest

pytestmark = pytest.mark.hardware

from libcpu.DeviceSetup import SP, LR
from libcpu.test_helpers import CPUHelper
from libcpu.cpu import *
from libcpu.markers import Addr


@pytest.mark.parametrize("expected", [255, 1, 2, 4, 8, 16, 32, 64, 128, 0])
def test_sp_load(cpu_helper: CPUHelper, expected: int) -> None:

    cpu_helper.load_reg16(SP, expected)

    value = cpu_helper.read_reg16(SP)

    assert value == expected

def test_lea_sp(cpu_helper: CPUHelper) -> None:

    lea (SP, Addr(0x1234))

    value = cpu_helper.read_reg16(SP)

    assert value == 0x1234

def test_sp_inc(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg16(SP, 12)

    cpu_helper.backend.control.reset()
    SP.inc.enable()
    cpu_helper.backend.client.ctrl_commit(cpu_helper.backend.control.c_word)
    cpu_helper.backend.client.clock_tick()
    cpu_helper.backend.control.reset()
    cpu_helper.backend.client.off(cpu_helper.backend.control.default)


    value = cpu_helper.read_reg16(SP)
    assert value == 13

def test_sp_dec(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg16(SP, 12)

    cpu_helper.backend.control.reset()
    SP.dec.enable()
    cpu_helper.backend.client.ctrl_commit(cpu_helper.backend.control.c_word)
    cpu_helper.backend.client.clock_tick()
    cpu_helper.backend.control.reset()
    cpu_helper.backend.client.off(cpu_helper.backend.control.default)


    value = cpu_helper.read_reg16(SP)
    assert value == 11


def test_push_a(cpu_helper: CPUHelper) -> None:

    # preparation - clear value at address 17
    cpu_helper.write_ram(17, 0)

    # initialize SP
    cpu_helper.load_reg16(SP, 18)

    # push 72 onto stack
    cpu_helper.load_reg8(A, 72)
    push (A)

    # read back sp and value at address 17
    spval = cpu_helper.read_reg16(SP)
    memval = cpu_helper.read_ram(17)

    assert spval == 17
    assert memval == 72


def test_pop_a(cpu_helper: CPUHelper) -> None:

    # preparation - set value at address 54
    cpu_helper.write_ram(54, 23)

    # load target with different value
    cpu_helper.load_reg8(A, 0)

    # initialize SP
    cpu_helper.load_reg16(SP, 54)

    # load in from stack
    pop (A)

    # read back sp and value in register
    spval = cpu_helper.read_reg16(SP)
    regval = cpu_helper.read_reg8(A)

    assert spval == 55
    assert regval == 23

def test_push_pop(cpu_helper: CPUHelper) -> None:

    cpu_helper.load_reg16(SP, 44)
    cpu_helper.load_reg8(C, 45)

    push (C)
    cpu_helper.load_reg8(C, 20)
    pop (C)

    val = cpu_helper.read_reg8(C)
    assert val == 45

def test_push_popf(cpu_helper: CPUHelper) -> None:

    cpu_helper.load_reg16(SP, 88)
    ldi (F, 0b1101)

    pushf ()
    ldi (F, 0)
    popf ()

    val = cpu_helper.backend.client.flags_get()
    assert val == 0b1101

def test_push_lr(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg16(SP, 0x88)

    cpu_helper.load_reg16(LR, 0x1234)

    push (LR)

    h = cpu_helper.read_ram(0x87)
    l = cpu_helper.read_ram(0x86)

    assert h == 0x12
    assert l == 0x34

def test_pop_lr(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg16(SP, 0x21)
    cpu_helper.load_reg16(LR, 0)

    cpu_helper.write_ram(0x21, 0x54)
    cpu_helper.write_ram(0x22, 0x83)

    pop (LR)

    val = cpu_helper.read_reg16(LR)

    assert val == 0x8354

def test_push_pop_lr(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg16(SP, 0x40)

    cpu_helper.load_reg16(LR, 0x5314)
    push (LR)
    cpu_helper.load_reg16(LR, 0)

    pop (LR)

    val = cpu_helper.read_reg16(LR)
    assert val == 0x5314

