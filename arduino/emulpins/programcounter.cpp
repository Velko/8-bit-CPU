#include "devices.h"


ProgramCounter PC0;
ProgramCounter LR0;

ProgramCounter *PC = &PC0;
ProgramCounter *LR = &LR0;


void ProgramCounter::set_out(bool enabled)
{
    count_enabled = enabled;
    if (enabled) {
        address_bus = secondary;
    }
}

void ProgramCounter::set_load(bool enabled)
{
    load_enabled = enabled;
}

void ProgramCounter::clock_pulse()
{
    if (count_enabled)
        ++primary;
    if (load_enabled)
        primary = address_bus;
}

void ProgramCounter::clock_inverted()
{
    secondary = primary;
}
