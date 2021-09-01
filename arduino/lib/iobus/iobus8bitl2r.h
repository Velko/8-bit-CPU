#ifndef IO_BUS_8BIT_L2R_H
#define IO_BUS_8BIT_L2R_H

#include <stdint.h>

class IOBus8bitL2R
{
    public:
        IOBus8bitL2R();
        void set_input();
        uint8_t read();
        void write(uint8_t value);
};


#endif