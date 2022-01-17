#ifndef EEPROM_OPS_H
#define EEPROM_OPS_H

#include <stdint.h>
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

    FILE *eeprom_open(void);
    void eeprom_verify(uint16_t addr, uint8_t value);
    void eeprom_erase_all();

#ifdef __cplusplus
}
#endif

#endif /* EEPROM_OPS_H */

