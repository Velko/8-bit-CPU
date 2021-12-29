#include <vpi_user.h>
#include "op-defs.h"


static int set_default_cw_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle cw_arg = vpi_scan(args_iter);

    struct t_vpi_value cw_val;
    cw_val.format = vpiIntVal;
    cw_val.value.integer = CTRL_DEFAULT;
    vpi_put_value(cw_arg, &cw_val, NULL, vpiNoDelay);

    vpi_free_object(args_iter);

    return 0;
}



void register_set_default_cw(void)
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$set_default_cw";
      tf_data.calltf    = set_default_cw_handler;
      tf_data.compiletf = 0;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}
