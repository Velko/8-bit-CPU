from .util import ControlSignal
from .devices import Register
from typing import List, Tuple, Mapping, Sequence

class FlagsAlt:
    def __init__(self, owner: 'MicroCode', mask: int, value: int):
        self.owner = owner
        self.mask = mask
        self.value = value
        self.steps: List[Sequence[ControlSignal]] = []

    def add_step(self, step: Sequence[ControlSignal]) -> 'FlagsAlt':
        self.steps.append(step)

        return self

    def add_condition(self, mask: int, value: int) -> 'FlagsAlt':
        return self.owner.add_condition(mask, value)

class MicroCode:
    def __init__(self, opcode: int, name: str):
        self._steps: List[Sequence[ControlSignal]] = []
        self.f_alt: List[FlagsAlt] = []
        self.opcode = opcode
        self.name = name

    def is_flag_dependent(self) -> bool:
        return any(self.f_alt)

    def steps(self, flags: int) -> Sequence[Sequence[ControlSignal]]:
        if self.f_alt:
            matches = list(filter(lambda alt: flags & alt.mask == alt.value, self.f_alt))

            if len(matches) > 1:
                raise Exception("Multiple options found")

            if len(matches) == 1:
                return matches[0].steps

        return self._steps

    def are_default(self, steps: Sequence[Sequence[ControlSignal]]) -> bool:
        return steps == self._steps

    def add_step(self, pins: Sequence[ControlSignal]) -> 'MicroCode':
        self._steps.append(pins)

        return self

    def add_condition(self, mask: int, value: int) -> FlagsAlt:
        alt = FlagsAlt(self, mask, value)
        self.f_alt.append(alt)

        return alt

class MicrocodeBuilder:
    def __init__(self):
        self.opcodes: List[Tuple[str, MicroCode]] = []

    def add_instruction(self, name: str, *fmt: Register) -> MicroCode:
        opcode = name.format(*fmt)
        ucode = MicroCode(len(self.opcodes), opcode)

        self.opcodes.append((opcode, ucode))
        return ucode

    def build(self) -> Mapping[str, MicroCode]:
        return dict(self.opcodes)
