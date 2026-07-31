#!/usr/bin/python3

import pytest
from conftest import Compiler, full_exec_supported, full_exec_reason

pytestmark = pytest.mark.hardware

from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.opcodes import opcode_of

def test_dummy_local(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:

    cpu_helper.regs.A = 0

    acpu.dummy_ext(45)

    val = cpu_helper.regs.A

    assert val == 45

# Dummyext is a copy of ldi A, imm with few additional internal nops
# if it works fine, it will load opcode of HLT into A. The opcode index
# is approx. 0x10D, if ext bit fails, it will execute a 1 byte ADD instruction
# instead and then hit HLT as next instruction
@pytest.fixture(scope="session")
def fetch_test_prog(asm_compiler: Compiler) -> bytes:
    return asm_compiler.compile(f"""
        dummyext 0x{opcode_of("hlt"):02x}
    """)

def test_dummy_fetch(acpu: AssistedCPU, fetch_test_prog: bytes) -> None:
    cpu_helper = CPUHelper(acpu.client)

    # when acpu is enabled, loading from ProgMem does not work at all,
    # so we need to inject everything into imm device
    acpu.imm.inject(fetch_test_prog)

    # reset A, to see if changed
    cpu_helper.regs.A = 0

    # act
    acpu.fetch_and_execute()

    # assert
    val = cpu_helper.regs.A
    assert val == opcode_of("hlt")

@pytest.mark.skipif(not full_exec_supported, reason=full_exec_reason)
def test_dummy_fetch_on_hw(cpu_helper: CPUHelper, fetch_test_prog: bytes) -> None:
    # reset A, to see if changed
    cpu_helper.regs.A = 0

    # run program on hardware
    cpu_helper.run_snippet(0x54, fetch_test_prog)

    # assert
    val = cpu_helper.regs.A
    assert val == opcode_of("hlt")
