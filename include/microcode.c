#include "microcode.h"

const cword_t op_fetch[] = {0x3af834c3};

const struct op_microcode microcode[] PROGMEM = {

    /* 00 nop        */
    { .default_steps = {0x3bf83fcf},},

    /* 01 ldi_A_imm  */
    { .default_steps = {0x3af830c3},},

    /* 02 ldi_B_imm  */
    { .default_steps = {0x3af831c3},},

    /* 03 ldi_C_imm  */
    { .default_steps = {0x3af838c3},},

    /* 04 ldi_D_imm  */
    { .default_steps = {0x3af839c3},},

    /* 05 ldi_F_imm  */
    { .default_steps = {0x3af837c3},},

    /* 06 lea_SP_addr */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x18783fcf},},

    /* 07 add_A_A    */
    { .default_steps = {0x3be03082},},

    /* 08 add_A_B    */
    { .default_steps = {0x3be43082},},

    /* 09 add_A_C    */
    { .default_steps = {0x3be83082},},

    /* 0a add_A_D    */
    { .default_steps = {0x3bec3082},},

    /* 0b add_B_A    */
    { .default_steps = {0x3be13182},},

    /* 0c add_B_B    */
    { .default_steps = {0x3be53182},},

    /* 0d add_B_C    */
    { .default_steps = {0x3be93182},},

    /* 0e add_B_D    */
    { .default_steps = {0x3bed3182},},

    /* 0f add_C_A    */
    { .default_steps = {0x3be23882},},

    /* 10 add_C_B    */
    { .default_steps = {0x3be63882},},

    /* 11 add_C_C    */
    { .default_steps = {0x3bea3882},},

    /* 12 add_C_D    */
    { .default_steps = {0x3bee3882},},

    /* 13 add_D_A    */
    { .default_steps = {0x3be33982},},

    /* 14 add_D_B    */
    { .default_steps = {0x3be73982},},

    /* 15 add_D_C    */
    { .default_steps = {0x3beb3982},},

    /* 16 add_D_D    */
    { .default_steps = {0x3bef3982},},

    /* 17 adc_A_A    */
    { .default_steps = {0x3be03082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be07082},
          },
      },
    },

    /* 18 adc_A_B    */
    { .default_steps = {0x3be43082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be47082},
          },
      },
    },

    /* 19 adc_A_C    */
    { .default_steps = {0x3be83082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be87082},
          },
      },
    },

    /* 1a adc_A_D    */
    { .default_steps = {0x3bec3082},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bec7082},
          },
      },
    },

    /* 1b adc_B_A    */
    { .default_steps = {0x3be13182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be17182},
          },
      },
    },

    /* 1c adc_B_B    */
    { .default_steps = {0x3be53182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be57182},
          },
      },
    },

    /* 1d adc_B_C    */
    { .default_steps = {0x3be93182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be97182},
          },
      },
    },

    /* 1e adc_B_D    */
    { .default_steps = {0x3bed3182},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bed7182},
          },
      },
    },

    /* 1f adc_C_A    */
    { .default_steps = {0x3be23882},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be27882},
          },
      },
    },

    /* 20 adc_C_B    */
    { .default_steps = {0x3be63882},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be67882},
          },
      },
    },

    /* 21 adc_C_C    */
    { .default_steps = {0x3bea3882},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bea7882},
          },
      },
    },

    /* 22 adc_C_D    */
    { .default_steps = {0x3bee3882},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bee7882},
          },
      },
    },

    /* 23 adc_D_A    */
    { .default_steps = {0x3be33982},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be37982},
          },
      },
    },

    /* 24 adc_D_B    */
    { .default_steps = {0x3be73982},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be77982},
          },
      },
    },

    /* 25 adc_D_C    */
    { .default_steps = {0x3beb3982},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3beb7982},
          },
      },
    },

    /* 26 adc_D_D    */
    { .default_steps = {0x3bef3982},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bef7982},
          },
      },
    },

    /* 27 sub_A_B    */
    { .default_steps = {0x3be43092},},

    /* 28 sub_A_C    */
    { .default_steps = {0x3be83092},},

    /* 29 sub_A_D    */
    { .default_steps = {0x3bec3092},},

    /* 2a sub_B_A    */
    { .default_steps = {0x3be13192},},

    /* 2b sub_B_C    */
    { .default_steps = {0x3be93192},},

    /* 2c sub_B_D    */
    { .default_steps = {0x3bed3192},},

    /* 2d sub_C_A    */
    { .default_steps = {0x3be23892},},

    /* 2e sub_C_B    */
    { .default_steps = {0x3be63892},},

    /* 2f sub_C_D    */
    { .default_steps = {0x3bee3892},},

    /* 30 sub_D_A    */
    { .default_steps = {0x3be33992},},

    /* 31 sub_D_B    */
    { .default_steps = {0x3be73992},},

    /* 32 sub_D_C    */
    { .default_steps = {0x3beb3992},},

    /* 33 sbb_A_B    */
    { .default_steps = {0x3be43092},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be47092},
          },
      },
    },

    /* 34 sbb_A_C    */
    { .default_steps = {0x3be83092},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be87092},
          },
      },
    },

    /* 35 sbb_A_D    */
    { .default_steps = {0x3bec3092},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bec7092},
          },
      },
    },

    /* 36 sbb_B_A    */
    { .default_steps = {0x3be13192},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be17192},
          },
      },
    },

    /* 37 sbb_B_C    */
    { .default_steps = {0x3be93192},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be97192},
          },
      },
    },

    /* 38 sbb_B_D    */
    { .default_steps = {0x3bed3192},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bed7192},
          },
      },
    },

    /* 39 sbb_C_A    */
    { .default_steps = {0x3be23892},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be27892},
          },
      },
    },

    /* 3a sbb_C_B    */
    { .default_steps = {0x3be63892},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be67892},
          },
      },
    },

    /* 3b sbb_C_D    */
    { .default_steps = {0x3bee3892},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bee7892},
          },
      },
    },

    /* 3c sbb_D_A    */
    { .default_steps = {0x3be33992},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be37992},
          },
      },
    },

    /* 3d sbb_D_B    */
    { .default_steps = {0x3be73992},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be77992},
          },
      },
    },

    /* 3e sbb_D_C    */
    { .default_steps = {0x3beb3992},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3beb7992},
          },
      },
    },

    /* 3f and_A_B    */
    { .default_steps = {0x3be43086},},

    /* 40 and_A_C    */
    { .default_steps = {0x3be83086},},

    /* 41 and_A_D    */
    { .default_steps = {0x3bec3086},},

    /* 42 and_B_A    */
    { .default_steps = {0x3be13186},},

    /* 43 and_B_C    */
    { .default_steps = {0x3be93186},},

    /* 44 and_B_D    */
    { .default_steps = {0x3bed3186},},

    /* 45 and_C_A    */
    { .default_steps = {0x3be23886},},

    /* 46 and_C_B    */
    { .default_steps = {0x3be63886},},

    /* 47 and_C_D    */
    { .default_steps = {0x3bee3886},},

    /* 48 and_D_A    */
    { .default_steps = {0x3be33986},},

    /* 49 and_D_B    */
    { .default_steps = {0x3be73986},},

    /* 4a and_D_C    */
    { .default_steps = {0x3beb3986},},

    /* 4b or_A_B     */
    { .default_steps = {0x3be43096},},

    /* 4c or_A_C     */
    { .default_steps = {0x3be83096},},

    /* 4d or_A_D     */
    { .default_steps = {0x3bec3096},},

    /* 4e or_B_A     */
    { .default_steps = {0x3be13196},},

    /* 4f or_B_C     */
    { .default_steps = {0x3be93196},},

    /* 50 or_B_D     */
    { .default_steps = {0x3bed3196},},

    /* 51 or_C_A     */
    { .default_steps = {0x3be23896},},

    /* 52 or_C_B     */
    { .default_steps = {0x3be63896},},

    /* 53 or_C_D     */
    { .default_steps = {0x3bee3896},},

    /* 54 or_D_A     */
    { .default_steps = {0x3be33996},},

    /* 55 or_D_B     */
    { .default_steps = {0x3be73996},},

    /* 56 or_D_C     */
    { .default_steps = {0x3beb3996},},

    /* 57 xor_A_B    */
    { .default_steps = {0x3be4308a},},

    /* 58 xor_A_C    */
    { .default_steps = {0x3be8308a},},

    /* 59 xor_A_D    */
    { .default_steps = {0x3bec308a},},

    /* 5a xor_B_A    */
    { .default_steps = {0x3be1318a},},

    /* 5b xor_B_C    */
    { .default_steps = {0x3be9318a},},

    /* 5c xor_B_D    */
    { .default_steps = {0x3bed318a},},

    /* 5d xor_C_A    */
    { .default_steps = {0x3be2388a},},

    /* 5e xor_C_B    */
    { .default_steps = {0x3be6388a},},

    /* 5f xor_C_D    */
    { .default_steps = {0x3bee388a},},

    /* 60 xor_D_A    */
    { .default_steps = {0x3be3398a},},

    /* 61 xor_D_B    */
    { .default_steps = {0x3be7398a},},

    /* 62 xor_D_C    */
    { .default_steps = {0x3beb398a},},

    /* 63 not_A      */
    { .default_steps = {0x3bf8309a},},

    /* 64 not_B      */
    { .default_steps = {0x3bf9319a},},

    /* 65 not_C      */
    { .default_steps = {0x3bfa389a},},

    /* 66 not_D      */
    { .default_steps = {0x3bfb399a},},

    /* 67 clr_A      */
    { .default_steps = {0x3be0308a},},

    /* 68 clr_B      */
    { .default_steps = {0x3be5318a},},

    /* 69 clr_C      */
    { .default_steps = {0x3bea388a},},

    /* 6a clr_D      */
    { .default_steps = {0x3bef398a},},

    /* 6b inc_A      */
    { .default_steps = {0x3bf87082},},

    /* 6c inc_B      */
    { .default_steps = {0x3bf97182},},

    /* 6d inc_C      */
    { .default_steps = {0x3bfa7882},},

    /* 6e inc_D      */
    { .default_steps = {0x3bfb7982},},

    /* 6f dec_A      */
    { .default_steps = {0x3bf87092},},

    /* 70 dec_B      */
    { .default_steps = {0x3bf97192},},

    /* 71 dec_C      */
    { .default_steps = {0x3bfa7892},},

    /* 72 dec_D      */
    { .default_steps = {0x3bfb7992},},

    /* 73 shr_A      */
    { .default_steps = {0x3bf83087},},

    /* 74 shr_B      */
    { .default_steps = {0x3bf93187},},

    /* 75 shr_C      */
    { .default_steps = {0x3bfa3887},},

    /* 76 shr_D      */
    { .default_steps = {0x3bfb3987},},

    /* 77 ror_A      */
    { .default_steps = {0x3bf83087},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf87087},
          },
      },
    },

    /* 78 ror_B      */
    { .default_steps = {0x3bf93187},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bf97187},
          },
      },
    },

    /* 79 ror_C      */
    { .default_steps = {0x3bfa3887},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bfa7887},
          },
      },
    },

    /* 7a ror_D      */
    { .default_steps = {0x3bfb3987},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bfb7987},
          },
      },
    },

    /* 7b asr_A      */
    { .default_steps = {0x3bf83f80, 0x3bf83087},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0x3bf83f80, 0x3bf87087},
          },
      },
    },

    /* 7c asr_B      */
    { .default_steps = {0x3bf83f81, 0x3bf93187},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0x3bf83f81, 0x3bf97187},
          },
      },
    },

    /* 7d asr_C      */
    { .default_steps = {0x3bf83f88, 0x3bfa3887},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0x3bf83f88, 0x3bfa7887},
          },
      },
    },

    /* 7e asr_D      */
    { .default_steps = {0x3bf83f89, 0x3bfb3987},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0x3bf83f89, 0x3bfb7987},
          },
      },
    },

    /* 7f swap_A     */
    { .default_steps = {0x3bf83097},},

    /* 80 swap_B     */
    { .default_steps = {0x3bf93197},},

    /* 81 swap_C     */
    { .default_steps = {0x3bfa3897},},

    /* 82 swap_D     */
    { .default_steps = {0x3bfb3997},},

    /* 83 cmp_A_B    */
    { .default_steps = {0x3be43f92},},

    /* 84 cmp_A_C    */
    { .default_steps = {0x3be83f92},},

    /* 85 cmp_A_D    */
    { .default_steps = {0x3bec3f92},},

    /* 86 cmp_B_A    */
    { .default_steps = {0x3be13f92},},

    /* 87 cmp_B_C    */
    { .default_steps = {0x3be93f92},},

    /* 88 cmp_B_D    */
    { .default_steps = {0x3bed3f92},},

    /* 89 cmp_C_A    */
    { .default_steps = {0x3be23f92},},

    /* 8a cmp_C_B    */
    { .default_steps = {0x3be63f92},},

    /* 8b cmp_C_D    */
    { .default_steps = {0x3bee3f92},},

    /* 8c cmp_D_A    */
    { .default_steps = {0x3be33f92},},

    /* 8d cmp_D_B    */
    { .default_steps = {0x3be73f92},},

    /* 8e cmp_D_C    */
    { .default_steps = {0x3beb3f92},},

    /* 8f mov_A_B    */
    { .default_steps = {0x3bf830c1},},

    /* 90 mov_A_C    */
    { .default_steps = {0x3bf830c8},},

    /* 91 mov_A_D    */
    { .default_steps = {0x3bf830c9},},

    /* 92 mov_B_A    */
    { .default_steps = {0x3bf831c0},},

    /* 93 mov_B_C    */
    { .default_steps = {0x3bf831c8},},

    /* 94 mov_B_D    */
    { .default_steps = {0x3bf831c9},},

    /* 95 mov_C_A    */
    { .default_steps = {0x3bf838c0},},

    /* 96 mov_C_B    */
    { .default_steps = {0x3bf838c1},},

    /* 97 mov_C_D    */
    { .default_steps = {0x3bf838c9},},

    /* 98 mov_D_A    */
    { .default_steps = {0x3bf839c0},},

    /* 99 mov_D_B    */
    { .default_steps = {0x3bf839c1},},

    /* 9a mov_D_C    */
    { .default_steps = {0x3bf839c8},},

    /* 9b out_A      */
    { .default_steps = {0x3bf836c0},},

    /* 9c out_B      */
    { .default_steps = {0x3bf836c1},},

    /* 9d out_C      */
    { .default_steps = {0x3bf836c8},},

    /* 9e out_D      */
    { .default_steps = {0x3bf836c9},},

    /* 9f cout_A     */
    { .default_steps = {0x3bf83ac0},},

    /* a0 cout_B     */
    { .default_steps = {0x3bf83ac1},},

    /* a1 cout_C     */
    { .default_steps = {0x3bf83ac8},},

    /* a2 cout_D     */
    { .default_steps = {0x3bf83ac9},},

    /* a3 st_addr_A  */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x387833c0},},

    /* a4 st_addr_B  */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x387833c1},},

    /* a5 st_addr_C  */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x387833c8},},

    /* a6 st_addr_D  */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x387833c9},},

    /* a7 stx_addr_A_A */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc0, 0x397833c0},},

    /* a8 stx_addr_A_B */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc0, 0x397833c1},},

    /* a9 stx_addr_A_C */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc0, 0x397833c8},},

    /* aa stx_addr_A_D */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc0, 0x397833c9},},

    /* ab stx_addr_B_A */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc1, 0x397833c0},},

    /* ac stx_addr_B_B */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc1, 0x397833c1},},

    /* ad stx_addr_B_C */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc1, 0x397833c8},},

    /* ae stx_addr_B_D */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc1, 0x397833c9},},

    /* af stx_addr_C_A */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc8, 0x397833c0},},

    /* b0 stx_addr_C_B */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc8, 0x397833c1},},

    /* b1 stx_addr_C_C */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc8, 0x397833c8},},

    /* b2 stx_addr_C_D */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc8, 0x397833c9},},

    /* b3 stx_addr_D_A */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc9, 0x397833c0},},

    /* b4 stx_addr_D_B */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc9, 0x397833c1},},

    /* b5 stx_addr_D_C */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc9, 0x397833c8},},

    /* b6 stx_addr_D_D */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc9, 0x397833c9},},

    /* b7 ld_A_addr  */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x38783083},},

    /* b8 ld_B_addr  */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x38783183},},

    /* b9 ld_C_addr  */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x38783883},},

    /* ba ld_D_addr  */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x38783983},},

    /* bb ldx_A_addr_A */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc0, 0x39783083},},

    /* bc ldx_A_addr_B */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc1, 0x39783083},},

    /* bd ldx_A_addr_C */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc8, 0x39783083},},

    /* be ldx_A_addr_D */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc9, 0x39783083},},

    /* bf ldx_B_addr_A */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc0, 0x39783183},},

    /* c0 ldx_B_addr_B */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc1, 0x39783183},},

    /* c1 ldx_B_addr_C */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc8, 0x39783183},},

    /* c2 ldx_B_addr_D */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc9, 0x39783183},},

    /* c3 ldx_C_addr_A */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc0, 0x39783883},},

    /* c4 ldx_C_addr_B */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc1, 0x39783883},},

    /* c5 ldx_C_addr_C */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc8, 0x39783883},},

    /* c6 ldx_C_addr_D */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc9, 0x39783883},},

    /* c7 ldx_D_addr_A */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc0, 0x39783983},},

    /* c8 ldx_D_addr_B */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc1, 0x39783983},},

    /* c9 ldx_D_addr_C */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc8, 0x39783983},},

    /* ca ldx_D_addr_D */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc9, 0x39783983},},

    /* cb tstx_addr_A */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc0, 0x39783f83},},

    /* cc tstx_addr_B */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc1, 0x39783f83},},

    /* cd tstx_addr_C */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc8, 0x39783f83},},

    /* ce tstx_addr_D */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x10783fc9, 0x39783f83},},

    /* cf ljmp_addr  */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x28783fcf},},

    /* d0 beql_addr  */
    { .default_steps = {0x3af83fcf, 0x3af83fcf},
      .f_alt = {
          /* mask: --Z- value: --Z- */
          { .mask = 0x02, .value = 0x02,
            .steps = {0x3af83bc3, 0x3af835c3, 0x28783fcf},
          },
      },
    },

    /* d1 bnel_addr  */
    { .default_steps = {0x3af83fcf, 0x3af83fcf},
      .f_alt = {
          /* mask: --Z- value: ---- */
          { .mask = 0x02, .value = 0x00,
            .steps = {0x3af83bc3, 0x3af835c3, 0x28783fcf},
          },
      },
    },

    /* d2 bcsl_addr  */
    { .default_steps = {0x3af83fcf, 0x3af83fcf},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3af83bc3, 0x3af835c3, 0x28783fcf},
          },
      },
    },

    /* d3 bccl_addr  */
    { .default_steps = {0x3af83fcf, 0x3af83fcf},
      .f_alt = {
          /* mask: -C-- value: ---- */
          { .mask = 0x04, .value = 0x00,
            .steps = {0x3af83bc3, 0x3af835c3, 0x28783fcf},
          },
      },
    },

    /* d4 bmil_addr  */
    { .default_steps = {0x3af83fcf, 0x3af83fcf},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0x3af83bc3, 0x3af835c3, 0x28783fcf},
          },
      },
    },

    /* d5 bpll_addr  */
    { .default_steps = {0x3af83fcf, 0x3af83fcf},
      .f_alt = {
          /* mask: ---N value: ---- */
          { .mask = 0x01, .value = 0x00,
            .steps = {0x3af83bc3, 0x3af835c3, 0x28783fcf},
          },
      },
    },

    /* d6 push_A     */
    { .default_steps = {0x3bb83fcf, 0x39f833c0},},

    /* d7 push_B     */
    { .default_steps = {0x3bb83fcf, 0x39f833c1},},

    /* d8 push_C     */
    { .default_steps = {0x3bb83fcf, 0x39f833c8},},

    /* d9 push_D     */
    { .default_steps = {0x3bb83fcf, 0x39f833c9},},

    /* da pushf      */
    { .default_steps = {0x3bb83fcf, 0x39f833c4},},

    /* db push_LR    */
    { .default_steps = {0x2383fcf, 0x39b833c5, 0x39f833cb},},

    /* dc pop_A      */
    { .default_steps = {0x39d830c3},},

    /* dd pop_B      */
    { .default_steps = {0x39d831c3},},

    /* de pop_C      */
    { .default_steps = {0x39d838c3},},

    /* df pop_D      */
    { .default_steps = {0x39d839c3},},

    /* e0 popf       */
    { .default_steps = {0x39d837c3},},

    /* e1 pop_LR     */
    { .default_steps = {0x39d83bc3, 0x39d835c3, 0x20783fcf},},

    /* e2 callf_addr */
    { .default_steps = {0x3af83bc3, 0x3af835c3, 0x22f83fcf, 0x28783fcf},},

    /* e3 ret        */
    { .default_steps = {0x2a783fcf},},

    /* e4 brk        */
    { .default_steps = {0x3ff83fcf},},

    /* e5 hlt        */
    { .default_steps = {0x3bf81fcf},},

    /* e6 ldr_A_SP_imm */
    { .default_steps = {0x3af83bc3, 0x11f83fcb, 0x39783083},},

    /* e7 ldr_B_SP_imm */
    { .default_steps = {0x3af83bc3, 0x11f83fcb, 0x39783183},},

    /* e8 ldr_C_SP_imm */
    { .default_steps = {0x3af83bc3, 0x11f83fcb, 0x39783883},},

    /* e9 ldr_D_SP_imm */
    { .default_steps = {0x3af83bc3, 0x11f83fcb, 0x39783983},},

    /* ea str_SP_imm_A */
    { .default_steps = {0x3af83bc3, 0x11f83fcb, 0x397833c0},},

    /* eb str_SP_imm_B */
    { .default_steps = {0x3af83bc3, 0x11f83fcb, 0x397833c1},},

    /* ec str_SP_imm_C */
    { .default_steps = {0x3af83bc3, 0x11f83fcb, 0x397833c8},},

    /* ed str_SP_imm_D */
    { .default_steps = {0x3af83bc3, 0x11f83fcb, 0x397833c9},},

    /* ee xprefix    */
    { .default_steps = {0x3af834e3, 0x3bf83fcf},},

    /* ef rjmp_imm   */
    { .default_steps = {0x12f83fc3, 0x29783fcf},},

    /* f0 beqr_imm   */
    { .default_steps = {0x3af83fcf},
      .f_alt = {
          /* mask: --Z- value: --Z- */
          { .mask = 0x02, .value = 0x02,
            .steps = {0x12f83fc3, 0x29783fcf},
          },
      },
    },

    /* f1 bner_imm   */
    { .default_steps = {0x3af83fcf},
      .f_alt = {
          /* mask: --Z- value: ---- */
          { .mask = 0x02, .value = 0x00,
            .steps = {0x12f83fc3, 0x29783fcf},
          },
      },
    },

    /* f2 bcsr_imm   */
    { .default_steps = {0x3af83fcf},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x12f83fc3, 0x29783fcf},
          },
      },
    },

    /* f3 bccr_imm   */
    { .default_steps = {0x3af83fcf},
      .f_alt = {
          /* mask: -C-- value: ---- */
          { .mask = 0x04, .value = 0x00,
            .steps = {0x12f83fc3, 0x29783fcf},
          },
      },
    },

    /* f4 bmir_imm   */
    { .default_steps = {0x3af83fcf},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0x12f83fc3, 0x29783fcf},
          },
      },
    },

    /* f5 bplr_imm   */
    { .default_steps = {0x3af83fcf},
      .f_alt = {
          /* mask: ---N value: ---- */
          { .mask = 0x01, .value = 0x00,
            .steps = {0x12f83fc3, 0x29783fcf},
          },
      },
    },

    /* f6 rcall_imm  */
    { .default_steps = {0x12f83fc3, 0x22f83fcf, 0x29783fcf},},

    /* f7 padding8   */
    { .default_steps = {0x3bf83fcf},},

    /* f8 padding9   */
    { .default_steps = {0x3bf83fcf},},

    /* f9 padding10  */
    { .default_steps = {0x3bf83fcf},},

    /* fa padding11  */
    { .default_steps = {0x3bf83fcf},},

    /* fb padding12  */
    { .default_steps = {0x3bf83fcf},},

    /* fc padding13  */
    { .default_steps = {0x3bf83fcf},},

    /* fd padding14  */
    { .default_steps = {0x3bf83fcf},},

    /* fe padding15  */
    { .default_steps = {0x3bf83fcf},},

    /* ff padding16  */
    { .default_steps = {0x3bf83fcf},},

    /* 100 padding17  */
    { .default_steps = {0x3bf83fcf},},

    /* 101 padding18  */
    { .default_steps = {0x3bf83fcf},},

    /* 102 padding19  */
    { .default_steps = {0x3bf83fcf},},

    /* 103 padding20  */
    { .default_steps = {0x3bf83fcf},},

    /* 104 padding21  */
    { .default_steps = {0x3bf83fcf},},

    /* 105 padding22  */
    { .default_steps = {0x3bf83fcf},},

    /* 106 padding23  */
    { .default_steps = {0x3bf83fcf},},

    /* 107 padding24  */
    { .default_steps = {0x3bf83fcf},},

    /* 108 padding25  */
    { .default_steps = {0x3bf83fcf},},

    /* 109 padding26  */
    { .default_steps = {0x3bf83fcf},},

    /* 10a padding27  */
    { .default_steps = {0x3bf83fcf},},

    /* 10b padding28  */
    { .default_steps = {0x3bf83fcf},},

    /* 10c padding29  */
    { .default_steps = {0x3bf83fcf},},

    /* 10d dummyext_imm */
    { .default_steps = {0x3af830c3},},
};
