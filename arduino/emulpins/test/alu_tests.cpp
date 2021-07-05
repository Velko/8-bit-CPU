#include <UnitTest++/UnitTest++.h>
#include "fixtures.h"
#include "devices.h"

SUITE(AluArgR)
{
    TEST(KeepIntact)
    {
        alu_arg_r_bus = 55;

        AluArgRAssert ara;

        ara.apply_control(MUX_VAL(MUX_ALUARGR_MASK, MPIN_A_ALU_R_BITS));

        CHECK_EQUAL(55, (int)alu_arg_r_bus);
    }

    TEST(ForceZero)
    {
        alu_arg_r_bus = 55;

        AluArgRAssert ara;

        ara.apply_control(CTRL_DEFAULT);

        CHECK_EQUAL(0, (int)alu_arg_r_bus);
    }
}