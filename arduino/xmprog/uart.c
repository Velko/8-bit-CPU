#include <stdio.h>
#include <avr/io.h>
#include "uart.h"

/* CPU frequency */
#define F_CPU 16000000UL

/* Desired UART baud rate */
#define BAUD 115200UL

#define     BAUD_TOL    3 /* override BAUD tolerance, as 'duino has unfortunate clock rate */
#include <util/setbaud.h>

FILE uart_str;
FILE *serial;

static int uart_putchar(char c, FILE *stream);
static int uart_getchar(FILE *stream);


void uart_init()
{
    UBRR0H = UBRRH_VALUE;
    UBRR0L = UBRRL_VALUE;

#if USE_2X
    UCSR0A = _BV(U2X0);
#else
    UCSR0A = 0;
#endif

    UCSR0C = _BV(UCSZ01) | _BV(UCSZ00); /* 8-bit data */
    UCSR0B = _BV(RXEN0) | _BV(TXEN0);   /* Enable RX and TX */

    fdev_setup_stream(&uart_str, uart_putchar, uart_getchar, _FDEV_SETUP_RW);
    serial = &uart_str;
}

static int uart_putchar(char c, FILE *stream)
{
    loop_until_bit_is_set(UCSR0A, UDRE0);
    UDR0 = c;
    return 0;
}

static int uart_getchar(FILE *stream)
{
    /* for text-only communication one might want to add a little distortion and
       return LF, when CR is received, as some terminal programs sends only CR,
       but fgets() only understands LF */
    loop_until_bit_is_set(UCSR0A, RXC0);

    return UDR0;
}
