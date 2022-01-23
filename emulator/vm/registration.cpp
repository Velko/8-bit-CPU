#include "registration.h"
#include "serial_host.h"

void (*vlog_startup_routines[])(void) = {
    open_serial,
    register_serial_get_cmd,
    register_serial_get_arg,
    register_serial_send_int,
    register_serial_send_str,
    0
};