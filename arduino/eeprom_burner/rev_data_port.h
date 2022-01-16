#ifndef REV_DATA_PORT_H
#define REV_DATA_PORT_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

    void rev_data_port_set_input();
    uint8_t rev_data_port_read();
    void rev_data_port_write(uint8_t value);

#ifdef __cplusplus
}
#endif


#endif /* REV_DATA_PORT_H */
