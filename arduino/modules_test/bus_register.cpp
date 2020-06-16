#include "bus_register.h"
#include <Arduino.h>

#define PIN_LOAD    13
#define PIN_OUT     12


Register::Register()
    : Register(
        CtrlPin(PIN_LOAD, CtrlPin::ACTIVE_LOW),
        CtrlPin(PIN_OUT, CtrlPin::ACTIVE_LOW)
    )
{

}

Register::Register(CtrlPin&& _pin_load, CtrlPin&& _pin_out)
    : BusDevice{9, 8, 7, 6, 5, 4, 3, 2},
      pin_load{_pin_load},
      pin_out{_pin_out}
{

}

void Register::setup()
{
    clock.setup();
    pin_load.setup();
    pin_out.setup();
}

void Register::load()
{
    pin_load.on();
    clock.pulse();
    pin_load.off();
}

void Register::write(uint8_t value)
{
    bus.write(value);
    pin_load.on();
    clock.pulse();
    // Emulate bus changes before LOAD is released
    // but since register should latch the value on
    // clock pulse - it should not affect it anymore
    bus.write(~value);
    pin_load.off();

    // Add few pulses to see if releasing LOAD really
    // worked
    clock.pulse();
    clock.pulse();

    // allow other devices to drive the bus
    bus.set_input();
}

uint8_t Register::read()
{
    bus.set_input();
    pin_out.on();
    uint8_t value = bus.read();
    pin_out.off();

    return value;
}
