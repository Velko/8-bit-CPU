#!/usr/bin/python3

import pytest

from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.DeviceSetup import A
from libcpu.opcodes import permute_gp_regs_nsame, gp_regs, opcode_of
from libcpu.devices import GPRegister, Flags

from conftest import ALUTestCase, devname

pytestmark = pytest.mark.hardware

and_test_args = [
    ALUTestCase("small", 230, 92, 68, "----"),
    ALUTestCase("zero", 0xa5, 0x5a, 0, "--Z-"),
]

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", and_test_args)
def test_and(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTestCase) -> None:
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.andb(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.get_flags(Flags.Z | Flags.N) # we are only interested in Z and N flags
    assert value == case.result
    assert str(flags) == case.xflags

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", and_test_args)
def test_andi(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTestCase) -> None:
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.andi(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags(Flags.Z | Flags.N) # we are only interested in Z and N flags
    assert value == case.result
    assert str(flags) == case.xflags



or_test_args = [
    ALUTestCase("small", 230, 92, 254, "---N"),
    ALUTestCase("full", 0xa5, 0x5a, 0xff, "---N"),
]

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", or_test_args)
def test_or(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTestCase) -> None:
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.orb(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.get_flags(Flags.Z | Flags.N)
    assert value == case.result
    assert str(flags) == case.xflags


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", or_test_args)
def test_ori(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTestCase) -> None:
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.ori(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags(Flags.Z | Flags.N) # we are only interested in Z and N flags
    assert value == case.result
    assert str(flags) == case.xflags




shr_args = [
    ("carry_out_1", 25, 12, "-C--"),
    ("carry_out_0", 122, 61, "----"),
    ("no_signext", 128, 64, "----"),
    ("zero", 1, 0, "-CZ-"),
]

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("_desc,val,result,xflags", shr_args)
@pytest.mark.parametrize("carry_in", [False, True])
def test_shr(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, _desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    if carry_in:
        cpu_helper.load_flags(Flags.C)
    else:
        cpu_helper.load_flags(Flags.Empty)

    cpu_helper.load_reg8(reg, val)

    acpu.shr(reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("_desc,val,result,xflags", shr_args)
@pytest.mark.parametrize("carry_in", [False, True])
def test_shr_real(cpu_helper: CPUHelper, reg: GPRegister, _desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    shr_test_prog = bytes([opcode_of(f"shr_{reg.name}")])

    if carry_in:
        cpu_helper.load_flags(Flags.C)
    else:
        cpu_helper.load_flags(Flags.Empty)

    cpu_helper.load_reg8(reg, val)

    cpu_helper.run_snippet(0x2066, shr_test_prog)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags


ror_args = [
    ("carry_out_1", False, 25, 12, "-C--"),
    ("carry_out_0", False, 122, 61, "----"),
    ("no_signext", False, 128, 64, "----"),
    ("zero", False, 1, 0, "-CZ-"),

    ("carry_in_out_1", True, 25, 140, "-C-N"),
    ("carry_in_1_out_0", True, 122, 189, "---N"),
    ("cin_zero", True, 0, 128, "---N"),
]

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("_desc,carry_in,val,result,xflags", ror_args)
def test_ror(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, _desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    if carry_in:
        cpu_helper.load_flags(Flags.C)
    else:
        cpu_helper.load_flags(Flags.Empty)

    cpu_helper.load_reg8(reg, val)

    acpu.ror(reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags

asr_args = [
    ("carry_out_1", 25, 12, "-C--"),
    ("carry_out_0", 122, 61, "----"),
    ("signext", 128, 192, "---N"),
    ("zero", 1, 0, "-CZ-"),
]

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("_desc,val,result,xflags", asr_args)
@pytest.mark.parametrize("carry_in", [False, True])
def test_asr(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, _desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    if carry_in:
        cpu_helper.load_flags(Flags.C)
    else:
        cpu_helper.load_flags(Flags.Empty)

    cpu_helper.load_reg8(reg, val)

    acpu.asr(reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("_desc,val,result,xflags", asr_args)
@pytest.mark.parametrize("carry_in", [False, True])
def test_asr_real(cpu_helper: CPUHelper, reg: GPRegister, _desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    asr_test_prog = bytes([opcode_of(f"asr_{reg.name}")])

    if carry_in:
        cpu_helper.load_flags(Flags.C)
    else:
        cpu_helper.load_flags(Flags.Empty)

    cpu_helper.load_reg8(reg, val)

    cpu_helper.run_snippet(0x2023, asr_test_prog)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags_s()
    assert value == result
    assert flags == xflags


swap_args = [
    ("simple", 0xa2, 0x2a, "----"),
    ("neg", 0x58, 0x85, "---N"),
    ("zero", 0, 0, "--Z-"),
]


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("_desc,val,result,xflags", swap_args)
@pytest.mark.parametrize("carry_in", [False, True])
def test_swap(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, _desc: str, carry_in: bool, val: int, result: int, xflags: str) -> None:

    if carry_in:
        cpu_helper.load_flags(Flags.C)
    else:
        cpu_helper.load_flags(Flags.Empty)

    cpu_helper.load_reg8(reg, val)

    acpu.swap(reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags(Flags.Z | Flags.N)
    assert value == result
    assert str(flags) == xflags


xor_test_args = [
    ALUTestCase("small", 230, 92, 186, "---N"),
    ALUTestCase("fill", 0xa5, 0x5a, 0xff, "---N"),
    ALUTestCase("zero", 0x142, 0x142, 0, "--Z-"),
]

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", xor_test_args)
def test_xor(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTestCase) -> None:
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.xor(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.get_flags(Flags.Z | Flags.N) # we are only interested in Z and N flags
    assert value == case.result
    assert str(flags) == case.xflags

def test_xor_zero_same(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.load_reg8(A, 0x5A)

    acpu.clr(A)

    value = cpu_helper.read_reg8(A)
    flags = cpu_helper.get_flags(Flags.Z | Flags.N)

    assert value == 0
    assert str(flags) == "--Z-"


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", xor_test_args)
def test_xori(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTestCase) -> None:
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.xori(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags(Flags.Z | Flags.N) # we are only interested in Z and N flags
    assert value == case.result
    assert str(flags) == case.xflags


not_args = [
    ("normal", 25, 230, "---N"),
    ("zero", 0xFF, 0, "--Z-"),
]

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("_desc,val,result,xflags", not_args)
def test_not(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, _desc: str, val: int, result: int, xflags: str) -> None:

    cpu_helper.load_reg8(reg, val)

    acpu.notb(reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.get_flags(Flags.Z | Flags.N)
    assert value == result
    assert str(flags) == xflags
