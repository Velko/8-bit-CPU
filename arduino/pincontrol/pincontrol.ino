/*
  Utility to test functionality of various modules
 */


#include <shiftoutext.h>
#include "device_interface.h"

DeviceInterface dev;

void setup()
{
    Serial.begin(9600);
    dev.setup();
}


void loop()
{
    int cmd = Serial.read();

    if (cmd < 0) return;

    uint16_t val = 0;

    switch (cmd)
    {
    case 'I':
        Serial.println(F("PinControl"));
        break;

    case 'B':
        val = Serial.parseInt();
        dev.mainBus.write(val);
        break;

    case 'b':
        dev.mainBus.set_input();
        val = dev.mainBus.read();
        Serial.println(val);
        break;

    case 's':
        val = dev.flagsBus.read();
        Serial.println(val);
        break;

    case 'f':
        dev.mainBus.set_input();
        break;

    case 'O':
        dev.control.reset();
        dev.mainBus.set_input();
        break;

    case 'M':
        val = Serial.parseInt();
        dev.control.commit(val);
        break;

    case 'c':
        dev.clock.pulse();
        break;

    case 'C':
        dev.inv_clock.pulse();
        break;

    default:
        Serial.println(F("Unknown command!"));
        break;
    }
}
