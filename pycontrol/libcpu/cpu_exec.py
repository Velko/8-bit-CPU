from typing import Union, Tuple, Optional, Sequence
from .markers import Bytes, Label
from .pseudo_devices import Imm, EnableCallback
from .DeviceSetup import OutPort, ProgMem, PC, Flags
from .opcodes import opcodes, fetch
from .cpu import CPUBackend, InvalidOpcodeException
from .pinclient import PinClient
from .ctrl_word import CtrlWord
from .util import ControlSignal

class CPUBackendControl(CPUBackend):
    def __init__(self, client: PinClient, control: CtrlWord):
        self.client = client
        self.control = control
        self.out_hooked_val: Optional[int] = None
        self.branch_taken = False
        self.flags_cache: Optional[int] = None

        Imm.connect(self.client)

        # hook into ProgMem read routine
        ProgMem.hook_out(EnableCallback(Imm.enable_out, ProgMem.out))


    def execute_opcode(self, opcode: str, arg: Union[None, int, Bytes, Label]=None) -> Tuple[bool, Optional[int]]:
        if not opcode in opcodes:
            raise InvalidOpcodeException(opcode)

        Imm.set(arg)
        self.branch_taken = False

        microcode = opcodes[opcode]

        steps = microcode.steps(lambda: self.get_flags_cached())
        for microstep in steps:
            self.execute_step(microstep)

        Imm.clear()

        return self.branch_taken, self.out_hooked_val

    def execute_step(self, microstep: Sequence[ControlSignal]) -> None:
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

            if PC.load.is_enabled():
                self.branch_taken = True
                Imm.clear() # immediate becomes invalid

            if PC.count.is_enabled():
                Imm.consume() # next byte for imm value

            if Flags.calc.is_enabled() or Flags.load.is_enabled():
                self.flags_cache = None

        Imm.disable()

    def get_flags_cached(self) -> int:
        if self.flags_cache is None:
            self.flags_cache = self.client.flags_get()

        return self.flags_cache