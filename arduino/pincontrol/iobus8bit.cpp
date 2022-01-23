#include <avr/io.h>
#include "iobus8bit.h"

/* 8-bit IOBus is connected always to Arduino pins
    2, 3, 4, 5, 6, 7, 8, 9 (MSB - LSB)

   According to UNO layout that is:
   PD2, PD3, PD4, PD5, PD6, PD7, PB0, PB1
    7    6    5    4    3    2    1    0

   First: we should reverse the bit order

   PB1, PB0, PD7, PD6, PD5, PD4, PD3, PD2
    0    1    2    3    4    5    6    7

   Now: split off PORTB and PORTD parts
   PB1, PB0
    0    1

   PD7, PD6, PD5, PD4, PD3, PD2
    2    3    4    5    6    7

   So, we should shift right 6 places for PORTB
   and shift left 2 places for PORTD

   TODO: is it possible to optimize even more? shift right 6 places is not
         too efficient
*/

static inline uint8_t bit_reverse(uint8_t x )
{
    x = ((x >> 1) & 0x55) | ((x << 1) & 0xaa);
    x = ((x >> 2) & 0x33) | ((x << 2) & 0xcc);
    x = ((x >> 4) & 0x0f) | ((x << 4) & 0xf0);

    return x;
}


IOBus8bit::IOBus8bit()
{

}

void IOBus8bit::set_input()
{
    DDRB &= 0xfc;
    DDRD &= 0x03;
}

uint8_t IOBus8bit::read()
{
    uint8_t value = (PIND >> 2) | (PINB << 6);
    return bit_reverse(value);
}

void IOBus8bit::write(uint8_t value)
{
    value = bit_reverse(value);

    /* no worries with PORTD - changing PD0 and PD1 won't affect UART */
    DDRD |= 0xfc;
    PORTD = value << 2;

    /* careful with PORTB - PB2 controls shift register latch */
    DDRB |= 0x03;
    PORTB = (PORTB & 0xfc ) | (value >> 6);
}

