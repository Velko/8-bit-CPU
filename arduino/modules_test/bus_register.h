#ifndef BUS_REGISTER
#define BUS_REGISTER

#include "bus_device.h"
#include "device_interface.h"


class Register : public BusDevice
{
    public:
        Register(DeviceInterface &devices);
        Register(DeviceInterface &devices, ShiftPin&& pin_load, ShiftPin&& pin_out);
        void setup() override;
        void write(uint8_t value) override;
        uint8_t read() override;
        void load();
    protected:
        DeviceInterface &devices;
        ShiftPin pin_load;
        ShiftPin pin_out;
};



#endif /* BUS_REGISTER */
