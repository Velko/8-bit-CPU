#!/usr/bin/python3

import pytest

pytestmark = pytest.mark.hardware

from libcpu.DeviceSetup import PC, LR
from libcpu.cpu import *
from libcpu.markers import Addr
from libcpu.test_helpers import CPUHelper
from libcpu.cpu_exec import CPUBackendControl

@pytest.mark.parametrize("expected", [65535, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 0])
def test_pc_load(cpu_helper: CPUHelper, expected: int) -> None:


    cpu_helper.load_reg16(PC, expected)
    value = cpu_helper.read_reg16(PC)

    assert value == expected




# assuming that PC works at all (test_pc_load should prove that), there's no need
# to count full range. Since it is built from two 161 counter chips, we will select
# range that includes both of them. For example 8..40
@pytest.mark.parametrize("expected", range(8, 40))
def test_pc_count(cpu_helper: CPUHelper, expected: int) -> None:
    # CPU gets a Reset before each test, preload value to increment from
    cpu_helper.load_reg16(PC, expected - 1)

    cpu_helper.backend.control.reset()
    PC.out.enable()
    cpu_helper.backend.client.ctrl_commit(cpu_helper.backend.control.c_word)
    cpu_helper.backend.client.clock_tick()

    value = cpu_helper.read_reg16(PC)

    assert value == expected

def test_beq_taken(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg8(F, 0b0010)
    cpu_helper.load_reg16(PC, 0x1234)

    taken = beq(Addr(0x4321))
    pcaddr = cpu_helper.read_reg16(PC)

    assert taken == True
    assert pcaddr == 0x4321

def test_beq_fallthrough(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg8(F, 0b0000)
    cpu_helper.load_reg16(PC, 0x1234)

    taken = beq(Addr(0x4321))
    pcaddr = cpu_helper.read_reg16(PC)

    assert taken == False
    assert pcaddr == 0x1236


def test_bne_taken(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg8(F, 0b0000)
    cpu_helper.load_reg16(PC, 0x1234)

    taken = bne(Addr(0x4321))
    pcaddr = cpu_helper.read_reg16(PC)

    assert taken == True
    assert pcaddr == 0x4321

def test_bne_fallthrough(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg8(F, 0b0010)
    cpu_helper.load_reg16(PC, 0x1234)

    taken = bne(Addr(0x4321))
    pcaddr = cpu_helper.read_reg16(PC)

    assert taken == False
    assert pcaddr == 0x1236

def test_bcs_taken(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg8(F, 0b0100)
    cpu_helper.load_reg16(PC, 0x1234)

    taken = bcs(Addr(0x4321))
    pcaddr = cpu_helper.read_reg16(PC)

    assert taken == True
    assert pcaddr == 0x4321

def test_bcs_fallthrough(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg8(F, 0b0000)
    cpu_helper.load_reg16(PC, 0x1234)

    taken = bcs(Addr(0x4321))
    pcaddr = cpu_helper.read_reg16(PC)

    assert taken == False
    assert pcaddr == 0x1236

def test_bcc_taken(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg8(F, 0b0000)
    cpu_helper.load_reg16(PC, 0x1234)

    taken = bcc(Addr(0x4321))
    pcaddr = cpu_helper.read_reg16(PC)

    assert taken == True
    assert pcaddr == 0x4321

def test_bcc_fallthrough(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg8(F, 0b0100)
    cpu_helper.load_reg16(PC, 0x1234)

    taken = bcc(Addr(0x4321))
    pcaddr = cpu_helper.read_reg16(PC)

    assert taken == False
    assert pcaddr == 0x1236

def test_lr_pc_swap(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg16(PC, 0xaa)
    cpu_helper.load_reg16(LR, 43)

    ret()

    value = cpu_helper.read_reg16(PC)

    assert value == 43

def test_call_addr(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg16(PC, 0x12bb)

    call (Addr(452))

    value = cpu_helper.read_reg16(PC)

    retaddr = cpu_helper.read_reg16(LR)

    assert value == 452
    assert retaddr == 0x12bd

def test_jmp_addr(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg16(PC, 0)

    jmp(Addr(0x1084))

    value = cpu_helper.read_reg16(PC)
    assert value == 0x1084

def test_rjmp_offset(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg16(PC, 32)

    rjmp(14)

    value = cpu_helper.read_reg16(PC)
    assert value == 46