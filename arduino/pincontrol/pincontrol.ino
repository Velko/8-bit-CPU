/*
  Utility to test functionality of various modules
 */

#include <EEPROM.h>
#include "device_interface.h"
#include "op-defs.h"


void run_program();
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

    case 'r':
        // read-in from SPI. The control of the device is a bit awkward:
        //   * output control word (NOP + IRFetch.load bit)
        //   * set back to defaults, shift reg keeps loading while IRFetch.load is active
        //   * now IRFetch.load is inactive - read in latched value
        val = Serial.parseInt();
        dev.control.write16(val);
        dev.control.write16(default_cword);
        val = dev.control.write16(default_cword);
        Serial.println(val);
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
