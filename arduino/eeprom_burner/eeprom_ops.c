#include <stdio.h>
#include <avr/pgmspace.h>
#include <util/delay.h>
#include "eeprom_ops.h"
#include "eeprom_hw.h"
#include "addr_port.h"

#define EEPROM_SIZE   ( 8 * 1024)   // AT28C64

FILE eeprom_stream;
uint32_t eeprom_addr;

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

void eeprom_erase_all()
{
    for (uint16_t addr = 0; addr < EEPROM_SIZE; ++addr)
    {
        eeprom_write(addr, 0xFF);
    }
}

static int eeprom_getc(FILE *stream)
{
    /* trying to read past end */
    if (eeprom_addr >= EEPROM_SIZE)
        return _FDEV_EOF;

    return eeprom_read_addr(eeprom_addr++);
}

static int eeprom_putc(char c, FILE *stream)
{
    /* trying to write past end */
    if (eeprom_addr >= EEPROM_SIZE)
        return _FDEV_ERR;

    eeprom_write(eeprom_addr++, c);
    return 0;
}

FILE *eeprom_open(void)
{
    fdev_setup_stream(&eeprom_stream, eeprom_putc, eeprom_getc, _FDEV_SETUP_RW);

    eeprom_addr = 0;

    return &eeprom_stream;
}
