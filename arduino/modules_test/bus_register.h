#ifndef BUS_REGISTER
#define BUS_REGISTER

#include "bus_device.h"

class Register : public BusDevice
{
    public:
        Register();
        void setup() override;
        void write(uint8_t value) override;
        uint8_t read() override;
};



#endif /* BUS_REGISTER */
