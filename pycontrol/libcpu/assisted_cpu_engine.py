from collections.abc import Sequence
from .markers import AddrBase
from .devices import Flags
from .pseudo_devices import ImmediateValue, IOMonitor
from .DeviceSetup import hardware
from .opcodes import opcodes, ops_by_code, fetch, InvalidOpcodeException
from .pinclient import PinClient
from .ctrl_word import CtrlWord
from .pin import ControlSignal
from .messages import RunMessage, OutMessage, HaltMessage, BrkMessage

class AssistedCPUEngine:
    def __init__(self, client: PinClient) -> None:
        self.client = client
        self.flags_cache: Flags | None = None
        self.opcode_cache: int | None = None
        self.op_extension = 0

        self.iomon = IOMonitor()

        # RAM hooks
        self.imm = ImmediateValue()
        hardware.ProgMem.out.forward_enable = False

    def execute_mnemonic(self, mnemonic: str, arg: int | AddrBase | None = None) -> RunMessage | None:
        if not mnemonic in opcodes:
            raise InvalidOpcodeException(mnemonic)

        self.imm.inject(arg)

        return self.execute_opcode(opcodes[mnemonic].opcode)

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
            microcode = ops_by_code[self.get_opcode_cached()]
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

        for pin in microstep:
            control.enable(pin)

        result: RunMessage | None = None

        if control.c_word != hardware.DEFAULT_CW.c_word:

            self.client.ctrl_commit(control)

            if hardware.ProgMem.out.check_enabled(control.c_word):
                self.imm.publish(self.client)

            # capture port output BEFORE clock tick.
            # TODO: think of more reliable approach
            # this probably messes up the immediate value on the Bus
            if hardware.IOCtl is not None and control.is_enabled(hardware.IOCtl.laddr):
                self.iomon.select_port(self.client.bus_get())

            if hardware.IOCtl is not None and control.is_enabled(hardware.IOCtl.to_dev):
                result = self.iomon.format_value(self.client.bus_get())

            self.client.clock_tick()

            if control.is_enabled(hardware.PC.load):
                self.imm.invalidate()

            if control.is_enabled(hardware.F.calc) or control.is_enabled(hardware.F.load):
                self.flags_cache = None

            if control.is_enabled(hardware.Clock.halt):
                result = HaltMessage()

            if control.is_enabled(hardware.Clock.brk):
                result = BrkMessage()

            if isinstance(result, OutMessage):
                # if we have captured a simulated OutMessage,
                # hardware should also produced one
                # consume and (potantially) verify it
                hw_message = self.client.receive_message()
                # not sure if really need to assert, but Ok for now
                assert isinstance(hw_message, OutMessage)
                assert hw_message.payload == result.payload
                assert hw_message.target == result.target


            # Drop current opcode since it was a prefix for extended one
            if control.is_enabled(hardware.StepCounter.extended):
                self.opcode_cache = None
                self.op_extension += 1

        self.imm.unpublish(self.client)
        hardware.ProgMem.out.apply_disable(control.c_word)

        return result

    def get_flags_cached(self) -> Flags:
        if self.flags_cache is None:
            self.flags_cache = Flags(self.client.flags_get())

        return self.flags_cache

    def get_opcode_cached(self) -> int:
        if self.opcode_cache is None:
            self.opcode_cache = self.client.ir_get() + (self.op_extension * 0x100)

        if self.opcode_cache >= len(ops_by_code):
            raise InvalidOpcodeException(self.opcode_cache)

        return self.opcode_cache



    def fetch_and_execute(self) -> RunMessage | None:
        # fetch the instruction
        for microstep in fetch:
            self.execute_step(microstep)

        # and execute it (will retrieve opcode automatically)
        return self.execute_opcode(None)
