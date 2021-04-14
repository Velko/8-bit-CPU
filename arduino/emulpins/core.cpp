#include "devices.h"
#include "op-defs.h"

uint8_t flags;
uint8_t main_bus;
uint8_t alu_arg_a_bus;
uint8_t alu_arg_b_bus;

Register A;
Register B;
Register IR;

void set_control(uint32_t control_word)
{
    A.set_load((control_word & MUX_LOAD_MASK) == MPIN_A_LOAD_BITS);
    B.set_load((control_word & MUX_LOAD_MASK) == MPIN_B_LOAD_BITS);
    IR.set_load((control_word & MUX_LOAD_MASK) == MPIN_IR_LOAD_BITS);
    PC.set_load((control_word & MUX_LOAD_MASK) == MPIN_PC_LOAD_BITS);
    MAR.set_load((control_word & MUX_LOAD_MASK) == MPIN_MAR_LOAD_BITS);
    RAM.set_write((control_word & MUX_LOAD_MASK) == MPIN_RAM_WRITE_BITS);

    A.set_out((control_word & MUX_OUT_MASK) == MPIN_A_OUT_BITS);
    B.set_out((control_word & MUX_OUT_MASK) == MPIN_B_OUT_BITS);
    PC.set_out((control_word & MUX_OUT_MASK) == MPIN_PC_OUT_BITS);
    RAM.set_out((control_word & MUX_OUT_MASK) == MPIN_RAM_OUT_BITS);

    Flags.set_calc((control_word & LPIN_F_CALC_BIT) == 0);
    Flags.set_load((control_word & MUX_LOAD_MASK) == MPIN_F_BUS_LOAD_BITS);
    Flags.set_out((control_word & MUX_OUT_MASK) == MPIN_F_BUS_OUT_BITS);

    PC.set_count((control_word & HPIN_PC_COUNT_BIT) != 0);

    AddSub.set_sub((control_word & HPIN_ADDSUB_SUB_BIT) != 0);
    AddSub.set_carry((control_word & HPIN_F_CARRY_BIT) != 0);


    alu_arg_a_bus = alu_arg_b_bus = 0; // emulate "pull-down"

    A.set_tap_a((control_word & MUX_ALUARGA_MASK) == MPIN_A_ALU_A_BITS);
    A.set_tap_b((control_word & MUX_ALUARGB_MASK) == MPIN_A_ALU_B_BITS);
    B.set_tap_a((control_word & MUX_ALUARGA_MASK) == MPIN_B_ALU_A_BITS);
    B.set_tap_b((control_word & MUX_ALUARGB_MASK) == MPIN_B_ALU_B_BITS);

    // should be one of the latest, after registers' tap config
    AddSub.set_out((control_word & MUX_OUT_MASK) == MPIN_ADDSUB_OUT_BITS);
}

void clock_pulse()
{
    A.clock_pulse();
    B.clock_pulse();
    IR.clock_pulse();
    Flags.clock_pulse();
    PC.clock_pulse();
    MAR.clock_pulse();
    RAM.clock_pulse();
}

void clock_inverted()
{
    A.clock_inverted();
    B.clock_inverted();
    IR.clock_inverted();
    Flags.clock_inverted();
    MAR.clock_inverted();
}