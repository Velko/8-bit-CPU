#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>

#include "addr_port.h"
#include "data_port.h"
#include "flash_hw.h"

#define CTRL_PORT   PORTC
#define CTRL_DDR    DDRC

#define WE          PC5
#define CS1         PC0
#define CS2         PC1
#define OE          PC4

#define CURRENT_CS  CS1


void flash_setup()
{
    CTRL_PORT |= _BV(WE) | _BV(CS1) | _BV(CS2) | _BV(OE);
    CTRL_DDR  |= _BV(WE) | _BV(CS1) | _BV(CS2) | _BV(OE);

    data_port_set_input();

    addr_port_setup();

    // Turn on Flash chip
    CTRL_PORT &= ~_BV(CURRENT_CS);
}

void flash_prepare_write()
{
    data_port_set_input(); /* To be sure, set as inputs */
    CTRL_PORT |= _BV(OE); /* Flash as input */
}

void flash_end_write()
{
    /* Switch back to inputs as soon as possible:
       let EEPROM control data lines */
    data_port_set_input();
}

void flash_send_command(uint32_t addr, uint8_t value)
{
    addr_port_write24(addr);

    data_port_write(value);

    /* Pulse the WE pin to start write */
    CTRL_PORT &= ~_BV(WE);
    CTRL_PORT |= _BV(WE);
}

uint8_t flash_read()
{
    data_port_set_input(); /* Set as inputs */
    CTRL_PORT &= ~_BV(OE); /* Flash as output */
    _delay_us(1);
    uint8_t data = data_port_read();
    CTRL_PORT |= _BV(OE); /* Flash as input */

    return data;
}


uint8_t flash_read_addr(uint32_t addr)
{
    addr_port_write24(addr);
    return flash_read();
}
