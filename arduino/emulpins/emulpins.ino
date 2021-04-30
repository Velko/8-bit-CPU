/*
  Utility to test functionality of various modules
 */

#include <EEPROM.h>
#include "op-defs.h"
#include "devices.h"


void load_default_cword();
void store_default_cword(uint32_t cword);

uint32_t default_cword;

void setup()
{
    Serial.begin(115200);
    load_default_cword();
    set_control(default_cword);
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
        main_bus = Serial.parseInt();
        break;

    case 'b':
        Serial.println(main_bus);
        break;

    case 's':
        Serial.println(Flags.read_tap());
        break;

    case 'f':
        break;

    case 'O':
        val = Serial.parseInt();
        store_default_cword(val);
        set_control(val);
        main_bus = 0;
        break;

    case 'M':
        val = Serial.parseInt();
        set_control(val);
        break;

    case 'N':
        // NOP
        break;

    case 'c':
        clock_pulse();
        break;

    case 'C':
        clock_inverted();
        break;

    case 'T':
        clock_pulse();
        clock_inverted();
        break;

    case 'r':
        val = Serial.parseInt();
        Serial.println(IR.read_tap());
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
