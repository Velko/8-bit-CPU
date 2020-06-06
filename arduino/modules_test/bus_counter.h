#ifndef BUS_COUNTER_H
#define BUS_COUNTER_H

#include "bus_register.h"

class Counter : public Register
{
    public:
        void setup() override;
        virtual void MoveNext();

    protected:
        virtual void set_count_enable(bool enabled);
};


#endif /* BUS_COUNTER_H */
