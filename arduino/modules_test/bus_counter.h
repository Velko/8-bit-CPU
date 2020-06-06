#ifndef BUS_COUNTER_H
#define BUS_COUNTER_H

#include "bus_register.h"

class Counter : public Register
{
    public:
        void setup() override;
        virtual void MoveNext();
};


#endif /* BUS_COUNTER_H */
