#ifndef EEPROM_OPS_H
#define EEPROM_OPS_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

    void eeprom_write(uint16_t addr, uint8_t value);
    void eeprom_verify(uint16_t addr, uint8_t value);
    void eeprom_read_contents();
    void eeprom_erase_all();

#ifdef __cplusplus
}
#endif

#endif /* EEPROM_OPS_H */

