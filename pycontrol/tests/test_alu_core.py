#!/usr/bin/python3

import pytest

from libcpu.opcodes import permute_gp_regs_nsame, gp_regs
from libcpu.devices import GPRegister, Flags

from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.DeviceSetup import F

from conftest import ALUTestCase, devname

pytestmark = pytest.mark.hardware

add_ab_test_args = [
    ALUTestCase("small", 24, 18, 42, "----"),
    ALUTestCase("wraparound", 245, 18, 7, "-C--"),
    ALUTestCase("overflow_to_negative", 126, 4, 130, "V--N"),
    ALUTestCase("overflow_to_positive", 226, 145, 115, "VC--"),
    ALUTestCase("to_zero", 246, 10, 0, "-CZ-"),
]

add_aa_test_args = [
    ("small", 25, 50, "----"),
]

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", add_ab_test_args, ids=str)
def test_add_ab(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTestCase) -> None:
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.add(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.get_flags_s()
    assert value == case.result
    assert flags == case.xflags

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("_desc,val,result,xflags", add_aa_test_args, ids=str)
def test_add_aa(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, _desc: str, val: int, result: int, xflags: str) -> None:
    cpu_helper.load_reg8(reg, val)

    acpu.add(reg, reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", add_ab_test_args, ids=str)
def test_addi(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTestCase) -> None:
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.addi(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == case.result
    assert flags == case.xflags


sub_test_args = [
    ALUTestCase("small", 4, 3, 1, "----"),
    ALUTestCase("zero", 4, 4, 0, "--Z-"),
    ALUTestCase("carry", 3, 5, 254, "-C-N"),
    ALUTestCase("overflow_to_positive", 140, 20, 120, "V---"),
    ALUTestCase("overflow_to_negative", 120, 130, 246, "VC-N"),
]

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", sub_test_args, ids=str)
def test_sub(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTestCase) -> None:
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.sub(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.get_flags_s()
    assert value == case.result
    assert flags == case.xflags


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", sub_test_args, ids=str)
def test_subi(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTestCase) -> None:
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.subi(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == case.result
    assert flags == case.xflags


adc_ab_test_args = [
    ALUTestCase("small", 24, 17, 42, "----"),
    ALUTestCase("wraparound", 245, 18, 8, "-C--"),
    ALUTestCase("overflow_to_negative", 126, 4, 131, "V--N"),
    ALUTestCase("overflow_to_positive", 226, 145, 116, "VC--"),
    ALUTestCase("to_zero", 246, 9, 0, "-CZ-"),
]

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", adc_ab_test_args, ids=str)
def test_adc_ab_c_set(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTestCase) -> None:
    cpu_helper.load_flags(Flags.C)
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.adc(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.get_flags_s()
    assert value == case.result
    assert flags == case.xflags

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", add_ab_test_args, ids=str)
def test_adc_ab_c_clear(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTestCase) -> None:
    acpu.ldi (F, Flags.Empty)
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.adc(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.get_flags_s()
    assert value == case.result
    assert flags == case.xflags


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", adc_ab_test_args, ids=str)
def test_adci_c_set(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTestCase) -> None:
    cpu_helper.load_flags(Flags.C)
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.adci(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == case.result
    assert flags == case.xflags

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", add_ab_test_args, ids=str)
def test_adci_c_clear(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTestCase) -> None:
    acpu.ldi (F, Flags.Empty)
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.adci(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == case.result
    assert flags == case.xflags

sbb_test_args = [
    ALUTestCase("small", 5, 3, 1, "----"),
    ALUTestCase("zero", 4, 3, 0, "--Z-"),
    ALUTestCase("carry", 3, 5, 253, "-C-N"),
    ALUTestCase("overflow_to_positive", 140, 19, 120, "V---"),
    ALUTestCase("overflow_to_negative", 120, 130, 245, "VC-N"),
]

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", sbb_test_args, ids=str)
def test_sbb_c_set(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTestCase) -> None:
    cpu_helper.load_flags(Flags.C)
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.sbb(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.get_flags_s()
    assert value == case.result
    assert flags == case.xflags

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", sub_test_args, ids=str)
def test_sbb_c_clear(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTestCase) -> None:
    acpu.ldi (F, Flags.Empty)
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.sbb(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.get_flags_s()
    assert value == case.result
    assert flags == case.xflags


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", sbb_test_args, ids=str)
def test_sbbi_c_set(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTestCase) -> None:
    cpu_helper.load_flags(Flags.C)
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.sbbi(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == case.result
    assert flags == case.xflags

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", sub_test_args, ids=str)
def test_sbbi_c_clear(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTestCase) -> None:
    acpu.ldi (F, Flags.Empty)
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.sbbi(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == case.result
    assert flags == case.xflags
