#ifndef SHIFT_CTRL_H
#define SHIFT_CTRL_H

#include <stdint.h>
#include <shiftoutext.h>

class ShiftCtrl
{
        ShiftOutExt shext;
        uint16_t init;
    public:
        ShiftCtrl(uint16_t init);
        void setup();
        void commit();
        void reset();
        void set(uint8_t pin);
        void clear(uint8_t pin);
    private:
        uint16_t buffer;
};

#endif /* SHIFT_CTRL_H */
