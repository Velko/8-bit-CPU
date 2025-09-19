#include <vpi_user.h>
#include "serial_host.h"

static int hdb_get_char_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle chr_arg = vpi_scan(args_iter);

    struct t_vpi_value chr_val;
    chr_val.format = vpiIntVal;
    chr_val.value.integer = serial_get_char();
    vpi_put_value(chr_arg, &chr_val, NULL, vpiNoDelay);

    vpi_free_object(args_iter);

    return 0;
}

static int hdb_peek_char_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle chr_arg = vpi_scan(args_iter);

    struct t_vpi_value chr_val;
    chr_val.format = vpiIntVal;
    chr_val.value.integer = serial_peek_char();
    vpi_put_value(chr_arg, &chr_val, NULL, vpiNoDelay);

    vpi_free_object(args_iter);

    return 0;
}

static int hdb_get_int_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle int_arg = vpi_scan(args_iter);

    struct t_vpi_value int_val;
    int_val.format = vpiIntVal;
    int_val.value.integer = serial_get_int();
    vpi_put_value(int_arg, &int_val, NULL, vpiNoDelay);

    vpi_free_object(args_iter);

    return 0;
}

static int hdb_send_char_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle resp_arg = vpi_scan(args_iter);

    struct t_vpi_value resp_val;
    resp_val.format = vpiIntVal;
    vpi_get_value(resp_arg, &resp_val);
    serial_send_char(resp_val.value.integer);

    vpi_free_object(args_iter);

    return 0;
}

static int hdb_send_int_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle resp_arg = vpi_scan(args_iter);

    struct t_vpi_value resp_val;
    resp_val.format = vpiIntVal;
    vpi_get_value(resp_arg, &resp_val);
    serial_send_int(resp_val.value.integer);

    vpi_free_object(args_iter);

    return 0;
}

static int hdb_send_str_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle resp_arg = vpi_scan(args_iter);

    struct t_vpi_value resp_val;
    resp_val.format = vpiStringVal;
    vpi_get_value(resp_arg, &resp_val);
    serial_send_str(resp_val.value.str);

    vpi_free_object(args_iter);

    return 0;
}

static int hdb_check_input_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle chr_arg = vpi_scan(args_iter);

    struct t_vpi_value status_val;
    status_val.format = vpiIntVal;
    status_val.value.integer = serial_check_input();
    vpi_put_value(chr_arg, &status_val, NULL, vpiNoDelay);

    vpi_free_object(args_iter);

    return 0;
}

static int hdb_discard_char_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    serial_discard_char();

    return 0;
}

void register_hdb_get_char(void)
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$hdb_get_char";
      tf_data.calltf    = hdb_get_char_handler;
      tf_data.compiletf = 0;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}

void register_hdb_peek_char(void)
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$hdb_peek_char";
      tf_data.calltf    = hdb_peek_char_handler;
      tf_data.compiletf = 0;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}

void register_hdb_get_int(void)
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$hdb_get_int";
      tf_data.calltf    = hdb_get_int_handler;
      tf_data.compiletf = 0;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}

void register_hdb_send_char(void)
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$hdb_send_char";
      tf_data.calltf    = hdb_send_char_handler;
      tf_data.compiletf = 0;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}

void register_hdb_send_int(void)
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$hdb_send_int";
      tf_data.calltf    = hdb_send_int_handler;
      tf_data.compiletf = 0;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}

void register_hdb_send_str(void)
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$hdb_send_str";
      tf_data.calltf    = hdb_send_str_handler;
      tf_data.compiletf = 0;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}

void register_hdb_check_input(void)
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$hdb_check_input";
      tf_data.calltf    = hdb_check_input_handler;
      tf_data.compiletf = 0;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}


void register_hdb_discard_char(void)
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$hdb_discard_char";
      tf_data.calltf    = hdb_discard_char_handler;
      tf_data.compiletf = 0;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}