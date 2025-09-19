#ifndef REGISTRATION_H
#define REGISTRATION_H

#include <vpi_user.h>

void register_hdb_get_char(void);
void register_hdb_peek_char(void);
void register_hdb_get_int(void);
void register_hdb_send_char(void);
void register_hdb_send_int(void);
void register_hdb_send_str(void);
void register_hdb_check_input(void);
void register_hdb_discard_char(void);

#endif /* REGISTRATION_H */