#ifndef OP_DEFS_H
#define OP_DEFS_H

/* Opcodes */
#define OP_NOP                 0x00
#define OP_LDI_A_IMM           0x01
#define OP_LDI_B_IMM           0x02
#define OP_LDI_C_IMM           0x03
#define OP_LDI_D_IMM           0x04
#define OP_LDI_F_IMM           0x05
#define OP_ADD_A_A             0x06
#define OP_ADD_A_B             0x07
#define OP_ADD_A_C             0x08
#define OP_ADD_A_D             0x09
#define OP_ADD_B_A             0x0a
#define OP_ADD_B_B             0x0b
#define OP_ADD_B_C             0x0c
#define OP_ADD_B_D             0x0d
#define OP_ADD_C_A             0x0e
#define OP_ADD_C_B             0x0f
#define OP_ADD_C_C             0x10
#define OP_ADD_C_D             0x11
#define OP_ADD_D_A             0x12
#define OP_ADD_D_B             0x13
#define OP_ADD_D_C             0x14
#define OP_ADD_D_D             0x15
#define OP_ADC_A_A             0x16
#define OP_ADC_A_B             0x17
#define OP_ADC_A_C             0x18
#define OP_ADC_A_D             0x19
#define OP_ADC_B_A             0x1a
#define OP_ADC_B_B             0x1b
#define OP_ADC_B_C             0x1c
#define OP_ADC_B_D             0x1d
#define OP_ADC_C_A             0x1e
#define OP_ADC_C_B             0x1f
#define OP_ADC_C_C             0x20
#define OP_ADC_C_D             0x21
#define OP_ADC_D_A             0x22
#define OP_ADC_D_B             0x23
#define OP_ADC_D_C             0x24
#define OP_ADC_D_D             0x25
#define OP_SUB_A_B             0x26
#define OP_SUB_A_C             0x27
#define OP_SUB_A_D             0x28
#define OP_SUB_B_A             0x29
#define OP_SUB_B_C             0x2a
#define OP_SUB_B_D             0x2b
#define OP_SUB_C_A             0x2c
#define OP_SUB_C_B             0x2d
#define OP_SUB_C_D             0x2e
#define OP_SUB_D_A             0x2f
#define OP_SUB_D_B             0x30
#define OP_SUB_D_C             0x31
#define OP_SBB_A_B             0x32
#define OP_SBB_A_C             0x33
#define OP_SBB_A_D             0x34
#define OP_SBB_B_A             0x35
#define OP_SBB_B_C             0x36
#define OP_SBB_B_D             0x37
#define OP_SBB_C_A             0x38
#define OP_SBB_C_B             0x39
#define OP_SBB_C_D             0x3a
#define OP_SBB_D_A             0x3b
#define OP_SBB_D_B             0x3c
#define OP_SBB_D_C             0x3d
#define OP_AND_A_B             0x3e
#define OP_AND_A_C             0x3f
#define OP_AND_A_D             0x40
#define OP_AND_B_A             0x41
#define OP_AND_B_C             0x42
#define OP_AND_B_D             0x43
#define OP_AND_C_A             0x44
#define OP_AND_C_B             0x45
#define OP_AND_C_D             0x46
#define OP_AND_D_A             0x47
#define OP_AND_D_B             0x48
#define OP_AND_D_C             0x49
#define OP_OR_A_B              0x4a
#define OP_OR_A_C              0x4b
#define OP_OR_A_D              0x4c
#define OP_OR_B_A              0x4d
#define OP_OR_B_C              0x4e
#define OP_OR_B_D              0x4f
#define OP_OR_C_A              0x50
#define OP_OR_C_B              0x51
#define OP_OR_C_D              0x52
#define OP_OR_D_A              0x53
#define OP_OR_D_B              0x54
#define OP_OR_D_C              0x55
#define OP_XOR_A_B             0x56
#define OP_XOR_A_C             0x57
#define OP_XOR_A_D             0x58
#define OP_XOR_B_A             0x59
#define OP_XOR_B_C             0x5a
#define OP_XOR_B_D             0x5b
#define OP_XOR_C_A             0x5c
#define OP_XOR_C_B             0x5d
#define OP_XOR_C_D             0x5e
#define OP_XOR_D_A             0x5f
#define OP_XOR_D_B             0x60
#define OP_XOR_D_C             0x61
#define OP_NOT_A               0x62
#define OP_NOT_B               0x63
#define OP_NOT_C               0x64
#define OP_NOT_D               0x65
#define OP_INC_A               0x66
#define OP_INC_B               0x67
#define OP_INC_C               0x68
#define OP_INC_D               0x69
#define OP_DEC_A               0x6a
#define OP_DEC_B               0x6b
#define OP_DEC_C               0x6c
#define OP_DEC_D               0x6d
#define OP_SHR_A               0x6e
#define OP_SHR_B               0x6f
#define OP_SHR_C               0x70
#define OP_SHR_D               0x71
#define OP_ROR_A               0x72
#define OP_ROR_B               0x73
#define OP_ROR_C               0x74
#define OP_ROR_D               0x75
#define OP_ASR_A               0x76
#define OP_ASR_B               0x77
#define OP_ASR_C               0x78
#define OP_ASR_D               0x79
#define OP_SWAP_A              0x7a
#define OP_SWAP_B              0x7b
#define OP_SWAP_C              0x7c
#define OP_SWAP_D              0x7d
#define OP_CMP_A_B             0x7e
#define OP_CMP_A_C             0x7f
#define OP_CMP_A_D             0x80
#define OP_CMP_B_A             0x81
#define OP_CMP_B_C             0x82
#define OP_CMP_B_D             0x83
#define OP_CMP_C_A             0x84
#define OP_CMP_C_B             0x85
#define OP_CMP_C_D             0x86
#define OP_CMP_D_A             0x87
#define OP_CMP_D_B             0x88
#define OP_CMP_D_C             0x89
#define OP_MOV_A_B             0x8a
#define OP_MOV_A_C             0x8b
#define OP_MOV_A_D             0x8c
#define OP_MOV_B_A             0x8d
#define OP_MOV_B_C             0x8e
#define OP_MOV_B_D             0x8f
#define OP_MOV_C_A             0x90
#define OP_MOV_C_B             0x91
#define OP_MOV_C_D             0x92
#define OP_MOV_D_A             0x93
#define OP_MOV_D_B             0x94
#define OP_MOV_D_C             0x95
#define OP_OUT_A               0x96
#define OP_OUT_B               0x97
#define OP_OUT_C               0x98
#define OP_OUT_D               0x99
#define OP_COUT_A              0x9a
#define OP_COUT_B              0x9b
#define OP_COUT_C              0x9c
#define OP_COUT_D              0x9d
#define OP_ST_ADDR_A           0x9e
#define OP_ST_ADDR_B           0x9f
#define OP_ST_ADDR_C           0xa0
#define OP_ST_ADDR_D           0xa1
#define OP_STABS_A_A           0xa2
#define OP_STABS_A_B           0xa3
#define OP_STABS_A_C           0xa4
#define OP_STABS_A_D           0xa5
#define OP_STABS_B_A           0xa6
#define OP_STABS_B_B           0xa7
#define OP_STABS_B_C           0xa8
#define OP_STABS_B_D           0xa9
#define OP_STABS_C_A           0xaa
#define OP_STABS_C_B           0xab
#define OP_STABS_C_C           0xac
#define OP_STABS_C_D           0xad
#define OP_STABS_D_A           0xae
#define OP_STABS_D_B           0xaf
#define OP_STABS_D_C           0xb0
#define OP_STABS_D_D           0xb1
#define OP_LD_A_ADDR           0xb2
#define OP_LD_B_ADDR           0xb3
#define OP_LD_C_ADDR           0xb4
#define OP_LD_D_ADDR           0xb5
#define OP_LDABS_A_A           0xb6
#define OP_LDABS_A_B           0xb7
#define OP_LDABS_A_C           0xb8
#define OP_LDABS_A_D           0xb9
#define OP_LDABS_B_A           0xba
#define OP_LDABS_B_B           0xbb
#define OP_LDABS_B_C           0xbc
#define OP_LDABS_B_D           0xbd
#define OP_LDABS_C_A           0xbe
#define OP_LDABS_C_B           0xbf
#define OP_LDABS_C_C           0xc0
#define OP_LDABS_C_D           0xc1
#define OP_LDABS_D_A           0xc2
#define OP_LDABS_D_B           0xc3
#define OP_LDABS_D_C           0xc4
#define OP_LDABS_D_D           0xc5
#define OP_TSTABS_A            0xc6
#define OP_TSTABS_B            0xc7
#define OP_TSTABS_C            0xc8
#define OP_TSTABS_D            0xc9
#define OP_JMP_ADDR            0xca
#define OP_BEQ_ADDR            0xcb
#define OP_BNE_ADDR            0xcc
#define OP_BCS_ADDR            0xcd
#define OP_BCC_ADDR            0xce
#define OP_PUSH_A              0xcf
#define OP_PUSH_B              0xd0
#define OP_PUSH_C              0xd1
#define OP_PUSH_D              0xd2
#define OP_PUSH_F              0xd3
#define OP_PUSH_LR             0xd4
#define OP_POP_A               0xd5
#define OP_POP_B               0xd6
#define OP_POP_C               0xd7
#define OP_POP_D               0xd8
#define OP_POP_F               0xd9
#define OP_POP_LR              0xda
#define OP_CALL_ADDR           0xdb
#define OP_RET                 0xdc
#define OP_HLT                 0xdd
#define NUM_OPS                222

/* Fetch */
#define NUM_FETCH_STEPS        2

/* Device setup */
#define CTRL_DEFAULT                    0b00000000111000000011111111001111

#define MUX_OUT_MASK                    0b00000000000000000000000000001111
#define MPIN_A_OUT_BITS                 0b00000000000000000000000000000000
#define MPIN_B_OUT_BITS                 0b00000000000000000000000000000001
#define MPIN_C_OUT_BITS                 0b00000000000000000000000000001000
#define MPIN_D_OUT_BITS                 0b00000000000000000000000000001001
#define MPIN_ADDSUB_OUT_BITS            0b00000000000000000000000000000010
#define MPIN_ANDOR_OUT_BITS             0b00000000000000000000000000000110
#define MPIN_XORNOT_OUT_BITS            0b00000000000000000000000000001010
#define MPIN_SHIFTSWAP_OUT_BITS         0b00000000000000000000000000000111
#define MPIN_F_OUT_BITS                 0b00000000000000000000000000000100
#define MPIN_RAM_OUT_BITS               0b00000000000000000000000000000011
#define MPIN_PC_OUT_BITS                0b00000000000000000000000000000101
#define MPIN_SP_OUT_BITS                0b00000000000000000000000000001011
#define MPIN_DP_OUT_BITS                0b00000000000000000000000000001110
#define MPIN_LR_OUT_BITS                0b00000000000000000000000000001100

#define MUX_LOAD_MASK                   0b00000000000000000000111100000000
#define MPIN_A_LOAD_BITS                0b00000000000000000000000000000000
#define MPIN_B_LOAD_BITS                0b00000000000000000000000100000000
#define MPIN_C_LOAD_BITS                0b00000000000000000000100000000000
#define MPIN_D_LOAD_BITS                0b00000000000000000000100100000000
#define MPIN_F_LOAD_BITS                0b00000000000000000000011100000000
#define MPIN_HAS_LOAD_BITS              0b00000000000000000000110100000000
#define MPIN_MAR_LOAD_BITS              0b00000000000000000000001000000000
#define MPIN_RAM_WRITE_BITS             0b00000000000000000000001100000000
#define MPIN_IR_LOAD_BITS               0b00000000000000000000010000000000
#define MPIN_PC_LOAD_BITS               0b00000000000000000000010100000000
#define MPIN_SP_LOAD_BITS               0b00000000000000000000101100000000
#define MPIN_DP_LOAD_BITS               0b00000000000000000000111000000000
#define MPIN_LR_LOAD_BITS               0b00000000000000000000110000000000
#define MPIN_OUT_LOAD_BITS              0b00000000000000000000011000000000
#define MPIN_COUT_LOAD_BITS             0b00000000000000000000101000000000

#define MUX_ALUARGA_MASK                0b00000000000000110000000000000000
#define MPIN_A_ALU_A_BITS               0b00000000000000000000000000000000
#define MPIN_B_ALU_A_BITS               0b00000000000000010000000000000000
#define MPIN_C_ALU_A_BITS               0b00000000000000100000000000000000
#define MPIN_D_ALU_A_BITS               0b00000000000000110000000000000000

#define MUX_ALUARGB_MASK                0b00000000000111000000000000000000
#define MPIN_A_ALU_B_BITS               0b00000000000100000000000000000000
#define MPIN_B_ALU_B_BITS               0b00000000000101000000000000000000
#define MPIN_C_ALU_B_BITS               0b00000000000110000000000000000000
#define MPIN_D_ALU_B_BITS               0b00000000000111000000000000000000

#define HPIN_ADDSUB_ALT_BIT             0b00000000000000000000000000010000
#define LPIN_F_CALC_BIT                 0b00000000000000000000000001000000
#define HPIN_F_CARRY_BIT                0b00000000000000000100000000000000
#define LPIN_HAS_OUT_BIT                0b00000000100000000000000000000000
#define HPIN_HAS_DIR_BIT                0b00000001000000000000000000000000
#define LPIN_CLOCK_HALT_BIT             0b00000000000000000010000000000000
#define LPIN_STEPS_RESET_BIT            0b00000000000000000000000010000000
#define LPIN_IRFETCH_LOAD_BIT           0b00000000000000000001000000000000
#define HPIN_PC_COUNT_BIT               0b00000000000000000000000000100000
#define LPIN_SP_INC_BIT                 0b00000000001000000000000000000000
#define LPIN_SP_DEC_BIT                 0b00000000010000000000000000000000
#define HPIN_PCLR_SWAP_BIT              0b00000000000000001000000000000000

#endif /* OP_DEFS_H */
