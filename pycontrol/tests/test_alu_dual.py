#!/usr/bin/python3

import pytest

from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.devmap import A, B

pytestmark = pytest.mark.hardware

hardwired_alu = False
hardwired_reason = "unsupported with hardwired ALU inputs"

@pytest.mark.skipif(hardwired_alu, reason=hardwired_reason)
def test_sub_b_a_small(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 3
    cpu_helper.regs.B = 4

    acpu.sub(B, A)

    assert cpu_helper.regs.B == 1

@pytest.mark.skipif(hardwired_alu, reason=hardwired_reason)
def test_add_a_a(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 21

    acpu.add(A, A)

    assert cpu_helper.regs.A == 42

@pytest.mark.skipif(hardwired_alu, reason=hardwired_reason)
def test_add_b_b(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.B = 18

    acpu.add(B, B)

    assert cpu_helper.regs.B == 36

def test_inc_a(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 4

    acpu.inc(A)

    value = cpu_helper.regs.A
    assert value == 5

def test_dec_a(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 4

    acpu.dec(A)

    value = cpu_helper.regs.A
    assert value == 3

def test_inc_flags_cz(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 255

    acpu.inc(A)

    flags = cpu_helper.get_flags_s()
    assert flags == "-CZ-"

def test_inc_flags_v(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 127

    acpu.inc(A)

    flags = cpu_helper.get_flags_s()
    assert flags == "V--N"


def test_dec_flags_z(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 1

    acpu.dec(A)

    flags = cpu_helper.get_flags_s()
    assert flags == "--Z-"

def test_dec_flags_cn(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 0

    acpu.dec(A)

    flags = cpu_helper.get_flags_s()
    assert flags == "-C-N"

def test_dec_flags_v(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 128

    acpu.dec(A)

    flags = cpu_helper.get_flags_s()
    assert flags == "V---"
