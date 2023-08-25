#!/usr/bin/python3

import pytest

from libcpu.opcodes import permute_gp_regs_nsame, gp_regs
from libcpu.devices import Register, Flags
from typing import Iterator, Tuple

from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU, F

pytestmark = pytest.mark.hardware

def add_ab_test_args() -> Iterator[Tuple[str, int, int, int, str]]:
    yield "small", 24, 18, 42, "----"
    yield "wraparound", 245, 18, 7, "-C--"
    yield "overflow_to_negative", 126, 4, 130, "V--N"
    yield "overflow_to_positive", 226, 145, 115, "VC--"
    yield "to_zero", 246, 10, 0, "-CZ-"

def add_aa_test_args() -> Iterator[Tuple[str, int, int, str]]:
    yield "small", 25, 50, "----"

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
@pytest.mark.parametrize("_desc,val_a,val_b,result,xflags", add_ab_test_args())
def test_add_ab(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: Register, rhs: Register, _desc: str, val_a: int, val_b: int, result: int, xflags: str) -> None:
    cpu_helper.load_reg8(lhs, val_a)
    cpu_helper.load_reg8(rhs, val_b)

    acpu.add(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags

@pytest.mark.parametrize("reg", gp_regs)
@pytest.mark.parametrize("_desc,val,result,xflags", add_aa_test_args())
def test_add_aa(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: Register, _desc: str, val: int, result: int, xflags: str) -> None:
    cpu_helper.load_reg8(reg, val)

    acpu.add(reg, reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags



def sub_test_args() -> Iterator[Tuple[str, int, int, int, str]]:
    yield "small", 4, 3, 1, "----"
    yield "zero", 4, 4, 0, "--Z-"
    yield "carry", 3, 5, 254, "-C-N"
    yield "overflow_to_positive", 140, 20, 120, "V---"
    yield "overflow_to_negative", 120, 130, 246, "VC-N"

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
@pytest.mark.parametrize("_desc,val_a,val_b,result,xflags", sub_test_args())
def test_sub(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: Register, rhs: Register, _desc: str, val_a: int, val_b: int, result: int, xflags: str) -> None:
    cpu_helper.load_reg8(lhs, val_a)
    cpu_helper.load_reg8(rhs, val_b)

    acpu.sub(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags


def adc_ab_test_args() -> Iterator[Tuple[str, int, int, int, str]]:
    yield "small", 24, 17, 42, "----"
    yield "wraparound", 245, 18, 8, "-C--"
    yield "overflow_to_negative", 126, 4, 131, "V--N"
    yield "overflow_to_positive", 226, 145, 116, "VC--"
    yield "to_zero", 246, 9, 0, "-CZ-"

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
@pytest.mark.parametrize("_desc,val_a,val_b,result,xflags", adc_ab_test_args())
def test_adc_ab_c_set(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: Register, rhs: Register, _desc: str, val_a: int, val_b: int, result: int, xflags: str) -> None:
    cpu_helper.load_reg8(F, Flags.C)
    cpu_helper.load_reg8(lhs, val_a)
    cpu_helper.load_reg8(rhs, val_b)

    acpu.adc(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
@pytest.mark.parametrize("_desc,val_a,val_b,result,xflags", add_ab_test_args())
def test_adc_ab_c_clear(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: Register, rhs: Register, _desc: str, val_a: int, val_b: int, result: int, xflags: str) -> None:
    acpu.ldi (F, 0)
    cpu_helper.load_reg8(lhs, val_a)
    cpu_helper.load_reg8(rhs, val_b)

    acpu.adc(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags


def sbb_test_args() -> Iterator[Tuple[str, int, int, int, str]]:
    yield "small", 5, 3, 1, "----"
    yield "zero", 4, 3, 0, "--Z-"
    yield "carry", 3, 5, 253, "-C-N"
    yield "overflow_to_positive", 140, 19, 120, "V---"
    yield "overflow_to_negative", 120, 130, 245, "VC-N"

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
@pytest.mark.parametrize("_desc,val_a,val_b,result,xflags", sbb_test_args())
def test_sbb_c_set(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: Register, rhs: Register, _desc: str, val_a: int, val_b: int, result: int, xflags: str) -> None:
    cpu_helper.load_reg8(F, Flags.C)
    cpu_helper.load_reg8(lhs, val_a)
    cpu_helper.load_reg8(rhs, val_b)

    acpu.sbb(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
@pytest.mark.parametrize("_desc,val_a,val_b,result,xflags", sub_test_args())
def test_sbb_c_clear(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: Register, rhs: Register, _desc: str, val_a: int, val_b: int, result: int, xflags: str) -> None:
    acpu.ldi (F, 0)
    cpu_helper.load_reg8(lhs, val_a)
    cpu_helper.load_reg8(rhs, val_b)

    acpu.sbb(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags
