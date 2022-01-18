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

    data_port_set_input();

    addr_port_setup();
}

void eeprom_select(uint8_t idx)
{
    CTRL_PORT |= _BV(CS1) | _BV(CS2);

    switch (idx)
    {
    case 0:
        CTRL_PORT &= ~_BV(CS1);
        break;
    case 1:
        CTRL_PORT &= ~_BV(CS2);
        break;
    default:
        break;
    }
}

void eeprom_peform_write(uint16_t addr, uint8_t value)
{
    data_port_set_input(); /* To be sure, set as inputs */
    CTRL_PORT |= _BV(OE); /* EEPROM as input */
    addr_port_write16(addr);

    data_port_write_rev(value);

    /* Pulse the WE pin to start write */
    CTRL_PORT &= ~_BV(WE);
    _delay_us(1);
    CTRL_PORT |= _BV(WE);
    _delay_us(1);

    /* Switch back to inputs as soon as possible:
       let EEPROM control data lines */
    data_port_set_input();
}

uint8_t eeprom_read_addr(uint16_t addr)
{
    addr_port_write16(addr);
    return eeprom_read();
}

uint8_t eeprom_read(void)
{
    data_port_set_input(); /* Set as inputs */

    CTRL_PORT &= ~_BV(OE); /* EEPROM as output */
    /* pause for EEPROM. Worst case scenario - it takes 250 ns to settle.
       So 1 uS (1000 ns) should be enough */
    _delay_us(1);
    uint8_t data = data_port_read_rev();

    CTRL_PORT |= _BV(OE); /* EEPROM as input */

    return data;
}
