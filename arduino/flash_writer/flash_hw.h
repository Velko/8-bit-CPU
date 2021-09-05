#ifndef EEPROM_HW_H
#define EEPROM_HW_H

#include <stdint.h>

void flash_setup();
uint8_t flash_read_addr(uint32_t addr);
uint8_t flash_read();
void flash_prepare_write();
void flash_send_command(uint32_t addr, uint8_t value);
void flash_end_write();

#endif /* EEPROM_HW_H */