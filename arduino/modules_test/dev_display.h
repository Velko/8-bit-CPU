#ifndef DEV_DISPLAY
#define DEV_DISPLAY

#include "bus_device.h"

class Display : BusDevice
{
    public:
        Display();
        void setup() override;
        void write(uint8_t value) override;
        uint8_t read() override;
        void set_mode(uint8_t mode);
    private:
        IOBus mode_bus;
};






#endif /* DEV_DISPLAY */