#ifndef SERIAL_H
#define SERIAL_H

#ifdef __cplusplus
extern "C" {
#endif

int serial_port_open(const char* port);
void serial_port_set_speed(int fd);
void serial_port_reset_arduino(int port_fd);


#ifdef __cplusplus
}
#endif

#endif /* SERIAL_H */