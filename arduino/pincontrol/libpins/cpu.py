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

        for microstep in microcode:
            for pin in microstep:
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

    def op_adc(self, target, arg):
        opcode = "adc_{}_{}".format(target.name, arg.name)
        self.execute_opcode(opcode)

    def op_sub(self, target, arg):
        opcode = "sub_{}_{}".format(target.name, arg.name)
        self.execute_opcode(opcode)

    def op_sbb(self, target, arg):
        opcode = "sbb_{}_{}".format(target.name, arg.name)
        self.execute_opcode(opcode)

    def op_cmp(self, target, arg):
        opcode = "cmp_{}_{}".format(target.name, arg.name)
        self.execute_opcode(opcode)

    def op_out(self, source):
        opcode = "out_{}".format(source.name)
        self.execute_opcode(opcode)

        print ("{}".format(OutPort.value), flush=True)

    def op_peek(self, source):
        opcode = "out_{}".format(source.name)
        self.execute_opcode(opcode)

        return OutPort.value

    def op_mov(self, target, source):
        opcode = "mov_{}_{}".format(target.name, source.name)
        self.execute_opcode(opcode)

    def op_st(self, addr, source):
        Imm.set(addr)
        opcode = "st_{}".format(source.name)
        self.execute_opcode(opcode)

    def op_stabs(self, addr_reg, source):
        opcode = "stabs_{}_{}".format(addr_reg.name, source.name)
        self.execute_opcode(opcode)

    def op_ldabs(self, target, addr_reg):
        opcode = "ldabs_{}_{}".format(target.name, addr_reg.name)
        self.execute_opcode(opcode)

    def op_tstabs(self, addr_reg):
        opcode = "tstabs_{}".format(addr_reg.name)
        self.execute_opcode(opcode)

    def op_ld(self, target, addr):
        Imm.set(addr)
        opcode = "ld_{}".format(target.name)
        self.execute_opcode(opcode)

    def op_bcs(self):
        # emulated version - returns true
        flags = self.client.flags_get()
        return (flags & Flags.C) != 0

    def op_bcc(self):
        # emulated version - returns true
        flags = self.client.flags_get()
        return (flags & Flags.C) == 0

    def op_beq(self):
        # emulated version - returns true
        flags = self.client.flags_get()
        return (flags & Flags.Z) != 0

    def op_bne(self):
        # emulated version - returns true
        flags = self.client.flags_get()
        return (flags & Flags.Z) == 0


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
            self.value = self.client.bus_get()
            self.active = False


Imm = ImmediateValue()
OutPort = ResultValue()


def mkuc_list(registers, nameformat, pinformatter):
    ops = list()

    for r in registers:
        name = nameformat.format(r.name)
        ucode = pinformatter(r)
        ops.append((name, ucode))
    return ops


def mkuc_permute_all(registers, nameformat, pinformatter):
    ops = list()

    for l in registers:
        for r in registers:
            name = nameformat.format(l.name, r.name)
            ucode = pinformatter(l, r)
            ops.append((name, ucode))
    return ops

def mkuc_permute_nsame(registers, nameformat, pinformatter):
    ops = list()

    for l in registers:
        for r in registers:
            if l == r: continue
            name = nameformat.format(l.name, r.name)
            ucode = pinformatter(l, r)
            ops.append((name, ucode))
    return ops

gp_regs = [RegA, RegB]


opcodes = dict(
    [("nop", [])]+

    mkuc_list(gp_regs, "ldi_{}_imm", lambda r: [[r.load, Imm.out]]) +

    [("ldi_F_imm", [[Flags.load, Flags.bus_in, Imm.out]])] +

    mkuc_permute_all(gp_regs, "add_{}_{}", lambda l, r: [[l.load, l.alu_a, r.alu_b, AddSub.out, Flags.load]]) +
    mkuc_permute_all(gp_regs, "adc_{}_{}", lambda l, r: [[l.load, l.alu_a, r.alu_b, AddSub.out, Flags.load, Flags.use_carry]]) +
    mkuc_permute_nsame(gp_regs, "sub_{}_{}", lambda l, r: [[l.load, l.alu_a, r.alu_b, AddSub.out, AddSub.sub, Flags.load]]) +
    mkuc_permute_nsame(gp_regs, "sbb_{}_{}", lambda l, r: [[l.load, l.alu_a, r.alu_b, AddSub.out, AddSub.sub, Flags.load, Flags.use_carry]]) +

    mkuc_permute_nsame(gp_regs, "cmp_{}_{}", lambda l, r: [[l.alu_a, r.alu_b, AddSub.out, AddSub.sub, Flags.load]]) +

    [("sbb_A_B", [[RegA.load, RegA.alu_a, RegB.alu_b, AddSub.out, AddSub.sub, Flags.load, Flags.use_carry]])] +

    mkuc_permute_nsame(gp_regs, "mov_{}_{}", lambda l, r: [[l.load, r.out]]) +
    mkuc_list(gp_regs, "out_{}", lambda r: [[r.out, OutPort.load]]) +

    mkuc_list(gp_regs, "st_{}", lambda r: [[Imm.out, Mar.load], [r.out, Ram.write]]) +
    mkuc_permute_all(gp_regs, "stabs_{}_{}", lambda a, v: [[a.out, Mar.load], [v.out, Ram.write]]) +
    mkuc_list(gp_regs, "ld_{}", lambda r: [[Imm.out, Mar.load], [Ram.out, r.load, Flags.load]]) +
    mkuc_permute_all(gp_regs, "ldabs_{}_{}", lambda v, a: [[a.out, Mar.load], [v.load, Ram.out, Flags.load]]) +

    mkuc_list(gp_regs, "tstabs_{}", lambda r: [[r.out, Mar.load], [Ram.out, Flags.load]]) +


    [("out_F", [[Flags.bus_out, OutPort.load]]),]
)
