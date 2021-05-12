#!/usr/bin/python3

import pytest

from libcpu.test_helpers import CPUHelper

pytestmark = pytest.mark.hardware

from libcpu.DeviceSetup import PC, LR
from libcpu.cpu_exec import CPUBackendControl
from libcpu.cpu import *
from libcpu.markers import Addr

@pytest.mark.parametrize("expected", [65535, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 0])
def test_pc_load(cpu_helper: CPUHelper, expected: int) -> None:


    cpu_helper.load_reg16(PC, expected)
    value = cpu_helper.read_reg16(PC)

    assert value == expected



class PCNext8: pass

# assuming that PC works at all (test_pc_load should prove that), there's no need
# to count full range. Since it is built from two 161 counter chips, we will select
# range that includes both of them. For example 8..40
@pytest.fixture(scope="module")
def set_pc_next8(cpu_helper: CPUHelper) -> PCNext8:
    # set PC to value so that next becomes 0
    # (easier to test this way)
    cpu_helper.load_reg16(PC, 7)

    return PCNext8()


@pytest.mark.parametrize("expected", range(8, 40))
def test_pc_count(cpu_helper: CPUHelper, set_pc_next8: PCNext8, expected: int) -> None:


    PC.count.enable()
    cpu_helper.backend.client.ctrl_commit(cpu_helper.backend.control.c_word)
    cpu_helper.backend.client.clock_tick()

    value = cpu_helper.read_reg16(PC)

    assert value == expected

def test_beq_taken(cpu_backend_real: CPUBackendControl) -> None:
    ldi (F, 0b0010)

    taken = beq()

    assert taken == True

def test_beq_fallthrough(cpu_backend_real: CPUBackendControl) -> None:
    ldi (F, 0b0000)

    taken = beq()

    assert taken == False

def test_bne_taken(cpu_backend_real: CPUBackendControl) -> None:
    ldi (F, 0b0000)

    taken = bne()

    assert taken == True

def test_bne_fallthrough(cpu_backend_real: CPUBackendControl) -> None:
    ldi (F, 0b0010)

    taken = bne()

    assert taken == False

def test_bcs_taken(cpu_backend_real: CPUBackendControl) -> None:
    ldi (F, 0b0100)

    taken = bcs()

    assert taken == True

def test_bcs_fallthrough(cpu_backend_real: CPUBackendControl) -> None:
    ldi (F, 0b0000)

    taken = bcs()

    assert taken == False

def test_bcc_taken(cpu_backend_real: CPUBackendControl) -> None:
    ldi (F, 0b0000)

    taken = bcc()

    assert taken == True

def test_bcc_fallthrough(cpu_backend_real: CPUBackendControl) -> None:
    ldi (F, 0b0100)

    taken = bcc()

    assert taken == False

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