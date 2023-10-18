#include "registration.h"
#include "serial_host.h"

void (*vlog_startup_routines[])(void) = {
    setup_serial_lazy,
    register_serial_get_char,
    register_serial_get_int,
    register_serial_send_char,
    register_serial_send_int,
    register_serial_send_str,
    register_serial_check_input,
    0
};