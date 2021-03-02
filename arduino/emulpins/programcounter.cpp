#include "devices.h"


ProgramCounter PC;

void ProgramCounter::set_out(bool enabled)
{
    if (enabled)
        main_bus = val;
}

void ProgramCounter::set_load(bool enabled)
{
    load_enabled = enabled;
}

void ProgramCounter::set_count(bool enabled)
{
    count_enabled = enabled;
}

void ProgramCounter::clock_pulse()
{
    if (count_enabled)
        ++val;
    if (load_enabled)
        val = main_bus;
}