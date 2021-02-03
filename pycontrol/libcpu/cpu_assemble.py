from .opcodes import opcodes, fetch
from .DeviceSetup import PC, ProgMem
from .markers import org, Bytes, Label

class ProgramInstruction:
    def __init__(self, address, opcode):
        self.address = address
        self.opcode = opcode
        self.args = []

    def eval_args(self):
        for arg in self.args:
            if isinstance(arg, int):
                yield arg
            elif isinstance(arg, Bytes):
                yield arg.start
            elif isinstance(arg, Label):
                yield arg.addr
            else:
                raise TypeError


    def print(self):

        argstr = "".join(map(lambda a: " {:02x}".format(a), self.eval_args()))

        print ("{:02x}  {:8}{}".format(self.address, self.opcode, argstr))

    def write_bytes(self, stream):
        binary = bytes([self.bin_opcode] + list(self.eval_args()))
        stream.write(binary)

class CPUBackendAssemble:
    def __init__(self, control):
        self.control = control
        self.addr_counter = 0
        self.program = []

    def advance_counter(self, steps):
        for step in steps:
            if PC.count in step:
                self.addr_counter +=1

        org(self.addr_counter)

    def execute_opcode(self, opcode, arg=None):
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

    def emit_arg(self):
        self.current_instruction.args.append(self.current_immediate)


    def list(self):
        for instr in self.program:
            instr.print()

    def bin(self, stream):
        for instr in self.program:
            instr.write_bytes(stream)