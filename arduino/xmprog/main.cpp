#include "xmprog.h"
#include "debug.h"
#include "uart.h"
#include <avr/pgmspace.h>

int main()
{
    uart_init();
    stdout = stdin = serial;

    printf_P(PSTR("XMODEM writer 0.1\r\n"));

    XmProg Prog(serial);

    for(;;)
    {
        Prog.StepMainLoop();
    }

    return 0;
}
