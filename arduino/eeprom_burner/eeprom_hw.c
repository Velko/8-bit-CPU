#include <avr/io.h>
#include <util/delay.h>
#include "addr_port.h"
#include "rev_data_port.h"
#include "eeprom_hw.h"

#define CTRL_PORT   PORTC
#define CTRL_DDR    DDRC

#define WE          PC5
#define CS1         PC0
#define CS2         PC1
#define OE          PC4

//TODO: software selectable
#define CURRENT_CS  CS1

void eeprom_setup()
{
    CTRL_PORT |= _BV(WE) | _BV(CS1) | _BV(CS2) | _BV(OE);
    CTRL_DDR  |= _BV(WE) | _BV(CS1) | _BV(CS2) | _BV(OE);

    rev_data_port_set_input();

    addr_port_setup();

    // Turn on DIP EEPROM
    CTRL_PORT &= ~_BV(CURRENT_CS);
}

void eeprom_peform_write(uint16_t addr, uint8_t value)
{
    rev_data_port_set_input(); /* To be sure, set as inputs */
    CTRL_PORT |= _BV(OE); /* EEPROM as input */
    addr_port_write16(addr);

    rev_data_port_write(value);

    /* Pulse the WE pin to start write */
    CTRL_PORT &= ~_BV(WE);
    CTRL_PORT |= _BV(WE);

    /* Switch back to inputs as soon as possible:
       let EEPROM control data lines */
    rev_data_port_set_input();
}

uint8_t eeprom_read(uint16_t addr)
{
    rev_data_port_set_input(); /* Set as inputs */
    addr_port_write16(addr);

    CTRL_PORT &= ~_BV(OE); /* Flash as output */
    /* pause for EEPROM. Worst case scenario - it takes 250 ns to settle.
       So 1 uS (1000 ns) should be enough */
    _delay_us(1);

    return rev_data_port_read();
}
