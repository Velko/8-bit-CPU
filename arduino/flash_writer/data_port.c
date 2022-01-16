#include <avr/io.h>
#include "data_port.h"

/* Flash chip's data pins are connected to Arduino pins
    9, 8, 7, 6, 5, 4, 3, 2 (MSB - LSB)

   According to UNO layout that is:
   PB1, PB0, PD7, PD6, PD5, PD4, PD3, PD2
    7    6    5    4    3    2    1    0

   we should split off PORTB and PORTD parts
   PB1, PB0
    7    6

   PD7, PD6, PD5, PD4, PD3, PD2
    5    4    3    2    1    0

   So, we should shift right 6 places for PORTB
   and shift left 2 places for PORTD
*/

void data_port_set_input()
{
    DDRB &= 0xfc;
    DDRD &= 0x03;
}

uint8_t data_port_read()
{
    uint8_t value = (PIND >> 2) | (PINB << 6);
    return value;
}

void data_port_write(uint8_t value)
{
    /* no worries with PORTD - changing PD0 and PD1 won't affect UART */
    DDRD |= 0xfc;
    PORTD = value << 2;

    /* careful with PORTB - PB2 controls shift register latch */
    DDRB |= 0x03;
    PORTB = (PORTB & 0xfc ) | (value >> 6);
}
