from .devices import *

RegA = Register("A", 1, 0)
RegB = Register("B", 6, 2)
AddSub = ALU("Add/Sub", 3, 4)
Flags = Flags(7, 5)
