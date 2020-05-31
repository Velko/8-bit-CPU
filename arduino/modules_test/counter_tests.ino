#include <iobus.h>



void counter_loop()
{
    register_setup();

    for(;;)
    {
        pulse_clock();
        uint8_t val = register_read();
        Serial.println(val);
        delay(100);
    }
}

