#include <UnitTest++/UnitTest++.h>
#include "devices.h"
#include "op-defs.h"


SUITE(GPRegister)
{
    TEST(Load_Out)
    {
        main_bus = 5;
        Register reg(MPIN_A_OUT_BITS, MPIN_A_LOAD_BITS, MPIN_A_ALU_L_BITS, MPIN_A_ALU_R_BITS);

        reg.apply_control((CTRL_DEFAULT & ~MUX_LOAD_MASK) | MPIN_A_LOAD_BITS);
        reg.clock_pulse();

        main_bus = 0;

        reg.apply_control((CTRL_DEFAULT & ~MUX_OUT_MASK) | MPIN_A_OUT_BITS);

        CHECK_EQUAL(5, (int)main_bus);
    }

    TEST(Load_AluL)
    {
        main_bus = 6;
        alu_arg_l_bus = 0;

        Register reg(MPIN_A_OUT_BITS, MPIN_A_LOAD_BITS, MPIN_A_ALU_L_BITS, MPIN_A_ALU_R_BITS);

        reg.apply_control((CTRL_DEFAULT & ~MUX_LOAD_MASK) | MPIN_A_LOAD_BITS);
        reg.clock_pulse();
        reg.clock_inverted();

        reg.apply_control((CTRL_DEFAULT & ~MUX_ALUARGL_MASK) | MPIN_A_ALU_L_BITS);

        CHECK_EQUAL(6, (int)alu_arg_l_bus);
    }
}