#include <stdio.h>
#include <avr/pgmspace.h>
#include <util/delay.h>
#include "eeprom_ops.h"
#include "eeprom_hw.h"
#include "addr_port.h"

FILE eeprom_stream;
uint32_t eeprom_addr;
uint32_t eeprom_size;

static uint8_t eeprom_wait_dq7(uint8_t data);

static void eeprom_write(uint16_t addr, uint8_t value)
{
    uint8_t old_value = eeprom_read_addr(addr);

    /* Only if new value differs */
    if (old_value != value)
    {
        do {
            eeprom_peform_write(addr, value);

            printf_P(PSTR("*"));
        }
        while (!eeprom_wait_dq7(value));

        printf_P(PSTR("+"));

    } else {
        /* Same value */
        printf_P(PSTR(".."));
    }

    /* Add newline after writes */
    if ((addr & 0x0F) == 0x0F)
        printf_P(PSTR("\r\n"));
}


static void eeprom_activate_chip(enum eeprom_chip chip)
{
    switch (chip)
    {
    case AT28C64P:
        eeprom_select(0);  // DIP
        eeprom_size = 8 * 1024UL;
        break;
    case AT28C64J:
        eeprom_select(1);  // PLCC
        eeprom_size = 8 * 1024UL;
        break;
    case AT28C256P:
        eeprom_select(0);  // DIP
        eeprom_size = 32 * 1024UL;
        break;
    case AT28C256J:
        eeprom_select(1);  // PLCC
        eeprom_size = 32 * 1024UL;
        break;
    }
}

#define MAX_POLL 0xFFFF

static uint8_t eeprom_wait_dq7(uint8_t data)
{
    data &= 0x80; // interested only in bit 7

    uint16_t repeats;
    // read repeatedly until bit 7 returns "true data" or too many attempts
    for (repeats = 0; (data != (eeprom_read() & 0x80)) && repeats < MAX_POLL; ++repeats)
        _delay_us(1);

    return repeats < MAX_POLL;  // true if success
}

void eeprom_erase_all(enum eeprom_chip chip)
{
    eeprom_activate_chip(chip);

    for (uint16_t addr = 0; addr < eeprom_size; ++addr)
    {
        eeprom_write(addr, 0xFF);
    }
}

static int eeprom_getc(FILE *stream)
{
    /* trying to read past end */
    if (eeprom_addr >= eeprom_size)
        return _FDEV_EOF;

    return eeprom_read_addr(eeprom_addr++);
}

static int eeprom_putc(char c, FILE *stream)
{
    /* trying to write past end */
    if (eeprom_addr >= eeprom_size)
        return _FDEV_ERR;

    eeprom_write(eeprom_addr++, c);
    return 0;
}

FILE *eeprom_open(enum eeprom_chip chip)
{
    eeprom_activate_chip(chip);

    fdev_setup_stream(&eeprom_stream, eeprom_putc, eeprom_getc, _FDEV_SETUP_RW);

    eeprom_addr = 0;

    return &eeprom_stream;
}
