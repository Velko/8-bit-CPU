#include "registration.h"


PLI_INT32 read_intval(vpiHandle handle)
{
    struct t_vpi_value arg_val;
    arg_val.format = vpiIntVal;
    vpi_get_value(handle, &arg_val);

    return arg_val.value.integer;
}

void (*vlog_startup_routines[])(void) = {
    open_serial,
    register_set_default_cw,
    register_serial_get_cmd,
    register_serial_get_arg,
    register_serial_send_int,
    register_serial_send_str,
    register_read_control_rom,
    0
};