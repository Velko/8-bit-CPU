from .cpu import CPUBackend, InvalidOpcodeException
from typing import Union, Tuple, Optional
from .markers import Bytes, Label
from .devices import Flags

def do_add_reg(arg0: int, arg1: int) -> Tuple[int, bool]:
    res = arg0 + arg1
    return res & 0xFF, res > 0xFF

def do_sub_reg(arg0: int, arg1: int) -> Tuple[int, bool]:
    res = arg0 - arg1
    return (res + 256) & 0xFF, res < 0


class CPUBackendEmulate(CPUBackend):
    def __init__(self) -> None:
        self.memory = [0]*256
        self.A = 0
        self.B = 0
        self.Flags = 0

    def execute_opcode(self, opcode: str, arg: Union[None, int, Bytes, Label]=None) -> Tuple[bool, Optional[int]]:
        attr = getattr(self, "op_"+opcode)
        if attr is None:
            raise InvalidOpcodeException(opcode)

        if isinstance(arg, Bytes):
            arg = arg.start

        res: Tuple[bool, Optional[int]] = attr(arg)

        if res is None:
            return False, None
        else:
            return res


    def update_flags(self, val: int, carry: Optional[bool]) -> None:
        if carry is None:
            carry = self.Flags & Flags.C != 0

        self.Flags = 0
        if val == 0:
            self.Flags |= Flags.Z
        if carry:
            self.Flags |= Flags.C


    def op_ldi_A_imm(self, arg: int) -> None:
        self.A = arg

    def op_ldi_B_imm(self, arg: int) -> None:
        self.B = arg

    def op_add_A_B(self, arg: int) -> None:
        self.A, carry  = do_add_reg(self.A, self.B)
        self.update_flags(self.A, carry)

    def op_cmp_A_B(self, arg: int) -> None:
        val, carry  = do_sub_reg(self.A, self.B)
        self.update_flags(val, carry)

    def op_sub_A_B(self, arg: int) -> None:
        self.A, carry  = do_sub_reg(self.A, self.B)
        self.update_flags(self.A, carry)

    def op_add_B_A(self, arg: int) -> None:
        self.B, carry  = do_add_reg(self.A, self.B)
        self.update_flags(self.B, carry)

    def op_stabs_B_A(self, arg: int) -> None:
        self.memory[self.B] = self.A

    def op_stabs_B_B(self, arg: int) -> None:
        self.memory[self.B] = self.B

    def op_bne_addr(self, arg: int) -> Tuple[bool, Optional[int]]:
        return self.Flags & Flags.Z == 0, None

    def op_beq_addr(self, arg: int) -> Tuple[bool, Optional[int]]:
        return self.Flags & Flags.Z != 0, None

    def op_bcc_addr(self, arg: int) -> Tuple[bool, Optional[int]]:
        return self.Flags & Flags.C == 0, None

    def op_bcs_addr(self, arg: int) -> Tuple[bool, Optional[int]]:
        return self.Flags & Flags.C != 0, None

    def op_st_addr_A(self, arg: int) -> None:
        self.memory[arg] = self.A

    def op_tstabs_B(self, arg: int) -> None:
        self.update_flags(self.memory[self.B], None)

    def op_out_A(self, arg: int) -> Tuple[bool, Optional[int]]:
        return False, self.A

    def op_out_B(self, arg: int) -> Tuple[bool, Optional[int]]:
        return False, self.B

    def op_mov_B_A(self, arg: int) -> None:
        self.B = self.A

    def op_ld_A_addr(self, arg: int) -> None:
        self.A = self.memory[arg]
        self.update_flags(self.A, None)

    def op_ld_B_addr(self, arg: int) -> None:
        self.B = self.memory[arg]
        self.update_flags(self.B, None)

    def op_ldabs_A_B(self, arg: int) -> None:
        self.A = self.memory[self.B]
        self.update_flags(self.A, None)

    def op_hlt(self, arg: int) -> None:
        pass

    def op_jmp_addr(self, arg: int) -> Tuple[bool, Optional[int]]:
        return True, None