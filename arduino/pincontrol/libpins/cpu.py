from .DeviceSetup import *

class CPU:
    def __init__(self, pins):
        self.pins = pins

        self.reg_A = RegA
        self.reg_B = RegB
        self.reg_F = Flags
        self.alu = AddSub

        self.connect()
        self.disable_all()
        self.pins.store_defaults()

    def connect(self):
        self.reg_A.connect(self.pins)
        self.reg_B.connect(self.pins)
        self.reg_F.connect(self.pins)
        self.alu.connect(self.pins)

    def disable_all(self):
        self.pins.c_word = 0
        self.reg_A.off()
        self.reg_B.off()
        self.reg_F.off()
        self.alu.off()

    def execute_opcode(self, opcode, value):
        microcode = opcodes[opcode]
        for pin in microcode:
            pin.enable()

        self.pins.ctrl_commit()

        if "imm" in opcode:
            self.pins.bus_set(value)

        self.pins.clock_pulse()
        self.pins.clock_inverted()

        result = None
        if "out" in opcode:
            result = int(self.pins.bus_get())

        self.pins.off()

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
    "ldi_A_imm": [RegA.pin_load],
    "ldi_B_imm": [RegB.pin_load],
    "add_A_B": [RegA.pin_load, AddSub.pin_out, Flags.pin_load],
    "add_B_A": [RegB.pin_load, AddSub.pin_out, Flags.pin_load],
    "sub_A_B": [RegA.pin_load, AddSub.pin_out, AddSub.pin_sub, Flags.pin_load],
    "out_A": [RegA.pin_out],
    "out_B": [RegB.pin_out],
}