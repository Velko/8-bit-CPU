#ifndef EEPROM_OPS_H
#define EEPROM_OPS_H

#include <stdint.h>
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

    FILE *flash_open(void);
    void flash_erase_all();
    uint16_t flash_identify();

#ifdef __cplusplus
}
#endif

#endif /* EEPROM_OPS_H */

