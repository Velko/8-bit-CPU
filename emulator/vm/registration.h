#ifndef REGISTRATION_H
#define REGISTRATION_H

void open_serial();
void register_serial_get_cmd(void);
void register_serial_get_arg(void);
void register_serial_send_int(void);
void register_serial_send_str(void);

void register_set_default_cw(void);


#endif /* REGISTRATION_H */