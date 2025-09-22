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
int channel_send(int fd, const void *buf, size_t len);
int channel_receive(int fd, void *buf, size_t len);
void channel_close(int fd);

#endif /* SERIAL_HOST_H */