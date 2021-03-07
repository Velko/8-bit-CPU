/* Skip everything if building for AVR */
#ifndef __AVR__

#include "serial_host.h"
#include "serprog.h"


SerProg<SerialHost> Prog(Serial);


int main()
{
    Serial.begin(115200);

    for(;;)
    {
        Prog.MainLoop();
    }

    return 0;
}


#endif /* __AVR__ */