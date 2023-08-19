from typing import Iterator, Tuple
from .pin import PinBase, Pin, MuxPin, Mux
from . import DeviceSetup

def all_pins() -> Iterator[Tuple[str, PinBase]]:
    dupe_filter = set()
    for var in vars(DeviceSetup).values():
        if not hasattr(var, "__dict__"): continue
        for a_name, attr in vars(var).items():
            if (not a_name.startswith("_")) and (isinstance(attr, Pin) or isinstance(attr, MuxPin)) and attr not in dupe_filter:
                dupe_filter.add(attr)
                yield "{}.{}".format(var.name, a_name), attr

def simple_pins() -> Iterator[Tuple[str, Pin]]:
    for name, pin in all_pins():
        if isinstance(pin, Pin):
            yield name, pin

def all_muxes() -> Iterator[Tuple[str, Mux]]:
    for v_name, var in vars(DeviceSetup).items():
        if isinstance(var, Mux):
            yield v_name, var

def mux_pins(mux: Mux) -> Iterator[Tuple[str, MuxPin]]:
    for name, pin in all_pins():
        if isinstance(pin, MuxPin) and pin.mux == mux:
            yield name, pin