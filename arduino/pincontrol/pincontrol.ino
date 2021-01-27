/*
  Utility to test functionality of various modules
 */

#include <EEPROM.h>
#include <shiftoutext.h>
#include "device_interface.h"


void load_default_cword();
void store_default_cword(uint16_t cword);

DeviceInterface dev;

uint16_t default_cword;

void setup()
{
    Serial.begin(115200);
    load_default_cword();
    dev.setup();
    dev.control.write16(default_cword);
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
        val = Serial.parseInt();
        store_default_cword(val);
        dev.control.write16(val);
        dev.mainBus.set_input();
        break;

    case 'M':
        val = Serial.parseInt();
        dev.control.write16(val);
        break;

    case 'N':
        // NOP
        break;

    case 'c':
        dev.clock.pulse();
        break;

    case 'C':
        dev.inv_clock.pulse();
        break;

    case 'T':
        dev.clock.pulse();
        dev.inv_clock.pulse();
        break;

    default:
        Serial.println(F("Unknown command!"));
        break;
    }
}

void store_default_cword(uint16_t cword)
{
    if (cword != default_cword)
    {
        EEPROM.put(0, cword);
        default_cword = cword;
    }
}

void load_default_cword()
{
     EEPROM.get(0, default_cword);
}
