#!/usr/bin/python3

import pytest

pytestmark = pytest.mark.hardware

from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.devices import Flags
from libcpu.DeviceSetup import hardware

A = hardware.gp_registers["A"]
B = hardware.gp_registers["B"]

def test_flags_out_n(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.load_reg8(A, 230)
    cpu_helper.load_reg8(B, 5)
    acpu.add(A, B)

    flags = cpu_helper.get_flags_s()

    assert flags == "---N"

def test_flags_out_z(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.load_reg8(A, 5)
    cpu_helper.load_reg8(B, 5)
    acpu.sub(A, B)

    flags = cpu_helper.get_flags_s()

    assert flags == "--Z-"

def test_flags_out_c(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.load_reg8(A, 230)
    cpu_helper.load_reg8(B, 40)
    acpu.add(A, B)

    flags = cpu_helper.get_flags_s()

    assert flags == "-C--"

def test_flags_out_v(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.load_reg8(A, 140)
    cpu_helper.load_reg8(B, 20)
    acpu.sub(A, B)

    flags = cpu_helper.get_flags_s()

    assert flags == "V---"

@pytest.mark.parametrize("f_int", range(16))
def test_flags_preload(cpu_helper: CPUHelper, f_int: int) -> None:
    flags = Flags(f_int)
    cpu_helper.load_flags(flags)

    f = cpu_helper.get_flags()
    assert f == flags
