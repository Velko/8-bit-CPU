#!/usr/bin/python3

import pytest
from conftest import Compiler, full_exec_supported, full_exec_reason

pytestmark = pytest.mark.hardware

from libcpu.cpu_helper import CPUHelper

@pytest.mark.hardware
@pytest.mark.skipif(not full_exec_supported, reason=full_exec_reason)
def test_ldi_on_hw(cpu_helper: CPUHelper, asm_compiler: Compiler) -> None:

    ldi_test_prog = asm_compiler.compile(f"""
        ldi A, 123
    """)

    # reset A, to see if changed
    cpu_helper.regs.A = 0

    # run program on hardware
    cpu_helper.run_snippet(0x32, ldi_test_prog)

    # assert
    val = cpu_helper.regs.A
    assert val == 123

@pytest.mark.hardware
@pytest.mark.skipif(not full_exec_supported, reason=full_exec_reason)
def test_rjmp_on_hw(cpu_helper: CPUHelper, asm_compiler: Compiler) -> None:

    jmp_test_prog = asm_compiler.compile(f"""
        jmp next
        hlt
    next:
    """)

    cpu_helper.run_snippet(0x8, jmp_test_prog)

    # should point to next instruction after brk
    assert cpu_helper.regs.PC == 0x0C
