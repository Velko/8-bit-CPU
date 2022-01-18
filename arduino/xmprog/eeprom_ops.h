#ifndef EEPROM_OPS_H
#define EEPROM_OPS_H

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include "chips.h"

#ifdef __cplusplus
extern "C" {
#endif

    FILE *eeprom_open(struct chip_def *chip);
    void eeprom_erase_all(struct chip_def *chip, bool force);

#ifdef __cplusplus
}
#endif

#endif /* EEPROM_OPS_H */

