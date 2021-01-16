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

        self.disable_all()
        self.client.store_defaults()

    def disable_all(self):
        self.client.c_word = 0
        RegA.off()
        RegB.off()
        Flags.off()
        AddSub.off()


    def execute_opcode(self, opcode, value):
        microcode = opcodes[opcode]
        for pin in microcode:
            pin.enable()

        self.client.ctrl_commit()

        if "imm" in opcode:
            self.client.bus_set(value)

        self.client.clock_pulse()
        self.client.clock_inverted()

        result = None
        if "out" in opcode:
            result = int(self.client.bus_get())

        self.client.off()

        return result

    def op_ldi(self, target, value):
        opcode = "ldi_{}_imm".format(target.name)
        self.execute_opcode(opcode, value)


    def op_add(self, target, arg):
        opcode = "add_{}_{}".format(target.name, arg.name)
        self.execute_opcode(opcode, None)


    def op_sub(self, target, arg):
        opcode = "sub_{}_{}".format(target.name, arg.name)

        # only one subtraction instruction currently supported
        if opcode != "sub_A_B":
            raise InvalidOpcodeException

        self.execute_opcode(opcode, None)

    def op_out(self, source):
        opcode = "out_{}".format(source.name)
        return self.execute_opcode(opcode, None)


class InvalidOpcodeException(Exception):
    pass

opcodes = {
    "ldi_A_imm": [RegA.load],
    "ldi_B_imm": [RegB.load],
    "add_A_B": [RegA.load, AddSub.out, Flags.load],
    "add_B_A": [RegB.load, AddSub.out, Flags.load],
    "sub_A_B": [RegA.load, AddSub.out, AddSub.sub, Flags.load],
    "out_A": [RegA.out],
    "out_B": [RegB.out],
}