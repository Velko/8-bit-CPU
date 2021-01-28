from .DeviceSetup import *
from .markers import Bytes

class CPUBackendControl:
    def __init__(self, client, control):
        self.client = client
        self.control = control

        Imm.connect(self.client)
        OutPort.connect(self.client)
        PC.connect(self.client)

    def execute_opcode(self, opcode, arg=None):
        if not opcode in opcodes:
            raise InvalidOpcodeException(opcode)

        Imm.set(arg)

        # fetch is emulated, it always advances PC by one
        PC.advance()

        microcode = opcodes[opcode]

        flags = None

        if microcode.is_flag_dependent():
            flags = self.client.flags_get()

        steps = microcode.steps(flags)
        for microstep in steps:
            self.execute_step(microstep)

        Imm.clear()

        return not microcode.are_default(steps)

    def execute_step(self, microstep):
        self.control.reset()

        for pin in microstep:
            pin.enable()

        if self.control.c_word != self.control.default:

            self.client.ctrl_commit(self.control.c_word)


            # special handling when reading the bus: it should
            # be done on "rising edge" - after primary clock
            # has rised, but inverted is not
            # in other cases it does not matter, using faster
            # version
            if OutPort.active:
                self.client.clock_pulse()
                OutPort.read_bus()
                self.client.clock_inverted()
            else:
                self.client.clock_tick()

            if PC.c_enabled:
                PC.advance()

            self.client.off(self.control.default)

        OutPort.disable()
        PC.disable()


class CPU:
    def __init__(self, client, control):

        self.backend = CPUBackendControl(client, control)

        self.reg_A = RegA
        self.reg_B = RegB
        self.reg_F = Flags
        self.alu = AddSub

    def op_ldi(self, target, value):
        opcode = "ldi_{}_imm".format(target.name)
        self.backend.execute_opcode(opcode, value)

    def op_add(self, target, arg):
        opcode = "add_{}_{}".format(target.name, arg.name)
        self.backend.execute_opcode(opcode)

    def op_adc(self, target, arg):
        opcode = "adc_{}_{}".format(target.name, arg.name)
        self.backend.execute_opcode(opcode)

    def op_sub(self, target, arg):
        opcode = "sub_{}_{}".format(target.name, arg.name)
        self.backend.execute_opcode(opcode)

    def op_sbb(self, target, arg):
        opcode = "sbb_{}_{}".format(target.name, arg.name)
        self.backend.execute_opcode(opcode)

    def op_cmp(self, target, arg):
        opcode = "cmp_{}_{}".format(target.name, arg.name)
        self.backend.execute_opcode(opcode)

    def op_out(self, source):
        opcode = "out_{}".format(source.name)
        self.backend.execute_opcode(opcode)

        print ("{}".format(OutPort.value), flush=True)

    def op_peek(self, source):
        opcode = "out_{}".format(source.name)
        self.backend.execute_opcode(opcode)

        return OutPort.value

    def op_mov(self, target, source):
        opcode = "mov_{}_{}".format(target.name, source.name)
        self.backend.execute_opcode(opcode)

    def op_st(self, addr, source):
        opcode = "st_addr_{}".format(source.name)
        self.backend.execute_opcode(opcode, addr)

    def op_stabs(self, addr_reg, source):
        opcode = "stabs_{}_{}".format(addr_reg.name, source.name)
        self.backend.execute_opcode(opcode)

    def op_ldabs(self, target, addr_reg):
        opcode = "ldabs_{}_{}".format(target.name, addr_reg.name)
        self.backend.execute_opcode(opcode)

    def op_tstabs(self, addr_reg):
        opcode = "tstabs_{}".format(addr_reg.name)
        self.backend.execute_opcode(opcode)

    def op_ld(self, target, addr):
        opcode = "ld_{}_addr".format(target.name)
        self.backend.execute_opcode(opcode, addr)

    def op_bcs(self, label=None):
        return self.backend.execute_opcode("bcs_addr", label)

    def op_bcc(self, label=None):
        return self.backend.execute_opcode("bcc_addr", label)

    def op_beq(self, label=None):
        return self.backend.execute_opcode("beq_addr", label)

    def op_bne(self, label=None):
        return self.backend.execute_opcode("bne_addr", label)

    def op_jmp(self, label=None):
        return self.backend.execute_opcode("jmp_addr", label)


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
        if isinstance(value, int) or value is None:
            self.value = value
        elif isinstance(value, Bytes):
            self.value = value.start
        else:
            raise TypeError

    def clear(self):
        self.value = None

    def enable(self):
        if self.value is not None:
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

    def disable(self):
        self.active = False

    def read_bus(self):
        self.value = self.client.bus_get()

class EnableCallback:
    def __init__(self, callback):
        self.callback = callback

    def enable(self):
        self.callback()

class ProgramCounter:
    def __init__(self):
        self.value = 0
        self.c_enabled = False
        self.out = self
        self.count = EnableCallback(self.enable_count)
        self.load  = EnableCallback(self.enable_load)

    def connect(self, client):
        pass

    def enable_count(self):
        self.c_enabled = True

    def enable_load(self):
        pass

    def enable(self):
        # OUT enable
        pass

    def disable(self):
        self.c_enabled = False

    def advance(self):
        self.value += 1

# to emulate ProgMAR
class NullRegister:
    def __init__(self):
        self.load = self

    def enable(self):
        pass



Imm = ImmediateValue()
OutPort = ResultValue()
PC = ProgramCounter()

# MAR to access program memory, normally same as regular MAR, Null in emulated mode
ProgMAR = NullRegister()

# Memory output when loading from program memory. Normally RAM or ROM, internal Imm for emulated
ProgMem = Imm

class FlagsAlt:
    def __init__(self, mask, value, steps):
        self.mask = mask
        self.value = value
        self.steps = steps

class MicroCode:
    def __init__(self, steps, f_alt=None):
        self._steps = steps
        self.f_alt = f_alt

    def is_flag_dependent(self):
        return self.f_alt is not None

    def steps(self, flags):
        if self.f_alt:
            matches = list(filter(lambda alt: flags & alt.mask == alt.value, self.f_alt))

            if len(matches) > 1:
                raise Exception("Multiple options found")

            if len(matches) == 1:
                return matches[0].steps

        return self._steps

    def are_default(self, steps):
        return steps == self._steps


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

setup_imm = [PC.out, ProgMAR.load]

opcodes = dict(
    [("nop", MicroCode([]))]+

    mkuc_list(gp_regs, "ldi_{}_imm", lambda r: MicroCode([setup_imm, [r.load, ProgMem.out, PC.count]])) +

    [("ldi_F_imm", MicroCode([setup_imm, [Flags.load, Flags.bus_in, ProgMem.out, PC.count]]))] +

    mkuc_permute_all(gp_regs, "add_{}_{}", lambda l, r: MicroCode([[l.load, l.alu_a, r.alu_b, AddSub.out, Flags.load]])) +
    mkuc_permute_all(gp_regs, "adc_{}_{}", lambda l, r: MicroCode([[l.load, l.alu_a, r.alu_b, AddSub.out, Flags.load]], [FlagsAlt(mask=Flags.C, value=Flags.C, steps=[[l.load, l.alu_a, r.alu_b, AddSub.out, Flags.load, Flags.use_carry]]) ])) +
    mkuc_permute_nsame(gp_regs, "sub_{}_{}", lambda l, r: MicroCode([[l.load, l.alu_a, r.alu_b, AddSub.out, AddSub.sub, Flags.load]])) +
    mkuc_permute_nsame(gp_regs, "sbb_{}_{}", lambda l, r: MicroCode([[l.load, l.alu_a, r.alu_b, AddSub.out, AddSub.sub, Flags.load, Flags.use_carry]])) +

    mkuc_permute_nsame(gp_regs, "cmp_{}_{}", lambda l, r: MicroCode([[l.alu_a, r.alu_b, AddSub.out, AddSub.sub, Flags.load]])) +

    [("sbb_A_B", MicroCode([[RegA.load, RegA.alu_a, RegB.alu_b, AddSub.out, AddSub.sub, Flags.load, Flags.use_carry]]))] +

    mkuc_permute_nsame(gp_regs, "mov_{}_{}", lambda l, r: MicroCode([[l.load, r.out]])) +
    mkuc_list(gp_regs, "out_{}", lambda r: MicroCode([[r.out, OutPort.load]])) +

    mkuc_list(gp_regs, "st_addr_{}", lambda r: MicroCode([setup_imm, [ProgMem.out, Mar.load, PC.count], [r.out, Ram.write]])) +
    mkuc_permute_all(gp_regs, "stabs_{}_{}", lambda a, v: MicroCode([[a.out, Mar.load], [v.out, Ram.write]])) +
    mkuc_list(gp_regs, "ld_{}_addr", lambda r: MicroCode([setup_imm, [ProgMem.out, Mar.load, PC.count], [Ram.out, r.load, Flags.load]])) +
    mkuc_permute_all(gp_regs, "ldabs_{}_{}", lambda v, a: MicroCode([[a.out, Mar.load], [v.load, Ram.out, Flags.load]])) +

    mkuc_list(gp_regs, "tstabs_{}", lambda r: MicroCode([[r.out, Mar.load], [Ram.out, Flags.load]])) +

    [("jmp_addr", MicroCode([setup_imm,[ProgMem.out, PC.load]]))]+
    [("beq_addr", MicroCode([[PC.count]],[FlagsAlt(mask=Flags.Z, value=Flags.Z, steps=[setup_imm,[ProgMem.out, PC.load]])]))]+
    [("bne_addr", MicroCode([[PC.count]],[FlagsAlt(mask=Flags.Z, value=0, steps=[setup_imm,[ProgMem.out, PC.load]])]))]+
    [("bcs_addr", MicroCode([[PC.count]],[FlagsAlt(mask=Flags.C, value=Flags.C, steps=[setup_imm,[ProgMem.out, PC.load]])]))]+
    [("bcc_addr", MicroCode([[PC.count]],[FlagsAlt(mask=Flags.C, value=0, steps=[setup_imm,[ProgMem.out, PC.load]])]))]+

    [("out_F", MicroCode([[Flags.bus_out, OutPort.load]]))]
)
