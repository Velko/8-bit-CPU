/*
  Utility to test functionality of various modules
 */


#include <shiftoutext.h>
#include "device_interface.h"
#include "register_tests.h"
#include "display_tests.h"
#include "counter_tests.h"
#include "udcounter_tests.h"
#include "alu_tests.h"


ShiftOutExt shift;

void setup()
{
    Serial.begin(9600);
    DeviceInterface::instance.setup();
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
        display_demo();
        break;
    case 'D':
        val = Serial.parseInt();
        display_set_value(val);
        break;
    case 'm':
        val = Serial.parseInt();
        display_set_mode(val);
        break;
    case 'r':
        register_demo();
        break;
    case 'R':
        val = Serial.parseInt();
        register_load(val);
        break;
    case 'c':
        counter_demo();
        break;
    case 'u':
        down_count_demo();
        break;
    case '1':
        register_tests();
        break;
    case '2':
        counter_tests();
        break;
    case '3':
        udcounter_tests();
        break;
    case 'a':
        alu_tests();
        break;
    case 'A':
        for (;;) alu_tests();
        break;
    case 's':
        val = Serial.parseInt();
        shift.setup();
        shift.write8(val);
        break;
    default:
        Serial.println(F("Unknown command!"));
        break;
    }
}
