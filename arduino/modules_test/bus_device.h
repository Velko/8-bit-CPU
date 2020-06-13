#ifndef BUS_DEVICE_H
#define BUS_DEVICE_H

#include <iobus.h>
#include "ext_device.h"

class BusDevice : public ExternalDevice
{
    public:
        BusDevice(std::initializer_list<uint8_t> pins);

        virtual void write(uint8_t value) = 0;
        virtual uint8_t read() = 0;

    protected:
        IOBus bus;
};


#endif /* BUS_DEVICE_H */