#include "dev_display.h"

void display_demo()
{
    Display dsp(DeviceInterface::instance);
    dsp.setup();

    for (;;)
    {
        for (int m = 0 ; m < 4 ; ++m)
        {
            dsp.set_mode(m);
            for (int i = 0 ; i < 256; ++i)
            {
                dsp.write(i);
                delay(200);
            }
        }
    }
}

void display_set_mode(int val)
{
    Display dsp(DeviceInterface::instance);
    dsp.setup();
    dsp.set_mode(val);
}

void display_set_value(int val)
{
    Display dsp(DeviceInterface::instance);
    dsp.setup();
    dsp.write(val);
}
