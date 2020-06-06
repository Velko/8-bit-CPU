#include "bus_register.h"

extern Register reg;

void counter_loop()
{
    reg.setup();

    for(;;)
    {
        //reg.pulse_clock();
        uint8_t val = reg.read();
        Serial.println(val);
        delay(100);
    }
}

