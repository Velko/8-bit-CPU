#include "microcode.h"

const uint16_t op_fetch[] = {0x32c5, 0x34e3};

const struct op_microcode microcode[] PROGMEM = {

    /* nop        */
    { .default_steps = {0x37c7},},

    /* ldi_A_imm  */
    { .default_steps = {0x32c5, 0x30e3},},

    /* ldi_B_imm  */
    { .default_steps = {0x32c5, 0x31e3},},

    /* ldi_F_imm  */
    { .default_steps = {0x32c5, 0x37ab},},

    /* add_A_A    */
    { .default_steps = {0x3082},},

    /* add_A_B    */
    { .default_steps = {0x3082},},

    /* add_B_A    */
    { .default_steps = {0x3182},},

    /* add_B_B    */
    { .default_steps = {0x3182},},

    /* adc_A_A    */
    { .default_steps = {0x3082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3882},
          },
      },
    },

    /* adc_A_B    */
    { .default_steps = {0x3082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3882},
          },
      },
    },

    /* adc_B_A    */
    { .default_steps = {0x3182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3982},
          },
      },
    },

    /* adc_B_B    */
    { .default_steps = {0x3182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3982},
          },
      },
    },

    /* sub_A_B    */
    { .default_steps = {0x3092},},

    /* sub_B_A    */
    { .default_steps = {0x3192},},

    /* sbb_A_B    */
    { .default_steps = {0x3892},},

    /* sbb_B_A    */
    { .default_steps = {0x3992},},

    /* cmp_A_B    */
    { .default_steps = {0x3792},},

    /* cmp_B_A    */
    { .default_steps = {0x3792},},

    /* mov_A_B    */
    { .default_steps = {0x30c1},},

    /* mov_B_A    */
    { .default_steps = {0x31c0},},

    /* out_A      */
    { .default_steps = {0x36c0},},

    /* out_B      */
    { .default_steps = {0x36c1},},

    /* st_addr_A  */
    { .default_steps = {0x32c5, 0x32e3, 0x33c0},},

    /* st_addr_B  */
    { .default_steps = {0x32c5, 0x32e3, 0x33c1},},

    /* stabs_A_A  */
    { .default_steps = {0x32c0, 0x33c0},},

    /* stabs_A_B  */
    { .default_steps = {0x32c0, 0x33c1},},

    /* stabs_B_A  */
    { .default_steps = {0x32c1, 0x33c0},},

    /* stabs_B_B  */
    { .default_steps = {0x32c1, 0x33c1},},

    /* ld_A_addr  */
    { .default_steps = {0x32c5, 0x32e3, 0x3083},},

    /* ld_B_addr  */
    { .default_steps = {0x32c5, 0x32e3, 0x3183},},

    /* ldabs_A_A  */
    { .default_steps = {0x32c0, 0x3083},},

    /* ldabs_A_B  */
    { .default_steps = {0x32c1, 0x3083},},

    /* ldabs_B_A  */
    { .default_steps = {0x32c0, 0x3183},},

    /* ldabs_B_B  */
    { .default_steps = {0x32c1, 0x3183},},

    /* tstabs_A   */
    { .default_steps = {0x32c0, 0x3783},},

    /* tstabs_B   */
    { .default_steps = {0x32c1, 0x3783},},

    /* jmp_addr   */
    { .default_steps = {0x32c5, 0x35c3},},

    /* beq_addr   */
    { .default_steps = {0x37e7},
      .f_alt = {
          /* mask: --Z- value: --Z- */
          { .mask = 0x02, .value = 0x02,
            .steps = {0x32c5, 0x35c3},
          },
      },
    },

    /* bne_addr   */
    { .default_steps = {0x37e7},
      .f_alt = {
          /* mask: --Z- value: ---- */
          { .mask = 0x02, .value = 0x00,
            .steps = {0x32c5, 0x35c3},
          },
      },
    },

    /* bcs_addr   */
    { .default_steps = {0x37e7},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x32c5, 0x35c3},
          },
      },
    },

    /* bcc_addr   */
    { .default_steps = {0x37e7},
      .f_alt = {
          /* mask: -C-- value: ---- */
          { .mask = 0x04, .value = 0x00,
            .steps = {0x32c5, 0x35c3},
          },
      },
    },

    /* out_F      */
    { .default_steps = {0x36c4},},

    /* hlt        */
    { .default_steps = {0x17c7},},
};
