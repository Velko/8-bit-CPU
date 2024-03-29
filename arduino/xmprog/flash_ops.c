#include <stdio.h>
#include <avr/pgmspace.h>
#include <util/delay.h>
#include "flash_hw.h"
#include "flash_ops.h"
#include "ctrl_pins.h"

FILE flash_stream;
uint32_t flash_addr;
uint32_t flash_size;

static void flash_wait_dq7(uint8_t data);
static void flash_write(uint32_t addr, uint8_t value);
static int flash_getc(FILE *stream);
static int flash_putc(char c, FILE *stream);

uint16_t flash_identify()
{
    flash_prepare_write();
    flash_send_command(0x5555, 0xaa);
    flash_send_command(0x2aaa, 0x55);
    flash_send_command(0x5555, 0x90);
    flash_end_write();

    _delay_us(1);

    // read the ID
    uint16_t manufacturer = flash_read_addr(0);
    uint8_t device = flash_read_addr(1);

    flash_prepare_write();
    flash_send_command(0x00, 0xF0);
    flash_end_write();

    return (manufacturer << 8) | device;
}

void flash_erase_all(struct chip_def *chip, bool force)
{
    /* Flash chips should always be erased before writes, forced or not*/
    ctrl_chip_select(chip->socket);

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

static int flash_getc(FILE *stream)
{
    /* trying to read past end */
    if (flash_addr >= flash_size)
        return _FDEV_EOF;

    return flash_read_addr(flash_addr++);
}

static int flash_putc(char c, FILE *stream)
{
    /* trying to write past end */
    if (flash_addr >= flash_size)
        return _FDEV_ERR;

    flash_write(flash_addr++, c);
    return 0;
}

FILE *flash_open(struct chip_def *chip)
{
    ctrl_chip_select(chip->socket);
    uint16_t device = flash_identify();

    if (device != chip->man_dev_id)
    {
        printf_P(PSTR("Wrong chip signature: %04X\r\n"), device);
        return NULL;
    }

    flash_addr = 0;
    flash_size = chip->size;

    fdev_setup_stream(&flash_stream, flash_putc, flash_getc, _FDEV_SETUP_RW);

    return &flash_stream;
}

static void flash_write(uint32_t addr, uint8_t value)
{
    flash_prepare_write();

    flash_send_command(0x5555, 0xaa);
    flash_send_command(0x2aaa, 0x55);
    flash_send_command(0x5555, 0xa0);
    flash_send_command(addr, value);

    flash_end_write();

    flash_wait_dq7(value);
}
