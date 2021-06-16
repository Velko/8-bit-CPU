#include "devices.h"

Register::Register()
{
    load_enabled = false;
}

void Register::clock_pulse()
{
    if (load_enabled)
        latched_primary = main_bus;
}

void Register::clock_inverted()
{
    latched_secondary = latched_primary;
}

void Register::set_load(bool enabled)
{
    load_enabled = enabled;
}

void Register::set_out(bool enabled)
{
    if (enabled)
        main_bus = latched_primary;
}

uint8_t Register::read_tap()
{
    return latched_secondary;
}

void Register::set_tap_l(bool enabled)
{
    if (enabled)
        alu_arg_l_bus = latched_secondary;
}

void Register::set_tap_r(bool enabled)
{
    if (enabled)
        alu_arg_r_bus = latched_secondary;
}

void AddressReg::set_load(bool enabled)
{
    load_enabled = enabled;
}

void AddressReg::set_out(bool enabled)
{
    if (enabled) {
        address_bus = val;
    }
}

void AddressReg::clock_pulse()
{
    if (load_enabled)
    {
        val = address_bus;
    }
}