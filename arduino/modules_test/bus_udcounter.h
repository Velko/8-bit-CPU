#ifndef BUS_UD_COUNTER_H
#define BUS_UD_COUNTER_H

#include "bus_counter.h"

class UpDownCounter : public Counter
{
    public:
        void setup() override;
        void MoveNext() override;
        void MovePrev();
};


#endif /* BUS_UD_COUNTER_H */