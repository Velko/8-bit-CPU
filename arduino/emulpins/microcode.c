#include "microcode.h"

const uint32_t op_fetch[] = {0xe032c5, 0xe034e3};

const struct op_microcode microcode[] PROGMEM = {

    /* 00 nop        */
    { .default_steps = {0xe03fcf},},

    /* 01 ldi_A_imm  */
    { .default_steps = {0xe032c5, 0xe030e3},},

    /* 02 ldi_B_imm  */
    { .default_steps = {0xe032c5, 0xe031e3},},

    /* 03 ldi_C_imm  */
    { .default_steps = {0xe032c5, 0xe038e3},},

    /* 04 ldi_D_imm  */
    { .default_steps = {0xe032c5, 0xe039e3},},

    /* 05 ldi_F_imm  */
    { .default_steps = {0xe032c5, 0xe037e3},},

    /* 06 lea_SP_addr */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x603be3},},

    /* 07 add_A_A    */
    { .default_steps = {0xf03082},},

    /* 08 add_A_B    */
    { .default_steps = {0xf43082},},

    /* 09 add_A_C    */
    { .default_steps = {0xf83082},},

    /* 0a add_A_D    */
    { .default_steps = {0xfc3082},},

    /* 0b add_B_A    */
    { .default_steps = {0xf13182},},

    /* 0c add_B_B    */
    { .default_steps = {0xf53182},},

    /* 0d add_B_C    */
    { .default_steps = {0xf93182},},

    /* 0e add_B_D    */
    { .default_steps = {0xfd3182},},

    /* 0f add_C_A    */
    { .default_steps = {0xf23882},},

    /* 10 add_C_B    */
    { .default_steps = {0xf63882},},

    /* 11 add_C_C    */
    { .default_steps = {0xfa3882},},

    /* 12 add_C_D    */
    { .default_steps = {0xfe3882},},

    /* 13 add_D_A    */
    { .default_steps = {0xf33982},},

    /* 14 add_D_B    */
    { .default_steps = {0xf73982},},

    /* 15 add_D_C    */
    { .default_steps = {0xfb3982},},

    /* 16 add_D_D    */
    { .default_steps = {0xff3982},},

    /* 17 adc_A_A    */
    { .default_steps = {0xf03082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf07082},
          },
      },
    },

    /* 18 adc_A_B    */
    { .default_steps = {0xf43082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf47082},
          },
      },
    },

    /* 19 adc_A_C    */
    { .default_steps = {0xf83082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf87082},
          },
      },
    },

    /* 1a adc_A_D    */
    { .default_steps = {0xfc3082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xfc7082},
          },
      },
    },

    /* 1b adc_B_A    */
    { .default_steps = {0xf13182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf17182},
          },
      },
    },

    /* 1c adc_B_B    */
    { .default_steps = {0xf53182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf57182},
          },
      },
    },

    /* 1d adc_B_C    */
    { .default_steps = {0xf93182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf97182},
          },
      },
    },

    /* 1e adc_B_D    */
    { .default_steps = {0xfd3182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xfd7182},
          },
      },
    },

    /* 1f adc_C_A    */
    { .default_steps = {0xf23882},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf27882},
          },
      },
    },

    /* 20 adc_C_B    */
    { .default_steps = {0xf63882},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf67882},
          },
      },
    },

    /* 21 adc_C_C    */
    { .default_steps = {0xfa3882},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xfa7882},
          },
      },
    },

    /* 22 adc_C_D    */
    { .default_steps = {0xfe3882},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xfe7882},
          },
      },
    },

    /* 23 adc_D_A    */
    { .default_steps = {0xf33982},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf37982},
          },
      },
    },

    /* 24 adc_D_B    */
    { .default_steps = {0xf73982},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf77982},
          },
      },
    },

    /* 25 adc_D_C    */
    { .default_steps = {0xfb3982},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xfb7982},
          },
      },
    },

    /* 26 adc_D_D    */
    { .default_steps = {0xff3982},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xff7982},
          },
      },
    },

    /* 27 sub_A_B    */
    { .default_steps = {0xf43092},},

    /* 28 sub_A_C    */
    { .default_steps = {0xf83092},},

    /* 29 sub_A_D    */
    { .default_steps = {0xfc3092},},

    /* 2a sub_B_A    */
    { .default_steps = {0xf13192},},

    /* 2b sub_B_C    */
    { .default_steps = {0xf93192},},

    /* 2c sub_B_D    */
    { .default_steps = {0xfd3192},},

    /* 2d sub_C_A    */
    { .default_steps = {0xf23892},},

    /* 2e sub_C_B    */
    { .default_steps = {0xf63892},},

    /* 2f sub_C_D    */
    { .default_steps = {0xfe3892},},

    /* 30 sub_D_A    */
    { .default_steps = {0xf33992},},

    /* 31 sub_D_B    */
    { .default_steps = {0xf73992},},

    /* 32 sub_D_C    */
    { .default_steps = {0xfb3992},},

    /* 33 sbb_A_B    */
    { .default_steps = {0xf43092},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf47092},
          },
      },
    },

    /* 34 sbb_A_C    */
    { .default_steps = {0xf83092},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf87092},
          },
      },
    },

    /* 35 sbb_A_D    */
    { .default_steps = {0xfc3092},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xfc7092},
          },
      },
    },

    /* 36 sbb_B_A    */
    { .default_steps = {0xf13192},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf17192},
          },
      },
    },

    /* 37 sbb_B_C    */
    { .default_steps = {0xf93192},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf97192},
          },
      },
    },

    /* 38 sbb_B_D    */
    { .default_steps = {0xfd3192},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xfd7192},
          },
      },
    },

    /* 39 sbb_C_A    */
    { .default_steps = {0xf23892},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf27892},
          },
      },
    },

    /* 3a sbb_C_B    */
    { .default_steps = {0xf63892},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf67892},
          },
      },
    },

    /* 3b sbb_C_D    */
    { .default_steps = {0xfe3892},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xfe7892},
          },
      },
    },

    /* 3c sbb_D_A    */
    { .default_steps = {0xf33992},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf37992},
          },
      },
    },

    /* 3d sbb_D_B    */
    { .default_steps = {0xf73992},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xf77992},
          },
      },
    },

    /* 3e sbb_D_C    */
    { .default_steps = {0xfb3992},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xfb7992},
          },
      },
    },

    /* 3f and_A_B    */
    { .default_steps = {0xf43086},},

    /* 40 and_A_C    */
    { .default_steps = {0xf83086},},

    /* 41 and_A_D    */
    { .default_steps = {0xfc3086},},

    /* 42 and_B_A    */
    { .default_steps = {0xf13186},},

    /* 43 and_B_C    */
    { .default_steps = {0xf93186},},

    /* 44 and_B_D    */
    { .default_steps = {0xfd3186},},

    /* 45 and_C_A    */
    { .default_steps = {0xf23886},},

    /* 46 and_C_B    */
    { .default_steps = {0xf63886},},

    /* 47 and_C_D    */
    { .default_steps = {0xfe3886},},

    /* 48 and_D_A    */
    { .default_steps = {0xf33986},},

    /* 49 and_D_B    */
    { .default_steps = {0xf73986},},

    /* 4a and_D_C    */
    { .default_steps = {0xfb3986},},

    /* 4b or_A_B     */
    { .default_steps = {0xf43096},},

    /* 4c or_A_C     */
    { .default_steps = {0xf83096},},

    /* 4d or_A_D     */
    { .default_steps = {0xfc3096},},

    /* 4e or_B_A     */
    { .default_steps = {0xf13196},},

    /* 4f or_B_C     */
    { .default_steps = {0xf93196},},

    /* 50 or_B_D     */
    { .default_steps = {0xfd3196},},

    /* 51 or_C_A     */
    { .default_steps = {0xf23896},},

    /* 52 or_C_B     */
    { .default_steps = {0xf63896},},

    /* 53 or_C_D     */
    { .default_steps = {0xfe3896},},

    /* 54 or_D_A     */
    { .default_steps = {0xf33996},},

    /* 55 or_D_B     */
    { .default_steps = {0xf73996},},

    /* 56 or_D_C     */
    { .default_steps = {0xfb3996},},

    /* 57 xor_A_B    */
    { .default_steps = {0xf4308a},},

    /* 58 xor_A_C    */
    { .default_steps = {0xf8308a},},

    /* 59 xor_A_D    */
    { .default_steps = {0xfc308a},},

    /* 5a xor_B_A    */
    { .default_steps = {0xf1318a},},

    /* 5b xor_B_C    */
    { .default_steps = {0xf9318a},},

    /* 5c xor_B_D    */
    { .default_steps = {0xfd318a},},

    /* 5d xor_C_A    */
    { .default_steps = {0xf2388a},},

    /* 5e xor_C_B    */
    { .default_steps = {0xf6388a},},

    /* 5f xor_C_D    */
    { .default_steps = {0xfe388a},},

    /* 60 xor_D_A    */
    { .default_steps = {0xf3398a},},

    /* 61 xor_D_B    */
    { .default_steps = {0xf7398a},},

    /* 62 xor_D_C    */
    { .default_steps = {0xfb398a},},

    /* 63 not_A      */
    { .default_steps = {0xe0309a},},

    /* 64 not_B      */
    { .default_steps = {0xe1319a},},

    /* 65 not_C      */
    { .default_steps = {0xe2389a},},

    /* 66 not_D      */
    { .default_steps = {0xe3399a},},

    /* 67 clr_A      */
    { .default_steps = {0xf0308a},},

    /* 68 clr_B      */
    { .default_steps = {0xf5318a},},

    /* 69 clr_C      */
    { .default_steps = {0xfa388a},},

    /* 6a clr_D      */
    { .default_steps = {0xff398a},},

    /* 6b inc_A      */
    { .default_steps = {0xe07082},},

    /* 6c inc_B      */
    { .default_steps = {0xe17182},},

    /* 6d inc_C      */
    { .default_steps = {0xe27882},},

    /* 6e inc_D      */
    { .default_steps = {0xe37982},},

    /* 6f dec_A      */
    { .default_steps = {0xe07092},},

    /* 70 dec_B      */
    { .default_steps = {0xe17192},},

    /* 71 dec_C      */
    { .default_steps = {0xe27892},},

    /* 72 dec_D      */
    { .default_steps = {0xe37992},},

    /* 73 shr_A      */
    { .default_steps = {0xe03087},},

    /* 74 shr_B      */
    { .default_steps = {0xe13187},},

    /* 75 shr_C      */
    { .default_steps = {0xe23887},},

    /* 76 shr_D      */
    { .default_steps = {0xe33987},},

    /* 77 ror_A      */
    { .default_steps = {0xe03087},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xe07087},
          },
      },
    },

    /* 78 ror_B      */
    { .default_steps = {0xe13187},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xe17187},
          },
      },
    },

    /* 79 ror_C      */
    { .default_steps = {0xe23887},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xe27887},
          },
      },
    },

    /* 7a ror_D      */
    { .default_steps = {0xe33987},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xe37987},
          },
      },
    },

    /* 7b asr_A      */
    { .default_steps = {0xe03f80, 0xe03087},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0xe03f80, 0xe07087},
          },
      },
    },

    /* 7c asr_B      */
    { .default_steps = {0xe03f81, 0xe13187},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0xe03f81, 0xe17187},
          },
      },
    },

    /* 7d asr_C      */
    { .default_steps = {0xe03f88, 0xe23887},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0xe03f88, 0xe27887},
          },
      },
    },

    /* 7e asr_D      */
    { .default_steps = {0xe03f89, 0xe33987},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0xe03f89, 0xe37987},
          },
      },
    },

    /* 7f swap_A     */
    { .default_steps = {0xe03097},},

    /* 80 swap_B     */
    { .default_steps = {0xe13197},},

    /* 81 swap_C     */
    { .default_steps = {0xe23897},},

    /* 82 swap_D     */
    { .default_steps = {0xe33997},},

    /* 83 cmp_A_B    */
    { .default_steps = {0xf43f92},},

    /* 84 cmp_A_C    */
    { .default_steps = {0xf83f92},},

    /* 85 cmp_A_D    */
    { .default_steps = {0xfc3f92},},

    /* 86 cmp_B_A    */
    { .default_steps = {0xf13f92},},

    /* 87 cmp_B_C    */
    { .default_steps = {0xf93f92},},

    /* 88 cmp_B_D    */
    { .default_steps = {0xfd3f92},},

    /* 89 cmp_C_A    */
    { .default_steps = {0xf23f92},},

    /* 8a cmp_C_B    */
    { .default_steps = {0xf63f92},},

    /* 8b cmp_C_D    */
    { .default_steps = {0xfe3f92},},

    /* 8c cmp_D_A    */
    { .default_steps = {0xf33f92},},

    /* 8d cmp_D_B    */
    { .default_steps = {0xf73f92},},

    /* 8e cmp_D_C    */
    { .default_steps = {0xfb3f92},},

    /* 8f mov_A_B    */
    { .default_steps = {0xe030c1},},

    /* 90 mov_A_C    */
    { .default_steps = {0xe030c8},},

    /* 91 mov_A_D    */
    { .default_steps = {0xe030c9},},

    /* 92 mov_B_A    */
    { .default_steps = {0xe031c0},},

    /* 93 mov_B_C    */
    { .default_steps = {0xe031c8},},

    /* 94 mov_B_D    */
    { .default_steps = {0xe031c9},},

    /* 95 mov_C_A    */
    { .default_steps = {0xe038c0},},

    /* 96 mov_C_B    */
    { .default_steps = {0xe038c1},},

    /* 97 mov_C_D    */
    { .default_steps = {0xe038c9},},

    /* 98 mov_D_A    */
    { .default_steps = {0xe039c0},},

    /* 99 mov_D_B    */
    { .default_steps = {0xe039c1},},

    /* 9a mov_D_C    */
    { .default_steps = {0xe039c8},},

    /* 9b out_A      */
    { .default_steps = {0xe036c0},},

    /* 9c out_B      */
    { .default_steps = {0xe036c1},},

    /* 9d out_C      */
    { .default_steps = {0xe036c8},},

    /* 9e out_D      */
    { .default_steps = {0xe036c9},},

    /* 9f cout_A     */
    { .default_steps = {0xe03ac0},},

    /* a0 cout_B     */
    { .default_steps = {0xe03ac1},},

    /* a1 cout_C     */
    { .default_steps = {0xe03ac8},},

    /* a2 cout_D     */
    { .default_steps = {0xe03ac9},},

    /* a3 st_addr_A  */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0xe033c0},},

    /* a4 st_addr_B  */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0xe033c1},},

    /* a5 st_addr_C  */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0xe033c8},},

    /* a6 st_addr_D  */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0xe033c9},},

    /* a7 stx_addr_A_A */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc0, 0xe033c0},},

    /* a8 stx_addr_A_B */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc0, 0xe033c1},},

    /* a9 stx_addr_A_C */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc0, 0xe033c8},},

    /* aa stx_addr_A_D */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc0, 0xe033c9},},

    /* ab stx_addr_B_A */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc1, 0xe033c0},},

    /* ac stx_addr_B_B */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc1, 0xe033c1},},

    /* ad stx_addr_B_C */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc1, 0xe033c8},},

    /* ae stx_addr_B_D */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc1, 0xe033c9},},

    /* af stx_addr_C_A */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc8, 0xe033c0},},

    /* b0 stx_addr_C_B */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc8, 0xe033c1},},

    /* b1 stx_addr_C_C */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc8, 0xe033c8},},

    /* b2 stx_addr_C_D */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc8, 0xe033c9},},

    /* b3 stx_addr_D_A */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc9, 0xe033c0},},

    /* b4 stx_addr_D_B */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc9, 0xe033c1},},

    /* b5 stx_addr_D_C */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc9, 0xe033c8},},

    /* b6 stx_addr_D_D */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc9, 0xe033c9},},

    /* b7 ld_A_addr  */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0xe03083},},

    /* b8 ld_B_addr  */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0xe03183},},

    /* b9 ld_C_addr  */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0xe03883},},

    /* ba ld_D_addr  */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0xe03983},},

    /* bb ldx_A_addr_A */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc0, 0xe03083},},

    /* bc ldx_A_addr_B */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc1, 0xe03083},},

    /* bd ldx_A_addr_C */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc8, 0xe03083},},

    /* be ldx_A_addr_D */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc9, 0xe03083},},

    /* bf ldx_B_addr_A */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc0, 0xe03183},},

    /* c0 ldx_B_addr_B */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc1, 0xe03183},},

    /* c1 ldx_B_addr_C */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc8, 0xe03183},},

    /* c2 ldx_B_addr_D */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc9, 0xe03183},},

    /* c3 ldx_C_addr_A */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc0, 0xe03883},},

    /* c4 ldx_C_addr_B */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc1, 0xe03883},},

    /* c5 ldx_C_addr_C */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc8, 0xe03883},},

    /* c6 ldx_C_addr_D */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc9, 0xe03883},},

    /* c7 ldx_D_addr_A */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc0, 0xe03983},},

    /* c8 ldx_D_addr_B */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc1, 0xe03983},},

    /* c9 ldx_D_addr_C */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc8, 0xe03983},},

    /* ca ldx_D_addr_D */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc9, 0xe03983},},

    /* cb tstx_addr_A */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc0, 0xe03f83},},

    /* cc tstx_addr_B */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc1, 0xe03f83},},

    /* cd tstx_addr_C */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc8, 0xe03f83},},

    /* ce tstx_addr_D */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6032e3, 0x2e03fc9, 0xe03f83},},

    /* cf jmp_addr   */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6035c3},},

    /* d0 beq_addr   */
    { .default_steps = {0xe03fef, 0xe03fef},
      .f_alt = {
          /* mask: --Z- value: --Z- */
          { .mask = 0x02, .value = 0x02,
            .steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6035c3},
          },
      },
    },

    /* d1 bne_addr   */
    { .default_steps = {0xe03fef, 0xe03fef},
      .f_alt = {
          /* mask: --Z- value: ---- */
          { .mask = 0x02, .value = 0x00,
            .steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6035c3},
          },
      },
    },

    /* d2 bcs_addr   */
    { .default_steps = {0xe03fef, 0xe03fef},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6035c3},
          },
      },
    },

    /* d3 bcc_addr   */
    { .default_steps = {0xe03fef, 0xe03fef},
      .f_alt = {
          /* mask: -C-- value: ---- */
          { .mask = 0x04, .value = 0x00,
            .steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6035c3},
          },
      },
    },

    /* d4 bmi_addr   */
    { .default_steps = {0xe03fef, 0xe03fef},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6035c3},
          },
      },
    },

    /* d5 bpl_addr   */
    { .default_steps = {0xe03fef, 0xe03fef},
      .f_alt = {
          /* mask: ---N value: ---- */
          { .mask = 0x01, .value = 0x00,
            .steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x6035c3},
          },
      },
    },

    /* d6 push_A     */
    { .default_steps = {0xa03fcf, 0xe032cb, 0xe033c0},},

    /* d7 push_B     */
    { .default_steps = {0xa03fcf, 0xe032cb, 0xe033c1},},

    /* d8 push_C     */
    { .default_steps = {0xa03fcf, 0xe032cb, 0xe033c8},},

    /* d9 push_D     */
    { .default_steps = {0xa03fcf, 0xe032cb, 0xe033c9},},

    /* da pushf      */
    { .default_steps = {0xa03fcf, 0xe032cb, 0xe033c4},},

    /* db push_LR    */
    { .default_steps = {0x1a03dcc, 0xe032cb, 0xa033cc, 0xe032cb, 0x16033cf},},

    /* dc pop_A      */
    { .default_steps = {0xe032cb, 0xc030c3},},

    /* dd pop_B      */
    { .default_steps = {0xe032cb, 0xc031c3},},

    /* de pop_C      */
    { .default_steps = {0xe032cb, 0xc038c3},},

    /* df pop_D      */
    { .default_steps = {0xe032cb, 0xc039c3},},

    /* e0 popf       */
    { .default_steps = {0xe032cb, 0xc037c3},},

    /* e1 pop_LR     */
    { .default_steps = {0xe032cb, 0xc03dc3, 0xe032cb, 0x403cc3},},

    /* e2 call_addr  */
    { .default_steps = {0xe032c5, 0xe03de3, 0xe032c5, 0x603ce3, 0xe0bfcf},},

    /* e3 ret        */
    { .default_steps = {0xe0bfcf},},

    /* e4 brk        */
    { .default_steps = {0x4e03fcf},},

    /* e5 hlt        */
    { .default_steps = {0xe01fcf},},
};
