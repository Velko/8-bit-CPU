#ifndef SERIAL_HOST_H
#define SERIAL_HOST_H

#include <stdio.h>

void setup_serial_lazy(void);
int serial_get_char(void);
int serial_get_int(void);
void serial_send_char(int value);
void serial_send_int(int value);
void serial_send_str(const char *value);

#endif /* SERIAL_HOST_H */