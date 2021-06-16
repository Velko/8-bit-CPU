#include "microcode.h"

const uint32_t op_fetch[] = {0x3ae034c3};

const struct op_microcode microcode[] PROGMEM = {

    /* 00 nop        */
    { .default_steps = {0x3be03fcf},},

    /* 01 ldi_A_imm  */
    { .default_steps = {0x3ae030c3},},

    /* 02 ldi_B_imm  */
    { .default_steps = {0x3ae031c3},},

    /* 03 ldi_C_imm  */
    { .default_steps = {0x3ae038c3},},

    /* 04 ldi_D_imm  */
    { .default_steps = {0x3ae039c3},},

    /* 05 ldi_F_imm  */
    { .default_steps = {0x3ae037c3},},

    /* 06 lea_SP_addr */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x18603fcf},},

    /* 07 add_A_A    */
    { .default_steps = {0x3bf03082},},

    /* 08 add_A_B    */
    { .default_steps = {0x3bf43082},},

    /* 09 add_A_C    */
    { .default_steps = {0x3bf83082},},

    /* 0a add_A_D    */
    { .default_steps = {0x3bfc3082},},

    /* 0b add_B_A    */
    { .default_steps = {0x3bf13182},},

    /* 0c add_B_B    */
    { .default_steps = {0x3bf53182},},

    /* 0d add_B_C    */
    { .default_steps = {0x3bf93182},},

    /* 0e add_B_D    */
    { .default_steps = {0x3bfd3182},},

    /* 0f add_C_A    */
    { .default_steps = {0x3bf23882},},

    /* 10 add_C_B    */
    { .default_steps = {0x3bf63882},},

    /* 11 add_C_C    */
    { .default_steps = {0x3bfa3882},},

    /* 12 add_C_D    */
    { .default_steps = {0x3bfe3882},},

    /* 13 add_D_A    */
    { .default_steps = {0x3bf33982},},

    /* 14 add_D_B    */
    { .default_steps = {0x3bf73982},},

    /* 15 add_D_C    */
    { .default_steps = {0x3bfb3982},},

    /* 16 add_D_D    */
    { .default_steps = {0x3bff3982},},

    /* 17 adc_A_A    */
    { .default_steps = {0x3bf03082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf07082},
          },
      },
    },

    /* 18 adc_A_B    */
    { .default_steps = {0x3bf43082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf47082},
          },
      },
    },

    /* 19 adc_A_C    */
    { .default_steps = {0x3bf83082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf87082},
          },
      },
    },

    /* 1a adc_A_D    */
    { .default_steps = {0x3bfc3082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bfc7082},
          },
      },
    },

    /* 1b adc_B_A    */
    { .default_steps = {0x3bf13182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf17182},
          },
      },
    },

    /* 1c adc_B_B    */
    { .default_steps = {0x3bf53182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf57182},
          },
      },
    },

    /* 1d adc_B_C    */
    { .default_steps = {0x3bf93182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf97182},
          },
      },
    },

    /* 1e adc_B_D    */
    { .default_steps = {0x3bfd3182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bfd7182},
          },
      },
    },

    /* 1f adc_C_A    */
    { .default_steps = {0x3bf23882},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf27882},
          },
      },
    },

    /* 20 adc_C_B    */
    { .default_steps = {0x3bf63882},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf67882},
          },
      },
    },

    /* 21 adc_C_C    */
    { .default_steps = {0x3bfa3882},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bfa7882},
          },
      },
    },

    /* 22 adc_C_D    */
    { .default_steps = {0x3bfe3882},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bfe7882},
          },
      },
    },

    /* 23 adc_D_A    */
    { .default_steps = {0x3bf33982},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf37982},
          },
      },
    },

    /* 24 adc_D_B    */
    { .default_steps = {0x3bf73982},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf77982},
          },
      },
    },

    /* 25 adc_D_C    */
    { .default_steps = {0x3bfb3982},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bfb7982},
          },
      },
    },

    /* 26 adc_D_D    */
    { .default_steps = {0x3bff3982},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bff7982},
          },
      },
    },

    /* 27 sub_A_B    */
    { .default_steps = {0x3bf43092},},

    /* 28 sub_A_C    */
    { .default_steps = {0x3bf83092},},

    /* 29 sub_A_D    */
    { .default_steps = {0x3bfc3092},},

    /* 2a sub_B_A    */
    { .default_steps = {0x3bf13192},},

    /* 2b sub_B_C    */
    { .default_steps = {0x3bf93192},},

    /* 2c sub_B_D    */
    { .default_steps = {0x3bfd3192},},

    /* 2d sub_C_A    */
    { .default_steps = {0x3bf23892},},

    /* 2e sub_C_B    */
    { .default_steps = {0x3bf63892},},

    /* 2f sub_C_D    */
    { .default_steps = {0x3bfe3892},},

    /* 30 sub_D_A    */
    { .default_steps = {0x3bf33992},},

    /* 31 sub_D_B    */
    { .default_steps = {0x3bf73992},},

    /* 32 sub_D_C    */
    { .default_steps = {0x3bfb3992},},

    /* 33 sbb_A_B    */
    { .default_steps = {0x3bf43092},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf47092},
          },
      },
    },

    /* 34 sbb_A_C    */
    { .default_steps = {0x3bf83092},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf87092},
          },
      },
    },

    /* 35 sbb_A_D    */
    { .default_steps = {0x3bfc3092},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bfc7092},
          },
      },
    },

    /* 36 sbb_B_A    */
    { .default_steps = {0x3bf13192},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf17192},
          },
      },
    },

    /* 37 sbb_B_C    */
    { .default_steps = {0x3bf93192},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf97192},
          },
      },
    },

    /* 38 sbb_B_D    */
    { .default_steps = {0x3bfd3192},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bfd7192},
          },
      },
    },

    /* 39 sbb_C_A    */
    { .default_steps = {0x3bf23892},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf27892},
          },
      },
    },

    /* 3a sbb_C_B    */
    { .default_steps = {0x3bf63892},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf67892},
          },
      },
    },

    /* 3b sbb_C_D    */
    { .default_steps = {0x3bfe3892},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bfe7892},
          },
      },
    },

    /* 3c sbb_D_A    */
    { .default_steps = {0x3bf33992},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf37992},
          },
      },
    },

    /* 3d sbb_D_B    */
    { .default_steps = {0x3bf73992},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf77992},
          },
      },
    },

    /* 3e sbb_D_C    */
    { .default_steps = {0x3bfb3992},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bfb7992},
          },
      },
    },

    /* 3f and_A_B    */
    { .default_steps = {0x3bf43086},},

    /* 40 and_A_C    */
    { .default_steps = {0x3bf83086},},

    /* 41 and_A_D    */
    { .default_steps = {0x3bfc3086},},

    /* 42 and_B_A    */
    { .default_steps = {0x3bf13186},},

    /* 43 and_B_C    */
    { .default_steps = {0x3bf93186},},

    /* 44 and_B_D    */
    { .default_steps = {0x3bfd3186},},

    /* 45 and_C_A    */
    { .default_steps = {0x3bf23886},},

    /* 46 and_C_B    */
    { .default_steps = {0x3bf63886},},

    /* 47 and_C_D    */
    { .default_steps = {0x3bfe3886},},

    /* 48 and_D_A    */
    { .default_steps = {0x3bf33986},},

    /* 49 and_D_B    */
    { .default_steps = {0x3bf73986},},

    /* 4a and_D_C    */
    { .default_steps = {0x3bfb3986},},

    /* 4b or_A_B     */
    { .default_steps = {0x3bf43096},},

    /* 4c or_A_C     */
    { .default_steps = {0x3bf83096},},

    /* 4d or_A_D     */
    { .default_steps = {0x3bfc3096},},

    /* 4e or_B_A     */
    { .default_steps = {0x3bf13196},},

    /* 4f or_B_C     */
    { .default_steps = {0x3bf93196},},

    /* 50 or_B_D     */
    { .default_steps = {0x3bfd3196},},

    /* 51 or_C_A     */
    { .default_steps = {0x3bf23896},},

    /* 52 or_C_B     */
    { .default_steps = {0x3bf63896},},

    /* 53 or_C_D     */
    { .default_steps = {0x3bfe3896},},

    /* 54 or_D_A     */
    { .default_steps = {0x3bf33996},},

    /* 55 or_D_B     */
    { .default_steps = {0x3bf73996},},

    /* 56 or_D_C     */
    { .default_steps = {0x3bfb3996},},

    /* 57 xor_A_B    */
    { .default_steps = {0x3bf4308a},},

    /* 58 xor_A_C    */
    { .default_steps = {0x3bf8308a},},

    /* 59 xor_A_D    */
    { .default_steps = {0x3bfc308a},},

    /* 5a xor_B_A    */
    { .default_steps = {0x3bf1318a},},

    /* 5b xor_B_C    */
    { .default_steps = {0x3bf9318a},},

    /* 5c xor_B_D    */
    { .default_steps = {0x3bfd318a},},

    /* 5d xor_C_A    */
    { .default_steps = {0x3bf2388a},},

    /* 5e xor_C_B    */
    { .default_steps = {0x3bf6388a},},

    /* 5f xor_C_D    */
    { .default_steps = {0x3bfe388a},},

    /* 60 xor_D_A    */
    { .default_steps = {0x3bf3398a},},

    /* 61 xor_D_B    */
    { .default_steps = {0x3bf7398a},},

    /* 62 xor_D_C    */
    { .default_steps = {0x3bfb398a},},

    /* 63 not_A      */
    { .default_steps = {0x3be0309a},},

    /* 64 not_B      */
    { .default_steps = {0x3be1319a},},

    /* 65 not_C      */
    { .default_steps = {0x3be2389a},},

    /* 66 not_D      */
    { .default_steps = {0x3be3399a},},

    /* 67 clr_A      */
    { .default_steps = {0x3bf0308a},},

    /* 68 clr_B      */
    { .default_steps = {0x3bf5318a},},

    /* 69 clr_C      */
    { .default_steps = {0x3bfa388a},},

    /* 6a clr_D      */
    { .default_steps = {0x3bff398a},},

    /* 6b inc_A      */
    { .default_steps = {0x3be07082},},

    /* 6c inc_B      */
    { .default_steps = {0x3be17182},},

    /* 6d inc_C      */
    { .default_steps = {0x3be27882},},

    /* 6e inc_D      */
    { .default_steps = {0x3be37982},},

    /* 6f dec_A      */
    { .default_steps = {0x3be07092},},

    /* 70 dec_B      */
    { .default_steps = {0x3be17192},},

    /* 71 dec_C      */
    { .default_steps = {0x3be27892},},

    /* 72 dec_D      */
    { .default_steps = {0x3be37992},},

    /* 73 shr_A      */
    { .default_steps = {0x3be03087},},

    /* 74 shr_B      */
    { .default_steps = {0x3be13187},},

    /* 75 shr_C      */
    { .default_steps = {0x3be23887},},

    /* 76 shr_D      */
    { .default_steps = {0x3be33987},},

    /* 77 ror_A      */
    { .default_steps = {0x3be03087},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be07087},
          },
      },
    },

    /* 78 ror_B      */
    { .default_steps = {0x3be13187},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be17187},
          },
      },
    },

    /* 79 ror_C      */
    { .default_steps = {0x3be23887},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be27887},
          },
      },
    },

    /* 7a ror_D      */
    { .default_steps = {0x3be33987},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be37987},
          },
      },
    },

    /* 7b asr_A      */
    { .default_steps = {0x3be03f80, 0x3be03087},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0x3be03f80, 0x3be07087},
          },
      },
    },

    /* 7c asr_B      */
    { .default_steps = {0x3be03f81, 0x3be13187},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0x3be03f81, 0x3be17187},
          },
      },
    },

    /* 7d asr_C      */
    { .default_steps = {0x3be03f88, 0x3be23887},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0x3be03f88, 0x3be27887},
          },
      },
    },

    /* 7e asr_D      */
    { .default_steps = {0x3be03f89, 0x3be33987},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0x3be03f89, 0x3be37987},
          },
      },
    },

    /* 7f swap_A     */
    { .default_steps = {0x3be03097},},

    /* 80 swap_B     */
    { .default_steps = {0x3be13197},},

    /* 81 swap_C     */
    { .default_steps = {0x3be23897},},

    /* 82 swap_D     */
    { .default_steps = {0x3be33997},},

    /* 83 cmp_A_B    */
    { .default_steps = {0x3bf43f92},},

    /* 84 cmp_A_C    */
    { .default_steps = {0x3bf83f92},},

    /* 85 cmp_A_D    */
    { .default_steps = {0x3bfc3f92},},

    /* 86 cmp_B_A    */
    { .default_steps = {0x3bf13f92},},

    /* 87 cmp_B_C    */
    { .default_steps = {0x3bf93f92},},

    /* 88 cmp_B_D    */
    { .default_steps = {0x3bfd3f92},},

    /* 89 cmp_C_A    */
    { .default_steps = {0x3bf23f92},},

    /* 8a cmp_C_B    */
    { .default_steps = {0x3bf63f92},},

    /* 8b cmp_C_D    */
    { .default_steps = {0x3bfe3f92},},

    /* 8c cmp_D_A    */
    { .default_steps = {0x3bf33f92},},

    /* 8d cmp_D_B    */
    { .default_steps = {0x3bf73f92},},

    /* 8e cmp_D_C    */
    { .default_steps = {0x3bfb3f92},},

    /* 8f mov_A_B    */
    { .default_steps = {0x3be030c1},},

    /* 90 mov_A_C    */
    { .default_steps = {0x3be030c8},},

    /* 91 mov_A_D    */
    { .default_steps = {0x3be030c9},},

    /* 92 mov_B_A    */
    { .default_steps = {0x3be031c0},},

    /* 93 mov_B_C    */
    { .default_steps = {0x3be031c8},},

    /* 94 mov_B_D    */
    { .default_steps = {0x3be031c9},},

    /* 95 mov_C_A    */
    { .default_steps = {0x3be038c0},},

    /* 96 mov_C_B    */
    { .default_steps = {0x3be038c1},},

    /* 97 mov_C_D    */
    { .default_steps = {0x3be038c9},},

    /* 98 mov_D_A    */
    { .default_steps = {0x3be039c0},},

    /* 99 mov_D_B    */
    { .default_steps = {0x3be039c1},},

    /* 9a mov_D_C    */
    { .default_steps = {0x3be039c8},},

    /* 9b out_A      */
    { .default_steps = {0x3be036c0},},

    /* 9c out_B      */
    { .default_steps = {0x3be036c1},},

    /* 9d out_C      */
    { .default_steps = {0x3be036c8},},

    /* 9e out_D      */
    { .default_steps = {0x3be036c9},},

    /* 9f cout_A     */
    { .default_steps = {0x3be03ac0},},

    /* a0 cout_B     */
    { .default_steps = {0x3be03ac1},},

    /* a1 cout_C     */
    { .default_steps = {0x3be03ac8},},

    /* a2 cout_D     */
    { .default_steps = {0x3be03ac9},},

    /* a3 st_addr_A  */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x386033c0},},

    /* a4 st_addr_B  */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x386033c1},},

    /* a5 st_addr_C  */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x386033c8},},

    /* a6 st_addr_D  */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x386033c9},},

    /* a7 stx_addr_A_A */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc0, 0x386033c0},},

    /* a8 stx_addr_A_B */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc0, 0x386033c1},},

    /* a9 stx_addr_A_C */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc0, 0x386033c8},},

    /* aa stx_addr_A_D */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc0, 0x386033c9},},

    /* ab stx_addr_B_A */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc1, 0x386033c0},},

    /* ac stx_addr_B_B */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc1, 0x386033c1},},

    /* ad stx_addr_B_C */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc1, 0x386033c8},},

    /* ae stx_addr_B_D */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc1, 0x386033c9},},

    /* af stx_addr_C_A */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc8, 0x386033c0},},

    /* b0 stx_addr_C_B */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc8, 0x386033c1},},

    /* b1 stx_addr_C_C */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc8, 0x386033c8},},

    /* b2 stx_addr_C_D */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc8, 0x386033c9},},

    /* b3 stx_addr_D_A */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc9, 0x386033c0},},

    /* b4 stx_addr_D_B */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc9, 0x386033c1},},

    /* b5 stx_addr_D_C */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc9, 0x386033c8},},

    /* b6 stx_addr_D_D */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc9, 0x386033c9},},

    /* b7 ld_A_addr  */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x38603083},},

    /* b8 ld_B_addr  */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x38603183},},

    /* b9 ld_C_addr  */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x38603883},},

    /* ba ld_D_addr  */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x38603983},},

    /* bb ldx_A_addr_A */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc0, 0x38603083},},

    /* bc ldx_A_addr_B */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc1, 0x38603083},},

    /* bd ldx_A_addr_C */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc8, 0x38603083},},

    /* be ldx_A_addr_D */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc9, 0x38603083},},

    /* bf ldx_B_addr_A */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc0, 0x38603183},},

    /* c0 ldx_B_addr_B */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc1, 0x38603183},},

    /* c1 ldx_B_addr_C */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc8, 0x38603183},},

    /* c2 ldx_B_addr_D */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc9, 0x38603183},},

    /* c3 ldx_C_addr_A */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc0, 0x38603883},},

    /* c4 ldx_C_addr_B */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc1, 0x38603883},},

    /* c5 ldx_C_addr_C */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc8, 0x38603883},},

    /* c6 ldx_C_addr_D */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc9, 0x38603883},},

    /* c7 ldx_D_addr_A */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc0, 0x38603983},},

    /* c8 ldx_D_addr_B */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc1, 0x38603983},},

    /* c9 ldx_D_addr_C */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc8, 0x38603983},},

    /* ca ldx_D_addr_D */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc9, 0x38603983},},

    /* cb tstx_addr_A */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc0, 0x38603f83},},

    /* cc tstx_addr_B */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc1, 0x38603f83},},

    /* cd tstx_addr_C */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc8, 0x38603f83},},

    /* ce tstx_addr_D */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x7be03fc9, 0x38603f83},},

    /* cf jmp_addr   */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x28603fcf},},

    /* d0 beq_addr   */
    { .default_steps = {0x3ae03fcf, 0x3ae03fcf},
      .f_alt = {
          /* mask: --Z- value: --Z- */
          { .mask = 0x02, .value = 0x02,
            .steps = {0x3ae03bc3, 0x3ae035c3, 0x28603fcf},
          },
      },
    },

    /* d1 bne_addr   */
    { .default_steps = {0x3ae03fcf, 0x3ae03fcf},
      .f_alt = {
          /* mask: --Z- value: ---- */
          { .mask = 0x02, .value = 0x00,
            .steps = {0x3ae03bc3, 0x3ae035c3, 0x28603fcf},
          },
      },
    },

    /* d2 bcs_addr   */
    { .default_steps = {0x3ae03fcf, 0x3ae03fcf},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3ae03bc3, 0x3ae035c3, 0x28603fcf},
          },
      },
    },

    /* d3 bcc_addr   */
    { .default_steps = {0x3ae03fcf, 0x3ae03fcf},
      .f_alt = {
          /* mask: -C-- value: ---- */
          { .mask = 0x04, .value = 0x00,
            .steps = {0x3ae03bc3, 0x3ae035c3, 0x28603fcf},
          },
      },
    },

    /* d4 bmi_addr   */
    { .default_steps = {0x3ae03fcf, 0x3ae03fcf},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0x3ae03bc3, 0x3ae035c3, 0x28603fcf},
          },
      },
    },

    /* d5 bpl_addr   */
    { .default_steps = {0x3ae03fcf, 0x3ae03fcf},
      .f_alt = {
          /* mask: ---N value: ---- */
          { .mask = 0x01, .value = 0x00,
            .steps = {0x3ae03bc3, 0x3ae035c3, 0x28603fcf},
          },
      },
    },

    /* d6 push_A     */
    { .default_steps = {0x3ba03fcf, 0x39e033c0},},

    /* d7 push_B     */
    { .default_steps = {0x3ba03fcf, 0x39e033c1},},

    /* d8 push_C     */
    { .default_steps = {0x3ba03fcf, 0x39e033c8},},

    /* d9 push_D     */
    { .default_steps = {0x3ba03fcf, 0x39e033c9},},

    /* da pushf      */
    { .default_steps = {0x3ba03fcf, 0x39e033c4},},

    /* db push_LR    */
    { .default_steps = {0x2203fcf, 0x39e033c5, 0x3ba03fcf, 0x39e033cb},},

    /* dc pop_A      */
    { .default_steps = {0x39e030c3, 0x3bc03fcf},},

    /* dd pop_B      */
    { .default_steps = {0x39e031c3, 0x3bc03fcf},},

    /* de pop_C      */
    { .default_steps = {0x39e038c3, 0x3bc03fcf},},

    /* df pop_D      */
    { .default_steps = {0x39e039c3, 0x3bc03fcf},},

    /* e0 popf       */
    { .default_steps = {0x39e037c3, 0x3bc03fcf},},

    /* e1 pop_LR     */
    { .default_steps = {0x39e03bc3, 0x3bc03fcf, 0x39e035c3, 0x20403fcf},},

    /* e2 call_addr  */
    { .default_steps = {0x3ae03bc3, 0x3ae035c3, 0x22e03fcf, 0x28603fcf},},

    /* e3 ret        */
    { .default_steps = {0x2a603fcf},},

    /* e4 brk        */
    { .default_steps = {0x3fe03fcf},},

    /* e5 hlt        */
    { .default_steps = {0x3be01fcf},},
};
