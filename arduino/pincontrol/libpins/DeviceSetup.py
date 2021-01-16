from .devices import *
from .pin import Pin, Level

RegA = Register("A", Pin(1, Level.LOW), Pin(0, Level.LOW))
RegB = Register("B", Pin(6, Level.LOW), Pin(2, Level.LOW))
AddSub = ALU("Add/Sub", Pin(3, Level.LOW), Pin(4, Level.HIGH))
Flags = Flags(Pin(7, Level.LOW), Pin(5, Level.HIGH), Pin(8, Level.LOW), Pin(9, Level.HIGH))
