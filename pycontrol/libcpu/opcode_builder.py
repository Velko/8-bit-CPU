from enum import Enum
from collections.abc import Mapping, Sequence
from .pin import ControlSignal
from .devices import Register, Flags

class InvalidInstructionDefinition(Exception):
    pass

class FlagsAlt:
    def __init__(self, owner: 'MicroCode', mask: Flags, value: Flags):
        self.owner = owner
        self.mask = mask
        self.value = value
        self.steps: list[Sequence[ControlSignal]] = []

    def add_step(self, *args: ControlSignal) -> 'FlagsAlt':
        self.steps.append(args)

        return self

    def add_condition(self, mask: Flags, value: Flags) -> 'FlagsAlt':
        return self.owner.add_condition(mask, value)


class OpcodeArg(Enum):
    BYTE = 1
    ADDR = 2

    def __str__(self) -> str:
        match self:
            case OpcodeArg.BYTE:
                return "imm"
            case OpcodeArg.ADDR:
                return "addr"

        raise TypeError # suppress warning, something's really wrong

class MicroCode:
    def __init__(self, opcode: int, name: str, hidden: bool, fmt: str | None, args: Sequence[Register | OpcodeArg]):
        self._steps: list[Sequence[ControlSignal]] = []
        self.f_alt: list[FlagsAlt] = []
        self.opcode = opcode
        self.name = name
        self.hidden = hidden
        self.args = args
        self.fmt = fmt
        self.opstr = "_".join([name] + list(map(str, args)))


    def is_flag_dependent(self) -> bool:
        return any(self.f_alt)

    def get_step(self, step_index: int, flags: Flags) -> tuple[Sequence[ControlSignal], bool]:
        matches = list(filter(lambda alt: flags & alt.mask == alt.value, self.f_alt))

        if len(matches) > 1:
            raise InvalidInstructionDefinition("Multiple options found")

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

    def add_condition(self, mask: Flags, value: Flags) -> FlagsAlt:
        alt = FlagsAlt(self, mask, value)
        self.f_alt.append(alt)

        return alt

class MicrocodeBuilder:
    def __init__(self) -> None:
        self.opcodes: list[MicroCode] = []

    def add_instruction(self, name: str, hidden: bool, fmt: str | None, *args: Register | OpcodeArg) -> MicroCode:

        ucode = MicroCode(len(self.opcodes), name, hidden, fmt, args)

        self.opcodes.append(ucode)
        return ucode

    def build(self) -> list[MicroCode]:
        return self.opcodes
