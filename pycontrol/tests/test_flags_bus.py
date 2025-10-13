#!/usr/bin/python3

import pytest

pytestmark = pytest.mark.hardware

from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.devices import Flags
from libcpu.devmap import A, B

def test_flags_out_n(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 230
    cpu_helper.regs.B = 5
    acpu.add(A, B)

    flags = cpu_helper.get_flags()

    assert flags == Flags.N

def test_flags_out_z(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 5
    cpu_helper.regs.B = 5
    acpu.sub(A, B)

    flags = cpu_helper.get_flags()

    assert flags == Flags.Z

def test_flags_out_c(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 230
    cpu_helper.regs.B = 40
    acpu.add(A, B)

    flags = cpu_helper.get_flags()

    assert flags == Flags.C

def test_flags_out_v(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 140
    cpu_helper.regs.B = 20
    acpu.sub(A, B)

    flags = cpu_helper.get_flags()

    assert flags == Flags.V

@pytest.mark.parametrize("f_int", range(16))
def test_flags_preload(cpu_helper: CPUHelper, f_int: int) -> None:
    flags = Flags(f_int)
    cpu_helper.regs.F = flags

    f = cpu_helper.get_flags()
    assert f == flags
