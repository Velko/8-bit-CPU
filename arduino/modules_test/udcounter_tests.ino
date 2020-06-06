#include "bus_udcounter.h"

UpDownCounter udc;

void down_count_demo()
{
    udc.setup();

    for(;;)
    {
        udc.MovePrev();
        uint8_t val = udc.read();
        Serial.println(val);
        delay(100);
    }
}

void test_count_down(UpDownCounter *c);


void udcounter_tests()
{
    reg_load_store_output(&udc);
    test_count_up(&udc);
    test_count_down(&udc);
}

void test_count_down(UpDownCounter *c)
{
    Serial.print(F("Count down... "));
    c->write(0);
    for (int i = 511; i >= 0; --i)
    {
        uint8_t val = c->read();
        if (val != (uint8_t)i)
        {
            Serial.print(F("ERR "));
            Serial.println(i);
            return;
        }
        c->MovePrev();
        delay(1);
    }
    Serial.println(F("OK"));
}
