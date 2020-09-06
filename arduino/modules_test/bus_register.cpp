#include "bus_register.h"
#include <Arduino.h>

#define PIN_LOAD    0
#define PIN_OUT     1


Register::Register(DeviceInterface &_dev)
    : Register(
        _dev,
        ShiftPin(PIN_LOAD, CtrlPin::ACTIVE_LOW),
        ShiftPin(PIN_OUT, CtrlPin::ACTIVE_LOW)
    )
{

}

Register::Register(DeviceInterface &_dev, ShiftPin&& _pin_load, ShiftPin&& _pin_out)
    : devices{_dev},
      BusDevice{9, 8, 7, 6, 5, 4, 3, 2},
      pin_load{_pin_load},
      pin_out{_pin_out}
{

}

void Register::setup()
{
    pin_load.setup();
    pin_out.setup();
}

void Register::load()
{
    pin_load.on();
    devices.clock.pulse();
    pin_load.off();
}

void Register::write(uint8_t value)
{
    bus.write(value);
    pin_load.on();
    devices.clock.pulse();
    // Emulate bus changes before LOAD is released
    // but since register should latch the value on
    // clock pulse - it should not affect it anymore
    bus.write(~value);
    pin_load.off();

    // Add few pulses to see if releasing LOAD really
    // worked
    devices.clock.pulse();
    devices.clock.pulse();

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
