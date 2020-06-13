#include "dev_display.h"
#include <Arduino.h>

const int MODE_PINS[] = {12, 13};


Display::Display()
    : BusDevice(9, 8, 7, 6, 5, 4, 2, 3)
{
}

void Display::setup()
{
    digitalWrite(MODE_PINS[0], LOW);
    digitalWrite(MODE_PINS[1], LOW);

    pinMode(MODE_PINS[0], OUTPUT);
    pinMode(MODE_PINS[1], OUTPUT);
}

void Display::write(uint8_t value)
{
    bus.write(value);
}

uint8_t Display::read()
{
    // Should not attempt to read it
    __builtin_unreachable();
}


void Display::set_mode(uint8_t mode)
{
    digitalWrite(MODE_PINS[0], mode & 1 ? HIGH : LOW);
    digitalWrite(MODE_PINS[1], mode & 2 ? HIGH : LOW);
}