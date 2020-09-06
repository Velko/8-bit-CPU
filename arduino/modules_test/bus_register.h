#ifndef BUS_REGISTER
#define BUS_REGISTER

#include "ext_device.h"
#include "device_interface.h"


class Register : public ExternalDevice
{
    public:
        Register(DeviceInterface &devices);
        Register(DeviceInterface &devices, ShiftPin &pin_load, ShiftPin &pin_out);
        void setup() override;
        void write_check(uint8_t value);
        void write_quick(uint8_t value);
        uint8_t read();
        void load();
    protected:
        DeviceInterface &devices;
        ShiftPin pin_load;
        ShiftPin pin_out;
};



#endif /* BUS_REGISTER */
