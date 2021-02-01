from .pseudo_devices import Imm, OutPort, PC
from .opcodes import opcodes

class CPUBackendControl:
    def __init__(self, client, control):
        self.client = client
        self.control = control

        Imm.connect(self.client)
        OutPort.connect(self.client)
        PC.connect(self.client)

    def execute_opcode(self, opcode, arg=None):
        if not opcode in opcodes:
            raise InvalidOpcodeException(opcode)

        Imm.set(arg)

        # fetch is emulated, it always advances PC by one
        PC.advance()

        microcode = opcodes[opcode]

        flags = None

        if microcode.is_flag_dependent():
            flags = self.client.flags_get()

        steps = microcode.steps(flags)
        for microstep in steps:
            self.execute_step(microstep)

        Imm.clear()

        return not microcode.are_default(steps), OutPort.value

    def execute_step(self, microstep):
        self.control.reset()

        for pin in microstep:
            pin.enable()

        if self.control.c_word != self.control.default:

            self.client.ctrl_commit(self.control.c_word)


            # special handling when reading the bus: it should
            # be done on "rising edge" - after primary clock
            # has rised, but inverted is not
            # in other cases it does not matter, using faster
            # version
            if OutPort.active:
                self.client.clock_pulse()
                OutPort.read_bus()
                self.client.clock_inverted()
            else:
                self.client.clock_tick()

            if PC.c_enabled:
                PC.advance()

        OutPort.disable()
        PC.disable()
        Imm.disable()

class InvalidOpcodeException(Exception):
    pass
