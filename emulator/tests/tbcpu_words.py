#!/usr/bin/python3

# A script to generate control word values for tb_cpu testbench.
# Useful if control bits are re-arranged.

from libcpu.ctrl_word import CtrlWord
from libcpu.DeviceSetup import hardware as hw


control = CtrlWord()

print("Clear, reset")
print(f"32'b{control.c_word:032b}")

print ("Load A")
control.enable(hw.A.load)
print(f"32'b{control.c_word:032b}")

print ("Load B")
control = CtrlWord()
control.enable(hw.B.load)
print(f"32'b{control.c_word:032b}")

print ("Add A to B")
control = CtrlWord()
control.enable(hw.A.load)
control.enable(hw.A.alu_l)
control.enable(hw.B.alu_r)
control.enable(hw.AddSub.out)
print(f"32'b{control.c_word:032b}")

print ("Output A to Bus")
control = CtrlWord()
control.enable(hw.A.out)
print(f"32'b{control.c_word:032b}")

print ("Write something in RAM")
control = CtrlWord()
control.enable(hw.RAM.write)
print(f"32'b{control.c_word:032b}")

print ("Read from different addr")
control = CtrlWord()
control.enable(hw.RAM.out)
print(f"32'b{control.c_word:032b}")

print ("XOR A, A")
control = CtrlWord()
control.enable(hw.A.load)
control.enable(hw.A.alu_l)
control.enable(hw.A.alu_r)
control.enable(hw.XorNot.out)
control.enable(hw.F.calc)
print(f"32'b{control.c_word:032b}")

print ("Put F on bus")
control = CtrlWord()
control.enable(hw.F.out)
print(f"32'b{control.c_word:032b}")