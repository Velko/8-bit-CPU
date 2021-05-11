#include "devices.h"


ProgramCounter PC0;
ProgramCounter LR0;

ProgramCounter *PC = &PC0;
ProgramCounter *LR = &LR0;
PCSwap PCSW;




void ProgramCounter::set_out(bool enabled)
{
    if (enabled) {
        main_bus = val & 0xFF;
        addr_high_bus = val >> 8;
    }
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
        val = (addr_high_bus << 8) | main_bus;
}

void PCSwap::set_swap(bool enabled)
{
    sw_enabled = enabled;
}

void PCSwap::clock_pulse()
{
    if (sw_enabled)
    {
        ProgramCounter *tmp = PC;
        PC = LR;
        LR = tmp;
    }
}
