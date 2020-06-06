#ifndef BUS_DEVICE_H
#define BUS_DEVICE_H

#include <iobus.h>

class BusDevice
{
    public:
        BusDevice(uint8_t p0, uint8_t p1, uint8_t p2, uint8_t p3, uint8_t p4, uint8_t p5, uint8_t p6, uint8_t p7);

        virtual void setup();
        virtual void write(uint8_t value) = 0;
        virtual uint8_t read() = 0;

    protected:
        IOBus bus;
};


#endif /* BUS_DEVICE_H */