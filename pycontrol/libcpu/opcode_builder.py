class FlagsAlt:
    def __init__(self, owner, mask, value):
        self.owner = owner
        self.mask = mask
        self.value = value
        self.steps = []

    def add_step(self, step):
        self.steps.append(step)

        return self

    def add_condition(self, mask, value):
        return self.owner.add_condition(mask, value)

class MicroCode:
    def __init__(self, opcode):
        self._steps = []
        self.f_alt = []
        self.opcode = opcode

    def is_flag_dependent(self):
        return any(self.f_alt)

    def steps(self, flags):
        if self.f_alt:
            matches = list(filter(lambda alt: flags & alt.mask == alt.value, self.f_alt))

            if len(matches) > 1:
                raise Exception("Multiple options found")

            if len(matches) == 1:
                return matches[0].steps

        return self._steps

    def are_default(self, steps):
        return steps == self._steps

    def add_step(self, pins):
        self._steps.append(pins)

        return self

    def add_condition(self, mask, value):
        alt = FlagsAlt(self, mask, value)
        self.f_alt.append(alt)

        return alt

class MicrocodeBuilder:
    def __init__(self):
        self.opcodes = []

    def add_instruction(self, name, *fmt):
        opcode = name.format(*fmt)
        ucode = MicroCode(len(self.opcodes))

        self.opcodes.append((opcode, ucode))
        return ucode

    def build(self):
        return dict(self.opcodes)
