#include "bus_device.h"

#include <Arduino.h>

#define PIN_CLK    11


BusDevice::BusDevice(uint8_t p0, uint8_t p1, uint8_t p2, uint8_t p3, uint8_t p4, uint8_t p5, uint8_t p6, uint8_t p7)
    : bus(p0, p1, p2, p3, p4, p5, p6, p7)
{
}

void BusDevice::setup()
{
    /* Default "inactive" position */

    digitalWrite(PIN_CLK, LOW);
    pinMode(PIN_CLK, OUTPUT);
}

void BusDevice::pulse_clock()
{
    digitalWrite(PIN_CLK, HIGH);
    delay(100);
    digitalWrite(PIN_CLK, LOW);
}
