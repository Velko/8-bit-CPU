#!/usr/bin/python3

import pytest
from conftest import Compiler

pytestmark = pytest.mark.hardware

from libcpu.cpu_helper import CPUHelper

# The UART had a bug, when 0xFF byte was sent, it resulted in status of no input available.
# Such a case would hang the program
@pytest.mark.parametrize("value", [0x00, 0x44, 0xFF])
def test_uart_input(cpu_helper: CPUHelper, asm_compiler: Compiler, value: int) -> None:

    uart_input_prog = asm_compiler.compile(f"""
        wait:
            in B, UART_STATUS
            beq wait
            in A, UART_DATA
    """)

    # set A, to see if changed
    cpu_helper.regs.A = 0x10

    # run program on hardware
    cpu_helper.run_snippet(0x32, uart_input_prog, input=bytes([value]))

    # assert
    val = cpu_helper.regs.A
    assert val == value
