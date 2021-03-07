#include "serprog.h"

SerProg<HardwareSerial> Prog(Serial);

void setup()
{
    Serial.begin(115200);
    //Serial.setTimeout(24UL * 60 * 60 * 1000);
    //eeprom_setup();
}

void loop()
{
    Prog.MainLoop();
}