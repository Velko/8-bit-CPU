#include <avr/io.h>
#include "data_port.h"

/* Flash chip's data pins are connected to Arduino pins
    9, 8, 7, 6, 5, 4, 3, 2 (MSB - LSB)

   EEPROM data pins are connected to Arduino:
    2, 3, 4, 5, 6, 7, 8, 9 (MSB - LSB)

   To get same situation as for Flash, we need to reverse
   the bits. Probably I should consider another, re-wired writer
   PCB.

   According to UNO layout, that maps to:
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

static inline uint8_t bit_reverse(uint8_t x )
{
    x = ((x >> 1) & 0x55) | ((x << 1) & 0xaa);
    x = ((x >> 2) & 0x33) | ((x << 2) & 0xcc);
    x = ((x >> 4) & 0x0f) | ((x << 4) & 0xf0);

    return x;
}

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


uint8_t data_port_read_rev()
{
    return bit_reverse(data_port_read());
}

void data_port_write_rev(uint8_t value)
{
    data_port_write(bit_reverse(value));
}