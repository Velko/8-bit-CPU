#include "dev_display.h"
#include <Arduino.h>

Display::Display(DeviceInterface &_dev)
    : devices{_dev},
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

void Display::set_mode(uint8_t mode)
{
    mode_bus.write(mode);
}