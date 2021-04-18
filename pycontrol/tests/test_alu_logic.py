#!/usr/bin/python3

import pytest

from libcpu.cpu_exec import CPUBackendControl
from libcpu.opcodes import permute_gp_regs_all, permute_gp_regs_nsame, gp_regs
from libcpu.devices import Register, Flags
from typing import Iterator, Tuple

pytestmark = pytest.mark.hardware

from libcpu.cpu import *

def and_test_args() -> Iterator[Tuple[str, int, int, int, str]]:
    yield "small", 230, 92, 68, "----"
    yield "zero", 0xa5, 0x5a, 0, "--Z-"

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
@pytest.mark.parametrize("desc,val_a,val_b,result,xflags", and_test_args())
def test_and(cpu_backend_real: CPUBackendControl, lhs: Register, rhs: Register, desc: str, val_a: int, val_b: int, result: int, xflags: str) -> None:
    ldi(lhs, val_a)
    ldi(rhs, val_b)

    andb(lhs, rhs)

    value = peek(lhs)
    flags = Flags.decode(cpu_backend_real.client.flags_get() & 0b0011) # we are only interested in Z and N flags
    assert value == result
    assert flags == xflags


def or_test_args() -> Iterator[Tuple[str, int, int, int, str]]:
    yield "small", 230, 92, 254, "---N"
    yield "full", 0xa5, 0x5a, 0xff, "---N"

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
@pytest.mark.parametrize("desc,val_a,val_b,result,xflags", or_test_args())
def test_or(cpu_backend_real: CPUBackendControl, lhs: Register, rhs: Register, desc: str, val_a: int, val_b: int, result: int, xflags: str) -> None:
    ldi(lhs, val_a)
    ldi(rhs, val_b)

    orb(lhs, rhs)

    value = peek(lhs)
    flags = Flags.decode(cpu_backend_real.client.flags_get() & 0b0011)
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
def test_shr(cpu_backend_real: CPUBackendControl, reg: Register, desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    if carry_in:
        ldi(F, 0b0100)
    else:
        ldi(F, 0)

    ldi(reg, val)

    shr(reg)

    value = peek(reg)
    flags = Flags.decode(cpu_backend_real.client.flags_get())
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
def test_ror(cpu_backend_real: CPUBackendControl, reg: Register, desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    if carry_in:
        ldi(F, 0b0100)
    else:
        ldi(F, 0)

    ldi(reg, val)

    ror(reg)

    value = peek(reg)
    flags = Flags.decode(cpu_backend_real.client.flags_get())
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
def test_asr(cpu_backend_real: CPUBackendControl, reg: Register, desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    if carry_in:
        ldi(F, 0b0100)
    else:
        ldi(F, 0)

    ldi(reg, val)

    asr(reg)

    value = peek(reg)
    flags = Flags.decode(cpu_backend_real.client.flags_get())
    assert value == result
    assert flags == xflags


def swap_args() -> Iterator[Tuple[str, int, int, str]]:
    yield "simple", 0xa2, 0x2a, "----"
    yield "neg", 0x58, 0x85, "---N"
    yield "zero", 0, 0, "--Z-"


@pytest.mark.parametrize("reg", gp_regs)
@pytest.mark.parametrize("desc,val,result,xflags", swap_args())
@pytest.mark.parametrize("carry_in", [False, True])
def test_swap(cpu_backend_real: CPUBackendControl, reg: Register, desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    if carry_in:
        ldi(F, 0b0100)
    else:
        ldi(F, 0)

    ldi(reg, val)

    swap(reg)

    value = peek(reg)
    flags = Flags.decode(cpu_backend_real.client.flags_get() & 0b0011)
    assert value == result
    assert flags == xflags


def xor_test_args() -> Iterator[Tuple[str, int, int, int, str]]:
    yield "small", 230, 92, 186, "---N"
    yield "fill", 0xa5, 0x5a, 0xff, "---N"
    yield "zero", 0x142, 0x142, 0, "--Z-"

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
@pytest.mark.parametrize("desc,val_a,val_b,result,xflags", xor_test_args())
def test_xor(cpu_backend_real: CPUBackendControl, lhs: Register, rhs: Register, desc: str, val_a: int, val_b: int, result: int, xflags: str) -> None:
    ldi(lhs, val_a)
    ldi(rhs, val_b)

    xor(lhs, rhs)

    value = peek(lhs)
    flags = Flags.decode(cpu_backend_real.client.flags_get() & 0b0011) # we are only interested in Z and N flags
    assert value == result
    assert flags == xflags


def not_args() -> Iterator[Tuple[str, int, int, str]]:
    yield "normal", 25, 230, "---N"
    yield "zero", 0xFF, 0, "--Z-"

@pytest.mark.parametrize("reg", gp_regs)
@pytest.mark.parametrize("desc,val,result,xflags", not_args())
def test_not(cpu_backend_real: CPUBackendControl, reg: Register, desc: str, val: int, result: int, xflags: str) -> None:

    ldi(reg, val)

    notb(reg)

    value = peek(reg)
    flags = Flags.decode(cpu_backend_real.client.flags_get() & 0b0011)
    assert value == result
    assert flags == xflags

