#include <vpi_user.h>
#include "hdb_comm.h"

static int hdb_get_char_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle endpoint_arg = vpi_scan(args_iter);
    vpiHandle chr_arg = vpi_scan(args_iter);

    struct t_vpi_value endpoint_val;
    endpoint_val.format = vpiIntVal;
    vpi_get_value(endpoint_arg, &endpoint_val);

    struct t_vpi_value chr_val;
    chr_val.format = vpiIntVal;
    chr_val.value.integer = hdb_get_char(endpoint_val.value.integer);
    vpi_put_value(chr_arg, &chr_val, NULL, vpiNoDelay);

    vpi_free_object(args_iter);

    return 0;
}

static int hdb_peek_char_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle endpoint_arg = vpi_scan(args_iter);
    vpiHandle chr_arg = vpi_scan(args_iter);

    struct t_vpi_value endpoint_val;
    endpoint_val.format = vpiIntVal;
    vpi_get_value(endpoint_arg, &endpoint_val);

    struct t_vpi_value chr_val;
    chr_val.format = vpiIntVal;
    chr_val.value.integer = hdb_peek_char(endpoint_val.value.integer);
    vpi_put_value(chr_arg, &chr_val, NULL, vpiNoDelay);

    vpi_free_object(args_iter);

    return 0;
}

static int hdb_get_int_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle endpoint_arg = vpi_scan(args_iter);
    vpiHandle int_arg = vpi_scan(args_iter);

    struct t_vpi_value endpoint_val;
    endpoint_val.format = vpiIntVal;
    vpi_get_value(endpoint_arg, &endpoint_val);

    struct t_vpi_value int_val;
    int_val.format = vpiIntVal;
    int_val.value.integer = hdb_get_int(endpoint_val.value.integer);
    vpi_put_value(int_arg, &int_val, NULL, vpiNoDelay);

    vpi_free_object(args_iter);

    return 0;
}

static int hdb_send_char_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle endpoint_arg = vpi_scan(args_iter);
    vpiHandle resp_arg = vpi_scan(args_iter);

    struct t_vpi_value endpoint_val;
    endpoint_val.format = vpiIntVal;
    vpi_get_value(endpoint_arg, &endpoint_val);

    struct t_vpi_value resp_val;
    resp_val.format = vpiIntVal;
    vpi_get_value(resp_arg, &resp_val);

    hdb_send_char(endpoint_val.value.integer, resp_val.value.integer);

    vpi_free_object(args_iter);

    return 0;
}

static int hdb_send_int_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle endpoint_arg = vpi_scan(args_iter);
    vpiHandle resp_arg = vpi_scan(args_iter);

    struct t_vpi_value endpoint_val;
    endpoint_val.format = vpiIntVal;
    vpi_get_value(endpoint_arg, &endpoint_val);

    struct t_vpi_value resp_val;
    resp_val.format = vpiIntVal;
    vpi_get_value(resp_arg, &resp_val);

    hdb_send_int(endpoint_val.value.integer, resp_val.value.integer);

    vpi_free_object(args_iter);

    return 0;
}

static int hdb_send_str_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle endpoint_arg = vpi_scan(args_iter);
    vpiHandle resp_arg = vpi_scan(args_iter);

    struct t_vpi_value endpoint_val;
    endpoint_val.format = vpiIntVal;
    vpi_get_value(endpoint_arg, &endpoint_val);

    struct t_vpi_value resp_val;
    resp_val.format = vpiStringVal;
    vpi_get_value(resp_arg, &resp_val);

    hdb_send_str(endpoint_val.value.integer, resp_val.value.str);

    vpi_free_object(args_iter);

    return 0;
}

static int hdb_check_input_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle endpoint_arg = vpi_scan(args_iter);
    vpiHandle chr_arg = vpi_scan(args_iter);

    struct t_vpi_value endpoint_val;
    endpoint_val.format = vpiIntVal;
    vpi_get_value(endpoint_arg, &endpoint_val);

    struct t_vpi_value status_val;
    status_val.format = vpiIntVal;

    status_val.value.integer = hdb_check_input(endpoint_val.value.integer);
    vpi_put_value(chr_arg, &status_val, NULL, vpiNoDelay);

    vpi_free_object(args_iter);

    return 0;
}

static int hdb_discard_char_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle endpoint_arg = vpi_scan(args_iter);

    struct t_vpi_value endpoint_val;
    endpoint_val.format = vpiIntVal;
    vpi_get_value(endpoint_arg, &endpoint_val);

    hdb_discard_char(endpoint_val.value.integer);

    vpi_free_object(args_iter);

    return 0;
}

static int hdb_register_endpoint_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle channel_arg = vpi_scan(args_iter);
    vpiHandle port_arg = vpi_scan(args_iter);

    struct t_vpi_value channel_val;
    channel_val.format = vpiIntVal;
    vpi_get_value(channel_arg, &channel_val);

    struct t_vpi_value port_val;
    port_val.format = vpiIntVal;
    vpi_get_value(port_arg, &port_val);

    hdb_register_endpoint(channel_val.value.integer, (uint16_t)port_val.value.integer);

    vpi_free_object(args_iter);

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

void register_hdb_register_endpoint(void)
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$hdb_register_endpoint";
      tf_data.calltf    = hdb_register_endpoint_handler;
      tf_data.compiletf = 0;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}
