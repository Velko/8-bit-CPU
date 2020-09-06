#include "dev_display.h"
#include <Arduino.h>

Display::Display(DeviceInterface &_dev)
    : devices{_dev},
      BusDevice{9, 8, 7, 6, 5, 4, 2, 3},
      mode_bus{12, 13}
{
}

void Display::setup()
{
    mode_bus.write(0);
}

void Display::write(uint8_t value)
{
    devices.mainBus.write(value);
}

uint8_t Display::read()
{
    // Should not attempt to read it
    __builtin_unreachable();
}


void Display::set_mode(uint8_t mode)
{
    mode_bus.write(mode);
}