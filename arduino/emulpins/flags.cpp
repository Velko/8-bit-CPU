
#include "devices.h"

uint8_t flags_bus;

FlagsReg Flags;

FlagsReg::FlagsReg()
{
    load_enabled = false;
    calc_enabled = false;
}

void FlagsReg::set_load(bool enabled)
{
    load_enabled = enabled;
}

void FlagsReg::set_calc(bool enabled)
{
    calc_enabled = enabled;
}

void FlagsReg::clock_pulse()
{
    if (load_enabled)
    {
        latched_primary = main_bus & 0x0F;
    }
    else if (calc_enabled)
    {
        latched_primary = flags_bus & (FLAG_C | FLAG_V);
        if (main_bus == 0)
            latched_primary |= FLAG_Z;
        if ((main_bus & 0x80) != 0)
            latched_primary |= FLAG_N;
    }
}

void FlagsReg::clock_inverted()
{
    latched_secondary = latched_primary;
}

uint8_t FlagsReg::read_tap()
{
    return latched_secondary;
}
void FlagsReg::set_out(bool enabled)
{
    if (enabled)
        main_bus = latched_primary;
}