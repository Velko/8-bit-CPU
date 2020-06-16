#ifndef BUS_REGISTER
#define BUS_REGISTER

#include <ctrlpin.h>
#include "bus_device.h"
#include "clock.h"

class Register : public BusDevice
{
    public:
        Register();
        Register(CtrlPin&& pin_load, CtrlPin&& pin_out);
        void setup() override;
        void write(uint8_t value) override;
        uint8_t read() override;
        void load();
    protected:
        Clock clock;
        CtrlPin pin_load;
        CtrlPin pin_out;
};



#endif /* BUS_REGISTER */
