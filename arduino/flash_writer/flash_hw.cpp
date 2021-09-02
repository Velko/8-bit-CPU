#include <Arduino.h>
#include "addr_port.h"
#include "data_port.h"
#include "flash_hw.h"

/* Not used in code, just for the notes */
#define SH_LATCH    10
#define SPI_SCK     13
#define SPI_MOSI    11

/* WE pin */
#define EE_WRITE    SCL
#define CS1         A0
#define OE          SDA

#define CURRENT_CS  CS1


CtrlPin write_pin(EE_WRITE, CtrlPin::ACTIVE_LOW);
CtrlPin cs_pin(CURRENT_CS, CtrlPin::ACTIVE_LOW);
CtrlPin oe_pin(OE, CtrlPin::ACTIVE_LOW);

/* Pins for data IO. LSB first */
DataPort data_port;

AddrPort addr_out;

void flash_setup()
{
    write_pin.setup();
    cs_pin.setup();
    oe_pin.setup();

    data_port.set_input();

    addr_out.setup();

    // Turn on DIP EEPROM
    cs_pin.on();
}

void flash_prepare_write()
{
    data_port.set_input(); /* To be sure, set as inputs */
    oe_pin.off(); /* EEPROM as input */
}

void flash_end_write()
{
    /* Switch back to inputs as soon as possible:
       let EEPROM control data lines */
    data_port.set_input();
}

void flash_send_command(uint32_t addr, uint8_t value)
{
    addr_out.write24(addr);

    data_port.write(value);

    /* Pulse the WE pin to start write */
    write_pin.on();
    write_pin.off();
}

uint8_t flash_read()
{
    data_port.set_input(); /* Set as inputs */
    oe_pin.on();
    uint8_t data = data_port.read();
    oe_pin.off();

    return data;
}


uint8_t flash_read_addr(uint32_t addr)
{
    addr_out.write24(addr);
    return flash_read();
}
