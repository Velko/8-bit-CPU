#ifndef SERIAL_HOST_H
#define SERIAL_HOST_H

#include <stdint.h>
#include <stddef.h>
#include <stdio.h>

void open_serial();

extern FILE *serial;

#endif /* SERIAL_HOST_H */