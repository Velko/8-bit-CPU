#!/usr/bin/python3

import pytest
import random

from libcpu.devices import GPRegister, Flags
from libcpu.DeviceSetup import hardware as hw
from libcpu.markers import Addr
from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from collections.abc import Iterator
from libcpu.opcodes import permute_gp_regs_nsame, gp_regs

pytestmark = pytest.mark.hardware

SP = hw.a_ptr("SP")

def all_regs_and_bits() -> Iterator[tuple[GPRegister, int]]:
    bits = range(8)

    for r in gp_regs:
        yield r, 255
        for b in bits:
            yield r, 1 << b
        yield r, 0

@pytest.mark.parametrize("register,value", all_regs_and_bits())
def test_load_store_reg(cpu_helper: CPUHelper, acpu: AssistedCPU, register: GPRegister, value: int) -> None:
    acpu.ldi (register, value)
    received = cpu_helper.read_reg8(register)

    assert value == received

@pytest.mark.parametrize("value", [~Flags.Empty, Flags.N, Flags.Z, Flags.C, Flags.V, Flags.Empty])
def test_load_store_flags(cpu_helper: CPUHelper, acpu: AssistedCPU, value: Flags) -> None:
    acpu.ldi (hw.F, value)
    received = cpu_helper.get_flags()

    assert value == received

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
def test_mov_a_b(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister) -> None:
    cpu_helper.load_reg8(lhs, 0)
    val = random.randrange(256)
    cpu_helper.load_reg8(rhs, val)

    acpu.mov(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    assert value == val

def test_lea(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    cpu_helper.load_reg16(SP, 0)

    acpu.lea(SP, Addr(0x4314))

    val = cpu_helper.read_reg16(SP)

    assert val == 0x4314

def test_mar_idx(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    cpu_helper.write_ram(0x45, 0xB5)
    cpu_helper.load_reg8(hw.B, 3)

    acpu.ldx (hw.A, Addr(0x42), hw.B)

    val = cpu_helper.read_reg8(hw.A)

    assert val == 0xB5
