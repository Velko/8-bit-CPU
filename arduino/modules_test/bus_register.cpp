#include "bus_register.h"
#include <Arduino.h>

#define PIN_LOAD    13
#define PIN_OUT     12


Register::Register()
    : BusDevice(9, 8, 7, 6, 5, 4, 3, 2)
{

}

void Register::setup()
{
    clock.setup();

    digitalWrite(PIN_LOAD, HIGH);
    pinMode(PIN_LOAD, OUTPUT);

    digitalWrite(PIN_OUT, HIGH);
    pinMode(PIN_OUT, OUTPUT);
}

void Register::write(uint8_t value)
{
    bus.write(value);
    digitalWrite(PIN_LOAD, LOW);
    clock.pulse();
    // Emulate bus changes before LOAD is released
    // but since register should latch the value on
    // clock pulse - it should not affect it anymore
    bus.write(~value);
    delayMicroseconds(10);
    digitalWrite(PIN_LOAD, HIGH);

    // Add few pulses to see if releasing LOAD really
    // worked
    clock.pulse();
    clock.pulse();
}

uint8_t Register::read()
{
    bus.set_input();
    digitalWrite(PIN_OUT, LOW);
    delayMicroseconds(10);
    uint8_t value = bus.read();
    digitalWrite(PIN_OUT, HIGH);

    return value;
}
