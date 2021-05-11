from .opcodes import opcodes, fetch
from .DeviceSetup import PC, ProgMem
from .markers import org, Bytes, Label, AddrBase
from typing import List, Union, Iterator, Optional, Sequence, Tuple, BinaryIO
from .util import UninitializedError, ControlSignal
from .cpu import CPUBackend, InvalidOpcodeException

class ProgramInstruction:
    def __init__(self, address: int, opcode: str):
        self.address = address
        self.opcode = opcode
        self.bin_opcode: Optional[int] = None
        self.args: List[Union[int, AddrBase]] = []

    def eval_args(self) -> Iterator[int]:
        for arg in self.args:
            if isinstance(arg, int):
                yield arg
            elif isinstance(arg, Bytes):
                yield arg.start
            elif isinstance(arg, Label):
                if arg.addr is None: raise UninitializedError
                yield arg.addr
            else:
                raise TypeError


    def print(self) -> None:

        argstr = "".join(map(lambda a: " {:02x}".format(a), self.eval_args()))

        print ("{:02x}  {:8}{}".format(self.address, self.opcode, argstr))

    def write_bytes(self, stream: BinaryIO) -> None:
        if self.bin_opcode is None: raise UninitializedError

        binary = bytes([self.bin_opcode] + list(self.eval_args()))
        stream.write(binary)

class CPUBackendAssemble(CPUBackend):
    def __init__(self) -> None:
        self.addr_counter = 0
        self.program: List[ProgramInstruction] = []

    def advance_counter(self, steps: Sequence[Sequence[ControlSignal]])->None:
        for step in steps:
            if PC.count in step:
                self.addr_counter +=1

        org(self.addr_counter)

    def execute_opcode(self, opcode: str, arg: Union[None, int, AddrBase]=None) -> Tuple[bool, Optional[int]]:
        if not opcode in opcodes:
            raise InvalidOpcodeException(opcode)

        instr = ProgramInstruction(self.addr_counter, opcode)
        self.program.append(instr)

        if arg is not None:
            instr.args.append(arg)

        self.advance_counter(fetch._steps)

        microcode = opcodes[opcode]

        instr.bin_opcode = microcode.opcode

        #self.advance_counter(microcode._steps) jump does not increase PC,
        # quick workaround
        if arg is not None:
            self.addr_counter +=1
            org(self.addr_counter)

        return False, None

    def list(self) -> None:
        for instr in self.program:
            instr.print()

    def bin(self, stream: BinaryIO) -> None:
        for instr in self.program:
            instr.write_bytes(stream)