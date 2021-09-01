#include <Arduino.h>
#include <shiftoutext.h>
#include <iobus8bitl2r.h>
#include "flash_hw.h"

/* Not used in code, just for the notes */
#define SH_LATCH    10
#define SPI_SCK     13
#define SPI_MOSI    11

/* WE pin */
#define EE_WRITE    SCL
#define CS1         A0
#define OE          SDA

//TODO: software selectable
#define CURRENT_CS  CS1


CtrlPin write_pin(EE_WRITE, CtrlPin::ACTIVE_LOW);
CtrlPin cs_pin(CURRENT_CS, CtrlPin::ACTIVE_LOW);
CtrlPin oe_pin(OE, CtrlPin::ACTIVE_LOW);

/* Pins for data IO. LSB first */
IOBus8bitL2R data_bus;

ShiftOutExt addr_out;

void flash_setup()
{
    write_pin.setup();
    cs_pin.setup();
    oe_pin.setup();

    data_bus.set_input();

    addr_out.setup();

    // Turn on DIP EEPROM
    cs_pin.on();
}

void flash_set_address(uint32_t addr)
{
    addr_out.write24(addr);
}

void flash_prepare_write()
{
    data_bus.set_input(); /* To be sure, set as inputs */
    oe_pin.off(); /* EEPROM as input */
}

void flash_end_write()
{
    /* Switch back to inputs as soon as possible:
       let EEPROM control data lines */
    data_bus.set_input();
}

void flash_send_command(uint32_t addr, uint8_t value)
{
    flash_set_address(addr);

    data_bus.write(value);

    /* Pulse the WE pin to start write */
    write_pin.on();
    write_pin.off();
}

uint8_t flash_read(uint32_t addr)
{
    data_bus.set_input(); /* Set as inputs */
    oe_pin.on();
    flash_set_address(addr);

    /* pause for EEPROM. Worst case scenario - it takes 250 ns to settle.
       So 1 uS (1000 ns) should be enough */
    delayMicroseconds(1);

    return data_bus.read();
}
