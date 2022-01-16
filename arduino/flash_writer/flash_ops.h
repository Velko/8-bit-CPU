#ifndef EEPROM_OPS_H
#define EEPROM_OPS_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

    void flash_write(uint32_t addr, uint8_t value);
    void flash_read_contents();
    void flash_erase_all();
    void flash_identify();

    void flash_write_test();

#ifdef __cplusplus
}
#endif

#endif /* EEPROM_OPS_H */

