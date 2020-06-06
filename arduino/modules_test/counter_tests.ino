#include "bus_udcounter.h"

Counter cnt;

UpDownCounter udc;

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