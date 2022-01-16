#include "addr_port.h"
#include <avr/io.h>

#define DDR_SPI     DDRB
#define PORT_SPI    PORTB
#define DD_MOSI     PB3
#define DD_MISO     PB4
#define DD_SCK      PB5
#define DD_SS       PB2

#define LATCH_PIN  DD_SS


void addr_port_setup(void)
{
    DDR_SPI = _BV(DD_MOSI) | _BV(DD_SCK) | _BV(LATCH_PIN);
    SPCR = _BV(SPE) | _BV(MSTR);
    SPSR = _BV(SPI2X);

    PORT_SPI &= ~_BV(LATCH_PIN);
}

void addr_port_write24(uint32_t data)
{
    SPDR = (data >> 16) & 0xFF;
    loop_until_bit_is_set(SPSR, SPIF);

    SPDR = (data >> 8) & 0xFF;
    loop_until_bit_is_set(SPSR, SPIF);

    SPDR = (data & 0xFF);
    loop_until_bit_is_set(SPSR, SPIF);

    PORT_SPI |= _BV(LATCH_PIN);
    PORT_SPI &= ~_BV(LATCH_PIN);
}
