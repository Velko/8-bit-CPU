#ifndef BUS_COUNTER_H
#define BUS_COUNTER_H

#include "bus_register.h"

class Counter : public Register
{
    public:
        Counter();
        Counter(CtrlPin::ActiveLevel enable_mode);
        void setup() override;
        virtual void MoveNext();

    protected:
        ShiftPin pin_c_enable;
};


#endif /* BUS_COUNTER_H */
