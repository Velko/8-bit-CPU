#include <iobus.h>
#include "bus_device.h"

IOBus reg_bus({9, 8, 7, 6, 5, 4, 3, 2});

BusDevice reg;

#define REG_OUT     12


void register_setup()
{
    reg.setup();
}


uint8_t register_read()
{
}

void register_loop()
{
    register_setup();

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
