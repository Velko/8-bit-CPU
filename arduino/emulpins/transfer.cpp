#include "devices.h"

TransferReg  TR;

void TransferReg::set_out_x(bool enabled)
{
    if (enabled)
        address_bus = val;
}

void TransferReg::set_load_x(bool enabled)
{
    load_x_enabled = enabled;
}

void TransferReg::set_out_h(bool enabled)
{
    if (enabled)
        main_bus = val >> 8;
}

void TransferReg::set_load_h(bool enabled)
{
    load_h_enabled = enabled;
}

void TransferReg::set_out_l(bool enabled)
{
    if (enabled)
        main_bus = val & 0xFF;
}

void TransferReg::set_load_l(bool enabled)
{
    load_l_enabled = enabled;
}

void TransferReg::set_add(bool enabled)
{
    add_enabled = enabled;
}

void TransferReg::clock_pulse()
{
    if (load_x_enabled)
        val = address_bus;

    if (load_h_enabled)
        val = (val & 0xFF ) | (main_bus << 8);

    if (load_l_enabled)
        val = (val & 0xFF00 ) | main_bus;

    if (add_enabled) {
        int8_t offset = main_bus;
        val += (int16_t)offset;
    }

}