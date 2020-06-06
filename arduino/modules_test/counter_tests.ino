#include "bus_device.h"

extern BusDevice reg;

void counter_loop()
{
    reg.setup();

    for(;;)
    {
        reg.pulse_clock();
        uint8_t val = register_read();
        Serial.println(val);
        delay(100);
    }
}

