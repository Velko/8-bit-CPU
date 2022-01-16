#ifndef ADDR_PORT_H
#define ADDR_PORT_H

#include <stdint.h>

class AddrPort
{
    public:
        void setup();
        void write24(uint32_t data);
    private:
};

#endif /* ADDR_PORT_H */
