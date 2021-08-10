from libcpu.util import ControlSignal
from .DeviceSetup import *
from .opcode_builder import MicrocodeBuilder, MicroCode, OpcodeArg
from .devices import Register, GPRegister
from typing import List, Sequence, Iterator, Tuple, Mapping

gp_regs: Sequence[GPRegister] = [RegA, RegB]

fetch: List[Sequence[ControlSignal]] = [[PC.out, ProgMar.load], [ProgMem.out, IR.load, PC.count]]

def permute_gp_regs_all() -> Iterator[Tuple[GPRegister, GPRegister]]:
    for l in gp_regs:
        for r in gp_regs:
            yield l, r


def permute_gp_regs_nsame() -> Iterator[Tuple[GPRegister, GPRegister]]:
    for l in gp_regs:
        for r in gp_regs:
            if l != r:
                yield l, r

def permute_regs_lr(lregs: Sequence[Register], rregs: Sequence[Register]) -> Iterator[Tuple[Register, Register]]:
    for l in lregs:
        for r in rregs:
            yield l, r

def build_opcodes() -> Tuple[Mapping[str, MicroCode], List[MicroCode]]:

    builder = MicrocodeBuilder()

    # easier to define an extra step here than
    # handling the special case in code
    builder.add_instruction("nop")\
        .add_step()

    for r in gp_regs:
        builder.add_instruction("ldi", r, OpcodeArg.BYTE)\
            .add_step(PC.out, ProgMar.load)\
            .add_step(r.load, ProgMem.out, PC.count)

    builder.add_instruction("ldi_F", OpcodeArg.BYTE)\
        .add_step(PC.out, ProgMar.load)\
        .add_step(Flags.calc, Flags.load, ProgMem.out, PC.count)

    for l, r in permute_gp_regs_all():
        builder.add_instruction("add", l, r)\
            .add_step(l.load, l.alu_l, r.alu_r, AddSub.out, Flags.calc)

    for l, r in permute_gp_regs_all():
        builder.add_instruction("adc", l, r)\
            .add_step(l.load, l.alu_l, r.alu_r, AddSub.out, Flags.calc)\
            .add_condition(mask=Flags.C, value=Flags.C)\
                .add_step(l.load, l.alu_l, r.alu_r, AddSub.out, Flags.calc, Flags.carry)

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("sub", l, r)\
            .add_step(l.load, l.alu_l, r.alu_r, AddSub.out, AddSub.alt, Flags.calc)

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("sbb", l, r)\
            .add_step(l.load, l.alu_l, r.alu_r, AddSub.out, AddSub.alt, Flags.calc)\
            .add_condition(mask=Flags.C, value=Flags.C)\
                .add_step(l.load, l.alu_l, r.alu_r, AddSub.out, AddSub.alt, Flags.calc, Flags.carry)

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("cmp", l, r)\
            .add_step(l.alu_l, r.alu_r, AddSub.out, AddSub.alt, Flags.calc)

    for al, ar in permute_gp_regs_nsame():
        builder.add_instruction("mov", al, ar)\
            .add_step(al.load, ar.out)

    for r in gp_regs:
        builder.add_instruction("out", r)\
            .add_step(r.out, OutPort.load)

    for v in gp_regs:
        builder.add_instruction("st", OpcodeArg.ADDR, v)\
            .add_step(PC.out, ProgMar.load)\
            .add_step(ProgMem.out, Mar.load, PC.count)\
            .add_step(v.out, Ram.write)

    for a, v in permute_gp_regs_all():
        builder.add_instruction("stabs", a, v)\
            .add_step(a.out, Mar.load)\
            .add_step(v.out, Ram.write)

    for r in gp_regs:
        builder.add_instruction("ld", r, OpcodeArg.ADDR)\
            .add_step(PC.out, ProgMar.load)\
            .add_step(ProgMem.out, Mar.load, PC.count)\
            .add_step(Ram.out, r.load, Flags.calc)

    for v, a in permute_gp_regs_all():
        builder.add_instruction("ldabs", v, a)\
            .add_step(a.out, Mar.load)\
            .add_step(v.load, Ram.out, Flags.calc)

    for r in gp_regs:
        builder.add_instruction("tstabs", r)\
            .add_step(r.out, Mar.load)\
            .add_step(Ram.out, Flags.calc)

    builder.add_instruction("jmp", OpcodeArg.ADDR)\
        .add_step(PC.out, ProgMar.load)\
        .add_step(ProgMem.out, PC.load)

    builder.add_instruction("beq", OpcodeArg.ADDR)\
        .add_step(PC.count)\
        .add_condition(mask=Flags.Z, value=Flags.Z)\
            .add_step(PC.out, ProgMar.load)\
            .add_step(ProgMem.out, PC.load)

    builder.add_instruction("bne", OpcodeArg.ADDR)\
        .add_step(PC.count)\
        .add_condition(mask=Flags.Z, value=0)\
            .add_step(PC.out, ProgMar.load)\
            .add_step(ProgMem.out, PC.load)

    builder.add_instruction("bcs", OpcodeArg.ADDR)\
        .add_step(PC.count)\
        .add_condition(mask=Flags.C, value=Flags.C)\
            .add_step(PC.out, ProgMar.load)\
            .add_step(ProgMem.out, PC.load)

    builder.add_instruction("bcc", OpcodeArg.ADDR)\
        .add_step(PC.count)\
        .add_condition(mask=Flags.C, value=0)\
            .add_step(PC.out, ProgMar.load)\
            .add_step(ProgMem.out, PC.load)

    builder.add_instruction("out_F")\
        .add_step(Flags.out, OutPort.load)

    builder.add_instruction("hlt")\
        .add_step(Clock.halt)


    return builder.build()


opcodes, ops_by_code = build_opcodes()
