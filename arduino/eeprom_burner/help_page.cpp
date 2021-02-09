#include <Arduino.h>

void display_help()
{
    Serial.println(F("Valid commands are:"));
    Serial.println(F("    help   - display this page"));
    Serial.println(F("    digits - burn digits"));
    Serial.println(F("    verify-digits - verify 7-seg digits"));
    Serial.println(F("    sieve - burn test program: Prime Sieve"));
    Serial.println(F("    verify-sieve - verify test program"));
    Serial.println(F("    control0 - burn control ROM #0"));
    Serial.println(F("    verify-control0 - verify control ROM #0"));
    Serial.println(F("    control1 - burn control ROM #1"));
    Serial.println(F("    verify-control1 - verify control ROM #1"));
    Serial.println(F("    erase  - erase all contents"));
    Serial.println(F("    read   - read all contents"));
}
