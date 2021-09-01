#ifndef EEPROM_OPS_H
#define EEPROM_OPS_H

#include <stdint.h>

void eeprom_write(uint16_t addr, uint8_t value);
void eeprom_verify(uint16_t addr, uint8_t value);
void flash_read_contents();
void eeprom_erase_all();
void test_send_inc();
void flash_identify();


#endif /* EEPROM_OPS_H */

