#include "bus_counter.h"

Counter cnt;

void counter_demo()
{
    cnt.setup();

    for(;;)
    {
        cnt.MoveNext();
        uint8_t val = cnt.read();
        Serial.println(val);
        delay(100);
    }
}

void test_count_up(Counter *c);

void counter_tests()
{
    reg_load_store_output(&cnt);
    test_count_up(&cnt);
}


void test_count_up(Counter *c)
{
    Serial.print(F("Count up... "));
    c->write(0);
    for (int i = 0; i < 512; ++i)
    {
        uint8_t val = c->read();
        if (val != (uint8_t)i)
        {
            Serial.print(F("ERR "));
            Serial.println(i);
            return;
        }
        c->MoveNext();
        delay(1);
    }
    Serial.println(F("OK"));
}
