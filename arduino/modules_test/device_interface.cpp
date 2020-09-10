#include <Arduino.h>
#include "device_interface.h"

DeviceInterface DeviceInterface::instance;

DeviceInterface::DeviceInterface()
{

}


void DeviceInterface::setup()
{
    clock.setup();
    control.setup();
}