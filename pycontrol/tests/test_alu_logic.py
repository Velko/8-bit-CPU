#!/usr/bin/python3

import pytest # type: ignore

from libcpu.cpu_exec import CPUBackendControl
from libcpu.opcodes import permute_gp_regs_all, permute_gp_regs_nsame, gp_regs
from libcpu.devices import Register
from typing import Iterator, Tuple

pytestmark = pytest.mark.hardware

from libcpu.cpu import *

def and_test_args() -> Iterator[Tuple[str, int, int, int, str]]:
    yield "small", 230, 92, 68, "----"
    yield "zero", 0xa5, 0x5a, 0, "--Z-"

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
@pytest.mark.parametrize("desc,val_a,val_b,result,xflags", and_test_args())
def test_and(cpu_backend_real: CPUBackendControl, lhs: Register, rhs: Register, desc: str, val_a: int, val_b: int, result: int, xflags: str) -> None:
    ldi(lhs, val_a)
    ldi(rhs, val_b)

    andb(lhs, rhs)

    value = peek(lhs)
    flags = Flags.decode(cpu_backend_real.client.flags_get() & 0b0011) # we are only interested in Z and N flags
    assert value == result
    assert flags == xflags


def or_test_args() -> Iterator[Tuple[str, int, int, int, str]]:
    yield "small", 230, 92, 254, "---N"
    yield "full", 0xa5, 0x5a, 0xff, "---N"

@pytest.mark.parametrize("lhs,rhs", permute_gp_regs_nsame())
@pytest.mark.parametrize("desc,val_a,val_b,result,xflags", or_test_args())
def test_or(cpu_backend_real: CPUBackendControl, lhs: Register, rhs: Register, desc: str, val_a: int, val_b: int, result: int, xflags: str) -> None:
    ldi(lhs, val_a)
    ldi(rhs, val_b)

    orb(lhs, rhs)

    value = peek(lhs)
    flags = Flags.decode(cpu_backend_real.client.flags_get() & 0b0011)
    assert value == result
    assert flags == xflags
