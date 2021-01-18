#include "bus_alu.h"
#include <Arduino.h>

#define PIN_LOAD_B     2
#define PIN_OUT_B      6

#define PIN_OUT_ALU    3
#define PIN_SUBTRACT   4
#define PIN_USE_CARRY  5
#define PIN_STORE_FLAG 7

#define PIN_FLAGS_BUS  8
#define PIN_FLAGS_SEL  9

#include "device_interface.h"

SecondRegister::SecondRegister(DeviceInterface &_dev)
    : Register (
        _dev,
        _dev.control.claim(PIN_LOAD_B, CtrlPin::ACTIVE_LOW),
        _dev.control.claim(PIN_OUT_B, CtrlPin::ACTIVE_LOW)
    )
{
}



ALU::ALU(DeviceInterface &_dev)
    : reg_a(_dev),
      reg_b(_dev),
      devices{_dev},
      pin_out{_dev.control.claim(PIN_OUT_ALU, CtrlPin::ACTIVE_LOW)},
      pin_subtract{_dev.control.claim(PIN_SUBTRACT, CtrlPin::ACTIVE_HIGH)},
      pin_use_carry{_dev.control.claim(PIN_USE_CARRY, CtrlPin::ACTIVE_HIGH)},
      pin_flags_load{_dev.control.claim(PIN_STORE_FLAG, CtrlPin::ACTIVE_LOW)},
      pin_flags_out{_dev.control.claim(PIN_FLAGS_BUS, CtrlPin::ACTIVE_LOW)},
      pin_flags_sel{_dev.control.claim(PIN_FLAGS_SEL, CtrlPin::ACTIVE_HIGH)}
{
}

void ALU::setup()
{
    reg_a.setup();
    reg_b.setup();
    devices.flagsBus.set_input();

    pin_out.setup();
    pin_subtract.setup();
    pin_use_carry.setup();
    pin_flags_load.setup();
    pin_flags_out.setup();
    pin_flags_sel.setup();
    devices.control.commit();
}


uint8_t ALU::add(uint8_t a, uint8_t b, bool carry_in)
{
    reg_a.write_quick(a);
    reg_b.write_quick(b);

    pin_subtract.off(false);
    pin_use_carry.set(carry_in, false);
    pin_out.on(false);
    pin_flags_load.on();

    reg_a.load();

    pin_out.off(false);
    pin_flags_load.off();

    return reg_a.read();
}

uint8_t ALU::add_b(uint8_t a, uint8_t b, bool carry_in)
{
    reg_a.write_quick(a);
    reg_b.write_quick(b);

    pin_subtract.off(false);
    pin_use_carry.set(carry_in, false);
    pin_out.on(false);
    pin_flags_load.on();

    reg_b.load();

    pin_out.off(false);
    pin_flags_load.off();

    return reg_b.read();
}

int8_t ALU::sub(uint8_t a, uint8_t b, bool carry_in)
{
    reg_a.write_quick(a);
    reg_b.write_quick(b);

    pin_subtract.on(false);
    pin_use_carry.set(carry_in, false);
    pin_out.on(false);
    pin_flags_load.on();

    reg_a.load();

    pin_out.off(false);
    pin_flags_load.off();

    return reg_a.read();
}

int8_t ALU::sub_b(uint8_t a, uint8_t b, bool carry_in)
{
    reg_a.write_quick(a);
    reg_b.write_quick(b);

    pin_subtract.on(false);
    pin_use_carry.set(carry_in, false);
    pin_out.on(false);
    pin_flags_load.on();

    reg_b.load();

    pin_out.off(false);
    pin_flags_load.off();

    return reg_b.read();
}

uint8_t ALU::read_flags()
{
    return devices.flagsBus.read();
}

void ALU::set_carry()
{
    devices.mainBus.write(0b0100);
    pin_flags_load.on(false);
    pin_flags_sel.on();

    devices.clock.pulse();
    devices.inv_clock.pulse();

    pin_flags_sel.off(false);
    pin_flags_load.off();
}
