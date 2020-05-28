#include <iobus.h>

IOBus reg_bus({9, 8, 7, 6, 5, 4, 3, 2});

#define REG_CLK     11
#define REG_LOAD    13
#define REG_OUT     12

void pulse_clock()
{
    digitalWrite(REG_CLK, HIGH);
    delay(100);
    digitalWrite(REG_CLK, LOW);
}


void register_test()
{
    digitalWrite(REG_CLK, LOW);
    pinMode(REG_CLK, OUTPUT);

    digitalWrite(REG_LOAD, HIGH);
    pinMode(REG_LOAD, OUTPUT);

    digitalWrite(REG_OUT, HIGH);
    pinMode(REG_OUT, OUTPUT);

    for (;;)
    {
        for (int i = 1; i < 256; i <<= 1)
        {
            Serial.print(i);
            Serial.print(" ");
            reg_bus.write(i);
            digitalWrite(REG_LOAD, LOW);
            pulse_clock();
            digitalWrite(REG_LOAD, HIGH);
            delay(250);

            reg_bus.set_input();
            digitalWrite(REG_OUT, LOW);
            delay(250);
            uint8_t readback = reg_bus.read();
            digitalWrite(REG_OUT, HIGH);
            Serial.print(readback);
            if (readback == i)
              Serial.println("   OK");
            else
              Serial.println("   ERR");
        }
    }

}
