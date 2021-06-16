#include "devices.h"

ALU_AddSub AddSub;
ALU_AndOr  AndOr;
ALU_ShiftSwap ShiftSwap;
ALU_XorNot XorNot;

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
    uint16_t a_arg = alu_arg_l_bus;
    uint16_t b_adj = alu_arg_r_bus;

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

ALU_AndOr::ALU_AndOr()
{
}

void ALU_AndOr::set_or(bool logical_or)
{
    op_or = logical_or;
}

void ALU_AndOr::set_out(bool enabled)
{
    if (enabled)
    {
        if (op_or)
            main_bus = alu_arg_l_bus | alu_arg_r_bus;
        else
            main_bus = alu_arg_l_bus & alu_arg_r_bus;

        // no need to update flags as N and Z is calculated
        // by flags register itself
    }
}


ALU_ShiftSwap::ALU_ShiftSwap()
{
}

void ALU_ShiftSwap::set_swap(bool swap)
{
    op_swap = swap;
}

void ALU_ShiftSwap::set_carry(bool c)
{
    carry = c;
}

void ALU_ShiftSwap::set_out(bool enabled)
{
    if (enabled)
    {
        if (op_swap)
            main_bus = alu_arg_l_bus << 4 | alu_arg_l_bus >> 4;
        else
        {
            main_bus = alu_arg_l_bus >> 1;

            if (carry)
                main_bus |= 0x80;

            flags_bus = 0;
            if ((alu_arg_l_bus & 1) != 0)
                flags_bus |= FLAG_C;
        }
    }
}

ALU_XorNot::ALU_XorNot()
{
}

void ALU_XorNot::set_not(bool logical_not)
{
    op_not = logical_not;
}

void ALU_XorNot::set_out(bool enabled)
{
    if (enabled)
    {
        uint8_t arg_b = alu_arg_r_bus;

        if (op_not)
            arg_b = 0xFF;

        main_bus = alu_arg_l_bus ^ arg_b;
    }
}
