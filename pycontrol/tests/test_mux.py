#!/usr/bin/python3

import pytest


from libcpu.pin import Mux, MuxPin, PinUsage
from libcpu.ctrl_word import CtrlWord



class MuxFixture:
    def __init__(self) -> None:
        self.mux = Mux("TestMux", [6, 9, 2], 5)
        self.pin = MuxPin(self.mux, 3, PinUsage.EXCLUSIVE)
        self.control = CtrlWord([("", self.pin)])

@pytest.fixture
def mux_fixture() -> MuxFixture:
    return MuxFixture()

def test_mux_manual(mux_fixture: MuxFixture) -> None:

    assert mux_fixture.control.c_word == 0b1000100


def test_mux_pin_set_bits(mux_fixture: MuxFixture) -> None:

    mux_fixture.control.enable(mux_fixture.pin)

    assert mux_fixture.control.c_word == 0b1001000000

def test_mux_pin_current(mux_fixture: MuxFixture) -> None:

    mux_fixture.control.enable(mux_fixture.pin)

    assert mux_fixture.mux.current(mux_fixture.control.c_word) == mux_fixture.pin.num
