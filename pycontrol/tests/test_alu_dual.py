#!/usr/bin/python3

import pytest # type: ignore

from libcpu.cpu import *
from libcpu.cpu_exec import CPUBackendControl

pytestmark = pytest.mark.hardware

hardwired_alu = False
hardwired_reason = "unsupported with hardwired ALU inputs"

@pytest.mark.skipif(hardwired_alu, reason=hardwired_reason)
def test_sub_b_a_small(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 3)
    ldi(B, 4)

    sub(B, A)

    value = peek(B)
    assert value == 1

@pytest.mark.skipif(hardwired_alu, reason=hardwired_reason)
def test_add_a_a(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 21)

    add(A, A)

    value = peek(A)
    assert value == 42

@pytest.mark.skipif(hardwired_alu, reason=hardwired_reason)
def test_add_b_b(cpu_backend_real: CPUBackendControl) -> None:
    ldi(B, 18)

    add(B, B)

    value = peek(B)
    assert value == 36

@pytest.mark.skipif(hardwired_alu, reason=hardwired_reason)
def test_sub_a_a(cpu_backend_real: CPUBackendControl) -> None:
    ldi(A, 32)

    sub(A, A)

    value = peek(A)
    assert value == 0

@pytest.mark.skipif(hardwired_alu, reason=hardwired_reason)
def test_sub_b_b(cpu_backend_real: CPUBackendControl) -> None:
    ldi(B, 63)

    sub(B, B)

    value = peek(B)
    assert value == 0
