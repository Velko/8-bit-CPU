#include "devices.h"

Register MAR;
Memory RAM;

void Memory::set_out(bool enabled)
{
    if (enabled)
    {
        main_bus = data[MAR.read_tap()];
    }
}

void Memory::set_write(bool enabled)
{
    write_enabled = enabled;
}

void Memory::clock_pulse()
{
    if (write_enabled)
    {
        data[MAR.read_tap()] = main_bus;
    }
}