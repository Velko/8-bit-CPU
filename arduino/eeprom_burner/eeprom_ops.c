#include <stdio.h>
#include <avr/pgmspace.h>
#include "eeprom_ops.h"
#include "eeprom_hw.h"
#include "addr_port.h"

#define EEPROM_SIZE   ( 8 * 1024)   // AT28C64

FILE eeprom_stream;
uint32_t eeprom_addr;

static void eeprom_wait_dq7(uint8_t data);

static void eeprom_write(uint16_t addr, uint8_t value)
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

void eeprom_read_contents()
{
    FILE *fstream = eeprom_open();

    unsigned char buff[16];
    uint16_t addr = 0;

    for (;;)
    {
        fread(buff, sizeof(buff), 1, fstream);

        if (feof(fstream)) break;

        /* Print address, each 16-th byte */
        printf_P(PSTR("%04X  "), addr);
        addr += sizeof(buff);

        uint8_t i;

        /* first 8 bytes */
        for (i = 0; i < 8; ++i)
        {
            /* Output the byte */
            printf_P(PSTR("%02X "), buff[i]);
        }

        /* Add extra space after first 8 bytes */
        printf_P(PSTR(" "));

        /* last 8 bytes */
        for (; i < sizeof(buff); ++i)
        {
            printf_P(PSTR("%02X "), buff[i]);
        }

        /* Newline after 16 bytes */
        printf_P(PSTR("\r\n"));
    }
}
