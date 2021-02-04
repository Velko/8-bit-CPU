#include "opcodes.h"

const uint16_t fetch[] = {0x51a3, 0x9167};

const struct opcode opcodes[] PROGMEM = {

    /* nop        */
    { .default_steps = {0xf1e3},},

    /* ldi_A_imm  */
    { .default_steps = {0x51a3, 0x1167},},

    /* ldi_B_imm  */
    { .default_steps = {0x51a3, 0x3167},},

    /* ldi_F_imm  */
    { .default_steps = {0x51a3, 0xf365},},

    /* add_A_A    */
    { .default_steps = {0x1141},},

    /* add_A_B    */
    { .default_steps = {0x1141},},

    /* add_B_A    */
    { .default_steps = {0x3141},},

    /* add_B_B    */
    { .default_steps = {0x3141},},

    /* adc_A_A    */
    { .default_steps = {0x1141},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x1149},
          },
      },
    },

    /* adc_A_B    */
    { .default_steps = {0x1141},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x1149},
          },
      },
    },

    /* adc_B_A    */
    { .default_steps = {0x3141},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3149},
          },
      },
    },

    /* adc_B_B    */
    { .default_steps = {0x3141},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3149},
          },
      },
    },

    /* sub_A_B    */
    { .default_steps = {0x1151},},

    /* sub_B_A    */
    { .default_steps = {0x3151},},

    /* sbb_A_B    */
    { .default_steps = {0x1159},},

    /* sbb_B_A    */
    { .default_steps = {0x3159},},

    /* cmp_A_B    */
    { .default_steps = {0xf151},},

    /* cmp_B_A    */
    { .default_steps = {0xf151},},

    /* mov_A_B    */
    { .default_steps = {0x1123},},

    /* mov_B_A    */
    { .default_steps = {0x3103},},

    /* out_A      */
    { .default_steps = {0xd103},},

    /* out_B      */
    { .default_steps = {0xd123},},

    /* st_addr_A  */
    { .default_steps = {0x51a3, 0x5167, 0x7103},},

    /* st_addr_B  */
    { .default_steps = {0x51a3, 0x5167, 0x7123},},

    /* stabs_A_A  */
    { .default_steps = {0x5103, 0x7103},},

    /* stabs_A_B  */
    { .default_steps = {0x5103, 0x7123},},

    /* stabs_B_A  */
    { .default_steps = {0x5123, 0x7103},},

    /* stabs_B_B  */
    { .default_steps = {0x5123, 0x7123},},

    /* ld_A_addr  */
    { .default_steps = {0x51a3, 0x5167, 0x1161},},

    /* ld_B_addr  */
    { .default_steps = {0x51a3, 0x5167, 0x3161},},

    /* ldabs_A_A  */
    { .default_steps = {0x5103, 0x1161},},

    /* ldabs_A_B  */
    { .default_steps = {0x5123, 0x1161},},

    /* ldabs_B_A  */
    { .default_steps = {0x5103, 0x3161},},

    /* ldabs_B_B  */
    { .default_steps = {0x5123, 0x3161},},

    /* tstabs_A   */
    { .default_steps = {0x5103, 0xf161},},

    /* tstabs_B   */
    { .default_steps = {0x5123, 0xf161},},

    /* jmp_addr   */
    { .default_steps = {0x51a3, 0xb163},},

    /* beq_addr   */
    { .default_steps = {0xf1e7},
      .f_alt = {
          /* mask: --Z- value: --Z- */
          { .mask = 0x02, .value = 0x02,
            .steps = {0x51a3, 0xb163},
          },
      },
    },

    /* bne_addr   */
    { .default_steps = {0xf1e7},
      .f_alt = {
          /* mask: --Z- value: ---- */
          { .mask = 0x02, .value = 0x00,
            .steps = {0x51a3, 0xb163},
          },
      },
    },

    /* bcs_addr   */
    { .default_steps = {0xf1e7},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x51a3, 0xb163},
          },
      },
    },

    /* bcc_addr   */
    { .default_steps = {0xf1e7},
      .f_alt = {
          /* mask: -C-- value: ---- */
          { .mask = 0x04, .value = 0x00,
            .steps = {0x51a3, 0xb163},
          },
      },
    },

    /* out_F      */
    { .default_steps = {0xd183},},

    /* hlt        */
    { .default_steps = {0xf0e3},},
};
