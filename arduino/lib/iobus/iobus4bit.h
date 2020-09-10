#ifndef IO_BUS_4BIT_H
#define IO_BUS_4BIT_H

#include <stdint.h>

class IOBus4bit
{
    public:
        IOBus4bit();
        void set_input();
        uint8_t read();
        void write(uint8_t value);
};


#endif