#include <Arduino.h>
#include "device_interface.h"

#define PIN_CLK        SCL
#define PIN_CLK_INV    SDA

DeviceInterface::DeviceInterface()
    : clock{PIN_CLK},
      inv_clock{PIN_CLK_INV}
{

}


void DeviceInterface::setup()
{
    mainBus.set_input();
    flagsBus.set_input();
    clock.setup();
    inv_clock.setup();
    control.setup();
}
