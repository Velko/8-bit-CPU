import sys
from .pin import Pin, MuxPin
from . import DeviceSetup

def all_pins():
    for v_name, var in vars(DeviceSetup).items():
        if not hasattr(var, "__dict__"): continue
        for a_name, attr in vars(var).items():
            if isinstance(attr, Pin) or isinstance(attr, MuxPin):
                yield "{}.{}".format(var.name, a_name), attr
