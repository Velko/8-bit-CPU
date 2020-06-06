#include "bus_counter.h"

Counter cnt;

void counter_loop()
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

