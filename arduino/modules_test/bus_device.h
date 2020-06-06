#ifndef BUS_DEVICE_H
#define BUS_DEVICE_H

#include <iobus.h>

class BusDevice
{
    public:
        BusDevice();

        void setup();
        void pulse_clock();
        void write(uint8_t value);
        uint8_t read();

    protected:
        IOBus bus;
};


#endif /* BUS_DEVICE_H */