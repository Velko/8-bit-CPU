#include "microcode.h"

const cword_t op_fetch[] = {0x14e3};

const struct op_microcode microcode[] PROGMEM = {

    /* 00 nop        */
    { .default_steps = {0x17c7},},

    /* 01 ldi_A_imm  */
    { .default_steps = {0x10e3},},

    /* 02 ldi_B_imm  */
    { .default_steps = {0x11e3},},

    /* 03 ldi_F_imm  */
    { .default_steps = {0x12e3},},

    /* 04 add_A_A    */
    { .default_steps = {0x1082},},

    /* 05 add_A_B    */
    { .default_steps = {0x1082},},

    /* 06 add_B_A    */
    { .default_steps = {0x1182},},

    /* 07 add_B_B    */
    { .default_steps = {0x1182},},

    /* 08 adc_A_A    */
    { .default_steps = {0x1082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x1882},
          },
      },
    },

    /* 09 adc_A_B    */
    { .default_steps = {0x1082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x1882},
          },
      },
    },

    /* 0a adc_B_A    */
    { .default_steps = {0x1182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x1982},
          },
      },
    },

    /* 0b adc_B_B    */
    { .default_steps = {0x1182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x1982},
          },
      },
    },

    /* 0c sub_A_B    */
    { .default_steps = {0x1092},},

    /* 0d sub_B_A    */
    { .default_steps = {0x1192},},

    /* 0e sbb_A_B    */
    { .default_steps = {0x1092},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x1892},
          },
      },
    },

    /* 0f sbb_B_A    */
    { .default_steps = {0x1192},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x1992},
          },
      },
    },

    /* 10 cmp_A_B    */
    { .default_steps = {0x1792},},

    /* 11 cmp_B_A    */
    { .default_steps = {0x1792},},

    /* 12 mov_A_B    */
    { .default_steps = {0x10c1},},

    /* 13 mov_B_A    */
    { .default_steps = {0x11c0},},

    /* 14 out_A      */
    { .default_steps = {0x16c0},},

    /* 15 out_B      */
    { .default_steps = {0x16c1},},

    /* 16 st_addr_A  */
    { .default_steps = {0x15e3, 0x53c0},},

    /* 17 st_addr_B  */
    { .default_steps = {0x15e3, 0x53c1},},

    /* 18 stabs_A_A  */
    { .default_steps = {0x15c0, 0x53c0},},

    /* 19 stabs_A_B  */
    { .default_steps = {0x15c0, 0x53c1},},

    /* 1a stabs_B_A  */
    { .default_steps = {0x15c1, 0x53c0},},

    /* 1b stabs_B_B  */
    { .default_steps = {0x15c1, 0x53c1},},

    /* 1c ld_A_addr  */
    { .default_steps = {0x15e3, 0x5083},},

    /* 1d ld_B_addr  */
    { .default_steps = {0x15e3, 0x5183},},

    /* 1e ldabs_A_A  */
    { .default_steps = {0x15c0, 0x5083},},

    /* 1f ldabs_A_B  */
    { .default_steps = {0x15c1, 0x5083},},

    /* 20 ldabs_B_A  */
    { .default_steps = {0x15c0, 0x5183},},

    /* 21 ldabs_B_B  */
    { .default_steps = {0x15c1, 0x5183},},

    /* 22 tstabs_A   */
    { .default_steps = {0x15c0, 0x5783},},

    /* 23 tstabs_B   */
    { .default_steps = {0x15c1, 0x5783},},

    /* 24 jmp_addr   */
    { .default_steps = {0x15e3, 0x57c7},},

    /* 25 beq_addr   */
    { .default_steps = {0x17e7},
      .f_alt = {
          /* mask: --Z- value: --Z- */
          { .mask = 0x02, .value = 0x02,
            .steps = {0x15e3, 0x57c7},
          },
      },
    },

    /* 26 bne_addr   */
    { .default_steps = {0x17e7},
      .f_alt = {
          /* mask: --Z- value: ---- */
          { .mask = 0x02, .value = 0x00,
            .steps = {0x15e3, 0x57c7},
          },
      },
    },

    /* 27 bcs_addr   */
    { .default_steps = {0x17e7},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x15e3, 0x57c7},
          },
      },
    },

    /* 28 bcc_addr   */
    { .default_steps = {0x17e7},
      .f_alt = {
          /* mask: -C-- value: ---- */
          { .mask = 0x04, .value = 0x00,
            .steps = {0x15e3, 0x57c7},
          },
      },
    },

    /* 29 out_F      */
    { .default_steps = {0x16c4},},

    /* 2a hlt        */
    { .default_steps = {0x37c7},},

    /* 2b and_A_B    */
    { .default_steps = {0x1086},},

    /* 2c and_B_A    */
    { .default_steps = {0x1186},},

    /* 2d or_A_B     */
    { .default_steps = {0x1096},},

    /* 2e or_B_A     */
    { .default_steps = {0x1196},},
};
