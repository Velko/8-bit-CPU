#!/usr/bin/python3

import pytest

pytestmark = pytest.mark.hardware

from libcpu.DeviceSetup import SP
from libcpu.cpu_exec import CPUBackendControl
from libcpu.cpu import *
from libcpu.markers import Addr


def load_sp(backend: CPUBackendControl, value: int) -> None:
    backend.control.reset()
    backend.client.bus_set(value)
    SP.load.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    backend.client.clock_tick()

    backend.control.reset()
    backend.client.off(backend.control.default)

def read_sp(backend: CPUBackendControl) -> int:
    backend.control.reset()
    SP.out.enable()
    backend.client.ctrl_commit(backend.control.c_word)
    value = backend.client.bus_get()

    backend.control.reset()
    backend.client.off(backend.control.default)

    return value

@pytest.mark.parametrize("expected", [255, 1, 2, 4, 8, 16, 32, 64, 128, 0])
def test_sp_load(cpu_backend_real: CPUBackendControl, expected: int) -> None:

    backend = cpu_backend_real

    load_sp(backend, expected)
    value = read_sp(backend)

    assert value == expected


def test_sp_move_into(cpu_backend_real: CPUBackendControl) -> None:
    load_sp(cpu_backend_real, 0)
    ldi (A, 123)

    mov (SP, A)

    value = read_sp(cpu_backend_real)

    assert value == 123


def test_sp_move_from(cpu_backend_real: CPUBackendControl) -> None:
    load_sp(cpu_backend_real, 132)
    ldi (A, Addr(0))

    mov (A, SP)

    value = peek(A)

    assert value == 132


def test_sp_inc(cpu_backend_real: CPUBackendControl) -> None:
    load_sp(cpu_backend_real, 12)

    cpu_backend_real.control.reset()
    SP.inc.enable()
    cpu_backend_real.client.ctrl_commit(cpu_backend_real.control.c_word)
    cpu_backend_real.client.clock_tick()
    cpu_backend_real.control.reset()
    cpu_backend_real.client.off(cpu_backend_real.control.default)


    value = read_sp(cpu_backend_real)
    assert value == 13

def test_sp_dec(cpu_backend_real: CPUBackendControl) -> None:
    load_sp(cpu_backend_real, 12)

    cpu_backend_real.control.reset()
    SP.dec.enable()
    cpu_backend_real.client.ctrl_commit(cpu_backend_real.control.c_word)
    cpu_backend_real.client.clock_tick()
    cpu_backend_real.control.reset()
    cpu_backend_real.client.off(cpu_backend_real.control.default)


    value = read_sp(cpu_backend_real)
    assert value == 11


def test_push_a(cpu_backend_real: CPUBackendControl) -> None:

    # preparation - clear value at address 17
    ldi (B, 0)
    st (Addr(17), B)

    # initialize SP
    load_sp(cpu_backend_real, 18)

    # push 72 onto stack
    ldi (A, 72)
    push (A)

    # read back sp and value at address 17
    spval = read_sp(cpu_backend_real)
    ld (B, Addr(17))
    memval = peek(B)

    assert spval == 17
    assert memval == 72


def test_pop_a(cpu_backend_real: CPUBackendControl) -> None:

    # preparation - set value at address 54
    ldi (B, 23)
    st (Addr(54), B)

    # load target with different value
    ldi (A, 0)

    # initialize SP
    load_sp(cpu_backend_real, 54)

    # load in from stack
    pop (A)

    # read back sp and value in register
    spval = read_sp(cpu_backend_real)
    regval = peek(A)

    assert spval == 55
    assert regval == 23

def test_push_pop(cpu_backend_real: CPUBackendControl) -> None:

    load_sp(cpu_backend_real, 44)
    ldi (C, 45)

    push (C)
    ldi (C, 20)
    pop (C)

    val = peek(C)
    assert val == 45

def test_push_popf(cpu_backend_real: CPUBackendControl) -> None:

    load_sp(cpu_backend_real, 88)
    ldi (F, 0b1101)

    push (F)
    ldi (F, 0)
    pop (F)

    val = peek(F)
    assert val == 0b1101

