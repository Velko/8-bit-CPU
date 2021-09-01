#include "shiftoutext.h"
#include <SPI.h>

#define LATCH_PIN  10

ShiftOutExt::ShiftOutExt()
    : ShiftOutExt(CtrlPin(LATCH_PIN, CtrlPin::ACTIVE_HIGH))
{
}

ShiftOutExt::ShiftOutExt(CtrlPin&& _latch)
    : latch{_latch}
{
}

void ShiftOutExt::setup()
{
    SPI.begin();
    SPI.setDataMode(SPI_MODE0);
    SPI.setBitOrder(MSBFIRST);
    SPI.setClockDivider(SPI_CLOCK_DIV2);

    // We're using SS pin for latch control. The CtrlPin initialization
    // should be done after SPI.begin(), as it modifies the state of SS
    // to a "known safe" state
    latch.setup();
}

uint8_t ShiftOutExt::write8(uint8_t data)
{
    uint8_t din = SPI.transfer(data);
    latch.on();
    latch.off();

    return din;
}

uint16_t ShiftOutExt::write16(uint16_t data)
{
    uint8_t din_l = SPI.transfer((data >> 8) & 0xFF);
    uint16_t din_h = SPI.transfer(data & 0xFF);
    latch.on();
    latch.off();

    return din_l | (din_h << 8);
}

uint32_t ShiftOutExt::write24(uint32_t data)
{
    uint8_t din_l = SPI.transfer((data >> 16) & 0xFF);
    uint16_t din_m = SPI.transfer((data >> 8) & 0xFF);
    uint32_t din_h = SPI.transfer(data & 0xFF);
    latch.on();
    latch.off();

    return din_l | (din_m << 8) | (din_h << 16);
}
