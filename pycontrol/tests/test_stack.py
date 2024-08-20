#!/usr/bin/python3

import pytest
import itertools

pytestmark = pytest.mark.hardware

from libcpu.DeviceSetup import SP, LR, A, C, F
from libcpu.devices import Flags
from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.markers import Addr
from libcpu.ctrl_word import CtrlWord, DEFAULT_CW


@pytest.mark.parametrize("expected", [255, 1, 2, 4, 8, 16, 32, 64, 128, 0])
def test_sp_load(cpu_helper: CPUHelper, expected: int) -> None:

    cpu_helper.load_reg16(SP, expected)

    value = cpu_helper.read_reg16(SP)

    assert value == expected

def test_lea_sp(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    acpu.lea (SP, Addr(0x1234))

    value = cpu_helper.read_reg16(SP)

    assert value == 0x1234

# check transitions between SP chips
@pytest.mark.parametrize("expected", itertools.chain(range(0xC, 0x15), range(0xFC, 0x105), range(0xFFC, 0x1005)))
def test_sp_inc(cpu_helper: CPUHelper, expected: int) -> None:
    cpu_helper.load_reg16(SP, expected - 1)

    control = CtrlWord()\
        .enable(SP.inc)\
        .enable(SP.out)
    cpu_helper.client.ctrl_commit(control.c_word)
    cpu_helper.client.clock_tick()
    cpu_helper.client.off(DEFAULT_CW.c_word)


    value = cpu_helper.read_reg16(SP)
    assert value == expected

@pytest.mark.parametrize("expected", itertools.chain(range(0xC, 0x15), range(0xFC, 0x105), range(0xFFC, 0x1005)))
def test_sp_dec(cpu_helper: CPUHelper, expected: int) -> None:
    cpu_helper.load_reg16(SP, expected + 1)

    control = CtrlWord()\
        .enable(SP.dec)\
        .enable(SP.out)
    cpu_helper.client.ctrl_commit(control.c_word)
    cpu_helper.client.clock_tick()
    cpu_helper.client.off(DEFAULT_CW.c_word)


    value = cpu_helper.read_reg16(SP)
    assert value == expected


def test_push_a(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    # preparation - clear value at address 17
    cpu_helper.write_ram(0x17, 0)

    # initialize SP
    cpu_helper.load_reg16(SP, 0x18)

    # push 72 onto stack
    cpu_helper.load_reg8(A, 72)
    acpu.push (A)

    # read back sp and value at address 17
    spval = cpu_helper.read_reg16(SP)
    memval = cpu_helper.read_ram(0x17)

    assert spval == 0x17
    assert memval == 72


def test_pop_a(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    # preparation - set value at address 54
    cpu_helper.write_ram(0x54, 23)

    # load target with different value
    cpu_helper.load_reg8(A, 0)

    # initialize SP
    cpu_helper.load_reg16(SP, 0x54)

    # load in from stack
    acpu.pop (A)

    # read back sp and value in register
    spval = cpu_helper.read_reg16(SP)
    regval = cpu_helper.read_reg8(A)

    assert spval == 0x55
    assert regval == 23

def test_push_pop(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    cpu_helper.load_reg16(SP, 0x44)
    cpu_helper.load_reg8(C, 45)

    acpu.push (C)
    cpu_helper.load_reg8(C, 20)
    acpu.pop (C)

    val = cpu_helper.read_reg8(C)
    assert val == 45

def test_push_popf(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    flags_val = Flags(0b1101)

    cpu_helper.load_reg16(SP, 0x88)
    acpu.ldi (F, flags_val)

    acpu.pushf ()
    acpu.ldi (F, Flags.Empty)
    acpu.popf ()

    val = cpu_helper.get_flags()
    assert val == flags_val

def test_push_lr(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.load_reg16(SP, 0x88)

    cpu_helper.load_reg16(LR, 0x1234)

    acpu.push (LR)

    h = cpu_helper.read_ram(0x87)
    l = cpu_helper.read_ram(0x86)

    assert h == 0x12
    assert l == 0x34

def test_pop_lr(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.load_reg16(SP, 0x21)
    cpu_helper.load_reg16(LR, 0)

    cpu_helper.write_ram(0x21, 0x54)
    cpu_helper.write_ram(0x22, 0x83)

    acpu.pop (LR)

    val = cpu_helper.read_reg16(LR)

    assert val == 0x8354

def test_push_pop_lr(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.load_reg16(SP, 0x40)

    cpu_helper.load_reg16(LR, 0x5314)
    acpu.push (LR)
    cpu_helper.load_reg16(LR, 0)

    acpu.pop (LR)

    val = cpu_helper.read_reg16(LR)
    assert val == 0x5314

def test_ldr_sp_plus(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.load_reg16(SP, 0x30)
    cpu_helper.write_ram(0x33, 0x88)
    cpu_helper.load_reg8(A, 0)

    acpu.ldr (A, SP, 3)

    val = cpu_helper.read_reg8(A)

    assert val == 0x88

def test_ldr_sp_minus(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.load_reg16(SP, 0x30)
    cpu_helper.write_ram(0x20, 0x44)
    cpu_helper.load_reg8(A, 0)

    acpu.ldr (A, SP, -16)

    val = cpu_helper.read_reg8(A)

    assert val == 0x44


def test_str_sp_plus(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.load_reg16(SP, 0x30)
    cpu_helper.write_ram(0x33, 0)
    cpu_helper.load_reg8(A, 0x56)

    acpu.strel (SP, 3, A)

    val = cpu_helper.read_ram(0x33)

    assert val == 0x56
