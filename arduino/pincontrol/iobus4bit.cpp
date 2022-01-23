#include <avr/io.h>
#include "iobus4bit.h"

/* 4-bit IOBus is connected always to Arduino pins
    A3, A2, A1, A0 (MSB - LSB)

    According to UNO layout that is:
    PC3, PC2, PC1, PC0
     3    2    1    0

    So we just have to mask out unused bits and it corresponds to
    PORTC directly
*/

IOBus4bit::IOBus4bit()
{

}

void IOBus4bit::set_input()
{
    DDRC &= 0xF0;
}

uint8_t IOBus4bit::read()
{
    return PINC & 0x0F;
}


void IOBus4bit::write(uint8_t value)
{
    DDRC |= 0x0f;
    PORTC = (PORTC & 0xf0 ) | (value & 0x0f);
}
