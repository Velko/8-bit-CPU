#include "devices.h"
#include "op-defs.h"

uint8_t main_bus;
uint8_t addr_high_bus;
uint8_t alu_arg_a_bus;
uint8_t alu_arg_b_bus;

Register A;
Register B;
Register C;
Register D;
Register IR;

void set_control(uint32_t control_word)
{
    A.set_load((control_word & MUX_LOAD_MASK) == MPIN_A_LOAD_BITS);
    B.set_load((control_word & MUX_LOAD_MASK) == MPIN_B_LOAD_BITS);
    C.set_load((control_word & MUX_LOAD_MASK) == MPIN_C_LOAD_BITS);
    D.set_load((control_word & MUX_LOAD_MASK) == MPIN_D_LOAD_BITS);
    IR.set_load((control_word & MUX_LOAD_MASK) == MPIN_IR_LOAD_BITS);
    PC->set_load((control_word & MUX_LOAD_MASK) == MPIN_PC_LOAD_BITS);
    r_SP.set_load((control_word & MUX_LOAD_MASK) == MPIN_SP_LOAD_BITS);
    LR->set_load((control_word & MUX_LOAD_MASK) == MPIN_LR_LOAD_BITS);
    MAR.set_load((control_word & MUX_LOAD_MASK) == MPIN_MAR_LOAD_BITS);
    RAM.set_write((control_word & MUX_LOAD_MASK) == MPIN_RAM_WRITE_BITS);
    HAS.set_load((control_word & MUX_LOAD_MASK) == MPIN_HAS_LOAD_BITS);

    HAS.set_dir((control_word & HPIN_HAS_DIR_BIT) != 0); // should set before enabling Out

    A.set_out((control_word & MUX_OUT_MASK) == MPIN_A_OUT_BITS);
    B.set_out((control_word & MUX_OUT_MASK) == MPIN_B_OUT_BITS);
    C.set_out((control_word & MUX_OUT_MASK) == MPIN_C_OUT_BITS);
    D.set_out((control_word & MUX_OUT_MASK) == MPIN_D_OUT_BITS);
    PC->set_out((control_word & MUX_OUT_MASK) == MPIN_PC_OUT_BITS);
    r_SP.set_out((control_word & MUX_OUT_MASK) == MPIN_SP_OUT_BITS);
    LR->set_out((control_word & MUX_OUT_MASK) == MPIN_LR_OUT_BITS);
    RAM.set_out((control_word & MUX_OUT_MASK) == MPIN_RAM_OUT_BITS);
    HAS.set_out((control_word & LPIN_HAS_OUT_BIT) == 0);

    Flags.set_calc((control_word & LPIN_F_CALC_BIT) == 0);
    Flags.set_load((control_word & MUX_LOAD_MASK) == MPIN_F_LOAD_BITS);
    Flags.set_out((control_word & MUX_OUT_MASK) == MPIN_F_OUT_BITS);

    PC->set_count((control_word & HPIN_PC_COUNT_BIT) != 0);

    r_SP.set_inc((control_word & LPIN_SP_INC_BIT) == 0);
    r_SP.set_dec((control_word & LPIN_SP_DEC_BIT) == 0);

    AddSub.set_sub((control_word & HPIN_ADDSUB_ALT_BIT) != 0);
    AddSub.set_carry((control_word & HPIN_F_CARRY_BIT) != 0);


    AndOr.set_or((control_word & HPIN_ADDSUB_ALT_BIT) != 0);

    ShiftSwap.set_swap((control_word & HPIN_ADDSUB_ALT_BIT) != 0);
    ShiftSwap.set_carry((control_word & HPIN_F_CARRY_BIT) != 0);

    XorNot.set_not((control_word & HPIN_ADDSUB_ALT_BIT) != 0);

    PCSW.set_swap((control_word & HPIN_PCLR_SWAP_BIT) != 0);

    if ((control_word & MUX_ALUARGB_MASK) == (CTRL_DEFAULT & MUX_ALUARGB_MASK))
        alu_arg_b_bus = 0; // default value forces B input to 0

    // A input is always connected to one of registers

    A.set_tap_a((control_word & MUX_ALUARGA_MASK) == MPIN_A_ALU_A_BITS);
    A.set_tap_b((control_word & MUX_ALUARGB_MASK) == MPIN_A_ALU_B_BITS);
    B.set_tap_a((control_word & MUX_ALUARGA_MASK) == MPIN_B_ALU_A_BITS);
    B.set_tap_b((control_word & MUX_ALUARGB_MASK) == MPIN_B_ALU_B_BITS);
    C.set_tap_a((control_word & MUX_ALUARGA_MASK) == MPIN_C_ALU_A_BITS);
    C.set_tap_b((control_word & MUX_ALUARGB_MASK) == MPIN_C_ALU_B_BITS);
    D.set_tap_a((control_word & MUX_ALUARGA_MASK) == MPIN_D_ALU_A_BITS);
    D.set_tap_b((control_word & MUX_ALUARGB_MASK) == MPIN_D_ALU_B_BITS);


    // should be one of the latest, after registers' tap config
    AddSub.set_out((control_word & MUX_OUT_MASK) == MPIN_ADDSUB_OUT_BITS);
    AndOr.set_out((control_word & MUX_OUT_MASK) == MPIN_ANDOR_OUT_BITS);
    ShiftSwap.set_out((control_word & MUX_OUT_MASK) == MPIN_SHIFTSWAP_OUT_BITS);
    XorNot.set_out((control_word & MUX_OUT_MASK) == MPIN_XORNOT_OUT_BITS);
}

void clock_pulse()
{
    A.clock_pulse();
    B.clock_pulse();
    C.clock_pulse();
    D.clock_pulse();
    IR.clock_pulse();
    Flags.clock_pulse();
    PC->clock_pulse();
    r_SP.clock_pulse();
    LR->clock_pulse();
    MAR.clock_pulse();
    RAM.clock_pulse();
    PCSW.clock_pulse();
    HAS.clock_pulse();
}

void clock_inverted()
{
    A.clock_inverted();
    B.clock_inverted();
    C.clock_inverted();
    D.clock_inverted();
    IR.clock_inverted();
    Flags.clock_inverted();
    MAR.clock_inverted();
}
