#!/usr/bin/python3

import pytest

pytestmark = pytest.mark.hardware

from libcpu.DeviceSetup import PC, LR, Has
from libcpu.cpu_exec import CPUBackendControl
from libcpu.cpu import *
from libcpu.markers import Addr

def load_pc(backend: CPUBackendControl, value: int) -> None:
    backend.control.reset()
    backend.client.bus_set(value >> 8)
    Has.load.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    backend.client.clock_tick()

    backend.control.reset()
    backend.client.bus_set(value & 0xFF)
    Has.out.enable()
    PC.load.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    backend.client.clock_tick()

    backend.control.reset()
    backend.client.off(backend.control.default)

def read_pc(backend: CPUBackendControl) -> int:
    backend.control.reset()
    PC.out.enable()
    Has.dir.enable()
    Has.load.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    backend.client.clock_tick()
    value = backend.client.bus_get()

    backend.control.reset()
    Has.dir.enable()
    Has.out.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    value |= backend.client.bus_get() << 8

    backend.client.off(backend.control.default)

    return value

def read_lr(backend: CPUBackendControl) -> int:
    backend.control.reset()
    LR.out.enable()
    Has.dir.enable()
    Has.load.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    backend.client.clock_tick()
    value = backend.client.bus_get()

    backend.control.reset()
    Has.dir.enable()
    Has.out.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    value |= backend.client.bus_get() << 8

    backend.control.reset()
    backend.client.off(backend.control.default)

    return value


@pytest.mark.parametrize("expected", [65535, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 0])
def test_pc_load(cpu_backend_real: CPUBackendControl, expected: int) -> None:

    backend = cpu_backend_real

    load_pc(backend, expected)
    value = read_pc(backend)

    assert value == expected



class PCNext8: pass

# assuming that PC works at all (test_pc_load should prove that), there's no need
# to count full range. Since it is built from two 161 counter chips, we will select
# range that includes both of them. For example 8..40
@pytest.fixture(scope="module")
def set_pc_next8(cpu_backend_real: CPUBackendControl) -> PCNext8:
    # set PC to value so that next becomes 0
    # (easier to test this way)
    load_pc(cpu_backend_real, 7)

    return PCNext8()


@pytest.mark.parametrize("expected", range(8, 40))
def test_pc_count(cpu_backend_real: CPUBackendControl, set_pc_next8: PCNext8, expected: int) -> None:
    backend = cpu_backend_real

    PC.count.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    backend.client.clock_tick()

    value = read_pc(cpu_backend_real)

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

def test_lr_pc_swap(cpu_backend_real: CPUBackendControl) -> None:
    load_pc(cpu_backend_real, 0xaa)
    ldi (B, 43)
    mov (LR, B)

    ret()

    value = read_pc(cpu_backend_real)

    assert value == 43

def test_call_addr(cpu_backend_real: CPUBackendControl) -> None:
    load_pc(cpu_backend_real, 0x12bb)

    call (Addr(452))

    value = read_pc(cpu_backend_real)

    retaddr = read_lr(cpu_backend_real)

    assert value == 452
    assert retaddr == 0x12bd

def test_jmp_addr(cpu_backend_real: CPUBackendControl) -> None:
    load_pc(cpu_backend_real, 0)

    jmp(Addr(0x1084))

    value = read_pc(cpu_backend_real)
    assert value == 0x1084