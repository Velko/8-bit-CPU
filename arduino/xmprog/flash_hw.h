#ifndef FLASH_HW_H
#define FLASH_HW_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

    uint8_t flash_read_addr(uint32_t addr);
    uint8_t flash_read();
    void flash_prepare_write();
    void flash_send_command(uint32_t addr, uint8_t value);
    void flash_end_write();

#ifdef __cplusplus
}
#endif

#endif /* FLASH_HW_H */
