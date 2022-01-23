#include <vpi_user.h>
#include "serial_host.h"

static int serial_get_cmd_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle cmd_arg = vpi_scan(args_iter);

    struct t_vpi_value cmd_val;
    cmd_val.format = vpiIntVal;

    int val = fgetc(serial);
    if (val < 0)
        perror("serial_get_cmd");

    cmd_val.value.integer = val;
    vpi_put_value(cmd_arg, &cmd_val, NULL, vpiNoDelay);

    vpi_free_object(args_iter);

    return 0;
}

static int serial_get_arg_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle arg_arg = vpi_scan(args_iter);

    struct t_vpi_value arg_val;
    arg_val.format = vpiIntVal;

    int res = fscanf(serial, "%d", &arg_val.value.integer);
     if (res < 0)
        perror("serial_get_arg");

    vpi_put_value(arg_arg, &arg_val, NULL, vpiNoDelay);

    vpi_free_object(args_iter);

    return 0;
}

static int serial_send_int_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle resp_arg = vpi_scan(args_iter);

    struct t_vpi_value resp_val;
    resp_val.format = vpiIntVal;

    vpi_get_value(resp_arg, &resp_val);

    int res = fprintf(serial, "%d\r\n", resp_val.value.integer);
    if (res < 0)
        perror("serial_send_int");

    vpi_free_object(args_iter);

    return 0;
}

static int serial_send_str_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle resp_arg = vpi_scan(args_iter);

    struct t_vpi_value resp_val;
    resp_val.format = vpiStringVal;

    vpi_get_value(resp_arg, &resp_val);

    int res = fprintf(serial, "%s\r\n", resp_val.value.str);
    if (res < 0)
        perror("serial_send_str");

    vpi_free_object(args_iter);

    return 0;
}

void open_serial()
{
    Serial.begin(115200);
}

void register_serial_get_cmd(void)
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$serial_get_cmd";
      tf_data.calltf    = serial_get_cmd_handler;
      tf_data.compiletf = 0;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}

void register_serial_get_arg(void)
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$serial_get_arg";
      tf_data.calltf    = serial_get_arg_handler;
      tf_data.compiletf = 0;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}

void register_serial_send_int(void)
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$serial_send_int";
      tf_data.calltf    = serial_send_int_handler;
      tf_data.compiletf = 0;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}

void register_serial_send_str(void)
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$serial_send_str";
      tf_data.calltf    = serial_send_str_handler;
      tf_data.compiletf = 0;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}
