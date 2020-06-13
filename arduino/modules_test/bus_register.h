#ifndef BUS_REGISTER
#define BUS_REGISTER

#include "bus_device.h"
#include "clock.h"

class Register : public BusDevice
{
    public:
        Register();
        void setup() override;
        void write(uint8_t value) override;
        uint8_t read() override;
    protected:
        Clock clock;
        // override for alternate wiring
        // for example - when testing multiple
        // registers at same time
        virtual uint8_t get_pin_load();
        virtual uint8_t get_pin_out();
};



#endif /* BUS_REGISTER */
