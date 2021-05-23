from .DeviceSetup import *
from .opcode_builder import MicrocodeBuilder, MicroCode, OpcodeArg
from .devices import Register, GPRegister
from typing import List, Sequence, Iterator, Tuple, Mapping

gp_regs: Sequence[GPRegister] = [RegA, RegB, RegC, RegD]

fetch = MicroCode(-1, "Fetch", ())\
    .add_step([PC.out, ProgMar.load])\
    .add_step([ProgMem.out, IR.load, PC.count])

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
        .add_step([])

    for r in gp_regs:
        builder.add_instruction("ldi", r, OpcodeArg.BYTE)\
            .add_step([PC.out, ProgMar.load])\
            .add_step([r.load, ProgMem.out, PC.count])

    builder.add_instruction("ldi_F", OpcodeArg.BYTE)\
        .add_step([PC.out, ProgMar.load])\
        .add_step([Flags.load, ProgMem.out, PC.count])

    builder.add_instruction("lea", DP, OpcodeArg.ADDR)\
        .add_step([PC.out, ProgMar.load])\
        .add_step([ProgMem.out, Has.load, PC.count])\
        .add_step([PC.out, ProgMar.load])\
        .add_step([ProgMem.out, Has.out, DP.load, PC.count])

    for l, r in permute_gp_regs_all():
        builder.add_instruction("add", l, r)\
            .add_step([l.load, l.alu_a, r.alu_b, AddSub.out, Flags.calc])

    for l, r in permute_gp_regs_all():
        builder.add_instruction("adc", l, r)\
            .add_step([l.load, l.alu_a, r.alu_b, AddSub.out, Flags.calc])\
            .add_condition(mask=Flags.C, value=Flags.C)\
                .add_step([l.load, l.alu_a, r.alu_b, AddSub.out, Flags.calc, Flags.carry])

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("sub", l, r)\
            .add_step([l.load, l.alu_a, r.alu_b, AddSub.out, AddSub.alt, Flags.calc])

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("sbb", l, r)\
            .add_step([l.load, l.alu_a, r.alu_b, AddSub.out, AddSub.alt, Flags.calc])\
            .add_condition(mask=Flags.C, value=Flags.C)\
                .add_step([l.load, l.alu_a, r.alu_b, AddSub.out, AddSub.alt, Flags.calc, Flags.carry])

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("and", l, r)\
            .add_step([l.load, l.alu_a, r.alu_b, AndOr.out, Flags.calc])

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("or", l, r)\
            .add_step([l.load, l.alu_a, r.alu_b, AndOr.out, AndOr.alt, Flags.calc])

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("xor", l, r)\
            .add_step([l.load, l.alu_a, r.alu_b, XorNot.out, Flags.calc])

    for r in gp_regs:
        builder.add_instruction("not", r)\
            .add_step([r.load, r.alu_a, XorNot.out, XorNot.alt, Flags.calc])

    for r in gp_regs:
        builder.add_instruction("inc", r)\
            .add_step([r.load, r.alu_a, AddSub.out, Flags.calc, Flags.carry])

    for r in gp_regs:
        builder.add_instruction("dec", r)\
            .add_step([r.load, r.alu_a, AddSub.out, AddSub.alt, Flags.calc, Flags.carry])

    for r in gp_regs:
        builder.add_instruction("shr", r)\
            .add_step([r.load, r.alu_a, ShiftSwap.out, Flags.calc])

    for r in gp_regs:
        builder.add_instruction("ror", r)\
            .add_step([r.load, r.alu_a, ShiftSwap.out, Flags.calc])\
            .add_condition(mask=Flags.C, value=Flags.C)\
                .add_step([r.load, r.alu_a, ShiftSwap.out, Flags.calc, Flags.carry])

    for r in gp_regs:
        builder.add_instruction("asr", r)\
            .add_step([r.out, Flags.calc])\
            .add_step([r.load, r.alu_a, ShiftSwap.out, Flags.calc])\
            .add_condition(mask=Flags.N, value=Flags.N)\
                .add_step([r.out, Flags.calc])\
                .add_step([r.load, r.alu_a, ShiftSwap.out, Flags.calc, Flags.carry])

    for r in gp_regs:
        builder.add_instruction("swap", r)\
            .add_step([r.load, r.alu_a, ShiftSwap.out, ShiftSwap.alt, Flags.calc])

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("cmp", l, r)\
            .add_step([l.alu_a, r.alu_b, AddSub.out, AddSub.alt, Flags.calc])

    for al, ar in permute_gp_regs_nsame():
        builder.add_instruction("mov", al, ar)\
            .add_step([al.load, ar.out])

    for r in gp_regs:
        builder.add_instruction("out", r)\
            .add_step([r.out, OutPort.load])

    for r in gp_regs:
        builder.add_instruction("cout", r)\
            .add_step([r.out, COutPort.load])

    for v in gp_regs:
        builder.add_instruction("st", OpcodeArg.ADDR, v)\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.load, PC.count])\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.out, Mar.load, PC.count])\
            .add_step([v.out, Ram.write])

    for i, v in permute_gp_regs_all():
        builder.add_instruction("stx", OpcodeArg.ADDR, i, v)\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.load, PC.count])\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.out, Mar.load, PC.count])\
            .add_step([i.out, Mar.add])\
            .add_step([v.out, Ram.write])

    for r in gp_regs:
        builder.add_instruction("ld", r, OpcodeArg.ADDR)\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.load, PC.count])\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.out, Mar.load, PC.count])\
            .add_step([Ram.out, r.load, Flags.calc])

    for t, i in permute_gp_regs_all():
        builder.add_instruction("ldx", t, OpcodeArg.ADDR, i)\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.load, PC.count])\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.out, Mar.load, PC.count])\
            .add_step([i.out, Mar.add])\
            .add_step([t.load, Ram.out, Flags.calc])

    for i in gp_regs:
        builder.add_instruction("tstx", OpcodeArg.ADDR, i)\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.load, PC.count])\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.out, Mar.load, PC.count])\
            .add_step([i.out, Mar.add])\
            .add_step([Ram.out, Flags.calc])

    builder.add_instruction("jmp", OpcodeArg.ADDR)\
        .add_step([PC.out, ProgMar.load])\
        .add_step([ProgMem.out, Has.load, PC.count])\
        .add_step([PC.out, ProgMar.load])\
        .add_step([ProgMem.out, Has.out, PC.load])

    builder.add_instruction("beq", OpcodeArg.ADDR)\
        .add_step([PC.count])\
        .add_step([PC.count])\
        .add_condition(mask=Flags.Z, value=Flags.Z)\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.load, PC.count])\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.out, PC.load])

    builder.add_instruction("bne", OpcodeArg.ADDR)\
        .add_step([PC.count])\
        .add_step([PC.count])\
        .add_condition(mask=Flags.Z, value=0)\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.load, PC.count])\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.out, PC.load])

    builder.add_instruction("bcs", OpcodeArg.ADDR)\
        .add_step([PC.count])\
        .add_step([PC.count])\
        .add_condition(mask=Flags.C, value=Flags.C)\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.load, PC.count])\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.out, PC.load])

    builder.add_instruction("bcc", OpcodeArg.ADDR)\
        .add_step([PC.count])\
        .add_step([PC.count])\
        .add_condition(mask=Flags.C, value=0)\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.load, PC.count])\
            .add_step([PC.out, ProgMar.load])\
            .add_step([ProgMem.out, Has.out, PC.load])

    for r in gp_regs:
        builder.add_instruction("push", r)\
            .add_step([SP.dec])\
            .add_step([SP.out, Mar.load])\
            .add_step([r.out, Ram.write])

    builder.add_instruction("push_F")\
            .add_step([SP.dec])\
            .add_step([SP.out, Mar.load])\
            .add_step([Flags.out, Ram.write])

    builder.add_instruction("push", LR)\
            .add_step([SP.dec, LR.out, Has.load, Has.dir])\
            .add_step([SP.out, Mar.load])\
            .add_step([LR.out, Ram.write, SP.dec])\
            .add_step([SP.out, Mar.load])\
            .add_step([Has.out, Has.dir, Ram.write])

    for r in gp_regs:
        builder.add_instruction("pop", r)\
            .add_step([SP.out, Mar.load])\
            .add_step([Ram.out, r.load, SP.inc])

    builder.add_instruction("pop_F")\
        .add_step([SP.out, Mar.load])\
        .add_step([Ram.out, Flags.load, SP.inc])

    builder.add_instruction("pop", LR)\
        .add_step([SP.out, Mar.load])\
        .add_step([Ram.out, Has.load, SP.inc])\
        .add_step([SP.out, Mar.load])\
        .add_step([Ram.out, Has.out, LR.load, SP.inc])

    builder.add_instruction("call", OpcodeArg.ADDR)\
        .add_step([PC.out, ProgMar.load])\
        .add_step([ProgMem.out, Has.load, PC.count])\
        .add_step([PC.out, ProgMar.load])\
        .add_step([ProgMem.out, Has.out, LR.load, PC.count])\
        .add_step([PSW.swap])

    builder.add_instruction("ret")\
        .add_step([PSW.swap])

    builder.add_instruction("hlt")\
        .add_step([Clock.halt])


    return builder.build()


opcodes, ops_by_code = build_opcodes()
