#ifndef IO_BUS_8BIT_H
#define IO_BUS_8BIT_H

#include <stdint.h>

class IOBus8bit
{
    public:
        IOBus8bit();
        void set_input();
        uint8_t read();
        void write(uint8_t value);
};


#endif