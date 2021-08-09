#include "microcode.h"

const cword_t op_fetch[] = {0x32c5, 0x34e3};

const struct op_microcode microcode[] PROGMEM = {

    /* 00 nop        */
    { .default_steps = {0x37c7},},

    /* 01 ldi_A_imm  */
    { .default_steps = {0x32c5, 0x30e3},},

    /* 02 ldi_B_imm  */
    { .default_steps = {0x32c5, 0x31e3},},

    /* 03 ldi_F_imm  */
    { .default_steps = {0x32c5, 0x37ab},},

    /* 04 add_A_A    */
    { .default_steps = {0x3082},},

    /* 05 add_A_B    */
    { .default_steps = {0x3082},},

    /* 06 add_B_A    */
    { .default_steps = {0x3182},},

    /* 07 add_B_B    */
    { .default_steps = {0x3182},},

    /* 08 adc_A_A    */
    { .default_steps = {0x3082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3882},
          },
      },
    },

    /* 09 adc_A_B    */
    { .default_steps = {0x3082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3882},
          },
      },
    },

    /* 0a adc_B_A    */
    { .default_steps = {0x3182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3982},
          },
      },
    },

    /* 0b adc_B_B    */
    { .default_steps = {0x3182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3982},
          },
      },
    },

    /* 0c sub_A_B    */
    { .default_steps = {0x3092},},

    /* 0d sub_B_A    */
    { .default_steps = {0x3192},},

    /* 0e sbb_A_B    */
    { .default_steps = {0x3892},},

    /* 0f sbb_B_A    */
    { .default_steps = {0x3992},},

    /* 10 cmp_A_B    */
    { .default_steps = {0x3792},},

    /* 11 cmp_B_A    */
    { .default_steps = {0x3792},},

    /* 12 mov_A_B    */
    { .default_steps = {0x30c1},},

    /* 13 mov_B_A    */
    { .default_steps = {0x31c0},},

    /* 14 out_A      */
    { .default_steps = {0x36c0},},

    /* 15 out_B      */
    { .default_steps = {0x36c1},},

    /* 16 st_addr_A  */
    { .default_steps = {0x32c5, 0x32e3, 0x33c0},},

    /* 17 st_addr_B  */
    { .default_steps = {0x32c5, 0x32e3, 0x33c1},},

    /* 18 stabs_A_A  */
    { .default_steps = {0x32c0, 0x33c0},},

    /* 19 stabs_A_B  */
    { .default_steps = {0x32c0, 0x33c1},},

    /* 1a stabs_B_A  */
    { .default_steps = {0x32c1, 0x33c0},},

    /* 1b stabs_B_B  */
    { .default_steps = {0x32c1, 0x33c1},},

    /* 1c ld_A_addr  */
    { .default_steps = {0x32c5, 0x32e3, 0x3083},},

    /* 1d ld_B_addr  */
    { .default_steps = {0x32c5, 0x32e3, 0x3183},},

    /* 1e ldabs_A_A  */
    { .default_steps = {0x32c0, 0x3083},},

    /* 1f ldabs_A_B  */
    { .default_steps = {0x32c1, 0x3083},},

    /* 20 ldabs_B_A  */
    { .default_steps = {0x32c0, 0x3183},},

    /* 21 ldabs_B_B  */
    { .default_steps = {0x32c1, 0x3183},},

    /* 22 tstabs_A   */
    { .default_steps = {0x32c0, 0x3783},},

    /* 23 tstabs_B   */
    { .default_steps = {0x32c1, 0x3783},},

    /* 24 jmp_addr   */
    { .default_steps = {0x32c5, 0x35c3},},

    /* 25 beq_addr   */
    { .default_steps = {0x37e7},
      .f_alt = {
          /* mask: --Z- value: --Z- */
          { .mask = 0x02, .value = 0x02,
            .steps = {0x32c5, 0x35c3},
          },
      },
    },

    /* 26 bne_addr   */
    { .default_steps = {0x37e7},
      .f_alt = {
          /* mask: --Z- value: ---- */
          { .mask = 0x02, .value = 0x00,
            .steps = {0x32c5, 0x35c3},
          },
      },
    },

    /* 27 bcs_addr   */
    { .default_steps = {0x37e7},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x32c5, 0x35c3},
          },
      },
    },

    /* 28 bcc_addr   */
    { .default_steps = {0x37e7},
      .f_alt = {
          /* mask: -C-- value: ---- */
          { .mask = 0x04, .value = 0x00,
            .steps = {0x32c5, 0x35c3},
          },
      },
    },

    /* 29 out_F      */
    { .default_steps = {0x36c4},},

    /* 2a hlt        */
    { .default_steps = {0x17c7},},
};
