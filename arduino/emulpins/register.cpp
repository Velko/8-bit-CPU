#include "devices.h"

Register::Register()
{
    out_enabled = false;
    load_enabled = false;
    tap_a_enabled = false;
    tap_b_enabled = true; // hardwired for now
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
    out_enabled = enabled;
    if (out_enabled)
        main_bus = latched_primary;
}

uint8_t Register::read_tap_a()
{
    if (tap_a_enabled)
        return latched_secondary;
    else
        return 0;
}

uint8_t Register::read_tap_b()
{
    if (tap_b_enabled)
        return latched_secondary;
    else
        return 0;
}