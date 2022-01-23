#ifndef SERIAL_HOST_H
#define SERIAL_HOST_H

#include <stdint.h>
#include <stddef.h>
#include <stdio.h>

class SerialHost
{
    public:
        static void begin(unsigned long baud);
};

extern FILE *serial;

#endif /* SERIAL_HOST_H */