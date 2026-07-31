#!/usr/bin/python3

import pytest
import random

from libcpu.assisted_cpu import AssistedCPU
from libcpu.devmap import A, B, SDP, TDP
from libcpu.markers import Addr
from libcpu.cpu_helper import CPUHelper
from collections.abc import Sequence

from conftest import Compiler, full_exec_supported, full_exec_reason

pytestmark = pytest.mark.hardware

# can not make as a fixture, because it can not be
# unpacked for parametrization (couldn't find a way)
def make_random_addr() -> Sequence[int]:

    # make sure addresses are unique, skip ROM area
    addr = list(range(0xE000))
    random.shuffle(addr)

    # 64 addresses out of 65536 should be enough to
    # verify that RAM works as expected
    return addr[:64]

random_addr = make_random_addr()

@pytest.mark.parametrize("addr", random_addr)
def test_load(cpu_helper: CPUHelper, acpu: AssistedCPU, addr: int) -> None:
    test_val = random.randint(0, 255)
    cpu_helper.ram[addr] = test_val

    acpu.ld (A, Addr(addr))

    assert test_val == cpu_helper.regs.A

@pytest.mark.parametrize("addr", random_addr)
def test_store(cpu_helper: CPUHelper, acpu: AssistedCPU, addr: int) -> None:
    cpu_helper.ram[addr] = 0

    test_val = random.randint(1, 255) # do not use 0, because it is the default value in RAM
    cpu_helper.regs.A = test_val

    acpu.st (Addr(addr), A)

    assert cpu_helper.ram[addr] == test_val

@pytest.mark.skipif(not full_exec_supported, reason=full_exec_reason)
def test_ldx_hw(cpu_helper: CPUHelper, asm_compiler: Compiler) -> None:

    cpu_helper.ram[0x2203] = 0x33
    cpu_helper.regs.B = 3
    cpu_helper.regs.SDP = 0x2200

    out_test_prog = asm_compiler.compile(f"""
        ld A, (SDP + B)
    """)

    cpu_helper.run_snippet(0x0, out_test_prog)

    assert cpu_helper.regs.A == 0x33

@pytest.mark.parametrize("addr", random_addr)
def test_load_sdp(cpu_helper: CPUHelper, acpu: AssistedCPU, addr: int) -> None:

    test_val = random.randint(0, 255)
    cpu_helper.ram[addr] = test_val
    cpu_helper.regs.SDP = addr

    acpu.lpi (A, SDP)

    assert test_val == cpu_helper.regs.A
    assert addr + 1 == cpu_helper.regs.SDP


@pytest.mark.parametrize("addr", random_addr)
def test_store_tdp(cpu_helper: CPUHelper, acpu: AssistedCPU, addr: int) -> None:

    test_val = random.randint(1, 255)
    cpu_helper.ram[addr] = 0
    cpu_helper.regs.A = test_val
    cpu_helper.regs.TDP = addr

    acpu.spi (TDP, A)

    assert test_val == cpu_helper.ram[addr]
    assert addr + 1 == cpu_helper.regs.TDP



def test_load_idx(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    cpu_helper.ram[0x45] = 0xB5
    cpu_helper.regs.B = 3
    cpu_helper.regs.SDP = 0x42

    acpu.ldx (A, SDP, B)

    assert cpu_helper.regs.A == 0xB5


def test_store_idx(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    cpu_helper.ram[0x45] = 0
    cpu_helper.regs.A = 0xB5
    cpu_helper.regs.B = 3
    cpu_helper.regs.TDP = 0x42

    acpu.stx (TDP, B, A)

    assert cpu_helper.ram[0x45] == 0xB5

@pytest.mark.skipif(not full_exec_supported, reason=full_exec_reason)
def test_stx_hw(cpu_helper: CPUHelper, asm_compiler: Compiler) -> None:

    cpu_helper.ram[0x2203] = 0
    cpu_helper.regs.A = 0x33
    cpu_helper.regs.B = 3
    cpu_helper.regs.TDP = 0x2200

    out_test_prog = asm_compiler.compile(f"""
        st (TDP + B), A
    """)

    cpu_helper.run_snippet(0x0, out_test_prog)

    assert cpu_helper.ram[0x2203] == 0x33
