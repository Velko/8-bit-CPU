#!/usr/bin/python3

import pytest

from libcpu.discovery import all_pins, all_muxes
from libcpu.pin import Pin, MuxPin

def mux_addr_lines():
    for name, mux in all_muxes():
        for num, pin in enumerate(mux.pins):
            yield "{}.A{}".format(name, num), pin

def simple_pins():
    for name, pin in all_pins():
        if isinstance(pin, Pin):
            yield name, pin.num

def each_simple_pin_and_addr_with_others():

    all = list(mux_addr_lines()) + list(simple_pins())

    for a_id, (a_name, a_num) in enumerate(all):
        for b_name, b_num in all[a_id+1:]:
            yield a_name, a_num, b_name, b_num


@pytest.mark.parametrize("name_a,pin_a,name_b,pin_b", each_simple_pin_and_addr_with_others())
def test_simple_pin_and_mux_addr_overlap(name_a, pin_a, name_b, pin_b):

    assert pin_a != pin_b


def pins_in_mux(mux):
    for name, pin in all_pins():
        if isinstance(pin, MuxPin):
            if pin.mux == mux:
                yield name, pin.num

    # also add default as assigned pin
    yield "default", mux.default

def each_pin_with_others_in_mux():

   for mux_name, mux in all_muxes():
        mpins = list(pins_in_mux(mux))

        for a_id, (a_name, a_num) in enumerate(mpins):
            for b_name, b_num in mpins[a_id+1:]:
                yield "{}.{}".format(mux_name, a_name), a_num, "{}.{}".format(mux_name, b_name), b_num

@pytest.mark.parametrize("name_a,pin_a,name_b,pin_b", each_pin_with_others_in_mux())
def test_mux_pin_overlap(name_a, pin_a, name_b, pin_b):

    if name_a == name_b:
        pytest.skip("comparing aliased pins")

    assert pin_a != pin_b
