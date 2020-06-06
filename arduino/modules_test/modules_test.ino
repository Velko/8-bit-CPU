/*
  Utility to test functionality of various modules
 */


#include "bus_register.h"
#include "dev_display.h"

extern Register reg;
extern Display dsp;


void setup()
{
    Serial.begin(9600);
}

void loop()
{
    int cmd = Serial.read();

    if (cmd < 0) return;

    uint8_t val = 0;

    switch (cmd)
    {
    case 'I':
          Serial.println(F("MTEST"));
          break;
    case 'd':
        display_loop();
        break;
    case 'D':
        val = Serial.parseInt();
        dsp.setup();
        dsp.write(val);
        break;
    case 'm':
        val = Serial.parseInt();
        dsp.setup();
        dsp.set_mode(val);
        break;
    case 'r':
        register_loop();
        break;
    case 'R':
        val = Serial.parseInt();
        reg.setup();
        reg.write(val);
        break;
    case 'c':
        counter_loop();
        break;
    default:
        Serial.println(F("Unknown command!"));
        break;
    }
}
