#include "bus_alu.h"
#include <Arduino.h>

#define PIN_LOAD_B     10
#define PIN_OUT_B      -1  // hardwired to off

#define PIN_OUT_ALU    A3
#define PIN_SUBTRACT   SDA  // alias of A4
#define PIN_USE_CARRY  SCL  // alias of A5
#define PIN_STORE_FLAG -1  // hardwired to ON



uint8_t SecondRegister::get_pin_load()
{
    return PIN_LOAD_B;
}

uint8_t SecondRegister::get_pin_out()
{
    return PIN_OUT_B;
}

ALU::ALU()
    : flags{A0, A1, A2}
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

int8_t ALU::sub(uint8_t a, uint8_t b)
{
    reg_a.write(a);
    reg_b.write(b);

    digitalWrite(PIN_SUBTRACT, HIGH);
    digitalWrite(PIN_USE_CARRY, LOW);
    digitalWrite(PIN_OUT_ALU, LOW);

    reg_a.load();

    digitalWrite(PIN_OUT_ALU, HIGH);

    return reg_a.read();
}