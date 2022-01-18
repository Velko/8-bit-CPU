#ifndef FLASH_OPS_H
#define FLASH_OPS_H

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "chips.h"

#ifdef __cplusplus
extern "C" {
#endif

    FILE *flash_open(struct chip_def *chip);
    void flash_erase_all(struct chip_def *chip, bool force);
    uint16_t flash_identify();

#ifdef __cplusplus
}
#endif

#endif /* FLASH_OPS_H */

