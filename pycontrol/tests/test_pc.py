#!/usr/bin/python3

import pytest
import itertools

pytestmark = pytest.mark.hardware

from libcpu.devmap import PC, LR
from libcpu.markers import Addr
from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.devices import Flags
from libcpu.ctrl_word import CtrlWord
from libcpu.util import unwrap

@pytest.mark.parametrize("expected", [65535, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 0])
def test_pc_load(cpu_helper: CPUHelper, expected: int) -> None:

    cpu_helper.regs.PC = expected

    assert cpu_helper.regs.PC == expected




# assuming that PC works at all (test_pc_load should prove that), there's no need
# to count full range. Since it is built from four 161 counter chips, we should check
# ranges that include transitions between chips
@pytest.mark.parametrize("expected", itertools.chain(range(0xC, 0x15), range(0xFC, 0x105), range(0xFFC, 0x1005)))
def test_pc_count(cpu_helper: CPUHelper, expected: int) -> None:
    # CPU gets a Reset before each test, preload value to increment from
    cpu_helper.regs.PC = expected - 1

    control = CtrlWord()\
        .enable(PC.out)\
        .enable(PC.inc)
    cpu_helper.client.ctrl_commit(control.c_word)
    cpu_helper.client.clock_tick()

    assert cpu_helper.regs.PC == expected

def test_reset_inits_pc(cpu_helper: CPUHelper) -> None:
    cpu_helper.client.reset()

    assert cpu_helper.regs.PC == 0xE000

def test_beq_taken(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.F = Flags.Z
    cpu_helper.regs.PC = 0x1234

    acpu.beq(Addr(0x4321))

    assert cpu_helper.regs.PC == 0x4321

def test_beq_fallthrough(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.F = Flags.Empty
    cpu_helper.regs.PC = 0x1234

    acpu.beq(Addr(0x4321))

    assert cpu_helper.regs.PC == 0x1236


def test_bne_taken(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.F = Flags.Empty
    cpu_helper.regs.PC = 0x1234

    acpu.bne(Addr(0x4321))

    assert cpu_helper.regs.PC == 0x4321

def test_bne_fallthrough(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.F = Flags.Z
    cpu_helper.regs.PC = 0x1234

    acpu.bne(Addr(0x4321))

    assert cpu_helper.regs.PC == 0x1236

def test_bcs_taken(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.F = Flags.C
    cpu_helper.regs.PC = 0x1234

    acpu.bcs(Addr(0x4321))

    assert cpu_helper.regs.PC == 0x4321

def test_bcs_fallthrough(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.F = Flags.Empty
    cpu_helper.regs.PC = 0x1234

    acpu.bcs(Addr(0x4321))

    assert cpu_helper.regs.PC == 0x1236

def test_bcc_taken(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.F = Flags.Empty
    cpu_helper.regs.PC = 0x1234

    acpu.bcc(Addr(0x4321))

    assert cpu_helper.regs.PC == 0x4321

def test_bcc_fallthrough(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.F = Flags.C
    cpu_helper.regs.PC = 0x1234

    acpu.bcc(Addr(0x4321))

    assert cpu_helper.regs.PC == 0x1236

def test_lr_pc_swap(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.PC, 0xaa
    cpu_helper.regs.LR = 43

    acpu.ret()

    assert cpu_helper.regs.PC == 43

def test_call_addr(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.PC = 0x12bb

    acpu.call (Addr(452))

    assert cpu_helper.regs.PC == 452
    assert cpu_helper.regs.LR == 0x12bd

def test_jmp_addr(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.PC = 0

    acpu.jmp(Addr(0x1084))

    assert cpu_helper.regs.PC == 0x1084

def test_rjmp_offset(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.PC = 32

    acpu.rjmp(14)

    assert cpu_helper.regs.PC == 46
