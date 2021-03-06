#!/usr/bin/python3

import pytest # type: ignore

from libcpu.cpu import *
from libcpu.devices import Register
from libcpu.cpu_exec import CPUBackendControl
from typing import Iterator, Tuple

pytestmark = pytest.mark.hardware

def all_regs_and_bits() -> Iterator[Tuple[Register, int]]:
    regs = [A, B]
    bits = range(8)

    for r in regs:
        yield r, 255
        for b in bits:
            yield r, 1 << b
        yield r, 0

@pytest.mark.parametrize("register,value", all_regs_and_bits())
def test_load_store_reg(cpu_backend_real: CPUBackendControl, register: Register, value: int) -> None:
    ldi (register, value)
    received = peek(register)

    assert value == received

@pytest.mark.parametrize("value", [0xF, 1, 2, 4, 8, 0])
def test_load_store_flags(cpu_backend_real: CPUBackendControl, value: int) -> None:
    ldi (F, value)
    received = peek(F)

    assert value == received


def test_mov_a_b(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 0)
    ldi(B, 42)

    mov(A, B)

    value = peek(A)
    assert value == 42

def test_mov_b_a(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 34)
    ldi(B, 0)

    mov(B, A)

    value = peek(B)
    assert value == 34
