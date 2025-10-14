#!/usr/bin/python3

import pytest

from libcpu.cpu_helper import CPUHelper
from libcpu.pinclient import PinClient
from libcpu.devmap import ACalc
from libcpu.ctrl_word import CtrlWord
from libcpu.DeviceSetup import hardware as hw
from libcpu.util import unwrap

from collections.abc import Iterator

acalc_params = [
    ("signed", 64737, 168, True, 64737 + 168 - 256),
    ("unsigned", 64737, 168, False, 64737 + 168),
]


@pytest.mark.parametrize("_name,addr,offset,signed,expected", acalc_params)
def test_acalc(pins_client_real: PinClient, _name: str, addr: int, offset: int, signed: bool, expected: int) -> None:
    cpu_helper = CPUHelper(pins_client_real)

    pins_client_real.bus_set(offset)
    pins_client_real.addr_set(addr)

    control = CtrlWord()\
        .enable(ACalc.load)

    if signed:
        control.enable(ACalc.signed)

    pins_client_real.ctrl_commit(control)
    pins_client_real.clock_tick()

    pins_client_real.off(hw.DEFAULT_CW)

    assert  expected == cpu_helper.regs.ACalc
