/* Skip everything if building for AVR */
#ifndef __AVR__

#include "serial_host.h"

void setup();
void loop();

int main()
{
    setup();

    for(;;)
    {
        loop();
    }

    return 0;
}


#endif /* __AVR__ */