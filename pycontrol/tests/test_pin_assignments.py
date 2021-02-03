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
