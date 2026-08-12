from collections.abc import Sequence
from .markers import AddrBase
from .devices import Flags
from .pseudo_devices import ImmediateValue, IOMonitor
from .DeviceSetup import hardware
from .opcodes import ops_by_num, fetch, InvalidOpcodeException
from .pinclient import PinClient
from .ctrl_word import CtrlWord
from .pin import ControlSignal
from .messages import RunMessage

class AssistedCPUEngine:
    def __init__(self, client: PinClient) -> None:
        self.client = client
        self.flags_cache: Flags | None = None
        self.opcode_cache: int | None = None
        self.op_extension = 0

        self.iomon = IOMonitor()

        # RAM hooks
        self.imm = ImmediateValue()

        self.ops_by_str = {op.opstr: op for op in ops_by_num}

    def execute_mnemonic(self, mnemonic: str, arg: int | AddrBase | None = None) -> RunMessage | None:
        if not mnemonic in self.ops_by_str:
            raise InvalidOpcodeException(mnemonic)

        self.imm.inject(arg)

        return self.execute_opcode(self.ops_by_str[mnemonic].opcode)

    def execute_opcode(self, opcode: int | None) -> RunMessage | None:

        # reset op_extension when starting new instruction
        # the variable adds multiples of 256 to the opcode from IR and
        # also simulates skipping microstep counter increment
        # see get_opcode_cached() and parameter for get_step()
        self.op_extension = 0

        # Reset/force current opcode
        self.opcode_cache = opcode

        for s_idx in range(8-len(fetch)):
            # re-evaluate opcode, as it may change mid-instruction (when extended is loaded)
            microcode = ops_by_num[self.get_opcode_cached()]
            microstep, is_last = microcode.get_step(s_idx - self.op_extension , self.get_flags_cached())
            if is_last:
                fin_steps: list[ControlSignal] = [hardware.StepCounter.reset]
                fin_steps.extend(microstep)
                return self.execute_step(fin_steps)
            # only last step is expected to produce RunMessage
            step_result = self.execute_step(microstep)
            assert step_result is None
        return None

    def execute_step(self, microstep: Sequence[ControlSignal]) -> RunMessage | None:
        control = CtrlWord()

        progmem_out = False
        for pin in microstep:
            if pin == hardware.ProgMem.out and self.imm.has_value():
                # special handling for ProgMem.out to allow ImmediateValue to
                # hijack the output if python code needs to inject a value.
                # For example, when acpu.ldi() is executed from tests.
                # It should fall back to normal ProgMem.out behavior when nothing
                # is injected, to allow step-execution in debugger.
                progmem_out = True
            else:
                control.enable(pin)

        result: RunMessage | None = None

        self.client.ctrl_commit(control)

        if progmem_out:
            self.imm.publish(self.client)

        # capture port selection BEFORE clock tick. This is important for the decision
        # whether the instruction will produce an output message
        if hardware.IOCtl is not None and control.is_enabled(hardware.IOCtl.laddr):
            self.iomon.select_port(self.client.bus_get())

        self.client.clock_tick()

        if control.is_enabled(hardware.PC.load):
            self.imm.invalidate()

        if control.is_enabled(hardware.F.calc) or control.is_enabled(hardware.F.load):
            self.flags_cache = None

        if control.is_enabled(hardware.Clock.halt) or \
            control.is_enabled(hardware.Clock.brk) or \
            (control.is_enabled(hardware.IOCtl.to_dev) and self.iomon.active_port_produces_output()):
            result = self.client.receive_message()

        # Drop current opcode since it was a prefix for extended one
        if control.is_enabled(hardware.StepCounter.extended):
            self.opcode_cache = None
            self.op_extension += 1

        self.imm.unpublish(self.client)

        return result

    def get_flags_cached(self) -> Flags:
        if self.flags_cache is None:
            self.flags_cache = Flags(self.client.flags_get())

        return self.flags_cache

    def get_opcode_cached(self) -> int:
        if self.opcode_cache is None:
            self.opcode_cache = self.client.ir_get() + (self.op_extension * 0x100)

        if self.opcode_cache >= len(ops_by_num):
            raise InvalidOpcodeException(self.opcode_cache)

        return self.opcode_cache



    def fetch_and_execute(self) -> RunMessage | None:
        # fetch the instruction
        for microstep in fetch:
            self.execute_step(microstep)

        # and execute it (will retrieve opcode automatically)
        return self.execute_opcode(None)

def check_pcrel(offset: int) -> None:
    if not (-128 <= offset <= 127):
        raise ValueError(f"PC-relative offset {offset} out of range [-128, 127]")

