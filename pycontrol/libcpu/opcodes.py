from .DeviceSetup import *
from .opcode_builder import MicrocodeBuilder, MicroCode

gp_regs = [RegA, RegB]

setup_imm = [PC.out, ProgMar.load]

fetch = MicroCode(-1)\
    .add_step([PC.out, ProgMar.load])\
    .add_step([ProgMem.out, IR.load])

def permute_gp_regs_all():
    for l in gp_regs:
        for r in gp_regs:
            yield l, r


def permute_gp_regs_nsame():
    for l in gp_regs:
        for r in gp_regs:
            if l != r:
                yield l, r


def build_opcodes():

    builder = MicrocodeBuilder()

    builder.add_instruction("nop")

    for r in gp_regs:
        builder.add_instruction("ldi_{}_imm", r)\
            .add_step(setup_imm)\
            .add_step([r.load, ProgMem.out, PC.count])

    builder.add_instruction("ldi_F_imm")\
        .add_step(setup_imm)\
        .add_step([Flags.load, Flags.bus_in, ProgMem.out, PC.count])

    for l, r in permute_gp_regs_all():
        builder.add_instruction("add_{}_{}", l, r)\
            .add_step([l.load, l.alu_a, r.alu_b, AddSub.out, Flags.load])

    for l, r in permute_gp_regs_all():
        builder.add_instruction("adc_{}_{}", l, r)\
            .add_step([l.load, l.alu_a, r.alu_b, AddSub.out, Flags.load])\
            .add_condition(mask=Flags.C, value=Flags.C)\
                .add_step([l.load, l.alu_a, r.alu_b, AddSub.out, Flags.load, Flags.use_carry])

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("sub_{}_{}", l, r)\
            .add_step([l.load, l.alu_a, r.alu_b, AddSub.out, AddSub.sub, Flags.load])

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("sbb_{}_{}", l, r)\
            .add_step([l.load, l.alu_a, r.alu_b, AddSub.out, AddSub.sub, Flags.load, Flags.use_carry])

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("cmp_{}_{}", l, r)\
            .add_step([l.alu_a, r.alu_b, AddSub.out, AddSub.sub, Flags.load])

    for l, r in permute_gp_regs_nsame():
        builder.add_instruction("mov_{}_{}", l, r)\
            .add_step([l.load, r.out])

    for r in gp_regs:
        builder.add_instruction("out_{}", r)\
            .add_step([r.out, OutPort.load])

    for v in gp_regs:
        builder.add_instruction("st_addr_{}", v)\
            .add_step(setup_imm)\
            .add_step([ProgMem.out, Mar.load, PC.count])\
            .add_step([v.out, Ram.write])

    for a, v in permute_gp_regs_all():
        builder.add_instruction("stabs_{}_{}", a, v)\
            .add_step([a.out, Mar.load])\
            .add_step([v.out, Ram.write])

    for r in gp_regs:
        builder.add_instruction("ld_{}_addr", r)\
            .add_step(setup_imm)\
            .add_step([ProgMem.out, Mar.load, PC.count])\
            .add_step([Ram.out, r.load, Flags.load])

    for v, a in permute_gp_regs_all():
        builder.add_instruction("ldabs_{}_{}", v, a)\
            .add_step([a.out, Mar.load])\
            .add_step([v.load, Ram.out, Flags.load])

    for r in gp_regs:
        builder.add_instruction("tstabs_{}", r)\
            .add_step([r.out, Mar.load])\
            .add_step([Ram.out, Flags.load])

    builder.add_instruction("jmp_addr")\
        .add_step(setup_imm)\
        .add_step([ProgMem.out, PC.load])

    builder.add_instruction("beq_addr")\
        .add_step([PC.count])\
        .add_condition(mask=Flags.Z, value=Flags.Z)\
            .add_step(setup_imm)\
            .add_step([ProgMem.out, PC.load])

    builder.add_instruction("bne_addr")\
        .add_step([PC.count])\
        .add_condition(mask=Flags.Z, value=0)\
            .add_step(setup_imm)\
            .add_step([ProgMem.out, PC.load])

    builder.add_instruction("bcs_addr")\
        .add_step([PC.count])\
        .add_condition(mask=Flags.C, value=Flags.C)\
            .add_step(setup_imm)\
            .add_step([ProgMem.out, PC.load])

    builder.add_instruction("bcc_addr")\
        .add_step([PC.count])\
        .add_condition(mask=Flags.C, value=0)\
            .add_step(setup_imm)\
            .add_step([ProgMem.out, PC.load])

    builder.add_instruction("out_F")\
        .add_step([Flags.bus_out, OutPort.load])

    builder.add_instruction("hlt")\
        .add_step([Clock.halt])


    return builder.build()


opcodes = build_opcodes()
