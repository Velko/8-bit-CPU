#include <UnitTest++/UnitTest++.h>
#include "fixtures.h"
#include "devices.h"
#include "op-defs.h"

struct RegisterFixture : public BusStateFixture
{
    RegisterFixture();
    Register reg;
};

RegisterFixture::RegisterFixture()
    : reg(MPIN_A_OUT_BITS, MPIN_A_LOAD_BITS, MPIN_A_ALU_L_BITS, MPIN_A_ALU_R_BITS)
{}


#define LOAD_A  MUX_VAL(MUX_LOAD_MASK, MPIN_A_LOAD_BITS)
#define OUT_A   MUX_VAL(MUX_OUT_MASK, MPIN_A_OUT_BITS)
#define ARG_LA  MUX_VAL(MUX_ALUARGL_MASK, MPIN_A_ALU_L_BITS)

SUITE(GPRegister)
{
    TEST_FIXTURE(RegisterFixture, Load_Out)
    {
        main_bus = 5;

        reg.apply_control(LOAD_A);
        reg.clock_pulse();

        main_bus = 0;

        reg.apply_control(OUT_A);

        CHECK_EQUAL(5, (int)main_bus);
    }

    TEST_FIXTURE(RegisterFixture, Load_AluL)
    {
        main_bus = 6;

        reg.apply_control(LOAD_A);
        reg.clock_pulse();
        reg.clock_inverted();

        reg.apply_control(ARG_LA);

        CHECK_EQUAL(6, (int)alu_arg_l_bus);
    }
}