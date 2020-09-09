#ifndef DEVICE_INTERFACE_H
#define DEVICE_INTERFACE_H

#include <iobus.h>
#include <iobus8bit.h>
#include "clock.h"
#include "shiftctrl.h"

class DeviceInterface
{
    public:
        DeviceInterface();
        void setup();
        IOBus8bit mainBus;
        IOBus flagsBus;
        Clock clock;
        ShiftCtrl control;
        static DeviceInterface instance;
};



#endif /* DEVICE_INTERFACE_H */
