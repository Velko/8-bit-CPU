#include "xmprog.h"
#include "debug.h"
#include "uart.h"
#include "ctimer.h"
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include "flash_hw.h"

int main()
{
    uart_init();
    ctimer_init();
    flash_setup();
    stdout = stdin = serial;

    printf_P(PSTR("XMODEM writer 0.1\r\n"));

    sei();

    for(;;)
    {
        xmprog_step_main();
    }

    return 0;
}
