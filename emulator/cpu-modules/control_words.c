#include <vpi_user.h>
#include "op-defs.h"
#include "microcode.h"


PLI_INT32 read_intval(vpiHandle handle)
{
    struct t_vpi_value arg_val;
    arg_val.format = vpiIntVal;
    vpi_get_value(handle, &arg_val);

    return arg_val.value.integer;
}

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

static cword_t resolve_opcode_cw(PLI_INT32 step_no, PLI_INT32 opcode, PLI_INT32 flags)
{
    //TODO: should we implement INVALID_OPCODE ?
    if (opcode >= NUM_OPS)
        return CTRL_DEFAULT;

    const struct op_microcode *ucode = &microcode[opcode];

    const cword_t *steps = ucode->default_steps;

    // and look up if there are flags-dependant steps
    for (unsigned i = 0; i < MAX_ALTS; ++i)
    {
        if (ucode->f_alt[i].mask &&
            (flags & ucode->f_alt[i].mask) == ucode->f_alt[i].value)
        {
            steps = ucode->f_alt[i].steps;
            break;
        }
    }

    // add steps reset bit
    if (steps[step_no+1] == 0 || step_no + 1 == MAX_STEPS + NUM_FETCH_STEPS)
        return steps[step_no] & (~LPIN_STEPS_RESET_BIT);
    else
        return steps[step_no];
}

static int read_control_rom_handler(char *user_data)
{
    (void)user_data; // suppress [-Wunused-parameter]

    vpiHandle systfref = vpi_handle(vpiSysTfCall, NULL);
    vpiHandle args_iter = vpi_iterate(vpiArgument, systfref);

    vpiHandle cw_arg = vpi_scan(args_iter);
    vpiHandle step_arg = vpi_scan(args_iter);
    vpiHandle flags_arg = vpi_scan(args_iter);
    vpiHandle opcode_arg = vpi_scan(args_iter);

    /* output */
    struct t_vpi_value cw_val;
    cw_val.format = vpiIntVal;

    PLI_INT32 step_no = read_intval(step_arg);

    if (step_no < NUM_FETCH_STEPS)
    {
        // fetch step(s) are always the same
        cw_val.value.integer = op_fetch[step_no];
    } else {

        step_no -= NUM_FETCH_STEPS;

        // read instruction
        PLI_INT32 opcode = read_intval(opcode_arg);
        PLI_INT32 flags = read_intval(flags_arg);

        cw_val.value.integer = resolve_opcode_cw(step_no, opcode, flags);
    }


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


void register_read_control_rom(void)
{
      s_vpi_systf_data tf_data;

      tf_data.type      = vpiSysTask;
      tf_data.tfname    = "$read_control_rom";
      tf_data.calltf    = read_control_rom_handler;
      tf_data.compiletf = 0;
      tf_data.sizetf    = 0;
      tf_data.user_data = 0;
      vpi_register_systf(&tf_data);
}

void (*vlog_startup_routines[])(void) = {
    register_set_default_cw,
    register_read_control_rom,
    0
};