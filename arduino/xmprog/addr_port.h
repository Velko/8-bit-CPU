#ifndef ADDR_PORT_H
#define ADDR_PORT_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif


    void addr_port_setup();
    void addr_port_write8(uint8_t data);
    void addr_port_write24(uint32_t data);


#ifdef __cplusplus
}
#endif


#endif /* ADDR_PORT_H */
