#include "xmprog.h"
#include "debug.h"
#include "uart.h"
#include "ctimer.h"
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include "addr_port.h"
#include "data_port.h"
#include "ctrl_pins.h"

int main()
{
    uart_init();
    ctimer_init();
    ctrl_pins_setup();
    data_port_set_input();
    addr_port_setup();
    stdout = stdin = serial;

    printf_P(PSTR("XMODEM writer 0.1\r\n"));

    sei();

    for(;;)
    {
        xmprog_step_main();
    }

    return 0;
}
