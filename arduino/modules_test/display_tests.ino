#include "dev_display.h"

Display dsp;

void display_demo()
{
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
