#include <shiftoutext.h>

/* Not used in code, just for the notes */
#define SH_LATCH    10
#define SPI_SCK     13
#define SPI_MOSI    11

/* WE pin */
#define EE_WRITE    SCL

/* Pins for data IO. LSB first */
const int DATA_PINS[] = {6, 7, 8, 9,
                         5, 4, 3, 2};

ShiftOutExt addr_out;

void eeprom_config_pins_read()
{
    /* Configure data pins to default state: Input with pullup */
    for (int i = 0; i < 8; ++i)
    {
        pinMode(DATA_PINS[i], INPUT);
        digitalWrite(DATA_PINS[i], HIGH);
    }
}

void eeprom_setup()
{
    /* Keep WE pin high while not writing */
    digitalWrite(EE_WRITE, HIGH);
    pinMode(EE_WRITE, OUTPUT);

    eeprom_config_pins_read();

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
    eeprom_config_pins_read(); /* To be sure, set as inputs */
    eeprom_set_address(addr, true); /* EEPROM as input */

    uint8_t t_val = value;
    /* Setup data and outputs */
    for (int i = 0 ; i < 8 ; ++i)
    {
        pinMode(DATA_PINS[i], OUTPUT);
        digitalWrite(DATA_PINS[i], t_val & 1 ? HIGH : LOW);

        t_val >>= 1;
    }

    /* Pulse the WE pin to start write */
    digitalWrite(EE_WRITE, LOW);
    delayMicroseconds(1);
    digitalWrite(EE_WRITE, HIGH);

    /* Switch back to inputs as soon as possible:
       let EEPROM control data lines */
    eeprom_config_pins_read();
}

uint8_t eeprom_read(uint16_t addr)
{
    eeprom_config_pins_read(); /* Set as inputs */
    eeprom_set_address(addr, false); /* Also enables EEPROMs output */

    /* pause for EEPROM. Worst case scenario - it takes 250 ns to settle.
       So 1 uS (1000 ns) should be enough */
    delayMicroseconds(1);

    uint8_t rbyte = 0;

    for (int i = 7; i >= 0; --i)
    {
        rbyte <<= 1;
        rbyte |= digitalRead(DATA_PINS[i]) == HIGH ? 1 : 0;
    }

    return rbyte;
}
