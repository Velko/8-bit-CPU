#include <stdio.h>
#include <avr/pgmspace.h>
#include <util/delay.h>
#include "flash_hw.h"
#include "flash_ops.h"

#define FLASH_SIZE   ( 128UL * 1024)   // SST39SF010

static void flash_wait_dq7(uint8_t data);

void flash_identify()
{
    flash_prepare_write();
    flash_send_command(0x5555, 0xaa);
    flash_send_command(0x2aaa, 0x55);
    flash_send_command(0x5555, 0x90);
    flash_end_write();

    _delay_us(1);

    // read the ID
    uint8_t manufacturer = flash_read_addr(0);
    uint8_t device = flash_read_addr(1);

    printf_P(PSTR("%02X %02X\r\n"), manufacturer, device);

    flash_prepare_write();
    flash_send_command(0x00, 0xF0);
    flash_end_write();
}

void flash_erase_all()
{
    flash_prepare_write();

    flash_send_command(0x5555, 0xaa);
    flash_send_command(0x2aaa, 0x55);
    flash_send_command(0x5555, 0x80);
    flash_send_command(0x5555, 0xaa);
    flash_send_command(0x2aaa, 0x55);
    flash_send_command(0x5555, 0x10);

    flash_end_write();

    flash_wait_dq7(0xFF);

    printf_P(PSTR("Erased\r\n"));
}

static void flash_wait_dq7(uint8_t data)
{
    data &= 0x80; // interested only in bit 7

    // read repeatedly until bit 7 returns "true data"
    while (data != (flash_read() & 0x80));
}

void flash_read_contents()
{
    for (uint32_t addr = 0; addr < FLASH_SIZE; ++addr)
    {
        uint8_t value = flash_read_addr(addr);

        /* Print address when starting with each 16-th byte */
        if ((addr & 0x0F) == 0)
        {
            printf_P(PSTR("%05lX  "), addr);
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

void flash_write(uint32_t addr, uint8_t value)
{
    flash_prepare_write();

    flash_send_command(0x5555, 0xaa);
    flash_send_command(0x2aaa, 0x55);
    flash_send_command(0x5555, 0xa0);
    flash_send_command(addr, value);

    flash_end_write();

    flash_wait_dq7(value);
}


void flash_write_test()
{
    uint32_t addr;
    char msg[] = "Hello, World!\r\n";

    for (addr = 0; addr < FLASH_SIZE; ++addr)
    {
        flash_write(addr, msg[addr & 0x0F]);
    }

    printf_P(PSTR("Done\r\n"));
}
