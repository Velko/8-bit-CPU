#ifndef ADDR_PORT_H
#define ADDR_PORT_H

#include <outpin.h>

class AddrPort
{
    public:
        AddrPort();
        void setup();
        void write24(uint32_t data);
    private:
        OutPinH latch;
};

#endif /* ADDR_PORT_H */