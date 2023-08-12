#!/usr/bin/python3

import pytest

from libcpu.cpu import *
from libcpu.test_helpers import CPUHelper
from libcpu.DeviceSetup import ACalc

from typing import Iterator, Tuple


def acalc_params() -> Iterator[Tuple[str, int, int, bool, int]]:
    yield "signed", 64737, 168, True, 64737 + 168 - 256
    yield "unsigned", 64737, 168, False, 64737 + 168


@pytest.mark.parametrize("name,addr,offset,signed,expected", acalc_params())
def test_acalc(cpu_helper: CPUHelper, name: str, addr: int, offset: int, signed: bool, expected: int) -> None:
    backend = cpu_helper.backend

    backend.client.bus_set(offset)
    backend.client.addr_set(addr)

    if signed:
        ACalc.signed.enable(cpu_helper.backend.control)

    ACalc.load.enable(cpu_helper.backend.control)

    backend.client.ctrl_commit(backend.control.c_word)
    backend.client.clock_tick()

    backend.control.reset()
    backend.client.off(backend.control.default)

    readback = cpu_helper.read_reg16(ACalc)

    backend.control.reset()
    backend.client.off(backend.control.default)

    assert  expected == readback
