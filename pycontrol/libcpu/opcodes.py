from typing import List, Sequence, Iterator, Tuple, Mapping
from libcpu.util import ControlSignal
from .DeviceSetup import *
from .opcode_builder import MicrocodeBuilder, MicroCode, OpcodeArg
from .devices import Register, GPRegister, Flags

gp_regs: Sequence[GPRegister] = [A, B, C, D]

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
        .add_step(PC.out, PC.inc, ProgMem.out, F.load)

    builder.add_instruction("hlt")\
        .add_step(Clock.halt)

    for l, r in permute_gp_regs_all():
        builder.add_instruction("add", l, r)\
            .add_step(l.load, l.alu_l, r.alu_r, AddSub.out, F.calc)

    for l, r in permute_gp_regs_all():
        builder.add_instruction("adc", l, r)\
            .add_step(l.load, l.alu_l, r.alu_r, AddSub.out, F.calc)\
            .add_condition(mask=Flags.C, value=Flags.C)\
                .add_step(l.load, l.alu_l, r.alu_r, AddSub.out, F.calc, F.carry)

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("sub", l, r)\
            .add_step(l.load, l.alu_l, r.alu_r, AddSub.out, AddSub.alt, F.calc)

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("sbb", l, r)\
            .add_step(l.load, l.alu_l, r.alu_r, AddSub.out, AddSub.alt, F.calc)\
            .add_condition(mask=Flags.C, value=Flags.C)\
                .add_step(l.load, l.alu_l, r.alu_r, AddSub.out, AddSub.alt, F.calc, F.carry)

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("and", l, r)\
            .add_step(l.load, l.alu_l, r.alu_r, AndOr.out, F.calc)

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("or", l, r)\
            .add_step(l.load, l.alu_l, r.alu_r, AndOr.out, AndOr.alt, F.calc)

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("xor", l, r)\
            .add_step(l.load, l.alu_l, r.alu_r, XorNot.out, F.calc)

    for r in gp_regs:
        builder.add_instruction("not", r)\
            .add_step(r.load, r.alu_l, XorNot.out, XorNot.alt, F.calc)

    for r in gp_regs:
        builder.add_instruction("clr", r)\
            .add_step(r.load, r.alu_l, r.alu_r, XorNot.out, F.calc)

    for r in gp_regs:
        builder.add_instruction("inc", r)\
            .add_step(r.load, r.alu_l, AddSub.out, F.calc, F.carry)

    for r in gp_regs:
        builder.add_instruction("dec", r)\
            .add_step(r.load, r.alu_l, AddSub.out, AddSub.alt, F.calc, F.carry)

    for r in gp_regs:
        builder.add_instruction("shr", r)\
            .add_step(r.load, r.alu_l, ShiftSwap.out, F.calc)

    for r in gp_regs:
        builder.add_instruction("ror", r)\
            .add_step(r.load, r.alu_l, ShiftSwap.out, F.calc)\
            .add_condition(mask=Flags.C, value=Flags.C)\
                .add_step(r.load, r.alu_l, ShiftSwap.out, F.calc, F.carry)

    for r in gp_regs:
        builder.add_instruction("asr", r)\
            .add_step(r.out, F.calc)\
            .add_step(r.load, r.alu_l, ShiftSwap.out, F.calc)\
            .add_condition(mask=Flags.N, value=Flags.N)\
                .add_step(r.out, F.calc)\
                .add_step(r.load, r.alu_l, ShiftSwap.out, F.calc, F.carry)

    for r in gp_regs:
        builder.add_instruction("swap", r)\
            .add_step(r.load, r.alu_l, ShiftSwap.out, ShiftSwap.alt, F.calc)

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("cmp", l, r)\
            .add_step(l.alu_l, r.alu_r, AddSub.out, AddSub.alt, F.calc)

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
            .add_step(r.load, IOCtl.from_dev, F.calc)

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
            .add_step(TX.out, Ram.out, r.load, F.calc)

    for t, i in permute_gp_regs_all():
        builder.add_instruction("ldx", t, OpcodeArg.ADDR, i)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(i.out, TX.out, ACalc.load)\
            .add_step(ACalc.out, t.load, Ram.out, F.calc)

    for i in gp_regs:
        builder.add_instruction("tstx", OpcodeArg.ADDR, i)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(i.out, TX.out, ACalc.load)\
            .add_step(ACalc.out, Ram.out, F.calc)

    builder.add_instruction("ljmp", OpcodeArg.ADDR)\
        .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
        .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
        .add_step(TX.out, PC.load)

    builder.add_instruction("beql", OpcodeArg.ADDR)\
        .add_step(PC.out, PC.inc)\
        .add_step(PC.out, PC.inc)\
        .add_condition(mask=Flags.Z, value=Flags.Z)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(TX.out, PC.load)

    builder.add_instruction("bnel", OpcodeArg.ADDR)\
        .add_step(PC.out, PC.inc)\
        .add_step(PC.out, PC.inc)\
        .add_condition(mask=Flags.Z, value=Flags.Empty)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(TX.out, PC.load)

    builder.add_instruction("bcsl", OpcodeArg.ADDR)\
        .add_step(PC.out, PC.inc)\
        .add_step(PC.out, PC.inc)\
        .add_condition(mask=Flags.C, value=Flags.C)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(TX.out, PC.load)

    builder.add_instruction("bccl", OpcodeArg.ADDR)\
        .add_step(PC.out, PC.inc)\
        .add_step(PC.out, PC.inc)\
        .add_condition(mask=Flags.C, value=Flags.Empty)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(TX.out, PC.load)

    builder.add_instruction("bmil", OpcodeArg.ADDR)\
        .add_step(PC.out, PC.inc)\
        .add_step(PC.out, PC.inc)\
        .add_condition(mask=Flags.N, value=Flags.N)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(TX.out, PC.load)

    builder.add_instruction("bpll", OpcodeArg.ADDR)\
        .add_step(PC.out, PC.inc)\
        .add_step(PC.out, PC.inc)\
        .add_condition(mask=Flags.N, value=Flags.Empty)\
            .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
            .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
            .add_step(TX.out, PC.load)

    for r in gp_regs:
        builder.add_instruction("push", r)\
            .add_step(SP.out, SP.dec)\
            .add_step(SP.out, r.out, Ram.write)

    builder.add_instruction("pushf")\
            .add_step(SP.out, SP.dec)\
            .add_step(SP.out, F.out, Ram.write)

    builder.add_instruction("push", LR)\
            .add_step(LR.out, TX.load)\
            .add_step(SP.out, SP.dec)\
            .add_step(SP.out, TH.out, Ram.write, SP.dec)\
            .add_step(SP.out, TL.out, Ram.write)

    for r in gp_regs:
        builder.add_instruction("pop", r)\
            .add_step(SP.out, Ram.out, r.load, SP.inc)

    builder.add_instruction("popf")\
        .add_step(SP.out, Ram.out, F.load, SP.inc)

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
            .add_step(ACalc.out, Ram.out, r.load, F.calc)

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
        .add_step(PC.out, PC.inc)\
        .add_condition(mask=Flags.Z, value=Flags.Z)\
            .add_step(PC.out, PC.inc, ProgMem.out, ACalc.load, ACalc.signed)\
            .add_step(ACalc.out, PC.load)

    builder.add_instruction("bner", OpcodeArg.BYTE)\
        .add_step(PC.out, PC.inc)\
        .add_condition(mask=Flags.Z, value=Flags.Empty)\
            .add_step(PC.out, PC.inc, ProgMem.out, ACalc.load, ACalc.signed)\
            .add_step(ACalc.out, PC.load)

    builder.add_instruction("bcsr", OpcodeArg.BYTE)\
        .add_step(PC.out, PC.inc)\
        .add_condition(mask=Flags.C, value=Flags.C)\
            .add_step(PC.out, PC.inc, ProgMem.out, ACalc.load, ACalc.signed)\
            .add_step(ACalc.out, PC.load)

    builder.add_instruction("bccr", OpcodeArg.BYTE)\
        .add_step(PC.out, PC.inc)\
        .add_condition(mask=Flags.C, value=Flags.Empty)\
            .add_step(PC.out, PC.inc, ProgMem.out, ACalc.load, ACalc.signed)\
            .add_step(ACalc.out, PC.load)

    builder.add_instruction("bmir", OpcodeArg.BYTE)\
        .add_step(PC.out, PC.inc)\
        .add_condition(mask=Flags.N, value=Flags.N)\
            .add_step(PC.out, PC.inc, ProgMem.out, ACalc.load, ACalc.signed)\
            .add_step(ACalc.out, PC.load)

    builder.add_instruction("bplr", OpcodeArg.BYTE)\
        .add_step(PC.out, PC.inc)\
        .add_condition(mask=Flags.N, value=Flags.Empty)\
            .add_step(PC.out, PC.inc, ProgMem.out, ACalc.load, ACalc.signed)\
            .add_step(ACalc.out, PC.load)

    builder.add_instruction("rcall", OpcodeArg.BYTE)\
        .add_step(PC.out, PC.inc, ProgMem.out, ACalc.load, ACalc.signed)\
        .add_step(PC.out, LR.load)\
        .add_step(ACalc.out, PC.load)

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("lcmp", l, r)\
            .add_step(l.alu_l, r.alu_r, AndOr.out, F.calc)

    for r in gp_regs:
        builder.add_instruction("lpi", r, SDP)\
            .add_step(r.load, SDP.out, SDP.inc, Ram.out, F.calc)

    builder.add_instruction("lea", SDP, OpcodeArg.ADDR)\
        .add_step(PC.out, PC.inc, ProgMem.out, TL.load)\
        .add_step(PC.out, PC.inc, ProgMem.out, TH.load)\
        .add_step(TX.out, SDP.load)

    # create a bunch of NOPs to exceed 255 instructions
    builder.add_instruction(f"padding25")\
        .add_step()

    for r in gp_regs:
        builder.add_instruction("addi", r, OpcodeArg.BYTE)\
            .add_step(PC.out, PC.inc, ProgMem.out, T.load)\
            .add_step(r.load, r.alu_l, T.alu_r, AddSub.out, F.calc)

    # dummy instruction - same as ldi A, imm
    # ext bit should stick, even if it is not
    # present in each step. Only steps_reset can clear it
    builder.add_instruction("dummyext", OpcodeArg.BYTE)\
        .add_step()\
        .add_step()\
        .add_step(PC.out, PC.inc, ProgMem.out, A.load)

    for r in gp_regs:
        builder.add_instruction("adci", r, OpcodeArg.BYTE)\
            .add_step(PC.out, PC.inc, ProgMem.out, T.load)\
            .add_step(r.load, r.alu_l, T.alu_r, AddSub.out, F.calc)\
            .add_condition(mask=Flags.C, value=Flags.C)\
                .add_step(PC.out, PC.inc, ProgMem.out, T.load)\
                .add_step(r.load, r.alu_l, T.alu_r, AddSub.out, F.calc, F.carry)

    for r in gp_regs:
        builder.add_instruction("subi", r, OpcodeArg.BYTE)\
            .add_step(PC.out, PC.inc, ProgMem.out, T.load)\
            .add_step(r.load, r.alu_l, T.alu_r, AddSub.out, AddSub.alt, F.calc)

    for r in gp_regs:
        builder.add_instruction("cmpi", r, OpcodeArg.BYTE)\
            .add_step(PC.out, PC.inc, ProgMem.out, T.load)\
            .add_step(r.alu_l, T.alu_r, AddSub.out, AddSub.alt, F.calc)

    for r in gp_regs:
        builder.add_instruction("sbbi", r, OpcodeArg.BYTE)\
            .add_step(PC.out, PC.inc, ProgMem.out, T.load)\
            .add_step(r.load, r.alu_l, T.alu_r, AddSub.out, AddSub.alt, F.calc)\
            .add_condition(mask=Flags.C, value=Flags.C)\
                .add_step(PC.out, PC.inc, ProgMem.out, T.load)\
                .add_step(r.load, r.alu_l, T.alu_r, AddSub.out, AddSub.alt, F.calc, F.carry)

    for r in gp_regs:
        builder.add_instruction("andi", r, OpcodeArg.BYTE)\
            .add_step(PC.out, PC.inc, ProgMem.out, T.load)\
            .add_step(r.load, r.alu_l, T.alu_r, AndOr.out, F.calc)

    for r in gp_regs:
        builder.add_instruction("ori", r, OpcodeArg.BYTE)\
            .add_step(PC.out, PC.inc, ProgMem.out, T.load)\
            .add_step(r.load, r.alu_l, T.alu_r, AndOr.out, AndOr.alt, F.calc)

    for r in gp_regs:
        builder.add_instruction("xori", r, OpcodeArg.BYTE)\
            .add_step(PC.out, PC.inc, ProgMem.out, T.load)\
            .add_step(r.load, r.alu_l, T.alu_r, XorNot.out, F.calc)

    return builder.build()


opcodes, ops_by_code = build_opcodes()
