#include "bus_alu.h"
#include <Arduino.h>

#define PIN_LOAD_B     10
#define PIN_OUT_B      A5  // can reuse - not stricly needed

#define PIN_OUT_ALU    A4
#define PIN_SUBTRACT   SDA
#define PIN_USE_CARRY  SCL
#define PIN_STORE_FLAG 0  // hardwired to ON



uint8_t SecondRegister::get_pin_load()
{
    return PIN_LOAD_B;
}

uint8_t SecondRegister::get_pin_out()
{
    return PIN_OUT_B;
}

ALU::ALU()
    : flags{A0, A1, A2, A3}
{
}

void ALU::setup()
{
    reg_a.setup();
    reg_b.setup();
    flags.set_input();

    digitalWrite(PIN_OUT_ALU, HIGH);
    pinMode(PIN_OUT_ALU, OUTPUT);

    digitalWrite(PIN_SUBTRACT, LOW);
    pinMode(PIN_SUBTRACT, OUTPUT);

    digitalWrite(PIN_USE_CARRY, LOW);
    pinMode(PIN_USE_CARRY, OUTPUT);
}


uint8_t ALU::add(uint8_t a, uint8_t b)
{
    reg_a.write(a);
    reg_b.write(b);

    digitalWrite(PIN_SUBTRACT, LOW);
    digitalWrite(PIN_USE_CARRY, LOW);
    digitalWrite(PIN_OUT_ALU, LOW);

    reg_a.load();

    digitalWrite(PIN_OUT_ALU, HIGH);

    return reg_a.read();
}