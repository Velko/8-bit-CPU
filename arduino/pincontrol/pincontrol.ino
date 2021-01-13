/*
  Utility to test functionality of various modules
 */


#include <shiftoutext.h>
#include "device_interface.h"



void setup()
{
    Serial.begin(9600);
    DeviceInterface::instance.setup();
}


void loop()
{
    char buffer[20];
    DeviceInterface &dev = DeviceInterface::instance;

    int cmd = Serial.read();

    if (cmd < 0) return;

    uint8_t val = 0;

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
        sprintf_P(buffer, PSTR("b %d"), val);
        Serial.println(buffer);
        break;

    case 'f':
        dev.mainBus.set_input();
        break;

    case 'p':
        val = Serial.parseInt();
        dev.control.clear(val);
        break;

    case 'P':
        val = Serial.parseInt();
        dev.control.set(val);
        break;

    case 'M':
        dev.control.commit();
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
