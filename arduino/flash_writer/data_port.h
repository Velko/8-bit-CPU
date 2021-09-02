#ifndef DATA_PORT_H
#define DATA_PORT_H

#include <stdint.h>

class DataPort
{
    public:
        void set_input();
        uint8_t read();
        void write(uint8_t value);
};


#endif