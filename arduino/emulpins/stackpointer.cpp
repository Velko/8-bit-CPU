#include "devices.h"


StackPointer r_SP;

void StackPointer::set_out(bool enabled)
{
    if (enabled) {
        main_bus = val;
        addr_high_bus = val >> 8;
    }
}

void StackPointer::set_load(bool enabled)
{
    load_enabled = enabled;
}

void StackPointer::set_inc(bool enabled)
{
    inc_enabled = enabled;
}

void StackPointer::set_dec(bool enabled)
{
    dec_enabled = enabled;
}

void StackPointer::clock_pulse()
{
    if (inc_enabled)
        ++val;
    if (dec_enabled)
        --val;
    if (load_enabled)
        val = (addr_high_bus << 8 ) | main_bus;
}
