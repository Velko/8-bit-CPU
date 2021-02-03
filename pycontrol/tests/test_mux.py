#!/usr/bin/python3

import pytest


from libcpu.pin import Mux, MuxPin
from libcpu.ctrl_word import CtrlWord

@pytest.fixture

def mux_fixture():
    return MuxFixture()

class MuxFixture:
    def __init__(self):
        self.mux = Mux([6, 9, 2], 5)
        self.pin = MuxPin(self.mux, 3)
        self.control = CtrlWord([(None, self.pin)])


def test_mux_manual(mux_fixture):

    assert mux_fixture.control.c_word == 0b1000100


def test_mux_init_default(mux_fixture):

    assert mux_fixture.control.c_word == mux_fixture.control.default


def test_mux_pin_set_bits(mux_fixture):

    mux_fixture.pin.enable()

    assert mux_fixture.control.c_word == 0b1001000000

def test_mux_pin_current(mux_fixture):

    mux_fixture.pin.enable()

    assert mux_fixture.mux.current() == mux_fixture.pin.num

