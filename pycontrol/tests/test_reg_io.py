#!/usr/bin/python3

import pytest
import random

from libcpu.cpu import *
from libcpu.devices import Register
from libcpu.DeviceSetup import DP
from libcpu.markers import Addr
from libcpu.test_helpers import CPUHelper
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
def test_load_store_reg(cpu_helper: CPUHelper, register: Register, value: int) -> None:
    ldi (register, value)
    received = cpu_helper.read_reg8(register)

    assert value == received

@pytest.mark.parametrize("value", [0xF, 1, 2, 4, 8, 0])
def test_load_store_flags(cpu_helper: CPUHelper, value: int) -> None:
    ldi (F, value)
    received = cpu_helper.get_flags()

    assert value == received

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
def test_mov_a_b(cpu_helper: CPUHelper, lhs: Register, rhs: Register) -> None:
    ldi(lhs, 0)
    val = random.randrange(256)
    ldi(rhs, val)

    mov(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    assert value == val

def test_lea(cpu_helper: CPUHelper) -> None:

    cpu_helper.load_reg16(DP, 0)

    lea(DP, Addr(0x4314))

    val = cpu_helper.read_reg16(DP)

    assert val == 0x4314

def test_mar_dp_minus(cpu_helper: CPUHelper) -> None:

    cpu_helper.write_ram(42, 0xB5)
    cpu_helper.load_reg16(DP, 45)
    ldi (B, -3)

    ldrel(A, DP, B);

    val = cpu_helper.read_reg8(A)

    assert val == 0xB5
