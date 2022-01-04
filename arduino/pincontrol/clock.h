#ifndef CLOCK_H
#define CLOCK_H

#include "outpin.h"

class Clock : public OutPinH
{
    public:
        Clock(int pin);
        void pulse();
};


#endif /* CLOCK_H */
