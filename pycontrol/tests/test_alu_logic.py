#!/usr/bin/python3

import pytest

from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.devmap import A, B
from libcpu.opcodes import permute_gp_regs_nsame, gp_regs, opcode_of
from libcpu.devices import GPRegister, Flags

from conftest import ALUTwoRegTestCase, ALUOneRegTestCase, devname

pytestmark = pytest.mark.hardware

NZ_MASK = Flags.N | Flags.Z

and_test_args = [
    ALUTwoRegTestCase("small", 230, 92, 68, Flags.Empty),
    ALUTwoRegTestCase("zero", 0xa5, 0x5a, 0, Flags.Z),
]

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", and_test_args)
def test_and(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.andb(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.regs.F & NZ_MASK # we are only interested in Z and N flags
    assert value == case.result
    assert flags == case.xflags

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", and_test_args)
def test_andi(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.andi(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F & NZ_MASK # we are only interested in Z and N flags
    assert value == case.result
    assert flags == case.xflags



or_test_args = [
    ALUTwoRegTestCase("small", 230, 92, 254, Flags.N),
    ALUTwoRegTestCase("full", 0xa5, 0x5a, 0xff, Flags.N),
]

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", or_test_args)
def test_or(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.orb(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.regs.F & NZ_MASK
    assert value == case.result
    assert flags == case.xflags


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", or_test_args)
def test_ori(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.ori(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F & NZ_MASK # we are only interested in Z and N flags
    assert value == case.result
    assert flags == case.xflags




shr_args = [
    ALUOneRegTestCase("carry_out_1", 25, 12, Flags.C),
    ALUOneRegTestCase("carry_out_0", 122, 61, Flags.Empty),
    ALUOneRegTestCase("no_signext", 128, 64, Flags.Empty),
    ALUOneRegTestCase("zero", 1, 0, Flags.C | Flags.Z),
]

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", shr_args)
@pytest.mark.parametrize("carry_in", [Flags.Empty, Flags.C])
def test_shr(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, carry_in: Flags, case: ALUOneRegTestCase) -> None:
    cpu_helper.regs.F = carry_in
    cpu_helper.load_reg8(reg, case.val)

    acpu.shr(reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F
    assert value == case.result
    assert flags == case.xflags

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", shr_args)
@pytest.mark.parametrize("carry_in", [Flags.Empty, Flags.C])
def test_shr_real(cpu_helper: CPUHelper, reg: GPRegister, carry_in: Flags, case: ALUOneRegTestCase) -> None:

    shr_test_prog = bytes([opcode_of(f"shr_{reg.name}")])

    cpu_helper.regs.F = carry_in
    cpu_helper.load_reg8(reg, case.val)

    cpu_helper.run_snippet(0x66, shr_test_prog)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F
    assert value == case.result
    assert flags == case.xflags


ror_args = [
    ("carry_out_1", Flags.Empty, 25, 12, Flags.C),
    ("carry_out_0", Flags.Empty, 122, 61, Flags.Empty),
    ("no_signext", Flags.Empty, 128, 64, Flags.Empty),
    ("zero", Flags.Empty, 1, 0, Flags.C | Flags.Z),

    ("carry_in_out_1", Flags.C, 25, 140, Flags.C | Flags.N),
    ("carry_in_1_out_0", Flags.C, 122, 189, Flags.N),
    ("cin_zero", Flags.C, 0, 128, Flags.N),
]

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("_desc,carry_in,val,result,xflags", ror_args)
def test_ror(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, _desc: str, carry_in: Flags, val: int, result: int, xflags: Flags) -> None:
    cpu_helper.regs.F = carry_in
    cpu_helper.load_reg8(reg, val)

    acpu.ror(reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F
    assert value == result
    assert flags == xflags

asr_args = [
    ("carry_out_1", 25, 12, Flags.C),
    ("carry_out_0", 122, 61, Flags.Empty),
    ("signext", 128, 192, Flags.N),
    ("zero", 1, 0, Flags.C | Flags.Z),
]

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("_desc,val,result,xflags", asr_args)
@pytest.mark.parametrize("carry_in", [Flags.Empty, Flags.C])
def test_asr(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, _desc: str, carry_in: Flags, val: int, result: int, xflags: Flags) -> None:
    cpu_helper.regs.F = carry_in
    cpu_helper.load_reg8(reg, val)

    acpu.asr(reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F
    assert value == result
    assert flags == xflags

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("_desc,val,result,xflags", asr_args)
@pytest.mark.parametrize("carry_in", [Flags.Empty, Flags.C])
def test_asr_real(cpu_helper: CPUHelper, reg: GPRegister, _desc: str, carry_in: Flags, val: int, result: int, xflags: Flags) -> None:

    asr_test_prog = bytes([opcode_of(f"asr_{reg.name}")])

    cpu_helper.regs.F = carry_in
    cpu_helper.load_reg8(reg, val)

    cpu_helper.run_snippet(0x23, asr_test_prog)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F
    assert value == result
    assert flags == xflags


swap_args = [
    ALUOneRegTestCase("simple", 0xa2, 0x2a, Flags.Empty),
    ALUOneRegTestCase("neg", 0x58, 0x85, Flags.N),
    ALUOneRegTestCase("zero", 0, 0, Flags.Z),
]


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", swap_args)
def test_swap(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUOneRegTestCase) -> None:
    cpu_helper.load_reg8(reg, case.val)

    acpu.swap(reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F & NZ_MASK
    assert value == case.result
    assert flags == case.xflags


xor_test_args = [
    ALUTwoRegTestCase("small", 230, 92, 186, Flags.N),
    ALUTwoRegTestCase("fill", 0xa5, 0x5a, 0xff, Flags.N),
    ALUTwoRegTestCase("zero", 0x142, 0x142, 0, Flags.Z),
]

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", xor_test_args)
def test_xor(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.xor(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.regs.F & NZ_MASK # we are only interested in Z and N flags
    assert value == case.result
    assert flags == case.xflags

def test_xor_zero_same(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 0x5A

    acpu.clr(A)

    value = cpu_helper.regs.A
    flags = cpu_helper.regs.F & NZ_MASK

    assert value == 0
    assert flags == Flags.Z


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", xor_test_args)
def test_xori(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.xori(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F & NZ_MASK # we are only interested in Z and N flags
    assert value == case.result
    assert flags == case.xflags


not_args = [
    ALUOneRegTestCase("normal", 25, 230, Flags.N),
    ALUOneRegTestCase("zero", 0xFF, 0, Flags.Z),
]

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", not_args)
def test_not(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUOneRegTestCase) -> None:

    cpu_helper.load_reg8(reg, case.val)

    acpu.notb(reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F & NZ_MASK
    assert value == case.result
    assert flags == case.xflags
