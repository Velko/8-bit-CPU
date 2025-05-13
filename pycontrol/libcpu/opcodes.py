from collections.abc import Sequence, Iterator, Mapping
from typing import Tuple
from libcpu.util import ControlSignal
from .instruction_cfg import InstructionConfig, Repeat, Instruction
from .DeviceSetup import hardware, PC, IR, Clock, IOCtl, TL, TH, TX, SP, SDP, TDP, LR, ACalc, StepCounter
from .opcode_builder import MicrocodeBuilder, MicroCode, OpcodeArg
from .devices import Register, GPRegister, Flags
import os.path

gp_regs: list[GPRegister] = [r for r in hardware.gp_registers.values()]

fetch: list[Sequence[ControlSignal]] = []

class InvalidOpcodeException(Exception):
    pass

def permute_gp_regs_all() -> Iterator[tuple[GPRegister, GPRegister]]:
    for l in gp_regs:
        for r in gp_regs:
            yield l, r


def permute_gp_regs_nsame() -> Iterator[tuple[GPRegister, GPRegister]]:
    for l in gp_regs:
        for r in gp_regs:
            if l != r:
                yield l, r

def permute_regs_lr(lregs: Sequence[Register], rregs: Sequence[Register]) -> Iterator[tuple[Register, Register]]:
    for l in lregs:
        for r in rregs:
            yield l, r

def opcode_of(instr: str) -> int:
    if not instr in opcodes:
        raise InvalidOpcodeException(instr)
    return opcodes[instr].opcode

def resolve_pin(name: str, **kwargs: Register) -> ControlSignal:
    dev, pin = name.split('.')
    device = globals().get(dev)
    if device is None:
        device = hardware.get(dev)
    if device is None:
        device = kwargs.get(dev)
    if device is None:
        raise ValueError(f"Unknown device: {dev}")
    signal = getattr(device, pin, None)
    if isinstance(signal, ControlSignal):
        return signal;
    else:
        raise ValueError(f"Unknown pin: {pin} on device: {dev}")

def resolve_arg(name: str, **kwargs: Register) -> Register | OpcodeArg:
    if name == "ADDR":
        return OpcodeArg.ADDR
    elif name == "BYTE":
        return OpcodeArg.BYTE
    elif name in kwargs:
        return kwargs[name]
    elif name in globals():
        reg = globals()[name]
        if isinstance(reg, Register):
            return reg
        else:
            raise ValueError(f"{name} is not a register")
    else:
        raise ValueError(f"Unknown argument type: {name}")

def map_flags(flags: dict[str, bool]) -> Tuple[Flags, Flags]:
    mask = Flags.Empty
    value = Flags.Empty

    for k, v in flags.items():
        mask |= getattr(Flags, k)
        if v:
            value |= getattr(Flags, k)

    return mask, value

def add_instruction(builder: MicrocodeBuilder, instr: Instruction, **kwargs: Register) -> None:
    args = [ resolve_arg(a, **kwargs) for a in instr.args ]
    if instr.format:
        t_instr = builder.add_formatted(instr.name, instr.format, *args)
    else:
        t_instr = builder.add_instruction(instr.name, *args)
    for step in instr.steps:
        t_instr.add_step(*[resolve_pin(pin, **kwargs) for pin in step])
    for cond in instr.conditions:
        t_cond = t_instr.add_condition(*map_flags(cond.match))
        for step in cond.steps:
            t_cond.add_step(*[resolve_pin(pin, **kwargs) for pin in step])


def build_opcodes() -> tuple[Mapping[str, MicroCode], list[MicroCode]]:

    builder = MicrocodeBuilder()

    yaml_path = os.path.join(os.path.dirname(__file__), "../../include/instructions.yaml")
    icfg = InstructionConfig.load_from_yaml(yaml_path)

    global fetch
    fetch = [[resolve_pin(pin) for pin in step] for step in icfg.fetch]

    for instr in icfg.instructions:
        match instr.repeat:
            case Repeat.once:
                add_instruction(builder, instr)

            case Repeat.gp_regs:
                for r in gp_regs:
                    add_instruction(builder, instr, reg=r)

            case Repeat.gp_reg_pair_all:
                for l, r in permute_gp_regs_all():
                    add_instruction(builder, instr, left=l, right=r)
            case Repeat.gp_reg_pair_different:
                for l, r in permute_gp_regs_nsame():
                    add_instruction(builder, instr, left=l, right=r)

    return builder.build()


opcodes, ops_by_code = build_opcodes()
