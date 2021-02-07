#include "eeprom_ops.h"
#include <avr/pgmspace.h>


void burn_progmem_blob(unsigned char blob[], unsigned int len)
{
    for (uint8_t addr = 0; addr < len; ++addr)
    {
        uint8_t data = pgm_read_byte(&blob[addr]);
        eeprom_write(addr, data);
    }
}

void verify_progmem_blob(unsigned char blob[], unsigned int len)
{
    for (uint8_t addr = 0; addr < len; ++addr)
    {
        uint8_t data = pgm_read_byte(&blob[addr]);
        eeprom_verify(addr, data);
    }
}
