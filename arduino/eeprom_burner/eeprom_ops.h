#ifndef EEPROM_OPS_H
#define EEPROM_OPS_H

#include <stdint.h>

void eeprom_write(uint16_t addr, uint8_t value);
void eeprom_read_contents();
void eeprom_erase_all();
void test_send_inc();


#endif /* EEPROM_OPS_H */

