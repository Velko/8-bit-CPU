#include <Arduino.h>
#include "device_interface.h"

#define PIN_CLK        SCL
#define PIN_CLK_INV    SDA

DeviceInterface::DeviceInterface(uint16_t def_c_word)
    : clock{PIN_CLK},
      inv_clock{PIN_CLK_INV},
      control{def_c_word}
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
