#ifndef SHIFT_OUT_EXT_H
#define SHIFT_OUT_EXT_H

#include "outpin.h"

class ShiftOutExt
{
    public:
        ShiftOutExt();
        ShiftOutExt(OutPinH&& latch);
        void setup();
        uint8_t write8(uint8_t data);
        uint16_t write16(uint16_t data);
        uint32_t write24(uint32_t data);
    private:
        OutPinH latch;
};

#endif /* SHIFT_OUT_EXT_H */