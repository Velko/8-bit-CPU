#include "microcode.h"

const cword_t op_fetch[] = {0x94e3};

const struct op_microcode microcode[] PROGMEM = {

    /* 00 nop        */
    { .default_steps = {0x97c7},},

    /* 01 ldi_A_imm  */
    { .default_steps = {0x90e3},},

    /* 02 ldi_B_imm  */
    { .default_steps = {0x91e3},},

    /* 03 ldi_F_imm  */
    { .default_steps = {0x92e3},},

    /* 04 add_A_A    */
    { .default_steps = {0x9082},},

    /* 05 add_A_B    */
    { .default_steps = {0x9082},},

    /* 06 add_B_A    */
    { .default_steps = {0x9182},},

    /* 07 add_B_B    */
    { .default_steps = {0x9182},},

    /* 08 adc_A_A    */
    { .default_steps = {0x9082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x9882},
          },
      },
    },

    /* 09 adc_A_B    */
    { .default_steps = {0x9082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x9882},
          },
      },
    },

    /* 0a adc_B_A    */
    { .default_steps = {0x9182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x9982},
          },
      },
    },

    /* 0b adc_B_B    */
    { .default_steps = {0x9182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x9982},
          },
      },
    },

    /* 0c sub_A_B    */
    { .default_steps = {0x9092},},

    /* 0d sub_B_A    */
    { .default_steps = {0x9192},},

    /* 0e sbb_A_B    */
    { .default_steps = {0x9092},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x9892},
          },
      },
    },

    /* 0f sbb_B_A    */
    { .default_steps = {0x9192},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x9992},
          },
      },
    },

    /* 10 cmp_A_B    */
    { .default_steps = {0x9792},},

    /* 11 cmp_B_A    */
    { .default_steps = {0x9792},},

    /* 12 mov_A_B    */
    { .default_steps = {0x90c1},},

    /* 13 mov_B_A    */
    { .default_steps = {0x91c0},},

    /* 14 out_A      */
    { .default_steps = {0x96c0},},

    /* 15 out_B      */
    { .default_steps = {0x96c1},},

    /* 16 st_addr_A  */
    { .default_steps = {0x95e3, 0x93c8},},

    /* 17 st_addr_B  */
    { .default_steps = {0x95e3, 0x93c9},},

    /* 18 stabs_A_A  */
    { .default_steps = {0x95c0, 0x93c8},},

    /* 19 stabs_A_B  */
    { .default_steps = {0x95c0, 0x93c9},},

    /* 1a stabs_B_A  */
    { .default_steps = {0x95c1, 0x93c8},},

    /* 1b stabs_B_B  */
    { .default_steps = {0x95c1, 0x93c9},},

    /* 1c ld_A_addr  */
    { .default_steps = {0x95e3, 0x908b},},

    /* 1d ld_B_addr  */
    { .default_steps = {0x95e3, 0x918b},},

    /* 1e ldabs_A_A  */
    { .default_steps = {0x95c0, 0x908b},},

    /* 1f ldabs_A_B  */
    { .default_steps = {0x95c1, 0x908b},},

    /* 20 ldabs_B_A  */
    { .default_steps = {0x95c0, 0x918b},},

    /* 21 ldabs_B_B  */
    { .default_steps = {0x95c1, 0x918b},},

    /* 22 tstabs_A   */
    { .default_steps = {0x95c0, 0x978b},},

    /* 23 tstabs_B   */
    { .default_steps = {0x95c1, 0x978b},},

    /* 24 jmp_addr   */
    { .default_steps = {0x95e3, 0x17cf},},

    /* 25 beq_addr   */
    { .default_steps = {0x97e7},
      .f_alt = {
          /* mask: --Z- value: --Z- */
          { .mask = 0x02, .value = 0x02,
            .steps = {0x95e3, 0x17cf},
          },
      },
    },

    /* 26 bne_addr   */
    { .default_steps = {0x97e7},
      .f_alt = {
          /* mask: --Z- value: ---- */
          { .mask = 0x02, .value = 0x00,
            .steps = {0x95e3, 0x17cf},
          },
      },
    },

    /* 27 bcs_addr   */
    { .default_steps = {0x97e7},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x95e3, 0x17cf},
          },
      },
    },

    /* 28 bcc_addr   */
    { .default_steps = {0x97e7},
      .f_alt = {
          /* mask: -C-- value: ---- */
          { .mask = 0x04, .value = 0x00,
            .steps = {0x95e3, 0x17cf},
          },
      },
    },

    /* 29 out_F      */
    { .default_steps = {0x96c4},},

    /* 2a hlt        */
    { .default_steps = {0xb7c7},},

    /* 2b and_A_B    */
    { .default_steps = {0x9086},},

    /* 2c and_B_A    */
    { .default_steps = {0x9186},},

    /* 2d or_A_B     */
    { .default_steps = {0x9096},},

    /* 2e or_B_A     */
    { .default_steps = {0x9196},},
};
