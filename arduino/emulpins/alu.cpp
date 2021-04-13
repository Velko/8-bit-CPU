#include "devices.h"

ALU_AddSub AddSub;

ALU_AddSub::ALU_AddSub()
{
}


void ALU_AddSub::set_sub(bool subtract)
{
    sub = subtract;
}

void ALU_AddSub::set_carry(bool c)
{
    carry = c;
}

void ALU_AddSub::set_out(bool enabled)
{
    uint16_t a_arg = alu_arg_a_bus;
    uint16_t b_adj = alu_arg_b_bus;

    uint8_t c_val = carry ? 1 : 0;

    if (sub) {
        b_adj = (~b_adj) & 0xFF;
        c_val = 1 - c_val;
    }

    if (enabled)
    {
        uint16_t result = a_arg + b_adj + c_val;
        main_bus = result & 0xFF;

        flags_bus = 0;
        if ((result > 255) != sub)
            flags_bus |= FLAG_C;

        if ((a_arg & 0x80) != (result & 0x80) && (b_adj & 0x80) != (result & 0x80))
            flags_bus |= FLAG_V;
    }
}
