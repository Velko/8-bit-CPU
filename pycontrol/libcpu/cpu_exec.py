from .pseudo_devices import Imm, EnableCallback
from .DeviceSetup import OutPort, ProgMem
from .opcodes import opcodes, fetch

class CPUBackendControl:
    def __init__(self, client, control):
        self.client = client
        self.control = control
        self.out_hooked_val = None

        Imm.connect(self.client)

        # hook into ProgMem read routine
        ProgMem.ram_out = EnableCallback(Imm.enable_out)


    def execute_opcode(self, opcode, arg=None):
        if not opcode in opcodes:
            raise InvalidOpcodeException(opcode)

        Imm.set(arg)

        microcode = opcodes[opcode]

        flags = None

        if microcode.is_flag_dependent():
            flags = self.client.flags_get()

        steps = microcode.steps(flags)
        for microstep in steps:
            self.execute_step(microstep)

        Imm.clear()

        return not microcode.are_default(steps), self.out_hooked_val

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
            if OutPort.load.is_enabled():
                self.client.clock_pulse()
                self.out_hooked_val = self.client.bus_get()
                self.client.clock_inverted()
            else:
                self.client.clock_tick()

        Imm.disable()

class InvalidOpcodeException(Exception):
    pass
