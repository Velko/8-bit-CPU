#ifndef SERIAL_HOST_H
#define SERIAL_HOST_H

#include <stdio.h>

void open_serial(void);
int serial_get_cmd(void);
int serial_get_arg(void);
void serial_send_int(int value);
void serial_send_str(const char *value);

#endif /* SERIAL_HOST_H */