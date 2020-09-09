#include <Arduino.h>
#include "device_interface.h"

DeviceInterface DeviceInterface::instance;

DeviceInterface::DeviceInterface()
    : flagsBus{A0, A1, A2, A3}
{

}


void DeviceInterface::setup()
{
    clock.setup();
    control.setup();
}