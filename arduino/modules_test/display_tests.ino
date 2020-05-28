#include <iobus.h>


IOBus dsp_bus(9, 8, 7, 6, 5, 4, 2, 3);

const int MODE_PINS[] = {12, 13};

void display_set_mode(uint8_t mode)
{
    digitalWrite(MODE_PINS[0], mode & 1 ? HIGH : LOW);
    digitalWrite(MODE_PINS[1], mode & 2 ? HIGH : LOW);
    pinMode(MODE_PINS[0], OUTPUT);
    pinMode(MODE_PINS[1], OUTPUT);
}

void display_output(uint8_t value)
{
    dsp_bus.write(value);
}

void display_loop()
{
    for (;;)
    {
        for (int m = 0 ; m < 4 ; ++m)
        {
            display_set_mode(m);
            for (int i = 0 ; i < 256; ++i)
            {
                display_output(i);
                delay(200);
            }
        }
    }
}
