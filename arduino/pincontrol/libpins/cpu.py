from .DeviceSetup import *
from .cpu_exec import CPUBackendControl

class CPU:
    def __init__(self, client, control):

        self.backend = CPUBackendControl(client, control)

        self.reg_A = RegA
        self.reg_B = RegB
        self.reg_F = Flags
        self.alu = AddSub

    def op_ldi(self, target, value):
        opcode = "ldi_{}_imm".format(target.name)
        self.backend.execute_opcode(opcode, value)

    def op_add(self, target, arg):
        opcode = "add_{}_{}".format(target.name, arg.name)
        self.backend.execute_opcode(opcode)

    def op_adc(self, target, arg):
        opcode = "adc_{}_{}".format(target.name, arg.name)
        self.backend.execute_opcode(opcode)

    def op_sub(self, target, arg):
        opcode = "sub_{}_{}".format(target.name, arg.name)
        self.backend.execute_opcode(opcode)

    def op_sbb(self, target, arg):
        opcode = "sbb_{}_{}".format(target.name, arg.name)
        self.backend.execute_opcode(opcode)

    def op_cmp(self, target, arg):
        opcode = "cmp_{}_{}".format(target.name, arg.name)
        self.backend.execute_opcode(opcode)

    def op_out(self, source):
        opcode = "out_{}".format(source.name)
        _, out_val = self.backend.execute_opcode(opcode)

        print ("{}".format(out_val), flush=True)

    def op_peek(self, source):
        opcode = "out_{}".format(source.name)
        _, out_val = self.backend.execute_opcode(opcode)

        return out_val

    def op_mov(self, target, source):
        opcode = "mov_{}_{}".format(target.name, source.name)
        self.backend.execute_opcode(opcode)

    def op_st(self, addr, source):
        opcode = "st_addr_{}".format(source.name)
        self.backend.execute_opcode(opcode, addr)

    def op_stabs(self, addr_reg, source):
        opcode = "stabs_{}_{}".format(addr_reg.name, source.name)
        self.backend.execute_opcode(opcode)

    def op_ldabs(self, target, addr_reg):
        opcode = "ldabs_{}_{}".format(target.name, addr_reg.name)
        self.backend.execute_opcode(opcode)

    def op_tstabs(self, addr_reg):
        opcode = "tstabs_{}".format(addr_reg.name)
        self.backend.execute_opcode(opcode)

    def op_ld(self, target, addr):
        opcode = "ld_{}_addr".format(target.name)
        self.backend.execute_opcode(opcode, addr)

    def op_bcs(self, label=None):
        taken, _ = self.backend.execute_opcode("bcs_addr", label)
        return taken

    def op_bcc(self, label=None):
        taken, _ = self.backend.execute_opcode("bcc_addr", label)
        return taken

    def op_beq(self, label=None):
        taken, _ = self.backend.execute_opcode("beq_addr", label)
        return taken

    def op_bne(self, label=None):
        taken, _ = self.backend.execute_opcode("bne_addr", label)
        return taken

    def op_jmp(self, label=None):
        taken, _ = self.backend.execute_opcode("jmp_addr", label)
        return taken

    def op_hlt(self):
        self.backend.execute_opcode("hlt")

