#include <shiftoutext.h>
#include <iobus.h>

/* Not used in code, just for the notes */
#define SH_LATCH    10
#define SPI_SCK     13
#define SPI_MOSI    11

/* WE pin */
#define EE_WRITE    SCL

/* Pins for data IO. LSB first */
IOBus data_bus {6, 7, 8, 9,
                5, 4, 3, 2};

ShiftOutExt addr_out;

void eeprom_setup()
{
    /* Keep WE pin high while not writing */
    digitalWrite(EE_WRITE, HIGH);
    pinMode(EE_WRITE, OUTPUT);

    data_bus.set_input();

    addr_out.setup();
}

void eeprom_set_address(uint16_t addr, bool w)
{
    /* Use last bit in the address to set OE pin.
       We want EEPROM to output data when we want to read, so then we should
       pull the pin low. When we are writing the data, we should keep the pin
       high.
     */
    if (w)
        addr |= 0x8000;

    addr_out.write16(addr);
}

void eeprom_peform_write(uint16_t addr, uint8_t value)
{
    data_bus.set_input(); /* To be sure, set as inputs */
    eeprom_set_address(addr, true); /* EEPROM as input */

    data_bus.write(value);

    /* Pulse the WE pin to start write */
    digitalWrite(EE_WRITE, LOW);
    delayMicroseconds(1);
    digitalWrite(EE_WRITE, HIGH);

    /* Switch back to inputs as soon as possible:
       let EEPROM control data lines */
    data_bus.set_input();
}

uint8_t eeprom_read(uint16_t addr)
{
    data_bus.set_input(); /* Set as inputs */
    eeprom_set_address(addr, false); /* Also enables EEPROMs output */

    /* pause for EEPROM. Worst case scenario - it takes 250 ns to settle.
       So 1 uS (1000 ns) should be enough */
    delayMicroseconds(1);

    return data_bus.read();
}
