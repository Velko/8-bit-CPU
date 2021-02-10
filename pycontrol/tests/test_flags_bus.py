#!/usr/bin/python3

import pytest

pytestmark = pytest.mark.hardware

from libcpu.cpu import *

def test_flags_out_n(cpu_backend_real):
    ldi(A, 230)
    ldi(B, 5)
    add(A, B)

    f = peek(F)

    flags = Flags.decode(f)
    assert flags == "---N"

def test_flags_out_z(cpu_backend_real):
    ldi(A, 5)
    ldi(B, 5)
    sub(A, B)

    f = peek(F)

    flags = Flags.decode(f)
    assert flags == "--Z-"

def test_flags_out_c(cpu_backend_real):
    ldi(A, 230)
    ldi(B, 40)
    add(A, B)

    f = peek(F)

    flags = Flags.decode(f)
    assert flags == "-C--"

def test_flags_out_v(cpu_backend_real):
    ldi(A, 140)
    ldi(B, 20)
    sub(A, B)

    f = peek(F)

    flags = Flags.decode(f)
    assert flags == "V---"
