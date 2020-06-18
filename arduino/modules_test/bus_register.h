#ifndef BUS_REGISTER
#define BUS_REGISTER

#include "shiftctrl.h"
#include "bus_device.h"
#include "clock.h"

class Register : public BusDevice
{
    public:
        Register();
        Register(ShiftPin&& pin_load, ShiftPin&& pin_out);
        void setup() override;
        void write(uint8_t value) override;
        uint8_t read() override;
        void load();
    protected:
        Clock clock;
        ShiftPin pin_load;
        ShiftPin pin_out;
};



#endif /* BUS_REGISTER */
