#!/usr/bin/python3

import pytest

from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.opcodes import permute_gp_regs_nsame, gp_regs
from libcpu.devices import Register, Flags
from typing import Iterator, Tuple

pytestmark = pytest.mark.hardware

from libcpu.cpu import *

def and_test_args() -> Iterator[Tuple[str, int, int, int, str]]:
    yield "small", 230, 92, 68, "----"
    yield "zero", 0xa5, 0x5a, 0, "--Z-"

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
@pytest.mark.parametrize("desc,val_a,val_b,result,xflags", and_test_args())
def test_and(cpu_helper: CPUHelper, cpu_backend_real: AssistedCPU, lhs: Register, rhs: Register, desc: str, val_a: int, val_b: int, result: int, xflags: str) -> None:
    cpu_helper.load_reg8(lhs, val_a)
    cpu_helper.load_reg8(rhs, val_b)

    andb(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = Flags.decode(cpu_helper.get_flags() & (Flags.Z | Flags.N)) # we are only interested in Z and N flags
    assert value == result
    assert flags == xflags


def or_test_args() -> Iterator[Tuple[str, int, int, int, str]]:
    yield "small", 230, 92, 254, "---N"
    yield "full", 0xa5, 0x5a, 0xff, "---N"

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
@pytest.mark.parametrize("desc,val_a,val_b,result,xflags", or_test_args())
def test_or(cpu_helper: CPUHelper, cpu_backend_real: AssistedCPU, lhs: Register, rhs: Register, desc: str, val_a: int, val_b: int, result: int, xflags: str) -> None:
    cpu_helper.load_reg8(lhs, val_a)
    cpu_helper.load_reg8(rhs, val_b)

    orb(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = Flags.decode(cpu_helper.get_flags() & (Flags.Z | Flags.N))
    assert value == result
    assert flags == xflags



def shr_args() -> Iterator[Tuple[str, int, int, str]]:
    yield "carry_out_1", 25, 12, "-C--"
    yield "carry_out_0", 122, 61, "----"
    yield "no_signext", 128, 64, "----"
    yield "zero", 1, 0, "-CZ-"

@pytest.mark.parametrize("reg", gp_regs)
@pytest.mark.parametrize("desc,val,result,xflags", shr_args())
@pytest.mark.parametrize("carry_in", [False, True])
def test_shr(cpu_helper: CPUHelper, cpu_backend_real: AssistedCPU, reg: Register, desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    if carry_in:
        cpu_helper.load_reg8(F, Flags.C)
    else:
        cpu_helper.load_reg8(F, 0)

    cpu_helper.load_reg8(reg, val)

    shr(reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags

@pytest.mark.parametrize("reg", gp_regs)
@pytest.mark.parametrize("desc,val,result,xflags", shr_args())
@pytest.mark.parametrize("carry_in", [False, True])
def test_shr_real(cpu_helper: CPUHelper, cpu_backend_real: AssistedCPU, reg: Register, desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    shr_test_prog = bytes([opcode_of(f"shr_{reg.name}")])

    if carry_in:
        cpu_helper.load_reg8(F, Flags.C)
    else:
        cpu_helper.load_reg8(F, 0)

    cpu_helper.load_reg8(reg, val)

    cpu_helper.run_snippet(66, shr_test_prog)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags


def ror_args() -> Iterator[Tuple[str, bool, int, int, str]]:
    yield "carry_out_1", False, 25, 12, "-C--"
    yield "carry_out_0", False, 122, 61, "----"
    yield "no_signext", False, 128, 64, "----"
    yield "zero", False, 1, 0, "-CZ-"

    yield "carry_in_out_1", True, 25, 140, "-C-N"
    yield "carry_in_1_out_0", True, 122, 189, "---N"
    yield "cin_zero", True, 0, 128, "---N"

@pytest.mark.parametrize("reg", gp_regs)
@pytest.mark.parametrize("desc,carry_in,val,result,xflags", ror_args())
def test_ror(cpu_helper: CPUHelper, cpu_backend_real: AssistedCPU, reg: Register, desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    if carry_in:
        cpu_helper.load_reg8(F, Flags.C)
    else:
        cpu_helper.load_reg8(F, 0)

    cpu_helper.load_reg8(reg, val)

    ror(reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags

def asr_args() -> Iterator[Tuple[str, int, int, str]]:
    yield "carry_out_1", 25, 12, "-C--"
    yield "carry_out_0", 122, 61, "----"
    yield "signext", 128, 192, "---N"
    yield "zero", 1, 0, "-CZ-"

@pytest.mark.parametrize("reg", gp_regs)
@pytest.mark.parametrize("desc,val,result,xflags", asr_args())
@pytest.mark.parametrize("carry_in", [False, True])
def test_asr(cpu_helper: CPUHelper, cpu_backend_real: AssistedCPU, reg: Register, desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    if carry_in:
        cpu_helper.load_reg8(F, Flags.C)
    else:
        cpu_helper.load_reg8(F, 0)

    cpu_helper.load_reg8(reg, val)

    asr(reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags

@pytest.mark.parametrize("reg", gp_regs)
@pytest.mark.parametrize("desc,val,result,xflags", asr_args())
@pytest.mark.parametrize("carry_in", [False, True])
def test_asr_real(cpu_helper: CPUHelper, cpu_backend_real: AssistedCPU, reg: Register, desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    asr_test_prog = bytes([opcode_of(f"asr_{reg.name}")])

    if carry_in:
        cpu_helper.load_reg8(F, Flags.C)
    else:
        cpu_helper.load_reg8(F, 0)

    cpu_helper.load_reg8(reg, val)

    cpu_helper.run_snippet(23, asr_test_prog)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags


def swap_args() -> Iterator[Tuple[str, int, int, str]]:
    yield "simple", 0xa2, 0x2a, "----"
    yield "neg", 0x58, 0x85, "---N"
    yield "zero", 0, 0, "--Z-"


@pytest.mark.parametrize("reg", gp_regs)
@pytest.mark.parametrize("desc,val,result,xflags", swap_args())
@pytest.mark.parametrize("carry_in", [False, True])
def test_swap(cpu_helper: CPUHelper, cpu_backend_real: AssistedCPU, reg: Register, desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    if carry_in:
        cpu_helper.load_reg8(F, Flags.C)
    else:
        cpu_helper.load_reg8(F, 0)

    cpu_helper.load_reg8(reg, val)

    swap(reg)

    value = cpu_helper.read_reg8(reg)
    flags = Flags.decode(cpu_helper.get_flags() & (Flags.Z | Flags.N))
    assert value == result
    assert flags == xflags


def xor_test_args() -> Iterator[Tuple[str, int, int, int, str]]:
    yield "small", 230, 92, 186, "---N"
    yield "fill", 0xa5, 0x5a, 0xff, "---N"
    yield "zero", 0x142, 0x142, 0, "--Z-"

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
@pytest.mark.parametrize("desc,val_a,val_b,result,xflags", xor_test_args())
def test_xor(cpu_helper: CPUHelper, cpu_backend_real: AssistedCPU, lhs: Register, rhs: Register, desc: str, val_a: int, val_b: int, result: int, xflags: str) -> None:
    cpu_helper.load_reg8(lhs, val_a)
    cpu_helper.load_reg8(rhs, val_b)

    xor(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = Flags.decode(cpu_helper.get_flags() & (Flags.Z | Flags.N)) # we are only interested in Z and N flags
    assert value == result
    assert flags == xflags

def test_xor_zero_same(cpu_helper: CPUHelper, cpu_backend_real: AssistedCPU) -> None:
    cpu_helper.load_reg8(A, 0x5A)

    clr(A)

    value = cpu_helper.read_reg8(A)
    flags = Flags.decode(cpu_helper.get_flags() & (Flags.Z | Flags.N))

    assert value == 0
    assert flags == "--Z-"


def not_args() -> Iterator[Tuple[str, int, int, str]]:
    yield "normal", 25, 230, "---N"
    yield "zero", 0xFF, 0, "--Z-"

@pytest.mark.parametrize("reg", gp_regs)
@pytest.mark.parametrize("desc,val,result,xflags", not_args())
def test_not(cpu_helper: CPUHelper, cpu_backend_real: AssistedCPU, reg: Register, desc: str, val: int, result: int, xflags: str) -> None:

    cpu_helper.load_reg8(reg, val)

    notb(reg)

    value = cpu_helper.read_reg8(reg)
    flags = Flags.decode(cpu_helper.get_flags() & (Flags.Z | Flags.N))
    assert value == result
    assert flags == xflags

