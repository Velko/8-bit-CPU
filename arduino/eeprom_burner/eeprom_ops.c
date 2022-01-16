#include <stdio.h>
#include <avr/pgmspace.h>
#include <util/delay.h>
#include "eeprom_ops.h"
#include "eeprom_hw.h"
#include "addr_port.h"

#define EEPROM_SIZE   ( 8 * 1024)   // AT28C64

void eeprom_write(uint16_t addr, uint8_t value)
{
    uint8_t old_value = eeprom_read(addr);

    /* Only if new value differs */
    if (old_value != value)
    {
        eeprom_peform_write(addr, value);

        for (int retry = 0; retry < 5 ; ++retry)
        {
            _delay_ms(2);
            uint8_t readback = eeprom_read(addr);

            if (readback == value)
            {
                /* Success. */
                printf_P(PSTR("+"));
                goto format_line;
            }
        }
        /* Failed */
        printf_P(PSTR("!"));
        goto format_line;
    }
    /* Same value */
    printf_P(PSTR("."));

format_line:
    /* Add newline after writes */
    if ((addr & 0x0F) == 0x0F)
        printf_P(PSTR("\r\n"));
}

void eeprom_verify(uint16_t addr, uint8_t value)
{
    uint8_t old_value = eeprom_read(addr);

    if (old_value != value)
        printf_P(PSTR("+"));
    else
        printf_P(PSTR("."));

    /* Add newline after writes */
    if ((addr & 0x0F) == 0x0F)
        printf_P(PSTR("\r\n"));
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
        uint8_t value = eeprom_read(addr);

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


void test_send_inc()
{
    printf_P(PSTR("Sending addresses (write):"));
    for (int addr = 0; addr < 16; ++addr)
    {
        printf_P(PSTR("%d\r\n"), addr);
        addr_port_write16(addr);
        _delay_ms(500);
    }

    printf_P(PSTR("Sending addresses (read):"));
    for (int addr = 0; addr < 16; ++addr)
    {
        printf_P(PSTR("%d\r\n"), addr);
        addr_port_write16(addr);
        _delay_ms(500);
    }

    printf_P(PSTR("Done"));
    addr_port_write16(0);
}
