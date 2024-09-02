#!/usr/bin/python3

import pytest

from libcpu.discovery import simple_pins, all_muxes, mux_pins
from libcpu.pin import Mux
from collections.abc import Iterator

def simple_pin_nums() -> Iterator[tuple[str, int]]:
    for name, pin in simple_pins():
        yield name, pin.num

def mux_addr_lines() -> Iterator[tuple[str, int]]:
    for name, mux in all_muxes():
        for num, pin in enumerate(mux.pins):
            yield f"{name}.A{num}", pin

def each_simple_pin_and_addr_with_others() -> Iterator[tuple[str, int, str, int]]:

    all_pins = list(mux_addr_lines()) + list(simple_pin_nums())

    for a_id, (a_name, a_num) in enumerate(all_pins):
        for b_name, b_num in all_pins[a_id+1:]:
            yield a_name, a_num, b_name, b_num


@pytest.mark.parametrize("_name_a,pin_a,_name_b,pin_b", each_simple_pin_and_addr_with_others())
def test_simple_pin_and_mux_addr_overlap(_name_a: str, pin_a: int, _name_b: str, pin_b: int) -> None:

    assert pin_a != pin_b


def pins_in_mux(mux: Mux, include_default: bool) -> Iterator[tuple[str, int]]:
    for name, pin in mux_pins(mux):
        yield name, pin.num

    # also add default as assigned pin
    if include_default:
        yield "default", mux.default

def each_pin_with_others_in_mux() -> Iterator[tuple[str, int, str, int]]:

    for mux_name, mux in all_muxes():
        mpins = list(pins_in_mux(mux, True))

        for a_id, (a_name, a_num) in enumerate(mpins):
            for b_name, b_num in mpins[a_id+1:]:
                yield f"{mux_name}.{a_name}", a_num, f"{mux_name}.{b_name}", b_num

@pytest.mark.parametrize("_name_a,pin_a,_name_b,pin_b", each_pin_with_others_in_mux())
def test_mux_pin_overlap(_name_a: str, pin_a: int, _name_b: str, pin_b: int) -> None:

    assert pin_a != pin_b


def each_pin_with_capacity_in_mux() -> Iterator[tuple[str, int, int]]:
    for mux_name, mux in all_muxes():
        mpins = list(pins_in_mux(mux, False))
        capacity = 2**len(mux.pins)
        for p_name, p_num in mpins:
            yield f"{mux_name}.{p_name}", p_num, capacity


@pytest.mark.parametrize("_name,pin,capacity", each_pin_with_capacity_in_mux())
def test_mux_capacity(_name: str, pin: int, capacity: int) -> None:

    assert pin < capacity
