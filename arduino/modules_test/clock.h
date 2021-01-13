#ifndef CLOCK_H
#define CLOCK_H

#include "ext_device.h"

class Clock : public ExternalDevice
{
        int pin;
    public:
        Clock(int pin);
        void setup() override;
        void pulse();
};


#endif /* CLOCK_H */
