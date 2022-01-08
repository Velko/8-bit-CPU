#ifndef __UART_H__
#define __UART_H__

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

    void uart_init();

    extern FILE *serial;


#ifdef __cplusplus
}
#endif

#endif
