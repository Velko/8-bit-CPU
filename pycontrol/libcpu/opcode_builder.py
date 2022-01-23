from enum import Enum
from .util import ControlSignal
from .devices import Register
from typing import List, Optional, Tuple, Mapping, Sequence, Callable, Iterator, Union

class FlagsAlt:
    def __init__(self, owner: 'MicroCode', mask: int, value: int):
        self.owner = owner
        self.mask = mask
        self.value = value
        self.steps: List[Sequence[ControlSignal]] = []

    def add_step(self, *args: ControlSignal) -> 'FlagsAlt':
        self.steps.append(args)

        return self

    def add_condition(self, mask: int, value: int) -> 'FlagsAlt':
        return self.owner.add_condition(mask, value)


class OpcodeArg(Enum):
    BYTE = 1
    ADDR = 2

    def __str__(self) -> str:
        if (self == OpcodeArg.BYTE): return "imm"
        if (self == OpcodeArg.ADDR): return "addr"

        raise TypeError # suppress warning, something's really wrong

class MicroCode:
    def __init__(self, opcode: int, name: str, args: Sequence[Union[Register, OpcodeArg]]):
        self._steps: List[Sequence[ControlSignal]] = []
        self.f_alt: List[FlagsAlt] = []
        self.opcode = opcode
        self.name = name
        self.args = args


    def is_flag_dependent(self) -> bool:
        return any(self.f_alt)

    def get_step(self, step_index: int, flags: int) -> Tuple[Sequence[ControlSignal], bool]:
        matches = list(filter(lambda alt: flags & alt.mask == alt.value, self.f_alt))

        if len(matches) > 1:
            raise Exception("Multiple options found")

        if len(matches) == 1:
            steps = matches[0].steps
        else:
            steps = self._steps

        if step_index < len(steps):
            return steps[step_index], step_index == len(steps) - 1

        return [], False

    def add_step(self, *args: ControlSignal) -> 'MicroCode':
        self._steps.append(args)

        return self

    def add_condition(self, mask: int, value: int) -> FlagsAlt:
        alt = FlagsAlt(self, mask, value)
        self.f_alt.append(alt)

        return alt

class MicrocodeBuilder:
    def __init__(self) -> None:
        self.opcodes: List[Tuple[str, MicroCode]] = []

    def add_instruction(self, name: str, *args: Union[Register, OpcodeArg]) -> MicroCode:
        opcode = "_".join([name] + list(map(lambda a: str(a), args)))
        ucode = MicroCode(len(self.opcodes), name, args)

        self.opcodes.append((opcode, ucode))
        return ucode

    def build(self) -> Tuple[Mapping[str, MicroCode], List[MicroCode]]:
        return dict(self.opcodes), list(map(lambda o: o[1], self.opcodes))
