import pytest

from libcpu.cpu_helper import CPUHelper
from libcpu.assisted_cpu import AssistedCPU
from libcpu.devmap import A, B
from libcpu.messages import OutMessage

from conftest import Compiler

def test_outa_emu_char(cpu_helper: CPUHelper, acpu: AssistedCPU) -> None:
    cpu_helper.regs.A = 120

    message = acpu.out(4, A)

    assert isinstance(message, OutMessage)
    assert message.payload == 'x'

outb_args = [
    ("unsigned small", 0, 110, " 110\n"),
    ("unsigned large", 0, 245, " 245\n"),
    ("signed positive", 1, 40, "  40\n"),
    ("signed negative", 1, 140, "-116\n"),
    ("hex", 2, 233, "h e9\n"),
    ("oct", 3, 89, "o131\n"),
]

@pytest.mark.parametrize("_desc,mode,val,expected", outb_args)
def test_outa_emu_num(cpu_helper: CPUHelper, acpu: AssistedCPU, _desc: str, mode: int, val: int, expected: str) -> None:
    cpu_helper.regs.B = mode
    acpu.out(1, B)

    cpu_helper.regs.A = val
    message = acpu.out(0, A)

    assert isinstance(message, OutMessage)
    assert message.target == 0
    assert message.payload == expected

@pytest.mark.emulator
@pytest.mark.parametrize("_desc,mode,val,expected", outb_args)
def test_outb_int_hw(cpu_helper: CPUHelper, _desc: str, mode: int, val: int, expected: str, asm_compiler: Compiler) -> None:

    cpu_helper.regs.D = mode
    cpu_helper.regs.B = val

    out_test_prog = asm_compiler.compile(f"""
        out 1, D
        out 0, B
    """)

    # run program on hardware
    res = cpu_helper.run_snippet(0x14, out_test_prog)

    # assert
    assert res == expected

@pytest.mark.emulator
def test_outc_char_hw(cpu_helper: CPUHelper, asm_compiler: Compiler) -> None:

    cpu_helper.regs.C = 102

    out_test_prog = asm_compiler.compile(f"""
        out 4, C
    """)

    # run program on hardware
    val = cpu_helper.run_snippet(0x33, out_test_prog)

    # assert
    assert val == 'f'

@pytest.mark.emulator
def test_outc_newline_hw(cpu_helper: CPUHelper, asm_compiler: Compiler) -> None:

    cpu_helper.regs.C = 10

    out_test_prog = asm_compiler.compile(f"""
        out 4, C
    """)

    # run program on hardware
    val = cpu_helper.run_snippet(0x33, out_test_prog)

    # assert
    assert val == '\n'
