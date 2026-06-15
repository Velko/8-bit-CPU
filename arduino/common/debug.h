#ifndef DEBUG_H
#define DEBUG_H

#ifndef __AVR__

#include <stdio.h>

#define dprintf   printf

#else

#define dprintf(...)

#endif

#endif /* DEBUG_H */