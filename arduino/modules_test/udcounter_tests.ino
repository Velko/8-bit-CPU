#include "bus_udcounter.h"



void down_count_demo()
{
    UpDownCounter udc(DeviceInterface::instance);
    udc.setup();

    bool count_down = false;

    for(;;)
    {
        if (count_down)
            udc.MovePrev();
        else
            udc.MoveNext();

        uint8_t val = udc.read();
        Serial.println(val);
        delay(100);

        if (val == 0) count_down = false;
        if (val == 255) count_down = true;
    }
}

void reg_load_store_output(Register *r, int repeats);
void test_count_up(Counter *c, int repeats);
void test_count_down(UpDownCounter *c, int repeats);


void udcounter_tests()
{
    UpDownCounter udc(DeviceInterface::instance);
    udc.setup();

    reg_load_store_output(&udc, 1000);
    test_count_up(&udc, 100);
    test_count_down(&udc, 100);
}

void test_count_down(UpDownCounter *c, int repeats)
{
    c->setup();
    Serial.print(F("Count down"));
    c->write(255);
    for (int pass = 0; pass < repeats; ++pass)
    {
        if ((pass % 4) == 0)
            Serial.print('.');

        for (int i = 255; i >= 0; --i)
        {
            uint8_t val = c->read();
            if (val != (uint8_t)i)
            {
                Serial.print(F("ERR "));
                Serial.println(i);
                return;
            }
            c->MovePrev();
        }
    }
    Serial.println(F("OK"));
}
