from .DeviceSetup import *

class CPU:
    def __init__(self, client, control):
        self.client = client
        self.control = control

        self.reg_A = RegA
        self.reg_B = RegB
        self.reg_F = Flags
        self.alu = AddSub

        Imm.connect(self.client)
        OutPort.connect(self.client)

    def execute_opcode(self, opcode):
        if not opcode in opcodes:
            raise InvalidOpcodeException(opcode)

        microcode = opcodes[opcode]
        for pin in microcode:
            pin.enable()

        self.client.ctrl_commit(self.control.c_word)


        self.client.clock_pulse()
        self.client.clock_inverted()

        OutPort.read_bus()

        self.control.reset()
        self.client.off(self.control.default)

    def op_ldi(self, target, value):
        opcode = "ldi_{}_imm".format(target.name)
        Imm.set(value)
        self.execute_opcode(opcode)


    def op_add(self, target, arg):
        opcode = "add_{}_{}".format(target.name, arg.name)
        self.execute_opcode(opcode)


    def op_sub(self, target, arg):
        opcode = "sub_{}_{}".format(target.name, arg.name)

        self.execute_opcode(opcode)

    def op_out(self, source):
        opcode = "out_{}".format(source.name)
        self.execute_opcode(opcode)

        return OutPort.value

    def op_mov(self, target, source):
        opcode = "mov_{}_{}".format(target.name, source.name)
        self.execute_opcode(opcode)

class InvalidOpcodeException(Exception):
    pass

class ImmediateValue:
    def __init__(self):
        self.client = None
        self.value = None
        self.out = self

    def connect(self, client):
        self.client = client

    def set(self, value):
        self.value = value

    def enable(self):
        self.client.bus_set(self.value)

class ResultValue:
    def __init__(self):
        self.client = None
        self.value = None
        self.active = False
        self.load = self

    def connect(self, client):
        self.client = client

    def enable(self):
        self.active = True

    def read_bus(self):
        if self.active:
            self.value = int(self.client.bus_get())
            self.active = False


Imm = ImmediateValue()
OutPort = ResultValue()

opcodes = {
    "ldi_A_imm": [RegA.load, Imm.out],
    "ldi_B_imm": [RegB.load, Imm.out],
    "ldi_F_imm": [Flags.load, Flags.bus_in, Imm.out],
    "add_A_A": [RegA.load, RegA.alu_a, RegA.alu_b, AddSub.out, Flags.load],
    "add_A_B": [RegA.load, RegA.alu_a, RegB.alu_b, AddSub.out, Flags.load],
    "add_B_A": [RegB.load, RegB.alu_a, RegA.alu_b, AddSub.out, Flags.load],
    "add_B_B": [RegB.load, RegB.alu_a, RegB.alu_b, AddSub.out, Flags.load],
    "sub_A_A": [RegA.load, RegA.alu_a, RegA.alu_b, AddSub.out, AddSub.sub, Flags.load],
    "sub_A_B": [RegA.load, RegA.alu_a, RegB.alu_b, AddSub.out, AddSub.sub, Flags.load],
    "sub_B_A": [RegB.load, RegB.alu_a, RegA.alu_b, AddSub.out, AddSub.sub, Flags.load],
    "sub_B_B": [RegB.load, RegB.alu_a, RegB.alu_b, AddSub.out, AddSub.sub, Flags.load],
    "mov_A_B": [RegA.load, RegB.out],
    "mov_B_A": [RegB.load, RegA.out],
    "out_A": [RegA.out, OutPort.load],
    "out_B": [RegB.out, OutPort.load],
    "out_F": [Flags.bus_out, OutPort.load],
}
