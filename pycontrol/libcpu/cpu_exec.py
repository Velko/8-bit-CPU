from typing import Union, Tuple, Optional, Sequence
from .opcode_builder import MicroCode
from .markers import AddrBase
from .pseudo_devices import Imm, EnableCallback
from .DeviceSetup import IRFetch, OutPort, ProgMem, PC, Flags, StepCounter
from .opcodes import opcodes, ops_by_code, fetch
from .cpu import CPUBackend, InvalidOpcodeException, ret
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
        self.opcode_cache: Optional[int] = None
        self.op_extension = 0

        # prepare control word for IRFetch
        self.control.reset()
        IRFetch.load.enable()
        self.irf_word = control.c_word

        # RAM hooks
        Imm.connect(self.client)
        ProgMem.hook_out(Imm)

    def execute_mnemonic(self, mnemonic: str, arg: Union[None, int, AddrBase]=None) -> Tuple[bool, Optional[int]]:
        if not mnemonic in opcodes:
            raise InvalidOpcodeException(mnemonic)

        Imm.set(arg)

        exec_result = self.execute_opcode(opcodes[mnemonic].opcode)

        Imm.clear()

        return exec_result

    def execute_opcode(self, opcode: Optional[int]) -> Tuple[bool, Optional[int]]:

        # reset op_extension when starting new instruction
        # the variable adds multiples of 256 to the opcode from IR and
        # also simulates skipping microstep counter increment
        # see get_opcode_cached() and parameter for get_step()
        self.op_extension = 0

        # Reset/force current opcode
        self.opcode_cache = opcode

        self.branch_taken = False

        for s_idx in range(8-len(fetch)):
            # re-evaluate opcode, as it may change mid-instruction (when extended is loaded)
            microcode = ops_by_code[self.get_opcode_cached()]
            microstep = microcode.get_step(s_idx - self.op_extension , self.get_flags_cached())
            if microstep is None: break
            self.execute_step(microstep)

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

            if PC.out.is_enabled():
                Imm.consume() # next byte for imm value

            if Flags.calc.is_enabled() or Flags.load.is_enabled():
                self.flags_cache = None

        Imm.disable()

    def get_flags_cached(self) -> int:
        if self.flags_cache is None:
            self.flags_cache = self.client.flags_get()

        return self.flags_cache

    def get_opcode_cached(self) -> int:
        if self.opcode_cache is None:
            self.opcode_cache = self.client.ir_get(self.irf_word) + (self.op_extension * 0x100)

        if self.opcode_cache >= len(ops_by_code):
            raise InvalidOpcodeException(self.opcode_cache)

        return self.opcode_cache



    def fetch_and_execute(self) -> Optional[int]:
        # fetch the instruction
        for microstep in fetch:
            self.execute_step(microstep)

        # and execute it (will retrieve opcode automatically)
        _, outval = self.execute_opcode(None)

        return outval
