#!/usr/bin/python3

import pytest # type: ignore
import random

from libcpu.cpu import *
from libcpu.devices import Register
from libcpu.cpu_exec import CPUBackendControl
from typing import Iterator, Tuple
from libcpu.opcodes import permute_gp_regs_nsame, gp_regs

pytestmark = pytest.mark.hardware

def all_regs_and_bits() -> Iterator[Tuple[Register, int]]:
    bits = range(8)

    for r in gp_regs:
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

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
def test_mov_a_b(cpu_backend_real: CPUBackendControl, lhs: Register, rhs: Register) -> None:
    ldi(lhs, 0)
    val = random.randrange(256)
    ldi(rhs, val)

    mov(lhs, rhs)

    value = peek(lhs)
    assert value == val
