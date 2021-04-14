#!/usr/bin/python3

import pytest # type: ignore

from libcpu.cpu_exec import CPUBackendControl
from libcpu.opcodes import permute_gp_regs_all, permute_gp_regs_nsame, gp_regs
from libcpu.devices import Register

pytestmark = pytest.mark.hardware

from libcpu.cpu import *

def add_ab_result_test_args():
    yield "small", 24, 18, 42, "----"
    yield "wraparound", 245, 18, 7, "-C--"
    yield "overflow_to_negative", 126, 4, 130, "V--N"
    yield "overflow_to_positive", 226, 145, 115, "VC--"
    yield "to_zero", 246, 10, 0, "-CZ-"

def add_aa_result_test_args():
    yield "small", 25, 50, "----"

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
@pytest.mark.parametrize("desc,val_a,val_b,result,xflags", add_ab_result_test_args())
def test_add_ab(cpu_backend_real: CPUBackendControl, lhs: Register, rhs: Register, desc: str, val_a: int, val_b: int, result: int, xflags: str) -> None:
    ldi(lhs, val_a)
    ldi(rhs, val_b)

    add(lhs, rhs)

    value = peek(lhs)
    flags = Flags.decode(cpu_backend_real.client.flags_get())
    assert value == result
    assert flags == xflags

@pytest.mark.parametrize("reg", gp_regs)
@pytest.mark.parametrize("desc,val,result,xflags", add_aa_result_test_args())
def test_add_aa(cpu_backend_real: CPUBackendControl, reg: Register, desc: str, val: int, result: int, xflags: str) -> None:
    ldi(reg, val)

    add(reg, reg)

    value = peek(reg)
    flags = Flags.decode(cpu_backend_real.client.flags_get())
    assert value == result
    assert flags == xflags

def test_sub_result_small(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 4)
    ldi(B, 3)

    sub(A, B)

    value = peek(A)
    assert value == 1

def test_sub_flags_small(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 4)
    ldi(B, 3)

    sub(A, B)

    flags = Flags.decode(cpu_backend_real.client.flags_get())
    assert flags == "----"

def test_sub_result_zero(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 4)
    ldi(B, 4)

    sub(A, B)

    value = peek(A)
    assert value == 0

def test_sub_flags_zero(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 4)
    ldi(B, 4)

    sub(A, B)

    flags = Flags.decode(cpu_backend_real.client.flags_get())
    assert flags == "--Z-"

def test_sub_result_carry(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 3)
    ldi(B, 5)

    sub(A, B)

    value = peek(A)
    assert value == 254

def test_sub_flags_carry(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 3)
    ldi(B, 5)

    sub(A, B)

    flags = Flags.decode(cpu_backend_real.client.flags_get())
    assert flags == "-C-N"

def test_sub_overflow_to_positive(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 140)
    ldi(B, 20)

    sub(A, B)

    flags = Flags.decode(cpu_backend_real.client.flags_get())
    assert flags == "V---"

def test_sub_overflow_to_negative(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 120)
    ldi(B, 130)

    sub(A, B)

    flags = Flags.decode(cpu_backend_real.client.flags_get())
    assert flags == "VC-N"

def test_sub_flags_zero_again(cpu_backend_real: CPUBackendControl) -> None:
    #TODO: is this duplicate or what?
    ldi(A, 20)
    ldi(B, 20)

    sub(A, B)

    flags = Flags.decode(cpu_backend_real.client.flags_get())
    assert flags == "--Z-"

def test_sub_ba_result_small(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 3)
    ldi(B, 4)

    sub(B, A)

    value = peek(B)
    assert value == 1

def test_result_adc_ab_c_set(cpu_backend_real: CPUBackendControl) -> None:
    ldi (F, 0b0100)
    ldi (A, 5)
    ldi (B, 3)

    adc(A, B)

    value = peek(A)
    assert value == 9

def test_result_adc_ab_c_clear(cpu_backend_real: CPUBackendControl) -> None:
    ldi (F, 0)
    ldi (A, 5)
    ldi (B, 3)

    adc(A, B)

    value = peek(A)
    assert value == 8

def test_result_sbb_ab_c_set(cpu_backend_real: CPUBackendControl) -> None:
    ldi (F, 0b0100)
    ldi (A, 5)
    ldi (B, 3)

    sbb(A, B)

    value = peek(A)
    assert value == 1

def test_result_sbb_ab_c_clear(cpu_backend_real: CPUBackendControl) -> None:
    ldi (F, 0)
    ldi (A, 5)
    ldi (B, 3)

    sbb(A, B)

    value = peek(A)
    assert value == 2
