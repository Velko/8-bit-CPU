from collections.abc import Sequence, Iterator
from typing import Tuple
from unittest import case
from .pin import ControlSignal
from .instruction_cfg import InstructionConfig, Instruction
from .DeviceSetup import hardware
from .opcode_builder import MicrocodeBuilder, MicroCode, OpcodeArg
from .devices import Register, GPRegister, Flags
import os.path

gp_regs: list[GPRegister] = [r for r in hardware.devices.values() if isinstance(r, GPRegister)]

_ops_by_str: dict[str, MicroCode] = {}

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
    microcode = _ops_by_str.get(instr)
    if microcode is None:
        microcode = next((op for op in ops_by_num if op.opstr == instr), None)
        if microcode is None:
            raise InvalidOpcodeException(instr)
        _ops_by_str[instr] = microcode
    return microcode.opcode

def resolve_pin(name: str, **kwargs: Register) -> ControlSignal:
    dev, pin = name.split('.')
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
    elif name == "PCREL":
        return OpcodeArg.PCREL
    elif name in kwargs:
        return kwargs[name]
    elif name in hardware.devices:
        return hardware.get_typed_dev(name, Register)
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
    t_instr = builder.add_instruction(instr, *args)
    for step in instr.steps:
        t_instr.add_step(*[resolve_pin(pin, **kwargs) for pin in step])
    for cond in instr.conditions:
        t_cond = t_instr.add_condition(*map_flags(cond.match))
        for step in cond.steps:
            t_cond.add_step(*[resolve_pin(pin, **kwargs) for pin in step])


def build_opcodes(yaml_path: str) -> tuple[list[list[ControlSignal]], list[MicroCode]]:

    icfg = InstructionConfig.load_from_yaml(yaml_path)

    reserved_opcodes = set(i.opcode for i in icfg.instructions if i.opcode is not None)
    builder = MicrocodeBuilder(reserved_opcodes)

    fetch = [[resolve_pin(pin) for pin in step] for step in icfg.fetch]

    for instr in icfg.instructions:
        if instr.opcode is not None and len(instr.repeat) > 0:
            raise ValueError(f"Opcode should not be specified for repeated instruction: {instr.name}")

        if len(instr.repeat) == 0:
            add_instruction(builder, instr)
        else:
            for rep in instr.repeat:
                if rep in icfg.regsets:
                    for reg in icfg.regsets[rep]:
                        add_instruction(builder, instr, r0=hardware.get_typed_dev(reg, Register))
                elif rep == "gp_reg_pair_all":
                    for l, r in permute_gp_regs_all():
                        add_instruction(builder, instr, r0=l, r1=r)
                elif rep == "gp_reg_pair_different":
                    for l, r in permute_gp_regs_nsame():
                        add_instruction(builder, instr, r0=l, r1=r)
                else:
                    raise ValueError(f"Unsupported repeat type: {rep}")

    return fetch, builder.build()


fetch, ops_by_num = build_opcodes(os.path.join(os.path.dirname(__file__), "../../include/instructions.yaml"))
