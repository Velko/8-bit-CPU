#!/usr/bin/python3

import pytest
import itertools

pytestmark = pytest.mark.hardware

from libcpu.devmap import SP, A, C, LR
from libcpu.devices import Flags
from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.markers import Addr
from libcpu.ctrl_word import CtrlWord, DEFAULT_CW
from libcpu.util import unwrap

@pytest.mark.parametrize("expected", [255, 1, 2, 4, 8, 16, 32, 64, 128, 0])
def test_sp_load(cpu_helper: CPUHelper, expected: int) -> None:

    cpu_helper.regs.SP = expected

    assert cpu_helper.regs.SP == expected

def test_lea_sp(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    acpu.lea (SP, Addr(0x1234))

    assert cpu_helper.regs.SP == 0x1234

# check transitions between SP chips
@pytest.mark.parametrize("expected", itertools.chain(range(0xC, 0x15), range(0xFC, 0x105), range(0xFFC, 0x1005)))
def test_sp_inc(cpu_helper: CPUHelper, expected: int) -> None:
    cpu_helper.regs.SP = expected - 1

    control = CtrlWord()\
        .enable(SP.inc)\
        .enable(SP.out)
    cpu_helper.client.ctrl_commit(control.c_word)
    cpu_helper.client.clock_tick()
    cpu_helper.client.off(DEFAULT_CW.c_word)

    assert cpu_helper.regs.SP == expected

@pytest.mark.parametrize("expected", itertools.chain(range(0xC, 0x15), range(0xFC, 0x105), range(0xFFC, 0x1005)))
def test_sp_dec(cpu_helper: CPUHelper, expected: int) -> None:
    cpu_helper.regs.SP = expected + 1

    control = CtrlWord()\
        .enable(SP.dec)\
        .enable(SP.out)
    cpu_helper.client.ctrl_commit(control.c_word)
    cpu_helper.client.clock_tick()
    cpu_helper.client.off(DEFAULT_CW.c_word)

    assert cpu_helper.regs.SP == expected


def test_push_a(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    # preparation - clear value at address 17
    cpu_helper.ram[0x17] = 0

    # initialize SP
    cpu_helper.regs.SP = 0x18

    # push 72 onto stack
    cpu_helper.regs.A = 72
    acpu.push (A)

    # read back sp and value at address 17
    assert cpu_helper.regs.SP == 0x17
    assert cpu_helper.ram[0x17] == 72


def test_pop_a(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    # preparation - set value at address 54
    cpu_helper.ram[0x54] = 23

    # load target with different value
    cpu_helper.regs.A = 0

    # initialize SP
    cpu_helper.regs.SP = 0x54

    # load in from stack
    acpu.pop (A)

    # read back sp and value in register
    assert cpu_helper.regs.SP == 0x55
    assert cpu_helper.regs.A == 23

def test_push_pop(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    cpu_helper.regs.SP = 0x44
    cpu_helper.regs.C = 45

    acpu.push (C)
    cpu_helper.regs.C = 20
    acpu.pop (C)

    assert cpu_helper.regs.C == 45

def test_push_popf(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    flags_val = Flags(0b1101)

    cpu_helper.regs.SP = 0x88
    cpu_helper.regs.F = flags_val

    acpu.pushf ()
    cpu_helper.regs.F = Flags.Empty
    acpu.popf ()

    assert cpu_helper.regs.F == flags_val

def test_push_lr(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.SP = 0x88

    cpu_helper.regs.LR = 0x1234

    acpu.push (LR)

    assert cpu_helper.ram[0x87] == 0x12
    assert cpu_helper.ram[0x86] == 0x34

def test_pop_lr(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.SP = 0x21
    cpu_helper.regs.LR = 0

    cpu_helper.ram[0x21] = 0x54
    cpu_helper.ram[0x22] = 0x83

    acpu.pop (LR)

    assert cpu_helper.regs.LR == 0x8354

def test_push_pop_lr(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.SP = 0x40

    cpu_helper.regs.LR = 0x5314
    acpu.push (LR)
    cpu_helper.regs.LR = 0

    acpu.pop (LR)

    assert cpu_helper.regs.LR == 0x5314

def test_ldr_sp_plus(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.SP = 0x30
    cpu_helper.ram[0x33] = 0x88
    cpu_helper.regs.A = 0

    acpu.ldr (A, SP, 3)

    assert cpu_helper.regs.A == 0x88

def test_ldr_sp_minus(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.SP = 0x30
    cpu_helper.ram[0x20] = 0x44
    cpu_helper.regs.A = 0

    acpu.ldr (A, SP, -16)

    assert cpu_helper.regs.A == 0x44


def test_str_sp_plus(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.SP = 0x30
    cpu_helper.ram[0x33] = 0
    cpu_helper.regs.A = 0x56

    acpu.strel (SP, 3, A)

    assert cpu_helper.ram[0x33] == 0x56
