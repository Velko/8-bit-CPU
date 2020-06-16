#include "bus_alu.h"
#include <Arduino.h>

#define PIN_LOAD_B     10
#define PIN_OUT_B      -1  // hardwired to off

#define PIN_OUT_ALU    A3
#define PIN_SUBTRACT   SDA  // alias of A4
#define PIN_USE_CARRY  SCL  // alias of A5
#define PIN_STORE_FLAG A3   // connect together ALU_OUT and STORE_FLAGS

SecondRegister::SecondRegister()
    : Register (
        CtrlPin(PIN_LOAD_B, CtrlPin::ACTIVE_LOW),
        CtrlPin(PIN_OUT_B, CtrlPin::ACTIVE_LOW)
    )
{
}



ALU::ALU()
    : flags{A0, A1, A2},
      pin_out{PIN_OUT_ALU, CtrlPin::ACTIVE_LOW},
      pin_subtract{PIN_SUBTRACT, CtrlPin::ACTIVE_HIGH},
      pin_use_carry{PIN_USE_CARRY, CtrlPin::ACTIVE_HIGH}
{
}

void ALU::setup()
{
    reg_a.setup();
    reg_b.setup();
    flags.set_input();

    pin_out.setup();
    pin_subtract.setup();
    pin_use_carry.setup();
}


uint8_t ALU::add(uint8_t a, uint8_t b, bool carry_in)
{
    reg_a.write(a);
    reg_b.write(b);

    pin_subtract.off();
    pin_use_carry.set(carry_in);
    pin_out.on();

    reg_a.load();

    pin_out.off();

    return reg_a.read();
}

int8_t ALU::sub(uint8_t a, uint8_t b, bool carry_in)
{
    reg_a.write(a);
    reg_b.write(b);

    pin_subtract.on();
    pin_use_carry.set(carry_in);
    pin_out.on();

    reg_a.load();

    pin_out.off();

    return reg_a.read();
}

uint8_t ALU::read_flags()
{
    return flags.read();
}