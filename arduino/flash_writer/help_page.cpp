#include <Arduino.h>

void display_help()
{
    Serial.println(F("Valid commands are:"));
    Serial.println(F("    help   - display this page"));
    Serial.println(F("    identify - identify the chip"));
    Serial.println(F("    read   - read all contents"));
}
