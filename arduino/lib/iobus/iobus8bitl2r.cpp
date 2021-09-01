#include <avr/io.h>
#include "iobus8bitl2r.h"

/* 8-bit IOBus is connected always to Arduino pins
    2, 3, 4, 5, 6, 7, 8, 9 (LSB - MSB)

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

IOBus8bitL2R::IOBus8bitL2R()
{

}

void IOBus8bitL2R::set_input()
{
    DDRB &= 0xfc;
    DDRD &= 0x03;
}

uint8_t IOBus8bitL2R::read()
{
    uint8_t value = (PIND >> 2) | (PINB << 6);
    return value;
}

void IOBus8bitL2R::write(uint8_t value)
{
    /* no worries with PORTD - changing PD0 and PD1 won't affect UART */
    DDRD |= 0xfc;
    PORTD = value << 2;

    /* careful with PORTB - PB2 controls shift register latch */
    DDRB |= 0x03;
    PORTB = (PORTB & 0xfc ) | (value >> 6);
}

