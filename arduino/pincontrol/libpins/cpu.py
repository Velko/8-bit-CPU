from .DeviceSetup import *
from .cpu_exec import CPUBackendControl


backend = None

def setup(client, control):
    global backend
    backend = CPUBackendControl(client, control)

A = RegA
B = RegB
F = Flags

def ldi(target, value):
    opcode = "ldi_{}_imm".format(target.name)
    backend.execute_opcode(opcode, value)

def add(target, arg):
    opcode = "add_{}_{}".format(target.name, arg.name)
    backend.execute_opcode(opcode)

def adc(target, arg):
    opcode = "adc_{}_{}".format(target.name, arg.name)
    backend.execute_opcode(opcode)

def sub(target, arg):
    opcode = "sub_{}_{}".format(target.name, arg.name)
    backend.execute_opcode(opcode)

def sbb(target, arg):
    opcode = "sbb_{}_{}".format(target.name, arg.name)
    backend.execute_opcode(opcode)

def cmp(target, arg):
    opcode = "cmp_{}_{}".format(target.name, arg.name)
    backend.execute_opcode(opcode)

def out(source):
    opcode = "out_{}".format(source.name)
    _, out_val = backend.execute_opcode(opcode)

    print ("{}".format(out_val), flush=True)

def peek(source):
    opcode = "out_{}".format(source.name)
    _, out_val = backend.execute_opcode(opcode)

    return out_val

def mov(target, source):
    opcode = "mov_{}_{}".format(target.name, source.name)
    backend.execute_opcode(opcode)

def st(addr, source):
    opcode = "st_addr_{}".format(source.name)
    backend.execute_opcode(opcode, addr)

def stabs(addr_reg, source):
    opcode = "stabs_{}_{}".format(addr_reg.name, source.name)
    backend.execute_opcode(opcode)

def ldabs(target, addr_reg):
    opcode = "ldabs_{}_{}".format(target.name, addr_reg.name)
    backend.execute_opcode(opcode)

def tstabs(addr_reg):
    opcode = "tstabs_{}".format(addr_reg.name)
    backend.execute_opcode(opcode)

def ld(target, addr):
    opcode = "ld_{}_addr".format(target.name)
    backend.execute_opcode(opcode, addr)

def bcs(label=None):
    taken, _ = backend.execute_opcode("bcs_addr", label)
    return taken

def bcc(label=None):
    taken, _ = backend.execute_opcode("bcc_addr", label)
    return taken

def beq(label=None):
    taken, _ = backend.execute_opcode("beq_addr", label)
    return taken

def bne(label=None):
    taken, _ = backend.execute_opcode("bne_addr", label)
    return taken

def jmp(label=None):
    taken, _ = backend.execute_opcode("jmp_addr", label)
    return taken

def hlt():
    backend.execute_opcode("hlt")
