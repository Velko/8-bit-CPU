#ifndef DATA_PORT_H
#define DATA_PORT_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

    void data_port_set_input();
    uint8_t data_port_read();
    void data_port_write(uint8_t value);
    uint8_t data_port_read_rev();
    void data_port_write_rev(uint8_t value);

#ifdef __cplusplus
}
#endif

#endif
