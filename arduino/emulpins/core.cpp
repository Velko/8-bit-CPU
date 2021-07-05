#include "devices.h"
#include "op-defs.h"
#include "device_interface.h"

uint8_t main_bus;
uint16_t address_bus;
uint8_t alu_arg_l_bus;
uint8_t alu_arg_r_bus;

CPU Processor;

CPU::CPU()
    : A(MPIN_A_OUT_BITS,
        MPIN_A_LOAD_BITS,
        MPIN_A_ALU_L_BITS,
        MPIN_A_ALU_R_BITS),

      B(MPIN_B_OUT_BITS,
        MPIN_B_LOAD_BITS,
        MPIN_B_ALU_L_BITS,
        MPIN_B_ALU_R_BITS),

      C(MPIN_C_OUT_BITS,
        MPIN_C_LOAD_BITS,
        MPIN_C_ALU_L_BITS,
        MPIN_C_ALU_R_BITS),

      D(MPIN_D_OUT_BITS,
        MPIN_D_LOAD_BITS,
        MPIN_D_ALU_L_BITS,
        MPIN_D_ALU_R_BITS),

      IR(MPIN_IR_LOAD_BITS),
      PC(MPIN_PC_OUT_BITS, MPIN_PC_LOAD_BITS),
      r_SP(MPIN_SP_OUT_BITS, MPIN_SP_LOAD_BITS, LPIN_SP_INC_BIT, LPIN_SP_DEC_BIT),
      LR(MPIN_LR_OUT_BITS, MPIN_LR_LOAD_BITS),

      TR(MPIN_TX_OUT_BITS, MPIN_TX_LOAD_BITS,
         MPIN_TL_OUT_BITS, MPIN_TL_LOAD_BITS,
         MPIN_TH_OUT_BITS, MPIN_TH_LOAD_BITS),

      ACalc(MPIN_ACAL_OUT_BITS, MPIN_ACAL_LOAD_BITS),

      RAM(MPIN_RAM_OUT_BITS, MPIN_RAM_WRITE_BITS),

      Flags(MPIN_F_OUT_BITS, MPIN_F_LOAD_BITS, LPIN_F_CALC_BIT),
      AddSub(MPIN_ADDSUB_OUT_BITS, HPIN_ADDSUB_ALT_BIT, HPIN_F_CARRY_BIT),
      AndOr(MPIN_ANDOR_OUT_BITS, HPIN_ADDSUB_ALT_BIT),
      ShiftSwap(MPIN_SHIFTSWAP_OUT_BITS, HPIN_ADDSUB_ALT_BIT, HPIN_F_CARRY_BIT),
      XorNot(MPIN_XORNOT_OUT_BITS, HPIN_ADDSUB_ALT_BIT)
{

}

void CPU::apply_control(cword_t control_word)
{
    A.apply_control(control_word);
    B.apply_control(control_word);
    C.apply_control(control_word);
    D.apply_control(control_word);

    IR.apply_control(control_word);
    PC.apply_control(control_word);
    r_SP.apply_control(control_word);
    LR.apply_control(control_word);

    TR.apply_control(control_word);
    ACalc.apply_control(control_word);

    // RAM out should be enabled after registers had an opportunity to
    // put an address on the bus
    RAM.apply_control(control_word);

    Flags.apply_control(control_word);

    ALUArgR.apply_control(control_word);

    // "pull" to current value (relevant to C and V flags)
    flags_bus = Flags.read_tap();


    // should be one of the latest, after registers' tap config
    AddSub.apply_control(control_word);
    AndOr.apply_control(control_word);
    ShiftSwap.apply_control(control_word);
    XorNot.apply_control(control_word);
}

void CPU::clock_pulse()
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
    ACalc.clock_pulse();
}

void CPU::clock_inverted()
{
    A.clock_inverted();
    B.clock_inverted();
    C.clock_inverted();
    D.clock_inverted();
    IR.clock_inverted();
    Flags.clock_inverted();
    PC.clock_inverted();
    r_SP.clock_inverted();
    LR.clock_inverted();
}

uint8_t CPU::current_flags()
{
    return Flags.read_tap();
}

uint8_t CPU::current_opcode()
{
    return IR.read_tap();
}

void CPU::runtime_setup()
{
    RAM.setup();
}

uint32_t Control::write32(uint32_t control_word)
{
    Processor.apply_control(control_word);

    return 0;
}

void Clock::pulse()
{
    Processor.clock_pulse();
}

void InvClock::pulse()
{
    Processor.clock_inverted();
}
