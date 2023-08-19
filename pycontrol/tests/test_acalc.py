#!/usr/bin/python3

import pytest

from libcpu.cpu import *
from libcpu.test_helpers import CPUHelper
from libcpu.DeviceSetup import ACalc
from libcpu.ctrl_word import CtrlWord, DEFAULT_CW

from typing import Iterator, Tuple


def acalc_params() -> Iterator[Tuple[str, int, int, bool, int]]:
    yield "signed", 64737, 168, True, 64737 + 168 - 256
    yield "unsigned", 64737, 168, False, 64737 + 168


@pytest.mark.parametrize("name,addr,offset,signed,expected", acalc_params())
def test_acalc(cpu_helper: CPUHelper, name: str, addr: int, offset: int, signed: bool, expected: int) -> None:
    backend = cpu_helper.backend

    backend.client.bus_set(offset)
    backend.client.addr_set(addr)

    control = CtrlWord()\
        .enable(ACalc.load)

    if signed:
        control.enable(ACalc.signed)

    backend.client.ctrl_commit(control.c_word)
    backend.client.clock_tick()

    backend.client.off(DEFAULT_CW.c_word)

    readback = cpu_helper.read_reg16(ACalc)

    assert  expected == readback
