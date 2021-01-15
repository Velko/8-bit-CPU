#ifndef SHIFT_CTRL_H
#define SHIFT_CTRL_H

#include <stdint.h>
#include <shiftoutext.h>

class ShiftCtrl
{
        ShiftOutExt shext;
        uint16_t defaults;
    public:
        ShiftCtrl(uint16_t defaults);
        void setup();
        void commit(uint16_t c_word);
        void reset();
};

#endif /* SHIFT_CTRL_H */
