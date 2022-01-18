#define F_CPU 16000000UL
#include <util/delay.h>

#include "addr_port.h"
#include "data_port.h"
#include "ctrl_pins.h"
#include "flash_hw.h"

void flash_prepare_write()
{
    data_port_set_input(); /* To be sure, set as inputs */
    ctrl_oe_off();
}

void flash_end_write()
{
    /* Switch back to inputs as soon as possible:
       let flash chip control data lines */
    data_port_set_input();
}

void flash_send_command(uint32_t addr, uint8_t value)
{
    addr_port_write24(addr);

    data_port_write(value);

    /* Pulse the WE pin to start write */
    ctrl_we_pulse();
}

uint8_t flash_read()
{
    data_port_set_input(); /* Set as inputs */
    ctrl_oe_on(); /* Flash as output */
    _delay_us(1);
    uint8_t data = data_port_read();
    ctrl_oe_off(); /* Flash as input */

    return data;
}


uint8_t flash_read_addr(uint32_t addr)
{
    addr_port_write24(addr);
    return flash_read();
}
