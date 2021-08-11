#include "microcode.h"

const cword_t op_fetch[] = {0x12cd, 0x14eb};

const struct op_microcode microcode[] PROGMEM = {

    /* 00 nop        */
    { .default_steps = {0x17cf},},

    /* 01 ldi_A_imm  */
    { .default_steps = {0x12cd, 0x10eb},},

    /* 02 ldi_B_imm  */
    { .default_steps = {0x12cd, 0x11eb},},

    /* 03 ldi_F_imm  */
    { .default_steps = {0x12cd, 0x17e3},},

    /* 04 add_A_A    */
    { .default_steps = {0x108a},},

    /* 05 add_A_B    */
    { .default_steps = {0x108a},},

    /* 06 add_B_A    */
    { .default_steps = {0x118a},},

    /* 07 add_B_B    */
    { .default_steps = {0x118a},},

    /* 08 adc_A_A    */
    { .default_steps = {0x108a},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x188a},
          },
      },
    },

    /* 09 adc_A_B    */
    { .default_steps = {0x108a},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x188a},
          },
      },
    },

    /* 0a adc_B_A    */
    { .default_steps = {0x118a},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x198a},
          },
      },
    },

    /* 0b adc_B_B    */
    { .default_steps = {0x118a},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x198a},
          },
      },
    },

    /* 0c sub_A_B    */
    { .default_steps = {0x109a},},

    /* 0d sub_B_A    */
    { .default_steps = {0x119a},},

    /* 0e sbb_A_B    */
    { .default_steps = {0x109a},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x189a},
          },
      },
    },

    /* 0f sbb_B_A    */
    { .default_steps = {0x119a},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x199a},
          },
      },
    },

    /* 10 cmp_A_B    */
    { .default_steps = {0x179a},},

    /* 11 cmp_B_A    */
    { .default_steps = {0x179a},},

    /* 12 mov_A_B    */
    { .default_steps = {0x10c9},},

    /* 13 mov_B_A    */
    { .default_steps = {0x11c8},},

    /* 14 out_A      */
    { .default_steps = {0x16c8},},

    /* 15 out_B      */
    { .default_steps = {0x16c9},},

    /* 16 st_addr_A  */
    { .default_steps = {0x12cd, 0x12eb, 0x13c8},},

    /* 17 st_addr_B  */
    { .default_steps = {0x12cd, 0x12eb, 0x13c9},},

    /* 18 stabs_A_A  */
    { .default_steps = {0x12c8, 0x13c8},},

    /* 19 stabs_A_B  */
    { .default_steps = {0x12c8, 0x13c9},},

    /* 1a stabs_B_A  */
    { .default_steps = {0x12c9, 0x13c8},},

    /* 1b stabs_B_B  */
    { .default_steps = {0x12c9, 0x13c9},},

    /* 1c ld_A_addr  */
    { .default_steps = {0x12cd, 0x12eb, 0x108b},},

    /* 1d ld_B_addr  */
    { .default_steps = {0x12cd, 0x12eb, 0x118b},},

    /* 1e ldabs_A_A  */
    { .default_steps = {0x12c8, 0x108b},},

    /* 1f ldabs_A_B  */
    { .default_steps = {0x12c9, 0x108b},},

    /* 20 ldabs_B_A  */
    { .default_steps = {0x12c8, 0x118b},},

    /* 21 ldabs_B_B  */
    { .default_steps = {0x12c9, 0x118b},},

    /* 22 tstabs_A   */
    { .default_steps = {0x12c8, 0x178b},},

    /* 23 tstabs_B   */
    { .default_steps = {0x12c9, 0x178b},},

    /* 24 jmp_addr   */
    { .default_steps = {0x12cd, 0x15cb},},

    /* 25 beq_addr   */
    { .default_steps = {0x17ef},
      .f_alt = {
          /* mask: --Z- value: --Z- */
          { .mask = 0x02, .value = 0x02,
            .steps = {0x12cd, 0x15cb},
          },
      },
    },

    /* 26 bne_addr   */
    { .default_steps = {0x17ef},
      .f_alt = {
          /* mask: --Z- value: ---- */
          { .mask = 0x02, .value = 0x00,
            .steps = {0x12cd, 0x15cb},
          },
      },
    },

    /* 27 bcs_addr   */
    { .default_steps = {0x17ef},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x12cd, 0x15cb},
          },
      },
    },

    /* 28 bcc_addr   */
    { .default_steps = {0x17ef},
      .f_alt = {
          /* mask: -C-- value: ---- */
          { .mask = 0x04, .value = 0x00,
            .steps = {0x12cd, 0x15cb},
          },
      },
    },

    /* 29 out_F      */
    { .default_steps = {0x16cc},},

    /* 2a hlt        */
    { .default_steps = {0x37cf},},

    /* 2b and_A_B    */
    { .default_steps = {0x108e},},

    /* 2c and_B_A    */
    { .default_steps = {0x118e},},

    /* 2d or_A_B     */
    { .default_steps = {0x109e},},

    /* 2e or_B_A     */
    { .default_steps = {0x119e},},
};
