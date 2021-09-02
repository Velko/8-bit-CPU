#include "addr_port.h"
#include <SPI.h>

#define LATCH_PIN  10

AddrPort::AddrPort()
    : latch(LATCH_PIN, CtrlPin::ACTIVE_HIGH)
{
}

void AddrPort::setup()
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

void AddrPort::write24(uint32_t data)
{
    SPI.transfer((data >> 16) & 0xFF);
    SPI.transfer((data >> 8) & 0xFF);
    SPI.transfer(data & 0xFF);
    latch.on();
    latch.off();
}
