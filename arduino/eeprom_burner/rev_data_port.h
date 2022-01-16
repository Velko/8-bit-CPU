#ifndef REV_DATA_PORT_H
#define REV_DATA_PORT_H

#include <stdint.h>

class RevDataPort
{
    public:
        void set_input();
        uint8_t read();
        void write(uint8_t value);
};


#endif /* REV_DATA_PORT_H */
