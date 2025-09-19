#include "registration.h"
#include "hdb_comm.h"

void (*vlog_startup_routines[])(void) = {
    hdb_setup_comm_lazy,
    register_hdb_get_char,
    register_hdb_peek_char,
    register_hdb_get_int,
    register_hdb_send_char,
    register_hdb_send_int,
    register_hdb_send_str,
    register_hdb_check_input,
    register_hdb_discard_char,
    0
};