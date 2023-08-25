#!/usr/bin/python3

import pytest

from libcpu.cpu_helper import CPUHelper
from libcpu.pinclient import PinClient
from libcpu.DeviceSetup import ACalc
from libcpu.ctrl_word import CtrlWord, DEFAULT_CW

from typing import Iterator, Tuple


def acalc_params() -> Iterator[Tuple[str, int, int, bool, int]]:
    yield "signed", 64737, 168, True, 64737 + 168 - 256
    yield "unsigned", 64737, 168, False, 64737 + 168


@pytest.mark.parametrize("_name,addr,offset,signed,expected", acalc_params())
def test_acalc(pins_client_real: PinClient, _name: str, addr: int, offset: int, signed: bool, expected: int) -> None:
    cpu_helper = CPUHelper(pins_client_real)

    pins_client_real.bus_set(offset)
    pins_client_real.addr_set(addr)

    control = CtrlWord()\
        .enable(ACalc.load)

    if signed:
        control.enable(ACalc.signed)

    pins_client_real.ctrl_commit(control.c_word)
    pins_client_real.clock_tick()

    pins_client_real.off(DEFAULT_CW.c_word)

    readback = cpu_helper.read_reg16(ACalc)

    assert  expected == readback
