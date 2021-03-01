#!/usr/bin/python3

import pytest # type: ignore

from libcpu.cpu_exec import CPUBackendControl

pytestmark = pytest.mark.hardware

from libcpu.cpu import *

def test_add_ab_result_small(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 24)
    ldi(B, 18)

    add(A, B)

    value = peek(A)
    assert value == 42

def test_add_ab_flags_small(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 24)
    ldi(B, 18)

    add(A, B)

    flags = Flags.decode(cpu_backend_real.client.flags_get())
    assert flags == "----"

def test_add_ab_result_wraparound(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 245)
    ldi(B, 18)

    add(A, B)

    value = peek(A)
    assert value == 7

def test_add_ab_flags_carry(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 245)
    ldi(B, 18)

    add(A, B)

    flags = Flags.decode(cpu_backend_real.client.flags_get())
    assert flags == "-C--"

def test_add_ab_flags_overflow_to_negative(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 126)
    ldi(B, 4)

    add(A, B)

    flags = Flags.decode(cpu_backend_real.client.flags_get())
    assert flags == "V--N"

def test_add_ab_flags_overflow_to_positive(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 226)
    ldi(B, 145)

    add(A, B)

    flags = Flags.decode(cpu_backend_real.client.flags_get())
    assert flags == "VC--"

def test_add_ab_flags_zero(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 246)
    ldi(B, 10)

    add(A, B)

    flags = Flags.decode(cpu_backend_real.client.flags_get())
    assert flags == "-CZ-"

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

@pytest.mark.xfail
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
