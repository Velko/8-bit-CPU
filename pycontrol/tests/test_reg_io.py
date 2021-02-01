#!/usr/bin/python3

import pytest

from libcpu.cpu import *

def all_regs_and_bits():
    regs = [A, B]
    bits = range(8)

    for r in regs:
        yield r, 255
        for b in bits:
            yield r, 1 << b
        yield r, 0

@pytest.mark.parametrize("register,value", all_regs_and_bits())
def test_load_store_reg(cpu_backend_real, register, value):
    ldi (register, value)
    received = peek(register)

    assert value == received

@pytest.mark.parametrize("value", [0xF, 1, 2, 4, 8, 0])
def test_load_store_flags(cpu_backend_real, value):
    ldi (F, value)
    received = peek(F)

    assert value == received

