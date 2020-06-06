#include "bus_device.h"

#include <Arduino.h>

#define PIN_CLK    11
#define PIN_LOAD    13
#define PIN_OUT     12


BusDevice::BusDevice()
    : bus(9, 8, 7, 6, 5, 4, 3, 2)
{
}

void BusDevice::setup()
{
    /* Default "inactive" position */

    digitalWrite(PIN_CLK, LOW);
    pinMode(PIN_CLK, OUTPUT);

    digitalWrite(PIN_LOAD, HIGH);
    pinMode(PIN_LOAD, OUTPUT);

    digitalWrite(PIN_OUT, HIGH);
    pinMode(PIN_OUT, OUTPUT);
}

void BusDevice::pulse_clock()
{
    digitalWrite(PIN_CLK, HIGH);
    delay(100);
    digitalWrite(PIN_CLK, LOW);
}

void BusDevice::write(uint8_t value)
{
    bus.write(value);
    digitalWrite(PIN_LOAD, LOW);
    pulse_clock();
    // Emulate bus changes before LOAD is released
    // but since register should latch the value on
    // clock pulse - it should not affect it anymore
    bus.write(~value);
    delay(1);
    digitalWrite(PIN_LOAD, HIGH);
}

uint8_t BusDevice::read()
{
    bus.set_input();
    digitalWrite(PIN_OUT, LOW);
    delay(50);
    uint8_t value = bus.read();
    digitalWrite(PIN_OUT, HIGH);

    return value;
}