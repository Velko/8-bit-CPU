#ifndef SHIFT_OUT_EXT_H
#define SHIFT_OUT_EXT_H

#include "ctrlpin.h"

class ShiftOutExt
{
    public:
        ShiftOutExt();
        ShiftOutExt(CtrlPin&& latch);
        void setup();
        uint8_t write8(uint8_t data);
        uint16_t write16(uint16_t data);
    private:
        CtrlPin latch;
};

#endif /* SHIFT_OUT_EXT_H */