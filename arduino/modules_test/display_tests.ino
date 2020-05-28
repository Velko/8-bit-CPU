#include <iobus.h>


IOBus dsp_bus(9, 8, 7, 6, 5, 4, 2, 3);

const int MODE_PINS[] = {12, 13};

void display_setup_pins()
{
    dsp_bus.write(0);

    for (int i = 0; i < 2; ++i)
    {
        digitalWrite(MODE_PINS[i], LOW);
        pinMode(MODE_PINS[i], OUTPUT);
    }
}

void display_set_mode(int mode)
{
    digitalWrite(MODE_PINS[0], mode & 1 ? HIGH : LOW);
    digitalWrite(MODE_PINS[1], mode & 2 ? HIGH : LOW);
}

void display_loop()
{
    display_setup_pins();

    for (;;)
    {
      for (int m = 0 ; m < 4 ; ++m)
      {
          display_set_mode(m);
          for (int i = 0 ; i < 256; ++i)
          {
              dsp_bus.write(i);
              delay(200);
          }
      }
    }
}
