#!/usr/bin/python3

import pytest

pytestmark = pytest.mark.hardware

from libcpu.cpu import *
from libcpu.test_helpers import CPUHelper

from libcpu.devices import Flags

def test_flags_out_n(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg8(A, 230)
    cpu_helper.load_reg8(B, 5)
    add(A, B)

    f = cpu_helper.get_flags()

    flags = Flags.decode(f)
    assert flags == "---N"

def test_flags_out_z(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg8(A, 5)
    cpu_helper.load_reg8(B, 5)
    sub(A, B)

    f = cpu_helper.get_flags()

    flags = Flags.decode(f)
    assert flags == "--Z-"

def test_flags_out_c(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg8(A, 230)
    cpu_helper.load_reg8(B, 40)
    add(A, B)

    f = cpu_helper.get_flags()

    flags = Flags.decode(f)
    assert flags == "-C--"

def test_flags_out_v(cpu_helper: CPUHelper) -> None:
    cpu_helper.load_reg8(A, 140)
    cpu_helper.load_reg8(B, 20)
    sub(A, B)

    f = cpu_helper.get_flags()

    flags = Flags.decode(f)
    assert flags == "V---"

@pytest.mark.parametrize("flags", range(16))
def test_flags_preload(cpu_helper: CPUHelper, flags: int) -> None:
    cpu_helper.load_reg8(F, flags)

    f = cpu_helper.get_flags()
    assert f == flags