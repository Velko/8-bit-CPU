#ifndef REGISTRATION_H
#define REGISTRATION_H

#include <vpi_user.h>

void register_serial_get_char(void);
void register_serial_get_int(void);
void register_serial_send_char(void);
void register_serial_send_int(void);
void register_serial_send_str(void);

#endif /* REGISTRATION_H */