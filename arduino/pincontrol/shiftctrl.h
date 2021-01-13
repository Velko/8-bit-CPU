#ifndef SHIFT_CTRL_H
#define SHIFT_CTRL_H

#include <stdint.h>

class ShiftCtrl
{
    public:
        ShiftCtrl();
        void setup();
        void commit();
        void set(uint8_t pin);
        void clear(uint8_t pin);
    private:
        uint8_t buffer;
};

#endif /* SHIFT_CTRL_H */