#include <Arduino.h>
#include "device_interface.h"

DeviceInterface DeviceInterface::instance;

#define PIN_CLK        SCL
#define PIN_CLK_INV    SDA

DeviceInterface::DeviceInterface()
    : clock{PIN_CLK}, inv_clock{PIN_CLK_INV}
{

}


void DeviceInterface::setup()
{
    clock.setup();
    inv_clock.setup();
    control.setup();
}