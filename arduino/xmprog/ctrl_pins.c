#include <avr/io.h>
#include "ctrl_pins.h"
#include <avr/cpufunc.h>

#define CTRL_PORT   PORTC
#define CTRL_DDR    DDRC

#define WE          PC5
#define CS1         PC0
#define CS2         PC1
#define OE          PC4


void ctrl_pins_setup()
{
    CTRL_PORT |= _BV(WE) | _BV(CS1) | _BV(CS2) | _BV(OE);
    CTRL_DDR  |= _BV(WE) | _BV(CS1) | _BV(CS2) | _BV(OE);
}

void ctrl_oe_on()
{
    CTRL_PORT &= ~_BV(OE);
}

void ctrl_oe_off()
{
    CTRL_PORT |= _BV(OE);
}

void ctrl_we_pulse()
{
    /* At 16 MHz, one cycle is 62.5 ns. The WE pulse should be in range of 100 .. 1000 ns.
       Inserting a couple of NOPs should do the trick */
    CTRL_PORT &= ~_BV(WE);
    _NOP();
    _NOP();
    CTRL_PORT |= _BV(WE);
}

void ctrl_chip_select(uint8_t chip)
{
    CTRL_PORT |= _BV(CS1) | _BV(CS2);

    switch (chip)
    {
    case 0:
        CTRL_PORT &= ~_BV(CS1);
        break;
    case 1:
        CTRL_PORT &= ~_BV(CS2);
        break;
    }
}