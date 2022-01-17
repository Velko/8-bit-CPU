#ifndef XMPROG_H
#define XMPROG_H

#include <stdint.h>
#include <stddef.h>
#include <stdio.h>


#ifdef __AVR__
#else
#include "serial_host.h"
#include <unistd.h>
#define delay(X) sleep(X/1000)

#endif

#ifdef __cplusplus
extern "C" {
#endif

    void xmprog_step_main();

#ifdef __cplusplus
}
#endif

#endif /* XMPROG_H */