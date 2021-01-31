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

        return not microcode.are_default(steps), OutPort.value

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

        OutPort.disable()
        PC.disable()
        Imm.disable()

class InvalidOpcodeException(Exception):
    pass

class ImmediateValue:
    def __init__(self):
        self.client = None
        self.value = None
        self.out = self
        self.write_enabled = False

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

    def disable(self):
        if self.write_enabled:
            self.client.bus_free()
            self.write_enabled = False

    def enable(self):
        if self.value is not None:
            self.client.bus_set(self.value)
            self.write_enabled = True

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

    def add_step(self, step):
        self.steps.append(step)

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

    def add_step(self, pins):
        self._steps.append(pins)

    def add_condition(self, mask, value):
        if self.f_alt is None:
            self.f_alt = []

        alt = FlagsAlt(mask, value, [])
        self.f_alt.append(alt)

        return alt


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

def permute_gp_regs_all():
    for l in gp_regs:
        for r in gp_regs:
            yield l, r

def permute_gp_regs_nsame():
    for l in gp_regs:
        for r in gp_regs:
            if l != r:
                yield l, r


class MicrocodeBuilder:
    def __init__(self):
        self.opcodes = []

    def add_instruction(self, name, *fmt):
        opcode = name.format(*fmt)
        ucode = MicroCode([])

        self.opcodes.append((opcode, ucode))
        return ucode

    def build(self):
        return dict(self.opcodes)


def build_opcodes():

    builder = MicrocodeBuilder()

    builder.add_instruction("nop")

    for r in gp_regs:
        instr = builder.add_instruction("ldi_{}_imm", r)
        instr.add_step(setup_imm)
        instr.add_step([r.load, ProgMem.out, PC.count])

    instr = builder.add_instruction("ldi_F_imm")
    instr.add_step(setup_imm)
    instr.add_step([Flags.load, Flags.bus_in, ProgMem.out, PC.count])

    for l, r in permute_gp_regs_all():
        instr = builder.add_instruction("add_{}_{}", l, r)
        instr.add_step([l.load, l.alu_a, r.alu_b, AddSub.out, Flags.load])

    for l, r in permute_gp_regs_all():
        instr = builder.add_instruction("adc_{}_{}", l, r)
        instr.add_step([l.load, l.alu_a, r.alu_b, AddSub.out, Flags.load])

        cond = instr.add_condition(mask=Flags.C, value=Flags.C)
        cond.add_step([l.load, l.alu_a, r.alu_b, AddSub.out, Flags.load, Flags.use_carry])

    for l, r in permute_gp_regs_nsame():
        instr = builder.add_instruction("sub_{}_{}", l, r)
        instr.add_step([l.load, l.alu_a, r.alu_b, AddSub.out, AddSub.sub, Flags.load])

    for l, r in permute_gp_regs_nsame():
        instr = builder.add_instruction("sbb_{}_{}", l, r)
        instr.add_step([l.load, l.alu_a, r.alu_b, AddSub.out, AddSub.sub, Flags.load, Flags.use_carry])

    for l, r in permute_gp_regs_nsame():
        instr = builder.add_instruction("cmp_{}_{}", l, r)
        instr.add_step([l.alu_a, r.alu_b, AddSub.out, AddSub.sub, Flags.load])

    for l, r in permute_gp_regs_nsame():
        instr = builder.add_instruction("mov_{}_{}", l, r)
        instr.add_step([l.load, r.out])

    for r in gp_regs:
        instr = builder.add_instruction("out_{}", r)
        instr.add_step([r.out, OutPort.load])

    for v in gp_regs:
        instr = builder.add_instruction("st_addr_{}", v)
        instr.add_step(setup_imm)
        instr.add_step([ProgMem.out, Mar.load, PC.count])
        instr.add_step([v.out, Ram.write])

    for a, v in permute_gp_regs_all():
        instr = builder.add_instruction("stabs_{}_{}", a, v)
        instr.add_step([a.out, Mar.load])
        instr.add_step([v.out, Ram.write])

    for r in gp_regs:
        instr = builder.add_instruction("ld_{}_addr", r)
        instr.add_step(setup_imm)
        instr.add_step([ProgMem.out, Mar.load, PC.count])
        instr.add_step([Ram.out, r.load, Flags.load])

    for v, a in permute_gp_regs_all():
        instr = builder.add_instruction("ldabs_{}_{}", v, a)
        instr.add_step([a.out, Mar.load])
        instr.add_step([v.load, Ram.out, Flags.load])

    for r in gp_regs:
        instr = builder.add_instruction("tstabs_{}", r)
        instr.add_step([r.out, Mar.load])
        instr.add_step([Ram.out, Flags.load])

    instr = builder.add_instruction("jmp_addr")
    instr.add_step(setup_imm)
    instr.add_step([ProgMem.out, PC.load])

    instr = builder.add_instruction("beq_addr")
    instr.add_step([PC.count])
    cond = instr.add_condition(mask=Flags.Z, value=Flags.Z)
    cond.add_step(setup_imm)
    cond.add_step([ProgMem.out, PC.load])

    instr = builder.add_instruction("bne_addr")
    instr.add_step([PC.count])
    cond = instr.add_condition(mask=Flags.Z, value=0)
    cond.add_step(setup_imm)
    cond.add_step([ProgMem.out, PC.load])

    instr = builder.add_instruction("bcs_addr")
    instr.add_step([PC.count])
    cond = instr.add_condition(mask=Flags.C, value=Flags.C)
    cond.add_step(setup_imm)
    cond.add_step([ProgMem.out, PC.load])

    instr = builder.add_instruction("bcc_addr")
    instr.add_step([PC.count])
    cond = instr.add_condition(mask=Flags.C, value=0)
    cond.add_step(setup_imm)
    cond.add_step([ProgMem.out, PC.load])

    instr = builder.add_instruction("out_F")
    instr.add_step([Flags.bus_out, OutPort.load])

    instr = builder.add_instruction("hlt")
    instr.add_step([Clock.halt])


    return builder.build()


opcodes = build_opcodes()

opcodes0 = dict(
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

    [("out_F", MicroCode([[Flags.bus_out, OutPort.load]]))] +
    [("hlt", MicroCode([[Clock.halt]]))]
)
