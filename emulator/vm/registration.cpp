#include "registration.h"


void (*vlog_startup_routines[])(void) = {
    open_serial,
    register_set_default_cw,
    register_serial_get_cmd,
    register_serial_get_arg,
    register_serial_send_int,
    register_serial_send_str,
    0
};