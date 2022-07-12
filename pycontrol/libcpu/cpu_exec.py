from typing import List, Union, Tuple, Optional, Sequence
from .markers import AddrBase
from .pseudo_devices import Imm
from .DeviceSetup import IOCtl, ProgMem, PC, Flags, StepCounter
from .opcodes import opcodes, ops_by_code, fetch
from .pinclient import PinClient
from .ctrl_word import CtrlWord
from .util import ControlSignal

class InvalidOpcodeException(Exception):
    pass

class CPUBackendControl:
    def __init__(self) -> None:
        self.client = PinClient()
        self.control = CtrlWord()
        self.branch_taken = False
        self.flags_cache: Optional[int] = None
        self.opcode_cache: Optional[int] = None
        self.op_extension = 0

        # RAM hooks
        Imm.connect(self.client)
        ProgMem.hook_out(Imm)

    def execute_mnemonic(self, mnemonic: str, arg: Union[None, int, AddrBase]=None) -> bool:
        if not mnemonic in opcodes:
            raise InvalidOpcodeException(mnemonic)

        Imm.inject(arg)

        exec_result = self.execute_opcode(opcodes[mnemonic].opcode)

        return exec_result

    def execute_opcode(self, opcode: Optional[int]) -> bool:

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
            microstep, is_last = microcode.get_step(s_idx - self.op_extension , self.get_flags_cached())
            if is_last:
                fin_steps: List[ControlSignal] = [StepCounter.reset]
                fin_steps.extend(microstep)
                self.execute_step(fin_steps)
                break
            else:
                self.execute_step(microstep)

        return self.branch_taken

    def execute_step(self, microstep: Sequence[ControlSignal]) -> None:
        self.control.reset()

        for pin in microstep:
            pin.enable()

        if self.control.c_word != self.control.default:

            self.client.ctrl_commit(self.control.c_word)


            if IOCtl.laddr.is_enabled():
                IOCtl.select_port(self.client.bus_get())

            if IOCtl.to_dev.is_enabled():
                IOCtl.push_value(self.client.bus_get())

            self.client.clock_tick()

            if PC.load.is_enabled():
                self.branch_taken = True
                Imm.invalidate()

            if PC.inc.is_enabled():
                Imm.consume() # next byte for imm value

            if Flags.calc.is_enabled() or Flags.load.is_enabled():
                self.flags_cache = None

            # Drop current opcode since it was a prefix for extended one
            if StepCounter.extended.is_enabled():
                self.opcode_cache = None
                self.op_extension += 1

        Imm.release_bus()

    def get_flags_cached(self) -> int:
        if self.flags_cache is None:
            self.flags_cache = self.client.flags_get()

        return self.flags_cache

    def get_opcode_cached(self) -> int:
        if self.opcode_cache is None:
            self.opcode_cache = self.client.ir_get() + (self.op_extension * 0x100)

        if self.opcode_cache >= len(ops_by_code):
            raise InvalidOpcodeException(self.opcode_cache)

        return self.opcode_cache



    def fetch_and_execute(self) -> None:
        # fetch the instruction
        for microstep in fetch:
            self.execute_step(microstep)

        # and execute it (will retrieve opcode automatically)
        _ = self.execute_opcode(None)
