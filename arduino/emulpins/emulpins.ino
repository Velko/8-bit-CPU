/*
  Utility to test functionality of various modules
 */

#include <EEPROM.h>
#include "op-defs.h"
#include "devices.h"
#include "device_interface.h"

void run_program();
void load_default_cword();
void store_default_cword(uint32_t cword);

DeviceInterface dev;

uint32_t default_cword;

void setup()
{
    Serial.begin(115200);
    load_default_cword();
    dev.control.write32(default_cword);
    RAM.setup();
}


void loop()
{
    int cmd = Serial.read();

    if (cmd < 0) return;

    uint32_t val = 0;

    switch (cmd)
    {
    case 'I':
        Serial.println(F("EmulPins"));
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

    case 'A':
        val = Serial.parseInt();
        dev.addressBus.write(val);
        break;

    case 'a':
        dev.addressBus.set_input();
        val = dev.addressBus.read();
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
        dev.control.write32(val);
        dev.mainBus.set_input();
        break;

    case 'M':
        val = Serial.parseInt();
        dev.control.write32(val);
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

    case 'r':
        val = Serial.parseInt();
        Serial.println(IR.read_tap());
        break;

    case 'R':
        if (default_cword != CTRL_DEFAULT)
        {
            Serial.println(F("Wiring updated, re-upload sketch!"));
            break;
        }
        run_program();
        break;

    default:
        Serial.println(F("Unknown command!"));
        break;
    }
}

void store_default_cword(uint32_t cword)
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
