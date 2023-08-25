from libcpu.util import ControlSignal
from .DeviceSetup import *
from .opcode_builder import MicrocodeBuilder, MicroCode, OpcodeArg
from .devices import Register, GPRegister
from typing import List, Sequence, Iterator, Tuple, Mapping

gp_regs: Sequence[GPRegister] = [RegA, RegB, RegC, RegD]

fetch: List[Sequence[ControlSignal]] = [[PC.out, PC.inc, ProgMem.out, IR.load]]

class InvalidOpcodeException(Exception):
    pass

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

def opcode_of(instr: str) -> int:
    if not instr in opcodes:
        raise InvalidOpcodeException(instr)
    return opcodes[instr].opcode


def build_opcodes() -> Tuple[Mapping[str, MicroCode], List[MicroCode]]:

    builder = MicrocodeBuilder()

    # easier to define an extra step here than
    # handling the special case in code
    builder.add_instruction("nop")\
        .add_step()

    for r in gp_regs:
        builder.add_instruction("ldi", r, OpcodeArg.BYTE)\
            .add_step(PC.out, PC.inc, ProgMem.out, r.load)

    builder.add_instruction("ldi_F", OpcodeArg.BYTE)\
        .add_step(PC.out, PC.inc, ProgMem.out, Flags.load)

    builder.add_instruction("hlt")\
        .add_step(Clock.halt)

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
        builder.add_instruction("and", l, r)\
            .add_step(l.load, l.alu_l, r.alu_r, AndOr.out, Flags.calc)

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("or", l, r)\
            .add_step(l.load, l.alu_l, r.alu_r, AndOr.out, AndOr.alt, Flags.calc)

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("xor", l, r)\
            .add_step(l.load, l.alu_l, r.alu_r, XorNot.out, Flags.calc)

    for r in gp_regs:
        builder.add_instruction("not", r)\
            .add_step(r.load, r.alu_l, XorNot.out, XorNot.alt, Flags.calc)

    for r in gp_regs:
        builder.add_instruction("clr", r)\
            .add_step(r.load, r.alu_l, r.alu_r, XorNot.out, Flags.calc)

    for r in gp_regs:
        builder.add_instruction("inc", r)\
            .add_step(r.load, r.alu_l, AddSub.out, Flags.calc, Flags.carry)

    for r in gp_regs:
        builder.add_instruction("dec", r)\
            .add_step(r.load, r.alu_l, AddSub.out, AddSub.alt, Flags.calc, Flags.carry)

    for r in gp_regs:
        builder.add_instruction("shr", r)\
            .add_step(r.load, r.alu_l, ShiftSwap.out, Flags.calc)

    for r in gp_regs:
        builder.add_instruction("ror", r)\
            .add_step(r.load, r.alu_l, ShiftSwap.out, Flags.calc)\
            .add_condition(mask=Flags.C, value=Flags.C)\
                .add_step(r.load, r.alu_l, ShiftSwap.out, Flags.calc, Flags.carry)

    for r in gp_regs:
        builder.add_instruction("asr", r)\
            .add_step(r.out, Flags.calc)\
            .add_step(r.load, r.alu_l, ShiftSwap.out, Flags.calc)\
            .add_condition(mask=Flags.N, value=Flags.N)\
                .add_step(r.out, Flags.calc)\
                .add_step(r.load, r.alu_l, ShiftSwap.out, Flags.calc, Flags.carry)

    for r in gp_regs:
        builder.add_instruction("swap", r)\
            .add_step(r.load, r.alu_l, ShiftSwap.out, ShiftSwap.alt, Flags.calc)

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("cmp", l, r)\
            .add_step(l.alu_l, r.alu_r, AddSub.out, AddSub.alt, Flags.calc)

    for al, ar in permute_gp_regs_nsame():
        builder.add_instruction("mov", al, ar)\
            .add_step(al.load, ar.out)

    for r in gp_regs:
        builder.add_instruction("out", OpcodeArg.BYTE, r)\
            .add_step(PC.out, PC.inc, ProgMem.out, IOCtl.laddr)\
            .add_step(r.out, IOCtl.to_dev)

    for r in gp_regs:
        builder.add_instruction("in", r, OpcodeArg.BYTE)\
            .add_step(PC.out, PC.inc, ProgMem.out, IOCtl.laddr)\
            .add_step(r.load, IOCtl.from_dev)

    for v in gp_regs:
        builder.add_instruction("st", OpcodeArg.ADDR, v)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(TX.out, v.out, Ram.write)

    for i, v in permute_gp_regs_all():
        builder.add_instruction("stx", OpcodeArg.ADDR, i, v)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(i.out, TX.out, ACalc.load)\
            .add_step(ACalc.out, v.out, Ram.write)

    for r in gp_regs:
        builder.add_instruction("ld", r, OpcodeArg.ADDR)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(TX.out, Ram.out, r.load, Flags.calc)

    for t, i in permute_gp_regs_all():
        builder.add_instruction("ldx", t, OpcodeArg.ADDR, i)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(i.out, TX.out, ACalc.load)\
            .add_step(ACalc.out, t.load, Ram.out, Flags.calc)

    for i in gp_regs:
        builder.add_instruction("tstx", OpcodeArg.ADDR, i)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(i.out, TX.out, ACalc.load)\
            .add_step(ACalc.out, Ram.out, Flags.calc)

    builder.add_instruction("ljmp", OpcodeArg.ADDR)\
        .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
        .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
        .add_step(TX.out, PC.load)

    builder.add_instruction("beql", OpcodeArg.ADDR)\
        .add_step(PC.inc)\
        .add_step(PC.inc)\
        .add_condition(mask=Flags.Z, value=Flags.Z)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(TX.out, PC.load)

    builder.add_instruction("bnel", OpcodeArg.ADDR)\
        .add_step(PC.inc)\
        .add_step(PC.inc)\
        .add_condition(mask=Flags.Z, value=0)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(TX.out, PC.load)

    builder.add_instruction("bcsl", OpcodeArg.ADDR)\
        .add_step(PC.inc)\
        .add_step(PC.inc)\
        .add_condition(mask=Flags.C, value=Flags.C)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(TX.out, PC.load)

    builder.add_instruction("bccl", OpcodeArg.ADDR)\
        .add_step(PC.inc)\
        .add_step(PC.inc)\
        .add_condition(mask=Flags.C, value=0)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(TX.out, PC.load)

    builder.add_instruction("bmil", OpcodeArg.ADDR)\
        .add_step(PC.inc)\
        .add_step(PC.inc)\
        .add_condition(mask=Flags.N, value=Flags.N)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(TX.out, PC.load)

    builder.add_instruction("bpll", OpcodeArg.ADDR)\
        .add_step(PC.inc)\
        .add_step(PC.inc)\
        .add_condition(mask=Flags.N, value=0)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(TX.out, PC.load)

    for r in gp_regs:
        builder.add_instruction("push", r)\
            .add_step(SP.dec)\
            .add_step(SP.out, r.out, Ram.write)

    builder.add_instruction("pushf")\
            .add_step(SP.dec)\
            .add_step(SP.out, Flags.out, Ram.write)

    builder.add_instruction("push", LR)\
            .add_step(SP.dec, LR.out, TX.load)\
            .add_step(SP.out, TH.out, Ram.write, SP.dec)\
            .add_step(SP.out, TL.out, Ram.write)

    for r in gp_regs:
        builder.add_instruction("pop", r)\
            .add_step(SP.out, Ram.out, r.load, SP.inc)

    builder.add_instruction("popf")\
        .add_step(SP.out, Ram.out, Flags.load, SP.inc)

    builder.add_instruction("pop", LR)\
        .add_step(SP.out, Ram.out, TL.load, SP.inc)\
        .add_step(SP.out, Ram.out, TH.load, SP.inc)\
        .add_step(TX.out, LR.load)

    builder.add_instruction("callf", OpcodeArg.ADDR)\
        .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
        .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
        .add_step(PC.out, LR.load)\
        .add_step(TX.out, PC.load)

    builder.add_instruction("ret")\
        .add_step(LR.out, PC.load)

    builder.add_instruction("brk")\
        .add_step(Clock.brk)

    builder.add_instruction("lea", SP, OpcodeArg.ADDR)\
        .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
        .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
        .add_step(TX.out, SP.load)

    for r in gp_regs:
        builder.add_instruction("ldr", r, SP, OpcodeArg.BYTE)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(SP.out, TL.out, ACalc.load, ACalc.signed)\
            .add_step(ACalc.out, Ram.out, r.load, Flags.calc)

    for r in gp_regs:
        builder.add_instruction("str", SP, OpcodeArg.BYTE, r)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(SP.out, TL.out, ACalc.load, ACalc.signed)\
            .add_step(ACalc.out, r.out, Ram.write)

    builder.add_instruction("_xprefix")\
        .add_step(PC.out, PC.inc, ProgMem.out, IR.load, StepCounter.extended)\
        .add_step() # extra NOP to prevent microcode ROM generator from inserting steps reset

    builder.add_instruction("rjmp", OpcodeArg.BYTE)\
        .add_step(PC.out, PC.inc, ProgMem.out, ACalc.load, ACalc.signed)\
        .add_step(ACalc.out, PC.load)

    builder.add_instruction("beqr", OpcodeArg.BYTE)\
        .add_step(PC.inc)\
        .add_condition(mask=Flags.Z, value=Flags.Z)\
            .add_step(PC.out, PC.inc, ProgMem.out, ACalc.load, ACalc.signed)\
            .add_step(ACalc.out, PC.load)

    builder.add_instruction("bner", OpcodeArg.BYTE)\
        .add_step(PC.inc)\
        .add_condition(mask=Flags.Z, value=0)\
            .add_step(PC.out, PC.inc, ProgMem.out, ACalc.load, ACalc.signed)\
            .add_step(ACalc.out, PC.load)

    builder.add_instruction("bcsr", OpcodeArg.BYTE)\
        .add_step(PC.inc)\
        .add_condition(mask=Flags.C, value=Flags.C)\
            .add_step(PC.out, PC.inc, ProgMem.out, ACalc.load, ACalc.signed)\
            .add_step(ACalc.out, PC.load)

    builder.add_instruction("bccr", OpcodeArg.BYTE)\
        .add_step(PC.inc)\
        .add_condition(mask=Flags.C, value=0)\
            .add_step(PC.out, PC.inc, ProgMem.out, ACalc.load, ACalc.signed)\
            .add_step(ACalc.out, PC.load)

    builder.add_instruction("bmir", OpcodeArg.BYTE)\
        .add_step(PC.inc)\
        .add_condition(mask=Flags.N, value=Flags.N)\
            .add_step(PC.out, PC.inc, ProgMem.out, ACalc.load, ACalc.signed)\
            .add_step(ACalc.out, PC.load)

    builder.add_instruction("bplr", OpcodeArg.BYTE)\
        .add_step(PC.inc)\
        .add_condition(mask=Flags.N, value=0)\
            .add_step(PC.out, PC.inc, ProgMem.out, ACalc.load, ACalc.signed)\
            .add_step(ACalc.out, PC.load)

    builder.add_instruction("rcall", OpcodeArg.BYTE)\
        .add_step(PC.out, PC.inc, ProgMem.out, ACalc.load, ACalc.signed)\
        .add_step(PC.out, LR.load)\
        .add_step(ACalc.out, PC.load)

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("lcmp", l, r)\
            .add_step(l.alu_l, r.alu_r, AndOr.out, Flags.calc)

    # create a bunch of NOPs to exceed 255 instructions
    for n in range(20, 30):
        builder.add_instruction(f"padding{n}")\
            .add_step()

    # dummy instruction - same as ldi A, imm
    # ext bit should stick, even if it is not
    # present in each step. Only steps_reset can clear it
    builder.add_instruction("dummyext", OpcodeArg.BYTE)\
        .add_step()\
        .add_step()\
        .add_step(PC.out, PC.inc, ProgMem.out, RegA.load)

    return builder.build()


opcodes, ops_by_code = build_opcodes()
