#include "bus_counter.h"


#include <Arduino.h>

#define PIN_COUNT       2

Counter::Counter(DeviceInterface &_dev)
    : Register(_dev),
      pin_c_enable{_dev.control.claim(PIN_COUNT, CtrlPin::ACTIVE_HIGH)}
{
}

Counter::Counter(DeviceInterface &_dev, CtrlPin::ActiveLevel enable_mode)
    : Register(_dev),
      pin_c_enable{_dev.control.claim(PIN_COUNT, enable_mode)}
{
}

void Counter::setup()
{
    Register::setup();
    pin_c_enable.setup();
}

void Counter::MoveNext()
{
    pin_c_enable.on();
    devices.clock.pulse();
    pin_c_enable.off();

    // additional pulses to see if CE
    // really works
    devices.clock.pulse();
    devices.clock.pulse();
}
