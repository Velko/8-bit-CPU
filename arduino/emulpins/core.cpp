#include "devices.h"
#include "op-defs.h"

uint8_t flags;
uint8_t main_bus;

Register A;
Register B;
Register IR;

void set_control(uint16_t control_word)
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

    Flags.set_load((control_word & LPIN_F_LOAD_BIT) == 0);
    Flags.set_sel((control_word & HPIN_F_BUS_IN_BIT) != 0);
    Flags.set_out((control_word & MUX_OUT_MASK) == MPIN_F_BUS_OUT_BITS);

    PC.set_count((control_word & HPIN_PC_COUNT_BIT) != 0);

    AddSub.set_sub((control_word & HPIN_ADDSUB_SUB_BIT) != 0);
    AddSub.set_carry((control_word & HPIN_F_USE_CARRY_BIT) != 0);
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