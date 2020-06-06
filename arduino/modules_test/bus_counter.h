#ifndef BUS_COUNTER_H
#define BUS_COUNTER_H

#include "bus_register.h"

class Counter : public Register
{
    public:
        void setup() override;
        virtual void MoveNext();

    protected:
        void advance(bool active_high);
};


#endif /* BUS_COUNTER_H */
