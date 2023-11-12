from typing import Iterator, Tuple
from .pin import Pin, SimplePin, MuxPin, Mux, SharedSimplePin
from .devices import DeviceBase
from . import DeviceSetup

def _all_devices() -> Iterator[DeviceBase]:
    return filter(lambda x: isinstance(x, DeviceBase), vars(DeviceSetup).values())

def all_pins() -> Iterator[Tuple[str, Pin]]:
    dupe_filter = set()
    for dev in _all_devices():
        pin_attrs = filter(lambda x: isinstance(x[1], Pin), vars(dev).items())
        for a_name, attr in pin_attrs:
            if attr not in dupe_filter:
                dupe_filter.add(attr)
                if isinstance(attr, SharedSimplePin):
                    yield f"{attr.name}", attr
                elif isinstance(attr, (SimplePin, MuxPin)):
                    yield f"{dev.name}.{a_name}", attr

def simple_pins() -> Iterator[Tuple[str, SimplePin]]:
    for name, pin in all_pins():
        if isinstance(pin, SimplePin):
            yield name, pin

def all_muxes() -> Iterator[Tuple[str, Mux]]:
    for v_name, var in vars(DeviceSetup).items():
        if isinstance(var, Mux):
            yield v_name, var

def mux_pins(mux: Mux) -> Iterator[Tuple[str, MuxPin]]:
    for name, pin in all_pins():
        if isinstance(pin, MuxPin) and pin.mux == mux:
            yield name, pin
