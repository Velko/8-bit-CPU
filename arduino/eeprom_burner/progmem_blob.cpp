#include "eeprom_ops.h"
#include <avr/pgmspace.h>


void burn_progmem_blob(const unsigned char blob[], unsigned int len)
{
    char buff[64];

    FILE *eeprom = eeprom_open();
    for (uint16_t addr = 0; len > 0; )
    {
        uint8_t to_write = len < sizeof(buff) ? len : sizeof(buff);
        memcpy_P(buff, blob + addr, to_write);

        size_t written = fwrite(buff, 1, to_write, eeprom);

        if (written != to_write)
        {
            printf_P(PSTR("Write failed"));
            return;
        }

        len -= to_write;
        addr += to_write;
    }
}

void verify_progmem_blob(const unsigned char blob[], unsigned int len)
{
    FILE *eeprom = eeprom_open();

    for (uint8_t addr = 0; addr < len; ++addr)
    {
        uint8_t expected = pgm_read_byte(&blob[addr]);
        uint8_t actual = fgetc(eeprom);

        if (expected != actual)
        {
            printf_P(PSTR("Verification failed\r\n"));
            return;
        }
    }
    printf_P(PSTR("All OK\r\n"));
}
