#!/usr/bin/python3

import pytest

from conftest import permute_gp_regs_nsame, gp_regs
from libcpu.devices import GPRegister, Flags

from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.devmap import A, B

from libcpu.util import to_u8, to_i8


from conftest import ALUTwoRegTestCase, ALUOneRegTestCase, devname

pytestmark = pytest.mark.hardware

add_ab_test_args = [
    # Expected reachable ADD flag combinations for 8-bit operands: {}, Z, N, C, VN, CZ, CN, CV, CZV.
    ALUTwoRegTestCase("empty_flags", 24, 18, 42, Flags.Empty),
    ALUTwoRegTestCase("z_only", 0, 0, 0, Flags.Z),
    ALUTwoRegTestCase("n_only", 0, -128, -128, Flags.N),
    ALUTwoRegTestCase("c_only", 245, 18, 7, Flags.C),
    ALUTwoRegTestCase("vn", 126, 4, -126, Flags.V | Flags.N),
    ALUTwoRegTestCase("cz", 246, 10, 0, Flags.C | Flags.Z),
    ALUTwoRegTestCase("cn", 200, 200, -112, Flags.C | Flags.N),
    ALUTwoRegTestCase("cv", -30, -111, 115, Flags.V | Flags.C),
    ALUTwoRegTestCase("czv", -128, -128, 0, Flags.C | Flags.Z | Flags.V),
]

add_aa_test_args = [
    # Reachable ADD(reg, reg) flag combinations: {}, Z, VN, CN, CV, CZV.
    ALUOneRegTestCase("empty_flags", 25, 50, Flags.Empty),
    ALUOneRegTestCase("z_only", 0, 0, Flags.Z),
    ALUOneRegTestCase("vn", 64, -128, Flags.V | Flags.N),
    ALUOneRegTestCase("cn", 200, -112, Flags.C | Flags.N),
    ALUOneRegTestCase("cv", -116, 24, Flags.V | Flags.C),
    ALUOneRegTestCase("czv", -128, 0, Flags.C | Flags.Z | Flags.V),
]

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", add_ab_test_args, ids=str)
def test_add_ab(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.add(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.regs.F
    assert value == to_u8(case.result)
    assert flags == case.xflags

def test_add_ab_simple(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 10
    cpu_helper.regs.B = 20

    acpu.add(A, B)

    value = cpu_helper.regs.A
    flags = cpu_helper.regs.F
    assert value == 30
    assert flags == Flags.Empty

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", add_aa_test_args, ids=str)
def test_add_aa(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUOneRegTestCase) -> None:
    cpu_helper.load_reg8(reg, case.val)

    acpu.add(reg, reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F
    assert value == to_u8(case.result)
    assert flags == case.xflags


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", add_ab_test_args, ids=str)
def test_addi(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.addi(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F
    assert value == to_u8(case.result)
    assert flags == case.xflags


sub_test_args = [
    # Expected reachable SUB flag combinations: {}, N, Z, C, CN, V, CVN.
    ALUTwoRegTestCase("empty_flags", 4, 3, 1, Flags.Empty),
    ALUTwoRegTestCase("n_only", -128, 0, -128, Flags.N),
    ALUTwoRegTestCase("z_only", 4, 4, 0, Flags.Z),
    ALUTwoRegTestCase("c_only", 0, -127, 127, Flags.C),
    ALUTwoRegTestCase("cn", 3, 5, -2, Flags.C | Flags.N),
    ALUTwoRegTestCase("v_only", -128, 1, 127, Flags.V),
    ALUTwoRegTestCase("cvn", 120, -126, -10, Flags.V | Flags.C | Flags.N),
]

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", sub_test_args, ids=str)
def test_sub(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.sub(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.regs.F
    assert value == to_u8(case.result)
    assert flags == case.xflags


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", sub_test_args, ids=str)
def test_subi(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.subi(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F
    assert value == to_u8(case.result)
    assert flags == case.xflags


@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", sub_test_args, ids=str)
def test_cmp(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTwoRegTestCase) -> None:
    """CMP sets flags based on subtraction but does not store result."""
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)
    lhs_orig = case.val_a

    acpu.cmp(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.regs.F
    assert value == to_u8(lhs_orig)  # Value unchanged
    assert flags == case.xflags


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", sub_test_args, ids=str)
def test_cmpi(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTwoRegTestCase) -> None:
    """CMPI sets flags based on subtraction but does not store result."""
    cpu_helper.load_reg8(reg, case.val_a)
    reg_orig = case.val_a

    acpu.cmpi(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F
    assert value == to_u8(reg_orig)  # Value unchanged
    assert flags == case.xflags


adc_ab_test_args = [
    # Expected reachable ADC (carry-in=1) flag combinations: {}, N, C, VN, CZ, CN, CV.
    ALUTwoRegTestCase("empty_flags", 24, 17, 42, Flags.Empty),
    ALUTwoRegTestCase("n_only", 0, -128, -127, Flags.N),
    ALUTwoRegTestCase("c_only", 200, 100, 45, Flags.C),
    ALUTwoRegTestCase("vn", 126, 1, -128, Flags.V | Flags.N),
    ALUTwoRegTestCase("cz", 246, 9, 0, Flags.C | Flags.Z),
    ALUTwoRegTestCase("cn", 200, 200, -111, Flags.C | Flags.N),
    ALUTwoRegTestCase("cv", -128, -128, 1, Flags.V | Flags.C),
]

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", adc_ab_test_args, ids=str)
def test_adc_ab_c_set(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.regs.F = Flags.C
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.adc(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.regs.F
    assert value == to_u8(case.result)
    assert flags == case.xflags

def test_adc_ab_c_set_simple(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.F = Flags.C
    cpu_helper.regs.A = 246
    cpu_helper.regs.B = 9

    acpu.adc(A, B)

    value = cpu_helper.regs.A
    flags = cpu_helper.regs.F
    assert value == 0
    assert flags == Flags.C | Flags.Z

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", add_ab_test_args, ids=str)
def test_adc_ab_c_clear(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.regs.F = Flags.Empty
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.adc(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.regs.F
    assert value == to_u8(case.result)
    assert flags == case.xflags


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", adc_ab_test_args, ids=str)
def test_adci_c_set(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.regs.F = Flags.C
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.adci(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F
    assert value == to_u8(case.result)
    assert flags == case.xflags

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", add_ab_test_args, ids=str)
def test_adci_c_clear(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.regs.F = Flags.Empty
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.adci(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F
    assert value == to_u8(case.result)
    assert flags == case.xflags

sbb_test_args = [
    # Expected reachable SBB(carry-in=1) flag combinations: {}, N, Z, C, CN, CZ, V, CVN.
    ALUTwoRegTestCase("empty_flags", 5, 3, 1, Flags.Empty),
    ALUTwoRegTestCase("n_only", -127, 0, -128, Flags.N),
    ALUTwoRegTestCase("z_only", 1, 0, 0, Flags.Z),
    ALUTwoRegTestCase("c_only", 0, -128, 127, Flags.C),
    ALUTwoRegTestCase("cn", 3, 5, -3, Flags.C | Flags.N),
    ALUTwoRegTestCase("cz", 0, -1, 0, Flags.C | Flags.Z),
    ALUTwoRegTestCase("v_only", -128, 0, 127, Flags.V),
    ALUTwoRegTestCase("cvn", 120, -126, -11, Flags.V | Flags.C | Flags.N),
]

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", sbb_test_args, ids=str)
def test_sbb_c_set(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.regs.F = Flags.C
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.sbb(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.regs.F
    assert value == to_u8(case.result)
    assert flags == case.xflags

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", sub_test_args, ids=str)
def test_sbb_c_clear(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.regs.F = Flags.Empty
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)

    acpu.sbb(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.regs.F
    assert value == to_u8(case.result)
    assert flags == case.xflags


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", sbb_test_args, ids=str)
def test_sbbi_c_set(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.regs.F = Flags.C
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.sbbi(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F
    assert value == to_u8(case.result)
    assert flags == case.xflags

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", sub_test_args, ids=str)
def test_sbbi_c_clear(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.regs.F = Flags.Empty
    cpu_helper.load_reg8(reg, case.val_a)

    acpu.sbbi(reg, case.val_b)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F
    assert value == to_u8(case.result)
    assert flags == case.xflags

overflow_test_args = [
    # A+, B+, R+  → no overflow
    ALUTwoRegTestCase(
        "pos_pos_no_overflow",
        20, 30,
        50, Flags.Empty
    ),

    # A+, B+, R-  → OVERFLOW
    ALUTwoRegTestCase(
        "pos_pos_overflow",
        100, 50,
        -106, Flags.V
    ),

    # A+, B-, R+  → no overflow
    ALUTwoRegTestCase(
        "pos_neg_no_overflow_1",
        30, -10,
        20, Flags.Empty
    ),

    # A+, B-, R-  → no overflow
    ALUTwoRegTestCase(
        "pos_neg_no_overflow_2",
        10, -20,
        -10, Flags.Empty
    ),

    # A-, B+, R+  → no overflow
    ALUTwoRegTestCase(
        "neg_pos_no_overflow_1",
        -10, 20,
        10, Flags.Empty
    ),

    # A-, B+, R-  → no overflow
    ALUTwoRegTestCase(
        "neg_pos_no_overflow_2",
        -50, 20,
        -30, Flags.Empty
    ),

    # A-, B-, R-  → no overflow
    ALUTwoRegTestCase(
        "neg_neg_no_overflow",
        -30, -40,
        -70, Flags.Empty
    ),

    # A-, B-, R+  → OVERFLOW
    ALUTwoRegTestCase(
        "neg_neg_overflow",
        -80, -80,
        96, Flags.V
    ),
]

@pytest.mark.parametrize("case", overflow_test_args, ids=str)
def test_add_overflow_flag(cpu_helper: CPUHelper, acpu: AssistedCPU, case: ALUTwoRegTestCase) -> None:
    cpu_helper.regs.A = to_u8(case.val_a)
    cpu_helper.regs.B = to_u8(case.val_b)

    acpu.add(A, B)

    value = to_i8(cpu_helper.regs.A)
    flags = cpu_helper.regs.F & Flags.V
    assert value == case.result
    assert flags == case.xflags

# Parametrize with (value, expected_flags)
@pytest.mark.parametrize("value,expected_flags", [
    (0b0000_0000, Flags.Z),           # Zero, should set Z
    (0b1000_0000, Flags.N),           # Negative (MSB set), should set N
    (0b0000_0001, Flags.Empty),       # Neither Z nor N
    (0b1111_1111, Flags.N),           # Negative (MSB set), not zero
    (0b0111_1111, Flags.Empty),       # Positive, not zero
])
def test_tst(cpu_helper: CPUHelper, acpu: AssistedCPU, value: int, expected_flags: Flags) -> None:
    cpu_helper.regs.A = value
    acpu.tst(A)
    assert cpu_helper.regs.F & (Flags.Z | Flags.N) == expected_flags
