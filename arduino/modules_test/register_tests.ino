#include "bus_register.h"


Register reg;

void register_loop()
{
    reg.setup();

    for (;;)
    {
        for (int i = 1; i < 256; i <<= 1)
        {
            Serial.print(i);
            Serial.print(" ");

            reg.write(i);
            delay(250);

            uint8_t readback = reg.read();
            Serial.print(readback);
            if (readback == i)
              Serial.println("   OK");
            else
              Serial.println("   ERR");
        }
    }

}
