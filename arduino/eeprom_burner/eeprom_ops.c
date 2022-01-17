#include <stdio.h>
#include <avr/pgmspace.h>
#include "eeprom_ops.h"
#include "eeprom_hw.h"
#include "addr_port.h"

#define EEPROM_SIZE   ( 8 * 1024)   // AT28C64

static void eeprom_wait_dq7(uint8_t data);

void eeprom_write(uint16_t addr, uint8_t value)
{
    uint8_t old_value = eeprom_read_addr(addr);

    /* Only if new value differs */
    if (old_value != value)
    {
        eeprom_peform_write(addr, value);

        eeprom_wait_dq7(value);

        printf_P(PSTR("+"));

    } else {
        /* Same value */
        printf_P(PSTR("."));
    }

    /* Add newline after writes */
    if ((addr & 0x0F) == 0x0F)
        printf_P(PSTR("\r\n"));
}

void eeprom_verify(uint16_t addr, uint8_t value)
{
    uint8_t old_value = eeprom_read_addr(addr);

    if (old_value != value)
        printf_P(PSTR("+"));
    else
        printf_P(PSTR("."));

    /* Add newline after writes */
    if ((addr & 0x0F) == 0x0F)
        printf_P(PSTR("\r\n"));
}


static void eeprom_wait_dq7(uint8_t data)
{
    data &= 0x80; // interested only in bit 7

    // read repeatedly until bit 7 returns "true data"
    while (data != (eeprom_read() & 0x80));
}

void eeprom_erase_all()
{
    for (uint16_t addr = 0; addr < EEPROM_SIZE; ++addr)
    {
        eeprom_write(addr, 0xFF);
    }
}

void eeprom_read_contents()
{
    for (uint16_t addr = 0; addr < EEPROM_SIZE; ++addr)
    {
        uint8_t value = eeprom_read_addr(addr);

        /* Print address when starting with each 16-th byte */
        if ((addr & 0x0F) == 0)
        {
            printf_P(PSTR("%04X  "), addr);
        }

        /* Output the byte */
        printf_P(PSTR("%02X "), value);

        /* Newline after 16 bytes */
        if ((addr & 0x0F) == 0x0F)
        {
            printf_P(PSTR("\r\n"));
            continue;
        }

        /* Add extra space after first 8 bytes */
        if ((addr & 0x07) == 0x07)
            printf_P(PSTR(" "));
    }
}
