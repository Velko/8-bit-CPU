#ifndef SHIFT_CTRL_H
#define SHIFT_CTRL_H

#include <stdint.h>
#include <shiftoutext.h>

class ShiftCtrl
{
        ShiftOutExt shext;
    public:
        ShiftCtrl(uint8_t init);
        void setup();
        void commit();
        void set(uint8_t pin);
        void clear(uint8_t pin);
    private:
        uint8_t buffer;
};

#endif /* SHIFT_CTRL_H */