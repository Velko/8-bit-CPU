from .devices import *
from .pin import Pin, NullPin, Level

RegA = Register("A",
    out = Pin(1, Level.LOW),
    load = Pin(0, Level.LOW),
    alu_a = NullPin(10, Level.LOW),
    alu_b = NullPin(11, Level.LOW))

RegB = Register("B",
    out = Pin(6, Level.LOW),
    load = Pin(2, Level.LOW),
    alu_a = NullPin(12, Level.LOW),
    alu_b = NullPin(13, Level.LOW))

AddSub = ALU("AddSub",
    out = Pin(3, Level.LOW),
    sub = Pin(4, Level.HIGH))

Flags = Flags("F",
    load = Pin(7, Level.LOW),
    use_carry = Pin(5, Level.HIGH),
    bus_out = Pin(8, Level.LOW),
    bus_in = Pin(9, Level.HIGH))


def all_pins():
    return RegA.all_pins() + RegB.all_pins() + AddSub.all_pins() + Flags.all_pins()
