#ifndef EEPROM_OPS_H
#define EEPROM_OPS_H

#include <stdint.h>

void flash_write(uint32_t addr, uint8_t value);
void eeprom_verify(uint16_t addr, uint8_t value);
void flash_read_contents();
void flash_erase_all();
void flash_identify();
void flash_wait_dq7(uint8_t data);

void flash_write_test();

#endif /* EEPROM_OPS_H */

