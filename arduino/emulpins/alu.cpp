#include "devices.h"
#include "op-defs.h"

ALU_Unit::ALU_Unit(cword_t out, cword_t alt, cword_t carry)
    : _out(MUX_OUT_MASK, out),
      _alt(alt, alt),
      _carry(carry, carry)
{}

ALU_AddSub::ALU_AddSub(cword_t out, cword_t alt, cword_t carry)
    : ALU_Unit(out, alt, carry)
{}


void ALU_AddSub::control_updated()
{
    uint16_t a_arg = alu_arg_l_bus;
    uint16_t b_adj = alu_arg_r_bus;

    uint8_t c_val = _carry.is_enabled(_control) ? 1 : 0;
    bool sub = _alt.is_enabled(_control);

    if (sub) {
        b_adj = (~b_adj) & 0xFF;
        c_val = 1 - c_val;
    }

    if (_out.is_enabled(_control))
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

ALU_AndOr::ALU_AndOr(cword_t out, cword_t alt)
    : ALU_Unit(out, alt, 0)
{
}

void ALU_AndOr::control_updated()
{
    if (_out.is_enabled(_control))
    {
        if (_alt.is_enabled(_control))
            main_bus = alu_arg_l_bus | alu_arg_r_bus;
        else
            main_bus = alu_arg_l_bus & alu_arg_r_bus;

        // no need to update flags as N and Z is calculated
        // by flags register itself
    }
}


ALU_ShiftSwap::ALU_ShiftSwap(cword_t out, cword_t alt, cword_t carry)
    : ALU_Unit(out, alt, carry)
{
}

void ALU_ShiftSwap::control_updated()
{
    if (_out.is_enabled(_control))
    {
        if (_alt.is_enabled(_control))
            main_bus = alu_arg_l_bus << 4 | alu_arg_l_bus >> 4;
        else
        {
            main_bus = alu_arg_l_bus >> 1;

            if (_carry.is_enabled(_control))
                main_bus |= 0x80;

            flags_bus = 0;
            if ((alu_arg_l_bus & 1) != 0)
                flags_bus |= FLAG_C;
        }
    }
}

ALU_XorNot::ALU_XorNot(cword_t out, cword_t alt)
    : ALU_Unit(out, alt, 0)
{
}

void ALU_XorNot::control_updated()
{
    if (_out.is_enabled(_control))
    {
        uint8_t arg_b = alu_arg_r_bus;

        if (_alt.is_enabled(_control))
            arg_b = 0xFF;

        main_bus = alu_arg_l_bus ^ arg_b;
    }
}
