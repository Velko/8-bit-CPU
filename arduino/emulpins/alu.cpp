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
    uint16_t a_arg = A.read_tap_b();
    uint16_t b_adj = (uint16_t)B.read_tap_b();

    uint8_t c_val = 0;

    if (sub) {
        b_adj = (~b_adj) & 0xFF;
        c_val = 1;
    }

    if (carry && (Flags.read_tap() & FLAG_C))
    {
        if (!sub)
            c_val = 1;
        else
            c_val = 0;
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
