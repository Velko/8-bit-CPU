#ifndef REGISTRATION_H
#define REGISTRATION_H

#include <vpi_user.h>


PLI_INT32 read_intval(vpiHandle handle);

void register_serial_get_cmd(void);
void register_serial_get_arg(void);
void register_serial_send_int(void);
void register_serial_send_str(void);

void register_set_default_cw(void);
void register_read_control_rom(void);


#endif /* REGISTRATION_H */