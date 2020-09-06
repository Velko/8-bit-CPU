#ifndef DEV_DISPLAY
#define DEV_DISPLAY

#include "bus_device.h"
#include "device_interface.h"

class Display : BusDevice
{
    public:
        Display(DeviceInterface &devices);
        void setup() override;
        void write(uint8_t value) override;
        uint8_t read() override;
        void set_mode(uint8_t mode);
    private:
        DeviceInterface &devices;
        IOBus mode_bus;
};






#endif /* DEV_DISPLAY */