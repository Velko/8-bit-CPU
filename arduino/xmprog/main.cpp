#include "wrap_arduino.h"

#include "xmprog.h"


XmProg Prog(Serial);

#ifndef __AVR__

int main()
{


    for(;;)
    {
        loop();
    }

    return 0;
}


#endif /* __AVR__ */

void setup()
{
    Serial.begin(115200);
    while (!Serial);
    Serial.println("XMODEM writer 0.1");
}

void loop()
{
    Prog.StepMainLoop();
}