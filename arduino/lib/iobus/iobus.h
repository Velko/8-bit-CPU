#ifndef IO_BUS_H
#define IO_BUS_H

#include <stdint.h>
#include "gstl_initializer_list.h"

class IOBus
{
    public:
        IOBus(std::initializer_list<uint8_t> pins);
        void set_input();
        uint8_t read();
        void write(uint8_t value);
        static const size_t MAX_SIZE = 8;
    private:
        uint8_t pins[MAX_SIZE];
        uint8_t size;
};


#endif