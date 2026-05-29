#!/usr/bin/python3

import pytest

from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.devmap import A, B
from libcpu.opcodes import permute_gp_regs_nsame, gp_regs
from libcpu.devices import GPRegister, Flags

from conftest import ALUTwoRegTestCase, ALUOneRegTestCase, Compiler, devname

pytestmark = pytest.mark.hardware

NZ_MASK = Flags.N | Flags.Z

and_test_args = [
    # Expected reachable AND flag combinations: {}, N, Z.
    ALUTwoRegTestCase("empty_flags", 1, 1, 1, Flags.Empty),
    ALUTwoRegTestCase("empty_flags_2", 0xff, 0x01, 0x01, Flags.Empty),
    ALUTwoRegTestCase("n_only", 128, 128, 128, Flags.N),
    ALUTwoRegTestCase("n_only_2", 255, 255, 255, Flags.N),
    ALUTwoRegTestCase("z_only", 0, 0, 0, Flags.Z),
    ALUTwoRegTestCase("z_only_2", 128, 127, 0, Flags.Z),
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

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame(), ids=devname)
@pytest.mark.parametrize("case", and_test_args)
def test_lcmp(cpu_helper: CPUHelper, acpu: AssistedCPU, lhs: GPRegister, rhs: GPRegister, case: ALUTwoRegTestCase) -> None:
    cpu_helper.load_reg8(lhs, case.val_a)
    cpu_helper.load_reg8(rhs, case.val_b)
    lhs_orig = case.val_a

    acpu.lcmp(lhs, rhs)

    value = cpu_helper.read_reg8(lhs)
    flags = cpu_helper.regs.F & NZ_MASK # we are only interested in Z and N flags
    assert value == lhs_orig  # Value unchanged
    assert flags == case.xflags


or_test_args = [
    # Expected reachable OR flag combinations: {}, N, Z.
    ALUTwoRegTestCase("empty_flags", 0, 1, 1, Flags.Empty),
    ALUTwoRegTestCase("empty_flags_2", 0x7f, 0x01, 0x7f, Flags.Empty),
    ALUTwoRegTestCase("n_only", 0, 128, 128, Flags.N),
    ALUTwoRegTestCase("n_only_2", 0x80, 0x7f, 0xff, Flags.N),
    ALUTwoRegTestCase("z_only", 0, 0, 0, Flags.Z),
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


@pytest.mark.parametrize("vc_flags", [Flags.Empty, Flags.C, Flags.V, Flags.C | Flags.V])
@pytest.mark.parametrize(
    "lhs_val,rhs_val,expected_nz",
    [
        (0x80, 0x80, Flags.N),
        (0xAA, 0x55, Flags.Z),
    ],
)
def test_and_preserves_vc_flags(
    cpu_helper: CPUHelper,
    acpu: AssistedCPU,
    vc_flags: Flags,
    lhs_val: int,
    rhs_val: int,
    expected_nz: Flags,
) -> None:
    cpu_helper.regs.F = vc_flags
    cpu_helper.load_reg8(A, lhs_val)
    cpu_helper.load_reg8(B, rhs_val)

    acpu.andb(A, B)

    flags = cpu_helper.regs.F
    assert (flags & (Flags.C | Flags.V)) == vc_flags
    assert (flags & NZ_MASK) == expected_nz

@pytest.mark.parametrize("vc_flags", [Flags.Empty, Flags.C, Flags.V, Flags.C | Flags.V])
@pytest.mark.parametrize(
    "lhs_val,rhs_val,expected_nz",
    [
        (0x80, 0x80, Flags.N),
        (0xAA, 0x55, Flags.Z),
    ],
)
def test_lcmp_preserves_vc_flags(
    cpu_helper: CPUHelper,
    acpu: AssistedCPU,
    vc_flags: Flags,
    lhs_val: int,
    rhs_val: int,
    expected_nz: Flags,
) -> None:
    cpu_helper.regs.F = vc_flags
    cpu_helper.load_reg8(A, lhs_val)
    cpu_helper.load_reg8(B, rhs_val)

    acpu.lcmp(A, B)

    flags = cpu_helper.regs.F
    assert (flags & (Flags.C | Flags.V)) == vc_flags
    assert (flags & NZ_MASK) == expected_nz


@pytest.mark.parametrize("vc_flags", [Flags.Empty, Flags.C, Flags.V, Flags.C | Flags.V])
@pytest.mark.parametrize(
    "lhs_val,rhs_val,expected_nz",
    [
        (0x80, 0x00, Flags.N),
        (0x00, 0x00, Flags.Z),
    ],
)
def test_or_preserves_vc_flags(
    cpu_helper: CPUHelper,
    acpu: AssistedCPU,
    vc_flags: Flags,
    lhs_val: int,
    rhs_val: int,
    expected_nz: Flags,
) -> None:
    cpu_helper.regs.F = vc_flags
    cpu_helper.load_reg8(A, lhs_val)
    cpu_helper.load_reg8(B, rhs_val)

    acpu.orb(A, B)

    flags = cpu_helper.regs.F
    assert (flags & (Flags.C | Flags.V)) == vc_flags
    assert (flags & NZ_MASK) == expected_nz




shr_args = [
    ALUOneRegTestCase("carry_out_1", 25, 12, Flags.C),
    ALUOneRegTestCase("carry_out_0", 122, 61, Flags.Empty),
    ALUOneRegTestCase("no_signext", 128, 64, Flags.Empty),
    ALUOneRegTestCase("z_only", 0, 0, Flags.Z),
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


@pytest.fixture(scope="session")
def shr_test_prog(asm_compiler: Compiler) -> dict[str, bytes]:

    progs = {}
    for reg in gp_regs:
        progs[reg.name] = asm_compiler.compile(f"""
            shr {reg.name}
        """)

    return progs

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("case", shr_args)
@pytest.mark.parametrize("carry_in", [Flags.Empty, Flags.C])
def test_shr_real(cpu_helper: CPUHelper, reg: GPRegister, carry_in: Flags, case: ALUOneRegTestCase, shr_test_prog: dict[str, bytes]) -> None:

    cpu_helper.regs.F = carry_in
    cpu_helper.load_reg8(reg, case.val)

    cpu_helper.run_snippet(0x66, shr_test_prog[reg.name])

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F
    assert value == case.result
    assert flags == case.xflags


@pytest.mark.parametrize("initial_flags", [Flags.Empty, Flags.C, Flags.V, Flags.C | Flags.V])
@pytest.mark.parametrize("val", [0x00, 0x01, 0x80])
def test_shr_preserves_v_flag(cpu_helper: CPUHelper, acpu: AssistedCPU, initial_flags: Flags, val: int) -> None:
    cpu_helper.regs.F = initial_flags
    cpu_helper.load_reg8(A, val)

    acpu.shr(A)

    flags = cpu_helper.regs.F
    assert (flags & Flags.V) == (initial_flags & Flags.V)


ror_args = [
    ("carry_out_1", Flags.Empty, 25, 12, Flags.C),
    ("carry_out_0", Flags.Empty, 122, 61, Flags.Empty),
    ("no_signext", Flags.Empty, 128, 64, Flags.Empty),
    ("z_only", Flags.Empty, 0, 0, Flags.Z),
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


@pytest.mark.parametrize("initial_flags", [Flags.Empty, Flags.C, Flags.V, Flags.C | Flags.V])
@pytest.mark.parametrize("val", [0x00, 0x01, 0x80])
def test_ror_preserves_v_flag(cpu_helper: CPUHelper, acpu: AssistedCPU, initial_flags: Flags, val: int) -> None:
    cpu_helper.regs.F = initial_flags
    cpu_helper.load_reg8(A, val)

    acpu.ror(A)

    flags = cpu_helper.regs.F
    assert (flags & Flags.V) == (initial_flags & Flags.V)

asr_args = [
    ("carry_out_1", 25, 12, Flags.C),
    ("carry_out_0", 122, 61, Flags.Empty),
    ("signext", 128, 192, Flags.N),
    ("z_only", 0, 0, Flags.Z),
    ("zero", 1, 0, Flags.C | Flags.Z),
    ("cn", 129, 192, Flags.C | Flags.N),
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


@pytest.fixture(scope="session")
def asr_test_prog(asm_compiler: Compiler) -> dict[str, bytes]:
    progs = {}
    for reg in gp_regs:
        progs[reg.name] = asm_compiler.compile(f"""
            asr {reg.name}
        """)
    return progs

@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("_desc,val,result,xflags", asr_args)
@pytest.mark.parametrize("carry_in", [Flags.Empty, Flags.C])
def test_asr_real(cpu_helper: CPUHelper, reg: GPRegister, _desc: str, carry_in: Flags, val: int, result: int, xflags: Flags, asr_test_prog: dict[str, bytes]) -> None:

    cpu_helper.regs.F = carry_in
    cpu_helper.load_reg8(reg, val)

    cpu_helper.run_snippet(0x23, asr_test_prog[reg.name])

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F
    assert value == result
    assert flags == xflags


@pytest.mark.parametrize("initial_flags", [Flags.Empty, Flags.C, Flags.V, Flags.C | Flags.V])
@pytest.mark.parametrize("val", [0x00, 0x01, 0x80])
def test_asr_preserves_v_flag(cpu_helper: CPUHelper, acpu: AssistedCPU, initial_flags: Flags, val: int) -> None:
    cpu_helper.regs.F = initial_flags
    cpu_helper.load_reg8(A, val)

    acpu.asr(A)

    flags = cpu_helper.regs.F
    assert (flags & Flags.V) == (initial_flags & Flags.V)


swap_args = [
    ALUOneRegTestCase("simple", 0xa2, 0x2a, Flags.Empty),
    ALUOneRegTestCase("neg", 0x58, 0x85, Flags.N),
    ALUOneRegTestCase("zero", 0x00, 0x00, Flags.Z),
    ALUOneRegTestCase("all_ones", 0xff, 0xff, Flags.N),
    ALUOneRegTestCase("low_to_high", 0x0f, 0xf0, Flags.N),
    ALUOneRegTestCase("high_to_low", 0xf0, 0x0f, Flags.Empty),
    ALUOneRegTestCase("mixed_to_negative", 0x3c, 0xc3, Flags.N),
    ALUOneRegTestCase("mixed_to_positive", 0xc3, 0x3c, Flags.Empty),
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


@pytest.mark.parametrize("reg", gp_regs, ids=devname)
@pytest.mark.parametrize("val", [0x00, 0x01, 0x0f, 0x10, 0x3c, 0x80, 0xc3, 0xff])
def test_swap_twice_returns_original(cpu_helper: CPUHelper, acpu: AssistedCPU, reg: GPRegister, val: int) -> None:
    cpu_helper.load_reg8(reg, val)

    acpu.swap(reg)
    acpu.swap(reg)

    value = cpu_helper.read_reg8(reg)
    flags = cpu_helper.regs.F & NZ_MASK
    assert value == val
    assert flags == (Flags.Z if val == 0 else (Flags.N if val & 0x80 else Flags.Empty))


xor_test_args = [
    # Expected reachable XOR flag combinations: {}, N, Z.
    ALUTwoRegTestCase("empty_flags", 0x55, 0x01, 0x54, Flags.Empty),
    ALUTwoRegTestCase("empty_flags_2", 0x55, 0x0f, 0x5a, Flags.Empty),
    ALUTwoRegTestCase("n_only", 230, 92, 186, Flags.N),
    ALUTwoRegTestCase("n_only_2", 0xa5, 0x5a, 0xff, Flags.N),
    ALUTwoRegTestCase("z_only", 0x42, 0x42, 0, Flags.Z),
    ALUTwoRegTestCase("z_only_2", 0x00, 0x00, 0, Flags.Z),
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


@pytest.mark.parametrize("vc_flags", [Flags.Empty, Flags.C, Flags.V, Flags.C | Flags.V])
@pytest.mark.parametrize(
    "lhs_val,rhs_val,expected_nz",
    [
        (0x80, 0x00, Flags.N),
        (0x5A, 0x5A, Flags.Z),
    ],
)
def test_xor_preserves_vc_flags(
    cpu_helper: CPUHelper,
    acpu: AssistedCPU,
    vc_flags: Flags,
    lhs_val: int,
    rhs_val: int,
    expected_nz: Flags,
) -> None:
    cpu_helper.regs.F = vc_flags
    cpu_helper.load_reg8(A, lhs_val)
    cpu_helper.load_reg8(B, rhs_val)

    acpu.xor(A, B)

    flags = cpu_helper.regs.F
    assert (flags & (Flags.C | Flags.V)) == vc_flags
    assert (flags & NZ_MASK) == expected_nz


not_args = [
    # Expected reachable NOT flag combinations: {}, N, Z.
    ALUOneRegTestCase("empty_flags", 0x80, 0x7f, Flags.Empty),
    ALUOneRegTestCase("n_only", 25, 230, Flags.N),
    ALUOneRegTestCase("n_only_2", 0x00, 0xff, Flags.N),
    ALUOneRegTestCase("z_only", 0xFF, 0, Flags.Z),
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


@pytest.mark.parametrize("vc_flags", [Flags.Empty, Flags.C, Flags.V, Flags.C | Flags.V])
@pytest.mark.parametrize(
    "val,expected_nz",
    [
        (0xFF, Flags.Z),
        (0x00, Flags.N),
    ],
)
def test_not_preserves_vc_flags(
    cpu_helper: CPUHelper,
    acpu: AssistedCPU,
    vc_flags: Flags,
    val: int,
    expected_nz: Flags,
) -> None:
    cpu_helper.regs.F = vc_flags
    cpu_helper.load_reg8(A, val)

    acpu.notb(A)

    flags = cpu_helper.regs.F
    assert (flags & (Flags.C | Flags.V)) == vc_flags
    assert (flags & NZ_MASK) == expected_nz
