#ifndef EEPROM_OPS_H
#define EEPROM_OPS_H

#include <stdint.h>
#include <stdio.h>

enum eeprom_chip {
    AT28C64P,
    AT28C64J,
    AT28C256P,
    AT28C256J,
};

#ifdef __cplusplus
extern "C" {
#endif

    FILE *eeprom_open(enum eeprom_chip chip);
    void eeprom_erase_all(enum eeprom_chip chip);

#ifdef __cplusplus
}
#endif

#endif /* EEPROM_OPS_H */

