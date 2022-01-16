#include <Arduino.h>
#include <shiftoutext.h>
#include "rev_data_port.h"
#include "eeprom_hw.h"

/* Not used in code, just for the notes */
#define SH_LATCH    10
#define SPI_SCK     13
#define SPI_MOSI    11

/* WE pin */
#define EE_WRITE    SCL
#define CS1         A0
#define CS2         A1
#define OE          SDA

//TODO: software selectable
#define CURRENT_CS  CS1


OutPinL write_pin(EE_WRITE);
OutPinL cs_pin(CURRENT_CS);
OutPinL oe_pin(OE);

/* Pins for data IO. LSB first */
RevDataPort data_bus;

ShiftOutExt addr_out;

void eeprom_setup()
{
    write_pin.setup();
    cs_pin.setup();
    oe_pin.setup();

    data_bus.set_input();

    addr_out.setup();

    // Turn on DIP EEPROM
    cs_pin.on();
}

void eeprom_set_address(uint16_t addr)
{
    addr_out.write16(addr);
}

void eeprom_peform_write(uint16_t addr, uint8_t value)
{
    data_bus.set_input(); /* To be sure, set as inputs */
    oe_pin.off(); /* EEPROM as input */
    eeprom_set_address(addr);

    data_bus.write(value);

    /* Pulse the WE pin to start write */
    write_pin.on();
    delayMicroseconds(1);
    write_pin.off();

    /* Switch back to inputs as soon as possible:
       let EEPROM control data lines */
    data_bus.set_input();
}

uint8_t eeprom_read(uint16_t addr)
{
    data_bus.set_input(); /* Set as inputs */
    oe_pin.on();
    eeprom_set_address(addr);

    /* pause for EEPROM. Worst case scenario - it takes 250 ns to settle.
       So 1 uS (1000 ns) should be enough */
    delayMicroseconds(1);

    return data_bus.read();
}
