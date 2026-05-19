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

def resolve_arg(spec: str | dict[str, str]) -> Register | OpcodeArg:
    if isinstance(spec, dict):
        if len(spec) != 1:
            raise ValueError(f"Invalid argument specification: {spec}")
        name =  next(iter(spec))
    else:
        name = spec
    if name == "ADDR":
        return OpcodeArg.ADDR
    elif name == "BYTE":
        return OpcodeArg.BYTE
    elif name == "PCREL":
        return OpcodeArg.PCREL
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

def add_instruction(builder: MicrocodeBuilder, instr: Instruction, keys: list[str], argmap: dict[str, str]) -> None:
    args = [ resolve_arg(argmap[a]) for a in keys ]
    rdevs = dict(zip(keys, args))
    t_instr = builder.add_instruction(instr, *args)
    for step in instr.steps:
        t_instr.add_step(*[resolve_pin(pin, **rdevs) for pin in step])
    for cond in instr.conditions:
        t_cond = t_instr.add_condition(*map_flags(cond.match))
        for step in cond.steps:
            t_cond.add_step(*[resolve_pin(pin, **rdevs) for pin in step])

def evaluate_args(builder: MicrocodeBuilder, instr: Instruction, keys, values, argsource, regsets):

        if len(argsource) == 0:
            print (f"Arguments collected: {keys} -> {values}")
            add_instruction(builder, instr, keys, dict(zip(keys, values)))
            return
        arg = argsource[0]
        if isinstance(arg, dict):
            if len(arg) != 1:
                raise ValueError(f"Invalid argument specification: {arg}")
            name, rsname = next(iter(arg.items()))
            only_unique = rsname[0] == "^"
            if only_unique:
                rsname = rsname[1:]
            rs = regsets.get(rsname)
            if rs is None:
                raise ValueError(f"Unknown register set: {rsname}")
            newkeys = keys + [name]
            for reg in rs:
                if only_unique and reg in values:
                    continue
                newvalues = values + [reg]
                evaluate_args(builder, instr, newkeys, newvalues, argsource[1:], regsets)
        else:
            newkeys = keys + [arg]
            newvalues = values + [arg]
            evaluate_args(builder, instr, newkeys, newvalues, argsource[1:], regsets)



def build_opcodes(yaml_path: str) -> tuple[list[list[ControlSignal]], list[MicroCode]]:

    icfg = InstructionConfig.load_from_yaml(yaml_path)

    reserved_opcodes = set(i.opcode for i in icfg.instructions if i.opcode is not None)
    builder = MicrocodeBuilder(reserved_opcodes)

    fetch = [[resolve_pin(pin) for pin in step] for step in icfg.fetch]

    for instr in icfg.instructions:
        if instr.opcode is not None and any(isinstance(a, dict) for a in instr.args):
            raise ValueError(f"Opcode should not be specified for repeated instruction: {instr.name}")

        print (f"\nProcessing instruction: {instr.name}")

        arglist: list[str] = []
        keys: list[str] = []
        argsource = instr.args
        evaluate_args(builder, instr, keys, arglist, argsource, icfg.regsets)

    return fetch, builder.build()


fetch, ops_by_num = build_opcodes(os.path.join(os.path.dirname(__file__), "../../include/instructions.yaml"))
