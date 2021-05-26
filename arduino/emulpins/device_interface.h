#ifndef DEVICE_INTERFACE_H
#define DEVICE_INTERFACE_H

#include <stdint.h>

class MainBus
{
    public:
        void write(uint8_t val);
        void set_input();
        uint8_t read();
};

class FlagsBus
{
    public:
        uint8_t read();
};

class Clock
{
    public:
        void pulse();
};

class InvClock
{
    public:
        void pulse();
};

class Control
{
    public:
        uint32_t write32(uint32_t val);
};


class DeviceInterface
{
    public:
        MainBus mainBus;
        FlagsBus flagsBus;
        Clock clock;
        InvClock inv_clock;
        Control control;
};


#endif /* DEVICE_INTERFACE_H */