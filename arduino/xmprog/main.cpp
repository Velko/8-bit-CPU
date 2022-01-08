#include "xmprog.h"
#include "debug.h"
#include "uart.h"
#include "ctimer.h"
#include <avr/pgmspace.h>
#include <avr/interrupt.h>

extern "C" void ctimer_init();

int main()
{
    uart_init();
    ctimer_init();
    stdout = stdin = serial;

    printf_P(PSTR("XMODEM writer 0.1\r\n"));

    XmProg Prog(serial);

    sei();

    for(;;)
    {
        Prog.StepMainLoop();
    }

    return 0;
}
