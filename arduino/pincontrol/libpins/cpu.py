from .DeviceSetup import *

class CPU:
    def __init__(self):
        self.client = None

        self.reg_A = RegA
        self.reg_B = RegB
        self.reg_F = Flags
        self.alu = AddSub


    def connect(self, client):
        self.client = client

        RegA.connect(self.client)
        RegB.connect(self.client)
        Flags.connect(self.client)
        AddSub.connect(self.client)
        Imm.connect(self.client)
        OutPort.connect(self.client)

        self.disable_all()
        self.client.store_defaults()

    def disable_all(self):
        self.client.c_word = 0
        RegA.off()
        RegB.off()
        Flags.off()
        AddSub.off()


    def execute_opcode(self, opcode, value):
        if not opcode in opcodes:
            raise InvalidOpcodeException(opcode)

        microcode = opcodes[opcode]
        for pin in microcode:
            pin.enable()

        self.client.ctrl_commit()


        self.client.clock_pulse()
        self.client.clock_inverted()

        OutPort.read_bus()

        self.client.off()

    def op_ldi(self, target, value):
        opcode = "ldi_{}_imm".format(target.name)
        Imm.set(value)
        self.execute_opcode(opcode, value)


    def op_add(self, target, arg):
        opcode = "add_{}_{}".format(target.name, arg.name)
        self.execute_opcode(opcode, None)


    def op_sub(self, target, arg):
        opcode = "sub_{}_{}".format(target.name, arg.name)

        self.execute_opcode(opcode, None)

    def op_out(self, source):
        opcode = "out_{}".format(source.name)
        self.execute_opcode(opcode, None)

        return OutPort.value


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
    "add_A_A": [RegA.load, RegA.alu_a, RegA.alu_b, AddSub.out, Flags.load],
    "add_A_B": [RegA.load, RegA.alu_a, RegB.alu_b, AddSub.out, Flags.load],
    "add_B_A": [RegB.load, RegB.alu_a, RegA.alu_b, AddSub.out, Flags.load],
    "add_B_B": [RegB.load, RegB.alu_a, RegB.alu_b, AddSub.out, Flags.load],
    "sub_A_A": [RegA.load, RegA.alu_a, RegA.alu_b, AddSub.out, AddSub.sub, Flags.load],
    "sub_A_B": [RegA.load, RegA.alu_a, RegB.alu_b, AddSub.out, AddSub.sub, Flags.load],
    "sub_B_A": [RegB.load, RegB.alu_a, RegA.alu_b, AddSub.out, AddSub.sub, Flags.load],
    "sub_B_B": [RegB.load, RegB.alu_a, RegB.alu_b, AddSub.out, AddSub.sub, Flags.load],
    "out_A": [RegA.out, OutPort.load],
    "out_B": [RegB.out, OutPort.load],
}