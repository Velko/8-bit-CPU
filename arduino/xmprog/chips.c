#include "chips.h"
#include <avr/pgmspace.h>
#include <string.h>
#include "flash_ops.h"

const struct chip_def chips_supported[] PROGMEM = {
    {.name = "SST39SF010A", .man_dev_id = 0xBFB5, .size=128UL * 1024, .socket = 0, .open_fn = flash_open, .erase_fn = flash_erase_all },
    {.name = "SST39SF020A", .man_dev_id = 0xBFB6, .size=256UL * 1024, .socket = 0, .open_fn = flash_open, .erase_fn = flash_erase_all },
    {.name = "SST39SF040",  .man_dev_id = 0xBFB7, .size=512UL * 1024, .socket = 0, .open_fn = flash_open, .erase_fn = flash_erase_all },
//    {.name = "AT28C64-PU",  .man_dev_id = 0, .size=8UL * 1024,        .socket = 0},
//    {.name = "AT28C64-J",   .man_dev_id = 0, .size=8UL * 1024,        .socket = 1},
//    {.name = "AT28C256-PU", .man_dev_id = 0, .size=32UL * 1024,       .socket = 0},
//    {.name = "AT28C256-J",  .man_dev_id = 0, .size=32UL * 1024,       .socket = 1},
};

static struct chip_def *find_chip(struct chip_def *mem, const char *file_name)
{
    for (uint8_t i = 0; i < sizeof(chips_supported) / sizeof(struct chip_def); ++i)
    {
        memcpy_P(mem, chips_supported + i, sizeof(struct chip_def));
        if (strcmp(file_name, mem->name) == 0)
            return mem;
    }

    printf_P(PSTR("Unknown chip '%s'\r\n"), file_name);

    return NULL;
}


FILE *chip_open_stream(const char *file_name)
{
    struct chip_def storage;
    struct chip_def *current_chip = find_chip(&storage, file_name);

    if (current_chip == NULL)
        return NULL;

    return current_chip->open_fn(current_chip);
}

void chip_erase(const char *file_name, bool force)
{
    struct chip_def storage;
    struct chip_def *current_chip = find_chip(&storage, file_name);

    if (current_chip == NULL)
        return;

    current_chip->erase_fn(current_chip, force);
}