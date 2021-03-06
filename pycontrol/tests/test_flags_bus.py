#!/usr/bin/python3

import pytest # type: ignore

pytestmark = pytest.mark.hardware

from libcpu.cpu import *
from libcpu.cpu_exec import CPUBackendControl

def test_flags_out_n(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 230)
    ldi(B, 5)
    add(A, B)

    f = peek(F)

    flags = Flags.decode(f)
    assert flags == "---N"

def test_flags_out_z(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 5)
    ldi(B, 5)
    sub(A, B)

    f = peek(F)

    flags = Flags.decode(f)
    assert flags == "--Z-"

def test_flags_out_c(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 230)
    ldi(B, 40)
    add(A, B)

    f = peek(F)

    flags = Flags.decode(f)
    assert flags == "-C--"

def test_flags_out_v(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 140)
    ldi(B, 20)
    sub(A, B)

    f = peek(F)

    flags = Flags.decode(f)
    assert flags == "V---"
