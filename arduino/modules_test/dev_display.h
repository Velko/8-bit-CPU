#ifndef DEV_DISPLAY
#define DEV_DISPLAY

#include <iobus.h>
#include "ext_device.h"
#include "device_interface.h"

class Display : ExternalDevice
{
    public:
        Display(DeviceInterface &devices);
        void setup() override;
        void write(uint8_t value);
        void set_mode(uint8_t mode);
    private:
        DeviceInterface &devices;
        IOBus mode_bus;
};






#endif /* DEV_DISPLAY */