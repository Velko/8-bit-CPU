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

void reg_load_store_output(Register *r, int repeats);
void test_count_up(Counter *c, int repeats);
void test_count_down(UpDownCounter *c);


void udcounter_tests()
{
    reg_load_store_output(&udc, 1000);
    test_count_up(&udc, 100);
    test_count_down(&udc);
}

void test_count_down(UpDownCounter *c)
{
    c->setup();
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
        delayMicroseconds(10);
    }
    Serial.println(F("OK"));
}
