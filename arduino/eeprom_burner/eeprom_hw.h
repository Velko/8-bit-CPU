#ifndef EEPROM_HW_H
#define EEPROM_HW_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

    void eeprom_setup();
    void eeprom_select(uint8_t idx);
    uint8_t eeprom_read_addr(uint16_t addr);
    uint8_t eeprom_read(void);
    void eeprom_set_address(uint16_t addr);
    void eeprom_peform_write(uint16_t addr, uint8_t value);

#ifdef __cplusplus
}
#endif

#endif /* EEPROM_HW_H */