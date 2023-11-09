#ifndef REGISTRATION_H
#define REGISTRATION_H

#include <vpi_user.h>

void register_serial_get_char(void);
void register_serial_peek_char(void);
void register_serial_get_int(void);
void register_serial_send_char(void);
void register_serial_send_int(void);
void register_serial_send_str(void);
void register_serial_check_input(void);
void register_serial_discard_char(void);

#endif /* REGISTRATION_H */