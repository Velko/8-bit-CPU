#include <SPI.h>

/* Not used in code, just for the notes */
#define SPI_SCK     13
#define SPI_MOSI    11

/* WE pin */
#define EE_WRITE    SCL


/* Pins for data IO. LSB first */
const int DATA_PINS[] = {6, 7, 8, 9,
                         5, 4, 3, 2};

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

    /* The "old" SPI initialization sequence (I like this one better)*/
    SPI.begin();
    SPI.setDataMode(SPI_MODE0);
    SPI.setBitOrder(MSBFIRST);
    SPI.setClockDivider(SPI_CLOCK_DIV64);
}

void eeprom_set_address(uint16_t addr, bool w)
{
    /* Use last bit in the address to set OE pin.
       We want EEPROM to output data when we want to read, so then we should
       pull the pin low. When we are writing the data, we should keep the pin
       high. Note that we can not really reach Q7 output of second shift register
       as it requires an additional tick. But we can use Q6 output.
     */
    if (w)
        addr |= 0x4000;


    /* Shift register we're using (74HC594) buffers the values
       for one clock tick, so it requires an extra clock pulse
       until it reaches desired output pin. Since we do not need
       all 16 bits, the simplest solution is to add extra bit to
       the address. */

    addr <<= 1;

    SPI.begin();
    /* Older versions of Arduino Lib does not have SPI.transfer16(),
       but we can just send both bytes seperately */
    SPI.transfer((addr >> 8) & 0xFF);
    SPI.transfer(addr & 0xFF);
    
}

void eeprom_write(uint16_t addr, uint8_t value)
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

    /* Wait until data reads back correctly */
    eeprom_config_pins_read();
    delay(2);
    //while (eeprom_read(addr) != value);
}

uint8_t eeprom_read(uint16_t addr)
{
    eeprom_config_pins_read(); /* Set as inputs */
    eeprom_set_address(addr, false); /* Also enables EEPROMs output */

    delay(1);

    uint8_t rbyte = 0;

    for (int i = 7; i >= 0; --i)
    {
        rbyte <<= 1;
        rbyte |= digitalRead(DATA_PINS[i]) == HIGH ? 1 : 0;
    }

    return rbyte;
}

void eeprom_read_contents()
{
    char buff[8];

    for (uint16_t addr = 0; addr < (8 * 1024); ++addr)
    {
        uint8_t value = eeprom_read(addr);

        /* Print address when starting with each 16-th byte */
        if ((addr & 0x0F) == 0)
        {
            sprintf_P(buff, PSTR("%04X  "), addr);
            Serial.print(buff);
        }

        /* Output the byte */
        sprintf_P(buff, PSTR("%02X "), value);
        Serial.print(buff);

        /* Newline after 16 bytes */
        if ((addr & 0x0F) == 0x0F)
        {
            Serial.println();
            continue;
        }

        /* Add extra space after first 8 bytes */
        if ((addr & 0x07) == 0x07)
            Serial.print(F(" "));
    }
}


void test_send_inc()
{
    Serial.println(F("Sending addresses (write):"));
    for (int addr = 0; addr < 16; ++addr)
    {
        Serial.println(addr);
        eeprom_set_address(addr, true);
        delay(500);
    }

    Serial.println(F("Sending addresses (read):"));
    for (int addr = 0; addr < 16; ++addr)
    {
        Serial.println(addr);
        eeprom_set_address(addr, false);
        delay(500);
    }

    Serial.println(F("Done"));
    eeprom_set_address(0, false);
}
