#include <Arduino.h>
#include "device_interface.h"

DeviceInterface DeviceInterface::instance;

DeviceInterface::DeviceInterface()
    : mainBus{9, 8, 7, 6, 5, 4, 3, 2},
      flagsBus{A0, A1, A2, A3}
{

}


void DeviceInterface::setup()
{
    clock.setup();
    control.setup();
}