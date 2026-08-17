#ifndef SERIAL_HOST_H
#define SERIAL_HOST_H

#include <stdio.h>
#include <stdint.h>

#define NUM_CHANNELS 3

void hdb_setup_comm(void);
int hdb_get_char(int endpoint);
int hdb_peek_char(int endpoint);
int hdb_get_int(int endpoint);
void hdb_send_char(int endpoint, int value);
void hdb_send_int(int endpoint, int value);
void hdb_send_str(int endpoint, const char *value);
int hdb_check_input(int endpoint);
void hdb_discard_char(int endpoint);

void hdb_register_endpoint(int endpoint, uint16_t port);

int channel_open(int endpoint);
int channel_send(int fd, uint16_t port, const void *buf, size_t len);
int channel_receive(int fd, void *buf, size_t len);
void channel_close(int fd);

#endif /* SERIAL_HOST_H */
