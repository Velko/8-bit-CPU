#!/usr/bin/python3

import pytest

from libcpu.cpu import *
from libcpu.cpu_helper import CPUHelper
from libcpu.cpu_exec import CPUBackendControl
from libcpu.DeviceSetup import ACalc
from libcpu.ctrl_word import CtrlWord, DEFAULT_CW

from typing import Iterator, Tuple


def acalc_params() -> Iterator[Tuple[str, int, int, bool, int]]:
    yield "signed", 64737, 168, True, 64737 + 168 - 256
    yield "unsigned", 64737, 168, False, 64737 + 168


@pytest.mark.parametrize("name,addr,offset,signed,expected", acalc_params())
def test_acalc(cpu_backend_real: CPUBackendControl, name: str, addr: int, offset: int, signed: bool, expected: int) -> None:
    cpu_helper = CPUHelper(cpu_backend_real.client)

    cpu_backend_real.client.bus_set(offset)
    cpu_backend_real.client.addr_set(addr)

    control = CtrlWord()\
        .enable(ACalc.load)

    if signed:
        control.enable(ACalc.signed)

    cpu_backend_real.client.ctrl_commit(control.c_word)
    cpu_backend_real.client.clock_tick()

    cpu_backend_real.client.off(DEFAULT_CW.c_word)

    readback = cpu_helper.read_reg16(ACalc)

    assert  expected == readback
