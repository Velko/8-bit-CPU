#ifndef CLOCK_H
#define CLOCK_H

#include "ext_device.h"

class Clock : public ExternalDevice
{
    public:
        void setup() override;
        void pulse();
};


#endif /* CLOCK_H */
