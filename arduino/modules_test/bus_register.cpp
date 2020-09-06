#include "bus_register.h"
#include <Arduino.h>

#define PIN_LOAD    0
#define PIN_OUT     1


Register::Register(DeviceInterface &_dev)
    : Register(
        _dev,
        _dev.control.claim(PIN_LOAD, CtrlPin::ACTIVE_LOW),
        _dev.control.claim(PIN_OUT, CtrlPin::ACTIVE_LOW)
    )
{

}

Register::Register(DeviceInterface &_dev, ShiftPin &_pin_load, ShiftPin &_pin_out)
    : devices{_dev},
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

void Register::write_check(uint8_t value)
{
    devices.mainBus.write(value);
    pin_load.on();
    devices.clock.pulse();
    // Emulate bus changes before LOAD is released
    // but since register should latch the value on
    // clock pulse - it should not affect it anymore
    devices.mainBus.write(~value);
    pin_load.off();

    // Add few pulses to see if releasing LOAD really
    // worked
    devices.clock.pulse();
    devices.clock.pulse();

    // allow other devices to drive the bus
    devices.mainBus.set_input();
}

void Register::write_quick(uint8_t value)
{
    // Do just the minimum for loading the value. Checking if
    // Register reacts correctly to all quirks that might occur
    // in a computer is done with write_check().
    devices.mainBus.write(value);
    pin_load.on();
    devices.clock.pulse();
    pin_load.off();

    // allow other devices to drive the bus
    devices.mainBus.set_input();
}


uint8_t Register::read()
{
    devices.mainBus.set_input();
    pin_out.on();
    uint8_t value = devices.mainBus.read();
    pin_out.off();

    return value;
}
