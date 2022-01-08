#include <avr/io.h>
#include <avr/interrupt.h>
#include <stdio.h>

volatile char ctimer_on;

void ctimer_init()
{
    TCCR1A = 0;
    TCCR1B = _BV(CS12);
    TCCR1C = 0;

    TIMSK1 = _BV(TOIE1);
    ctimer_on = 0;
}

void ctimer_start()
{
    TCNT1H = 0;
    TCNT1L = 0;
    ctimer_on = 1;
}

void ctimer_stop()
{
    ctimer_on = 0;
}

ISR(TIMER1_OVF_vect)
{
    if (ctimer_on) {
        fputc('C', stdout);
        fflush(stdout);
    }
}