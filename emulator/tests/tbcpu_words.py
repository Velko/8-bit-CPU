#!/usr/bin/python3

# A script to generate control word values for tb_cpu testbench.
# Useful if control bits are re-arranged.

import localpath
from libcpu.ctrl_word import CtrlWord
from libcpu.DeviceSetup import RegA, RegB, AddSub, Ram

control = CtrlWord()

print("Clear, reset")
control.reset()
print(f"32'b{control.c_word:032b}")

print ("Load A")
RegA.load.enable()
print(f"32'b{control.c_word:032b}")

print ("Load B")
control.reset()
RegB.load.enable()
print(f"32'b{control.c_word:032b}")

print ("Add A to B")
control.reset()
RegA.load.enable()
RegA.alu_l.enable()
RegB.alu_r.enable()
AddSub.out.enable()
print(f"32'b{control.c_word:032b}")

print ("Output A to Bus")
control.reset()
RegA.out.enable()
print(f"32'b{control.c_word:032b}")

print ("Write something in RAM")
control.reset()
Ram.write.enable()
print(f"32'b{control.c_word:032b}")

print ("Read from different addr")
control.reset()
Ram.out.enable()
print(f"32'b{control.c_word:032b}")