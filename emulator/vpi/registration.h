#ifndef REGISTRATION_H
#define REGISTRATION_H

#include <vpi_user.h>

void register_serial_get_cmd(void);
void register_serial_get_arg(void);
void register_serial_send_int(void);
void register_serial_send_str(void);

#endif /* REGISTRATION_H */