#include <util/delay.h>
#include "addr_port.h"
#include "rev_data_port.h"
#include "eeprom_hw.h"
#include "ctrl_pins.h"

void eeprom_setup()
{
    ctrl_pins_setup();
    data_port_set_input();
    addr_port_setup();
}

void eeprom_peform_write(uint16_t addr, uint8_t value)
{
    data_port_set_input(); /* To be sure, set as inputs */
    ctrl_oe_off(); /* EEPROM as input */
    addr_port_write16(addr);

    data_port_write_rev(value);

    /* Pulse the WE pin to start write */
    ctrl_we_pulse();
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

    ctrl_oe_on(); /* EEPROM as output */
    /* pause for EEPROM. Worst case scenario - it takes 250 ns to settle.
       So 1 uS (1000 ns) should be enough */
    _delay_us(1);
    uint8_t data = data_port_read_rev();

    ctrl_oe_off(); /* EEPROM as input */

    return data;
}
