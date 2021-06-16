#include "devices.h"
#include "op-defs.h"
#include "device_interface.h"

uint8_t main_bus;
uint16_t address_bus;
uint8_t alu_arg_a_bus;
uint8_t alu_arg_b_bus;

ControlSignal a_load(MUX_LOAD_MASK, MPIN_A_LOAD_BITS);
ControlSignal b_load(MUX_LOAD_MASK, MPIN_B_LOAD_BITS);
ControlSignal c_load(MUX_LOAD_MASK, MPIN_C_LOAD_BITS);
ControlSignal d_load(MUX_LOAD_MASK, MPIN_D_LOAD_BITS);
ControlSignal ir_load(MUX_LOAD_MASK, MPIN_IR_LOAD_BITS);

ControlSignal a_out(MUX_OUT_MASK, MPIN_A_OUT_BITS);
ControlSignal b_out(MUX_OUT_MASK, MPIN_B_OUT_BITS);
ControlSignal c_out(MUX_OUT_MASK, MPIN_C_OUT_BITS);
ControlSignal d_out(MUX_OUT_MASK, MPIN_D_OUT_BITS);

ControlSignal a_tap_a(MUX_ALUARGA_MASK, MPIN_A_ALU_A_BITS);
ControlSignal a_tap_b(MUX_ALUARGB_MASK, MPIN_A_ALU_B_BITS);
ControlSignal b_tap_a(MUX_ALUARGA_MASK, MPIN_B_ALU_A_BITS);
ControlSignal b_tap_b(MUX_ALUARGB_MASK, MPIN_B_ALU_B_BITS);
ControlSignal c_tap_a(MUX_ALUARGA_MASK, MPIN_C_ALU_A_BITS);
ControlSignal c_tap_b(MUX_ALUARGB_MASK, MPIN_C_ALU_B_BITS);
ControlSignal d_tap_a(MUX_ALUARGA_MASK, MPIN_D_ALU_A_BITS);
ControlSignal d_tap_b(MUX_ALUARGB_MASK, MPIN_D_ALU_B_BITS);


Register A;
Register B;
Register C;
Register D;
Register IR;
AddressReg DP;

uint32_t Control::write32(uint32_t control_word)
{

    A.set_load(a_load.is_enabled(control_word));
    A.set_out(a_out.is_enabled(control_word));
    A.set_tap_a(a_tap_a.is_enabled(control_word));
    A.set_tap_b(a_tap_b.is_enabled(control_word));

    B.set_load(b_load.is_enabled(control_word));
    B.set_out(b_out.is_enabled(control_word));
    B.set_tap_a(b_tap_a.is_enabled(control_word));
    B.set_tap_b(b_tap_b.is_enabled(control_word));

    C.set_load(c_load.is_enabled(control_word));
    C.set_out(c_out.is_enabled(control_word));
    C.set_tap_a(c_tap_a.is_enabled(control_word));
    C.set_tap_b(c_tap_b.is_enabled(control_word));

    D.set_load(d_load.is_enabled(control_word));
    D.set_out(d_out.is_enabled(control_word));
    D.set_tap_a(d_tap_a.is_enabled(control_word));
    D.set_tap_b(d_tap_b.is_enabled(control_word));

    IR.set_load(ir_load.is_enabled(control_word));
    PC.set_load((control_word & MUX_ADDRLOAD_MASK) == MPIN_PC_LOAD_BITS);
    r_SP.set_load((control_word & MUX_ADDRLOAD_MASK) == MPIN_SP_LOAD_BITS);
    LR.set_load((control_word & MUX_ADDRLOAD_MASK) == MPIN_LR_LOAD_BITS);
    RAM.set_write((control_word & MUX_LOAD_MASK) == MPIN_RAM_WRITE_BITS);
    TR.set_load_x((control_word & MUX_ADDRLOAD_MASK) == MPIN_TX_LOAD_BITS);
    TR.set_load_h((control_word & MUX_LOAD_MASK) == MPIN_TH_LOAD_BITS);
    TR.set_load_l((control_word & MUX_LOAD_MASK) == MPIN_TL_LOAD_BITS);

    PC.set_out((control_word & MUX_ADDROUT_MASK) == MPIN_PC_OUT_BITS);
    r_SP.set_out((control_word & MUX_ADDROUT_MASK) == MPIN_SP_OUT_BITS);
    LR.set_out((control_word & MUX_ADDROUT_MASK) == MPIN_LR_OUT_BITS);
    TR.set_out_x((control_word & MUX_ADDROUT_MASK) == MPIN_TX_OUT_BITS);
    TR.set_out_h((control_word & MUX_OUT_MASK) == MPIN_TH_OUT_BITS);
    TR.set_out_l((control_word & MUX_OUT_MASK) == MPIN_TL_OUT_BITS);

    // RAM out should be enabled after registers had an opportunity to
    // put an address on the bus
    RAM.set_out((control_word & MUX_OUT_MASK) == MPIN_RAM_OUT_BITS);

    Flags.set_calc((control_word & LPIN_F_CALC_BIT) == 0);
    Flags.set_load((control_word & MUX_LOAD_MASK) == MPIN_F_LOAD_BITS);
    Flags.set_out((control_word & MUX_OUT_MASK) == MPIN_F_OUT_BITS);

    r_SP.set_inc((control_word & LPIN_SP_INC_BIT) == 0);
    r_SP.set_dec((control_word & LPIN_SP_DEC_BIT) == 0);

    AddSub.set_sub((control_word & HPIN_ADDSUB_ALT_BIT) != 0);
    AddSub.set_carry((control_word & HPIN_F_CARRY_BIT) != 0);


    AndOr.set_or((control_word & HPIN_ADDSUB_ALT_BIT) != 0);

    ShiftSwap.set_swap((control_word & HPIN_ADDSUB_ALT_BIT) != 0);
    ShiftSwap.set_carry((control_word & HPIN_F_CARRY_BIT) != 0);

    XorNot.set_not((control_word & HPIN_ADDSUB_ALT_BIT) != 0);

    TR.set_add((control_word & HPIN_TL_ADD_BIT) != 0);

    if ((control_word & MUX_ALUARGB_MASK) == (CTRL_DEFAULT & MUX_ALUARGB_MASK))
        alu_arg_b_bus = 0; // default value forces B input to 0

    // "pull" to current value (relevant to C and V flags)
    flags_bus = Flags.read_tap();

    // A input is always connected to one of registers



    // should be one of the latest, after registers' tap config
    AddSub.set_out((control_word & MUX_OUT_MASK) == MPIN_ADDSUB_OUT_BITS);
    AndOr.set_out((control_word & MUX_OUT_MASK) == MPIN_ANDOR_OUT_BITS);
    ShiftSwap.set_out((control_word & MUX_OUT_MASK) == MPIN_SHIFTSWAP_OUT_BITS);
    XorNot.set_out((control_word & MUX_OUT_MASK) == MPIN_XORNOT_OUT_BITS);

    return 0;
}

void Clock::pulse()
{
    A.clock_pulse();
    B.clock_pulse();
    C.clock_pulse();
    D.clock_pulse();
    IR.clock_pulse();
    Flags.clock_pulse();
    PC.clock_pulse();
    r_SP.clock_pulse();
    LR.clock_pulse();
    RAM.clock_pulse();
    TR.clock_pulse();
}

void InvClock::pulse()
{
    A.clock_inverted();
    B.clock_inverted();
    C.clock_inverted();
    D.clock_inverted();
    IR.clock_inverted();
    Flags.clock_inverted();
    PC.clock_inverted();
    LR.clock_inverted();
}
