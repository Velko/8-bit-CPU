#ifndef EEPROM_HW_H
#define EEPROM_HW_H

#include <stdint.h>

void eeprom_setup();
uint8_t eeprom_read(uint16_t addr);
void eeprom_set_address(uint16_t addr, bool w);
void eeprom_peform_write(uint16_t addr, uint8_t value);

#endif /* EEPROM_HW_H */