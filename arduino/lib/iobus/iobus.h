#ifndef IO_BUS_H
#define IO_BUS_H

#include <stdint.h>

class IOBus
{
    public:
        IOBus(uint8_t p0, uint8_t p1, uint8_t p2, uint8_t p3, uint8_t p4, uint8_t p5, uint8_t p6, uint8_t p7);
        void set_input();
        uint8_t read();
        void write(uint8_t value);
        static const uint8_t WIDTH = 8;
    private:
        uint8_t pins[WIDTH];
};


#endif