#ifndef REV_DATA_PORT_H
#define REV_DATA_PORT_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

    void data_port_set_input();
    uint8_t data_port_read_rev();
    void data_port_write_rev(uint8_t value);

#ifdef __cplusplus
}
#endif


#endif /* REV_DATA_PORT_H */
