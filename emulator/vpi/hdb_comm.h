#ifndef SERIAL_HOST_H
#define SERIAL_HOST_H

#include <stdio.h>

void hdb_setup_comm_lazy(void);
int hdb_get_char(void);
int hdb_peek_char(void);
int hdb_get_int(void);
void hdb_send_char(int value);
void hdb_send_int(int value);
void hdb_send_str(const char *value);
int hdb_check_input(void);
void hdb_discard_char(void);

int channel_open(void);

#endif /* SERIAL_HOST_H */