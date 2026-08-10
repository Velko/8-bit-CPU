#!/usr/bin/python3

import pytest
from conftest import Compiler, full_exec_supported, full_exec_reason

pytestmark = pytest.mark.hardware

from libcpu.cpu_helper import CPUHelper

# The UART had a bug, when 0xFF byte was sent, it resulted in status of no input available.
# Such a case would hang the program
@pytest.mark.skipif(not full_exec_supported, reason=full_exec_reason)
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


# A bug in UART module caused IO Bus contention by LCD_STATUS and UART_DATA
@pytest.mark.skipif(not full_exec_supported, reason=full_exec_reason)
def test_lcd_status_and_uart_data_read(cpu_helper: CPUHelper, asm_compiler: Compiler) -> None:
    # LCD_STATUS and UART_DATA has different major device, but same sub-address. Checking that
    # only the desired major device is selected.
    prog = asm_compiler.compile("""
        ldi C, 0x01             ; clear display command
        out DISPLAY_LCD_CMD, C  ; send command to LCD, to ensure it is busy
        in A, DISPLAY_LCD_CMD
        in B, UART_DATA
    """)

    cpu_helper.run_snippet(0x32, prog)

    lcd_status = cpu_helper.regs.A
    uart_data = cpu_helper.regs.B

    assert lcd_status == 0x80  # LCD is ready
    assert uart_data == 0xFF  # no input available (technically have to check UART_STATUS to distinguish from actual 0xFF input)
