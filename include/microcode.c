#include "microcode.h"

const cword_t op_fetch[] = {0x3af838c9};

const struct op_microcode microcode[] PROGMEM = {

    /* 00 nop        */
    { .default_steps = {0x3bf83fcf},},

    /* 01 ldi_A_imm  */
    { .default_steps = {0x3af830c9},},

    /* 02 ldi_B_imm  */
    { .default_steps = {0x3af831c9},},

    /* 03 ldi_C_imm  */
    { .default_steps = {0x3af832c9},},

    /* 04 ldi_D_imm  */
    { .default_steps = {0x3af833c9},},

    /* 05 ldi_F_imm  */
    { .default_steps = {0x3af837c9},},

    /* 06 lea_SP_addr */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x18783fcf},},

    /* 07 add_A_A    */
    { .default_steps = {0x3be03085},},

    /* 08 add_A_B    */
    { .default_steps = {0x3be43085},},

    /* 09 add_A_C    */
    { .default_steps = {0x3be83085},},

    /* 0a add_A_D    */
    { .default_steps = {0x3bec3085},},

    /* 0b add_B_A    */
    { .default_steps = {0x3be13185},},

    /* 0c add_B_B    */
    { .default_steps = {0x3be53185},},

    /* 0d add_B_C    */
    { .default_steps = {0x3be93185},},

    /* 0e add_B_D    */
    { .default_steps = {0x3bed3185},},

    /* 0f add_C_A    */
    { .default_steps = {0x3be23285},},

    /* 10 add_C_B    */
    { .default_steps = {0x3be63285},},

    /* 11 add_C_C    */
    { .default_steps = {0x3bea3285},},

    /* 12 add_C_D    */
    { .default_steps = {0x3bee3285},},

    /* 13 add_D_A    */
    { .default_steps = {0x3be33385},},

    /* 14 add_D_B    */
    { .default_steps = {0x3be73385},},

    /* 15 add_D_C    */
    { .default_steps = {0x3beb3385},},

    /* 16 add_D_D    */
    { .default_steps = {0x3bef3385},},

    /* 17 adc_A_A    */
    { .default_steps = {0x3be03085},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be07085},
          },
      },
    },

    /* 18 adc_A_B    */
    { .default_steps = {0x3be43085},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be47085},
          },
      },
    },

    /* 19 adc_A_C    */
    { .default_steps = {0x3be83085},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be87085},
          },
      },
    },

    /* 1a adc_A_D    */
    { .default_steps = {0x3bec3085},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bec7085},
          },
      },
    },

    /* 1b adc_B_A    */
    { .default_steps = {0x3be13185},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be17185},
          },
      },
    },

    /* 1c adc_B_B    */
    { .default_steps = {0x3be53185},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be57185},
          },
      },
    },

    /* 1d adc_B_C    */
    { .default_steps = {0x3be93185},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be97185},
          },
      },
    },

    /* 1e adc_B_D    */
    { .default_steps = {0x3bed3185},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bed7185},
          },
      },
    },

    /* 1f adc_C_A    */
    { .default_steps = {0x3be23285},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be27285},
          },
      },
    },

    /* 20 adc_C_B    */
    { .default_steps = {0x3be63285},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be67285},
          },
      },
    },

    /* 21 adc_C_C    */
    { .default_steps = {0x3bea3285},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bea7285},
          },
      },
    },

    /* 22 adc_C_D    */
    { .default_steps = {0x3bee3285},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bee7285},
          },
      },
    },

    /* 23 adc_D_A    */
    { .default_steps = {0x3be33385},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be37385},
          },
      },
    },

    /* 24 adc_D_B    */
    { .default_steps = {0x3be73385},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be77385},
          },
      },
    },

    /* 25 adc_D_C    */
    { .default_steps = {0x3beb3385},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3beb7385},
          },
      },
    },

    /* 26 adc_D_D    */
    { .default_steps = {0x3bef3385},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bef7385},
          },
      },
    },

    /* 27 sub_A_B    */
    { .default_steps = {0x3be43095},},

    /* 28 sub_A_C    */
    { .default_steps = {0x3be83095},},

    /* 29 sub_A_D    */
    { .default_steps = {0x3bec3095},},

    /* 2a sub_B_A    */
    { .default_steps = {0x3be13195},},

    /* 2b sub_B_C    */
    { .default_steps = {0x3be93195},},

    /* 2c sub_B_D    */
    { .default_steps = {0x3bed3195},},

    /* 2d sub_C_A    */
    { .default_steps = {0x3be23295},},

    /* 2e sub_C_B    */
    { .default_steps = {0x3be63295},},

    /* 2f sub_C_D    */
    { .default_steps = {0x3bee3295},},

    /* 30 sub_D_A    */
    { .default_steps = {0x3be33395},},

    /* 31 sub_D_B    */
    { .default_steps = {0x3be73395},},

    /* 32 sub_D_C    */
    { .default_steps = {0x3beb3395},},

    /* 33 sbb_A_B    */
    { .default_steps = {0x3be43095},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be47095},
          },
      },
    },

    /* 34 sbb_A_C    */
    { .default_steps = {0x3be83095},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be87095},
          },
      },
    },

    /* 35 sbb_A_D    */
    { .default_steps = {0x3bec3095},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bec7095},
          },
      },
    },

    /* 36 sbb_B_A    */
    { .default_steps = {0x3be13195},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be17195},
          },
      },
    },

    /* 37 sbb_B_C    */
    { .default_steps = {0x3be93195},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be97195},
          },
      },
    },

    /* 38 sbb_B_D    */
    { .default_steps = {0x3bed3195},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bed7195},
          },
      },
    },

    /* 39 sbb_C_A    */
    { .default_steps = {0x3be23295},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be27295},
          },
      },
    },

    /* 3a sbb_C_B    */
    { .default_steps = {0x3be63295},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be67295},
          },
      },
    },

    /* 3b sbb_C_D    */
    { .default_steps = {0x3bee3295},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bee7295},
          },
      },
    },

    /* 3c sbb_D_A    */
    { .default_steps = {0x3be33395},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be37395},
          },
      },
    },

    /* 3d sbb_D_B    */
    { .default_steps = {0x3be73395},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3be77395},
          },
      },
    },

    /* 3e sbb_D_C    */
    { .default_steps = {0x3beb3395},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3beb7395},
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
    { .default_steps = {0x3be23286},},

    /* 46 and_C_B    */
    { .default_steps = {0x3be63286},},

    /* 47 and_C_D    */
    { .default_steps = {0x3bee3286},},

    /* 48 and_D_A    */
    { .default_steps = {0x3be33386},},

    /* 49 and_D_B    */
    { .default_steps = {0x3be73386},},

    /* 4a and_D_C    */
    { .default_steps = {0x3beb3386},},

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
    { .default_steps = {0x3be23296},},

    /* 52 or_C_B     */
    { .default_steps = {0x3be63296},},

    /* 53 or_C_D     */
    { .default_steps = {0x3bee3296},},

    /* 54 or_D_A     */
    { .default_steps = {0x3be33396},},

    /* 55 or_D_B     */
    { .default_steps = {0x3be73396},},

    /* 56 or_D_C     */
    { .default_steps = {0x3beb3396},},

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
    { .default_steps = {0x3be2328a},},

    /* 5e xor_C_B    */
    { .default_steps = {0x3be6328a},},

    /* 5f xor_C_D    */
    { .default_steps = {0x3bee328a},},

    /* 60 xor_D_A    */
    { .default_steps = {0x3be3338a},},

    /* 61 xor_D_B    */
    { .default_steps = {0x3be7338a},},

    /* 62 xor_D_C    */
    { .default_steps = {0x3beb338a},},

    /* 63 not_A      */
    { .default_steps = {0x3bf8309a},},

    /* 64 not_B      */
    { .default_steps = {0x3bf9319a},},

    /* 65 not_C      */
    { .default_steps = {0x3bfa329a},},

    /* 66 not_D      */
    { .default_steps = {0x3bfb339a},},

    /* 67 clr_A      */
    { .default_steps = {0x3be0308a},},

    /* 68 clr_B      */
    { .default_steps = {0x3be5318a},},

    /* 69 clr_C      */
    { .default_steps = {0x3bea328a},},

    /* 6a clr_D      */
    { .default_steps = {0x3bef338a},},

    /* 6b inc_A      */
    { .default_steps = {0x3bf87085},},

    /* 6c inc_B      */
    { .default_steps = {0x3bf97185},},

    /* 6d inc_C      */
    { .default_steps = {0x3bfa7285},},

    /* 6e inc_D      */
    { .default_steps = {0x3bfb7385},},

    /* 6f dec_A      */
    { .default_steps = {0x3bf87095},},

    /* 70 dec_B      */
    { .default_steps = {0x3bf97195},},

    /* 71 dec_C      */
    { .default_steps = {0x3bfa7295},},

    /* 72 dec_D      */
    { .default_steps = {0x3bfb7395},},

    /* 73 shr_A      */
    { .default_steps = {0x3bf83087},},

    /* 74 shr_B      */
    { .default_steps = {0x3bf93187},},

    /* 75 shr_C      */
    { .default_steps = {0x3bfa3287},},

    /* 76 shr_D      */
    { .default_steps = {0x3bfb3387},},

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
    { .default_steps = {0x3bfa3287},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bfa7287},
          },
      },
    },

    /* 7a ror_D      */
    { .default_steps = {0x3bfb3387},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3bfb7387},
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
    { .default_steps = {0x3bf83f82, 0x3bfa3287},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0x3bf83f82, 0x3bfa7287},
          },
      },
    },

    /* 7e asr_D      */
    { .default_steps = {0x3bf83f83, 0x3bfb3387},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0x3bf83f83, 0x3bfb7387},
          },
      },
    },

    /* 7f swap_A     */
    { .default_steps = {0x3bf83097},},

    /* 80 swap_B     */
    { .default_steps = {0x3bf93197},},

    /* 81 swap_C     */
    { .default_steps = {0x3bfa3297},},

    /* 82 swap_D     */
    { .default_steps = {0x3bfb3397},},

    /* 83 cmp_A_B    */
    { .default_steps = {0x3be43f95},},

    /* 84 cmp_A_C    */
    { .default_steps = {0x3be83f95},},

    /* 85 cmp_A_D    */
    { .default_steps = {0x3bec3f95},},

    /* 86 cmp_B_A    */
    { .default_steps = {0x3be13f95},},

    /* 87 cmp_B_C    */
    { .default_steps = {0x3be93f95},},

    /* 88 cmp_B_D    */
    { .default_steps = {0x3bed3f95},},

    /* 89 cmp_C_A    */
    { .default_steps = {0x3be23f95},},

    /* 8a cmp_C_B    */
    { .default_steps = {0x3be63f95},},

    /* 8b cmp_C_D    */
    { .default_steps = {0x3bee3f95},},

    /* 8c cmp_D_A    */
    { .default_steps = {0x3be33f95},},

    /* 8d cmp_D_B    */
    { .default_steps = {0x3be73f95},},

    /* 8e cmp_D_C    */
    { .default_steps = {0x3beb3f95},},

    /* 8f mov_A_B    */
    { .default_steps = {0x3bf830c1},},

    /* 90 mov_A_C    */
    { .default_steps = {0x3bf830c2},},

    /* 91 mov_A_D    */
    { .default_steps = {0x3bf830c3},},

    /* 92 mov_B_A    */
    { .default_steps = {0x3bf831c0},},

    /* 93 mov_B_C    */
    { .default_steps = {0x3bf831c2},},

    /* 94 mov_B_D    */
    { .default_steps = {0x3bf831c3},},

    /* 95 mov_C_A    */
    { .default_steps = {0x3bf832c0},},

    /* 96 mov_C_B    */
    { .default_steps = {0x3bf832c1},},

    /* 97 mov_C_D    */
    { .default_steps = {0x3bf832c3},},

    /* 98 mov_D_A    */
    { .default_steps = {0x3bf833c0},},

    /* 99 mov_D_B    */
    { .default_steps = {0x3bf833c1},},

    /* 9a mov_D_C    */
    { .default_steps = {0x3bf833c2},},

    /* 9b out_A      */
    { .default_steps = {0x3bf836c0},},

    /* 9c out_B      */
    { .default_steps = {0x3bf836c1},},

    /* 9d out_C      */
    { .default_steps = {0x3bf836c2},},

    /* 9e out_D      */
    { .default_steps = {0x3bf836c3},},

    /* 9f cout_A     */
    { .default_steps = {0x3bf83ac0},},

    /* a0 cout_B     */
    { .default_steps = {0x3bf83ac1},},

    /* a1 cout_C     */
    { .default_steps = {0x3bf83ac2},},

    /* a2 cout_D     */
    { .default_steps = {0x3bf83ac3},},

    /* a3 st_addr_A  */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x387839c0},},

    /* a4 st_addr_B  */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x387839c1},},

    /* a5 st_addr_C  */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x387839c2},},

    /* a6 st_addr_D  */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x387839c3},},

    /* a7 stx_addr_A_A */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc0, 0x397839c0},},

    /* a8 stx_addr_A_B */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc0, 0x397839c1},},

    /* a9 stx_addr_A_C */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc0, 0x397839c2},},

    /* aa stx_addr_A_D */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc0, 0x397839c3},},

    /* ab stx_addr_B_A */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc1, 0x397839c0},},

    /* ac stx_addr_B_B */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc1, 0x397839c1},},

    /* ad stx_addr_B_C */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc1, 0x397839c2},},

    /* ae stx_addr_B_D */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc1, 0x397839c3},},

    /* af stx_addr_C_A */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc2, 0x397839c0},},

    /* b0 stx_addr_C_B */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc2, 0x397839c1},},

    /* b1 stx_addr_C_C */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc2, 0x397839c2},},

    /* b2 stx_addr_C_D */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc2, 0x397839c3},},

    /* b3 stx_addr_D_A */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc3, 0x397839c0},},

    /* b4 stx_addr_D_B */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc3, 0x397839c1},},

    /* b5 stx_addr_D_C */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc3, 0x397839c2},},

    /* b6 stx_addr_D_D */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc3, 0x397839c3},},

    /* b7 ld_A_addr  */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x38783089},},

    /* b8 ld_B_addr  */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x38783189},},

    /* b9 ld_C_addr  */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x38783289},},

    /* ba ld_D_addr  */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x38783389},},

    /* bb ldx_A_addr_A */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc0, 0x39783089},},

    /* bc ldx_A_addr_B */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc1, 0x39783089},},

    /* bd ldx_A_addr_C */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc2, 0x39783089},},

    /* be ldx_A_addr_D */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc3, 0x39783089},},

    /* bf ldx_B_addr_A */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc0, 0x39783189},},

    /* c0 ldx_B_addr_B */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc1, 0x39783189},},

    /* c1 ldx_B_addr_C */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc2, 0x39783189},},

    /* c2 ldx_B_addr_D */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc3, 0x39783189},},

    /* c3 ldx_C_addr_A */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc0, 0x39783289},},

    /* c4 ldx_C_addr_B */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc1, 0x39783289},},

    /* c5 ldx_C_addr_C */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc2, 0x39783289},},

    /* c6 ldx_C_addr_D */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc3, 0x39783289},},

    /* c7 ldx_D_addr_A */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc0, 0x39783389},},

    /* c8 ldx_D_addr_B */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc1, 0x39783389},},

    /* c9 ldx_D_addr_C */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc2, 0x39783389},},

    /* ca ldx_D_addr_D */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc3, 0x39783389},},

    /* cb tstx_addr_A */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc0, 0x39783f89},},

    /* cc tstx_addr_B */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc1, 0x39783f89},},

    /* cd tstx_addr_C */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc2, 0x39783f89},},

    /* ce tstx_addr_D */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x10783fc3, 0x39783f89},},

    /* cf ljmp_addr  */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x28783fcf},},

    /* d0 beql_addr  */
    { .default_steps = {0x3af83fcf, 0x3af83fcf},
      .f_alt = {
          /* mask: --Z- value: --Z- */
          { .mask = 0x02, .value = 0x02,
            .steps = {0x3af83bc9, 0x3af83cc9, 0x28783fcf},
          },
      },
    },

    /* d1 bnel_addr  */
    { .default_steps = {0x3af83fcf, 0x3af83fcf},
      .f_alt = {
          /* mask: --Z- value: ---- */
          { .mask = 0x02, .value = 0x00,
            .steps = {0x3af83bc9, 0x3af83cc9, 0x28783fcf},
          },
      },
    },

    /* d2 bcsl_addr  */
    { .default_steps = {0x3af83fcf, 0x3af83fcf},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x3af83bc9, 0x3af83cc9, 0x28783fcf},
          },
      },
    },

    /* d3 bccl_addr  */
    { .default_steps = {0x3af83fcf, 0x3af83fcf},
      .f_alt = {
          /* mask: -C-- value: ---- */
          { .mask = 0x04, .value = 0x00,
            .steps = {0x3af83bc9, 0x3af83cc9, 0x28783fcf},
          },
      },
    },

    /* d4 bmil_addr  */
    { .default_steps = {0x3af83fcf, 0x3af83fcf},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0x3af83bc9, 0x3af83cc9, 0x28783fcf},
          },
      },
    },

    /* d5 bpll_addr  */
    { .default_steps = {0x3af83fcf, 0x3af83fcf},
      .f_alt = {
          /* mask: ---N value: ---- */
          { .mask = 0x01, .value = 0x00,
            .steps = {0x3af83bc9, 0x3af83cc9, 0x28783fcf},
          },
      },
    },

    /* d6 push_A     */
    { .default_steps = {0x3bb83fcf, 0x39f839c0},},

    /* d7 push_B     */
    { .default_steps = {0x3bb83fcf, 0x39f839c1},},

    /* d8 push_C     */
    { .default_steps = {0x3bb83fcf, 0x39f839c2},},

    /* d9 push_D     */
    { .default_steps = {0x3bb83fcf, 0x39f839c3},},

    /* da pushf      */
    { .default_steps = {0x3bb83fcf, 0x39f839c4},},

    /* db push_LR    */
    { .default_steps = {0x2383fcf, 0x39b839cc, 0x39f839cb},},

    /* dc pop_A      */
    { .default_steps = {0x39d830c9},},

    /* dd pop_B      */
    { .default_steps = {0x39d831c9},},

    /* de pop_C      */
    { .default_steps = {0x39d832c9},},

    /* df pop_D      */
    { .default_steps = {0x39d833c9},},

    /* e0 popf       */
    { .default_steps = {0x39d837c9},},

    /* e1 pop_LR     */
    { .default_steps = {0x39d83bc9, 0x39d83cc9, 0x20783fcf},},

    /* e2 callf_addr */
    { .default_steps = {0x3af83bc9, 0x3af83cc9, 0x22f83fcf, 0x28783fcf},},

    /* e3 ret        */
    { .default_steps = {0x2a783fcf},},

    /* e4 brk        */
    { .default_steps = {0x3ff83fcf},},

    /* e5 hlt        */
    { .default_steps = {0x3bf81fcf},},

    /* e6 ldr_A_SP_imm */
    { .default_steps = {0x3af83bc9, 0x11f83fcb, 0x39783089},},

    /* e7 ldr_B_SP_imm */
    { .default_steps = {0x3af83bc9, 0x11f83fcb, 0x39783189},},

    /* e8 ldr_C_SP_imm */
    { .default_steps = {0x3af83bc9, 0x11f83fcb, 0x39783289},},

    /* e9 ldr_D_SP_imm */
    { .default_steps = {0x3af83bc9, 0x11f83fcb, 0x39783389},},

    /* ea str_SP_imm_A */
    { .default_steps = {0x3af83bc9, 0x11f83fcb, 0x397839c0},},

    /* eb str_SP_imm_B */
    { .default_steps = {0x3af83bc9, 0x11f83fcb, 0x397839c1},},

    /* ec str_SP_imm_C */
    { .default_steps = {0x3af83bc9, 0x11f83fcb, 0x397839c2},},

    /* ed str_SP_imm_D */
    { .default_steps = {0x3af83bc9, 0x11f83fcb, 0x397839c3},},

    /* ee xprefix    */
    { .default_steps = {0x3af838e9, 0x3bf83fcf},},

    /* ef rjmp_imm   */
    { .default_steps = {0x12f83fc9, 0x29783fcf},},

    /* f0 beqr_imm   */
    { .default_steps = {0x3af83fcf},
      .f_alt = {
          /* mask: --Z- value: --Z- */
          { .mask = 0x02, .value = 0x02,
            .steps = {0x12f83fc9, 0x29783fcf},
          },
      },
    },

    /* f1 bner_imm   */
    { .default_steps = {0x3af83fcf},
      .f_alt = {
          /* mask: --Z- value: ---- */
          { .mask = 0x02, .value = 0x00,
            .steps = {0x12f83fc9, 0x29783fcf},
          },
      },
    },

    /* f2 bcsr_imm   */
    { .default_steps = {0x3af83fcf},
      .f_alt = {
          /* mask: -C-- value: -C-- */
          { .mask = 0x04, .value = 0x04,
            .steps = {0x12f83fc9, 0x29783fcf},
          },
      },
    },

    /* f3 bccr_imm   */
    { .default_steps = {0x3af83fcf},
      .f_alt = {
          /* mask: -C-- value: ---- */
          { .mask = 0x04, .value = 0x00,
            .steps = {0x12f83fc9, 0x29783fcf},
          },
      },
    },

    /* f4 bmir_imm   */
    { .default_steps = {0x3af83fcf},
      .f_alt = {
          /* mask: ---N value: ---N */
          { .mask = 0x01, .value = 0x01,
            .steps = {0x12f83fc9, 0x29783fcf},
          },
      },
    },

    /* f5 bplr_imm   */
    { .default_steps = {0x3af83fcf},
      .f_alt = {
          /* mask: ---N value: ---- */
          { .mask = 0x01, .value = 0x00,
            .steps = {0x12f83fc9, 0x29783fcf},
          },
      },
    },

    /* f6 rcall_imm  */
    { .default_steps = {0x12f83fc9, 0x22f83fcf, 0x29783fcf},},

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
    { .default_steps = {0x3af830c9},},
};
