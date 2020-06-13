#include "bus_register.h"


Register reg;

void register_demo()
{
    reg.setup();

    for (;;)
    {
        for (int i = 1; i < 256; i <<= 1)
        {
            Serial.print(i);
            Serial.print(" ");

            reg.write(i);
            delay(250);

            uint8_t readback = reg.read();
            Serial.print(readback);
            if (readback == i)
              Serial.println("   OK");
            else
              Serial.println("   ERR");
        }
    }
}

void reg_load_store_output(Register *r, int repeats);

void register_tests()
{
    reg_load_store_output(&reg, 1000);
}

void reg_load_store_output(Register *r, int repeats)
{
    r->setup();

    Serial.print(F("Load-store-output"));
    for (int pass = 0; pass < repeats; ++pass)
    {
        if (pass % 50 == 0)
            Serial.print('.');
        for (int i = 1; i < 256; i <<= 1)
        {
            r->write(i);
            uint8_t readback = r->read();

            if (readback != i)
            {
                Serial.print(F("ERR "));
                Serial.println(i);
                return;
            }
        }
    }
    Serial.println(F("OK"));
}