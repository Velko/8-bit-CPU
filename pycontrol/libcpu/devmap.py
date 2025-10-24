from .DeviceSetup import hardware as hw
from . import devices as dev
from .pseudo_devices import RamProxy

A = hw.get_typed_dev("A", dev.GPRegister)
B = hw.get_typed_dev("B", dev.GPRegister)
C = hw.get_typed_dev("C", dev.GPRegister)
D = hw.get_typed_dev("D", dev.GPRegister)

AddSub = hw.get_typed_dev("AddSub", dev.ALU)
F = hw.get_typed_dev("F", dev.FlagsRegister)
RAM = hw.get_typed_dev("Ram", dev.RAM)
ProgMem = hw.get_typed_dev("ProgMem", dev.ROM)
IR = hw.get_typed_dev("IR", dev.WORegister)
Clock = hw.get_typed_dev("Clock", dev.Clock)
StepCounter = hw.get_typed_dev("StepCounter", dev.StepCounter)
PC = hw.get_typed_dev("PC", dev.ProgramCounter)
SP = hw.get_typed_dev("SP", dev.StackPointer)
SDP = hw.get_typed_dev("SDP", dev.StackPointer)
TDP = hw.get_typed_dev("TDP", dev.StackPointer)
TX = hw.get_typed_dev("TX", dev.TransferRegister)
TL = hw.get_typed_dev("TL", dev.TransferRegister)
TH = hw.get_typed_dev("TH", dev.TransferRegister)
LR = hw.get_typed_dev("LR", dev.AddressRegister)
ACalc = hw.get_typed_dev("ACalc", dev.AddressCalculator)
IOCtl = hw.get_typed_dev("IOCtl", dev.IOController)
