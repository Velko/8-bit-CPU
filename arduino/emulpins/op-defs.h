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
#define OP_SUB_A_A             0x26
#define OP_SUB_A_B             0x27
#define OP_SUB_A_C             0x28
#define OP_SUB_A_D             0x29
#define OP_SUB_B_A             0x2a
#define OP_SUB_B_B             0x2b
#define OP_SUB_B_C             0x2c
#define OP_SUB_B_D             0x2d
#define OP_SUB_C_A             0x2e
#define OP_SUB_C_B             0x2f
#define OP_SUB_C_C             0x30
#define OP_SUB_C_D             0x31
#define OP_SUB_D_A             0x32
#define OP_SUB_D_B             0x33
#define OP_SUB_D_C             0x34
#define OP_SUB_D_D             0x35
#define OP_SBB_A_B             0x36
#define OP_SBB_A_C             0x37
#define OP_SBB_A_D             0x38
#define OP_SBB_B_A             0x39
#define OP_SBB_B_C             0x3a
#define OP_SBB_B_D             0x3b
#define OP_SBB_C_A             0x3c
#define OP_SBB_C_B             0x3d
#define OP_SBB_C_D             0x3e
#define OP_SBB_D_A             0x3f
#define OP_SBB_D_B             0x40
#define OP_SBB_D_C             0x41
#define OP_INC_A               0x42
#define OP_INC_B               0x43
#define OP_INC_C               0x44
#define OP_INC_D               0x45
#define OP_DEC_A               0x46
#define OP_DEC_B               0x47
#define OP_DEC_C               0x48
#define OP_DEC_D               0x49
#define OP_CMP_A_B             0x4a
#define OP_CMP_A_C             0x4b
#define OP_CMP_A_D             0x4c
#define OP_CMP_B_A             0x4d
#define OP_CMP_B_C             0x4e
#define OP_CMP_B_D             0x4f
#define OP_CMP_C_A             0x50
#define OP_CMP_C_B             0x51
#define OP_CMP_C_D             0x52
#define OP_CMP_D_A             0x53
#define OP_CMP_D_B             0x54
#define OP_CMP_D_C             0x55
#define OP_MOV_A_B             0x56
#define OP_MOV_A_C             0x57
#define OP_MOV_A_D             0x58
#define OP_MOV_B_A             0x59
#define OP_MOV_B_C             0x5a
#define OP_MOV_B_D             0x5b
#define OP_MOV_C_A             0x5c
#define OP_MOV_C_B             0x5d
#define OP_MOV_C_D             0x5e
#define OP_MOV_D_A             0x5f
#define OP_MOV_D_B             0x60
#define OP_MOV_D_C             0x61
#define OP_OUT_A               0x62
#define OP_OUT_B               0x63
#define OP_OUT_C               0x64
#define OP_OUT_D               0x65
#define OP_ST_ADDR_A           0x66
#define OP_ST_ADDR_B           0x67
#define OP_ST_ADDR_C           0x68
#define OP_ST_ADDR_D           0x69
#define OP_STABS_A_A           0x6a
#define OP_STABS_A_B           0x6b
#define OP_STABS_A_C           0x6c
#define OP_STABS_A_D           0x6d
#define OP_STABS_B_A           0x6e
#define OP_STABS_B_B           0x6f
#define OP_STABS_B_C           0x70
#define OP_STABS_B_D           0x71
#define OP_STABS_C_A           0x72
#define OP_STABS_C_B           0x73
#define OP_STABS_C_C           0x74
#define OP_STABS_C_D           0x75
#define OP_STABS_D_A           0x76
#define OP_STABS_D_B           0x77
#define OP_STABS_D_C           0x78
#define OP_STABS_D_D           0x79
#define OP_LD_A_ADDR           0x7a
#define OP_LD_B_ADDR           0x7b
#define OP_LD_C_ADDR           0x7c
#define OP_LD_D_ADDR           0x7d
#define OP_LDABS_A_A           0x7e
#define OP_LDABS_A_B           0x7f
#define OP_LDABS_A_C           0x80
#define OP_LDABS_A_D           0x81
#define OP_LDABS_B_A           0x82
#define OP_LDABS_B_B           0x83
#define OP_LDABS_B_C           0x84
#define OP_LDABS_B_D           0x85
#define OP_LDABS_C_A           0x86
#define OP_LDABS_C_B           0x87
#define OP_LDABS_C_C           0x88
#define OP_LDABS_C_D           0x89
#define OP_LDABS_D_A           0x8a
#define OP_LDABS_D_B           0x8b
#define OP_LDABS_D_C           0x8c
#define OP_LDABS_D_D           0x8d
#define OP_TSTABS_A            0x8e
#define OP_TSTABS_B            0x8f
#define OP_TSTABS_C            0x90
#define OP_TSTABS_D            0x91
#define OP_JMP_ADDR            0x92
#define OP_BEQ_ADDR            0x93
#define OP_BNE_ADDR            0x94
#define OP_BCS_ADDR            0x95
#define OP_BCC_ADDR            0x96
#define OP_OUT_F               0x97
#define OP_HLT                 0x98
#define NUM_OPS                0x99

/* Fetch */
#define NUM_FETCH_STEPS        2

/* Device setup */
#define CTRL_DEFAULT                    0b000111000011111111001111

#define MUX_OUT_MASK                    0b000000000000000000001111
#define MPIN_A_OUT_BITS                 0b000000000000000000000000
#define MPIN_B_OUT_BITS                 0b000000000000000000000001
#define MPIN_C_OUT_BITS                 0b000000000000000000001000
#define MPIN_D_OUT_BITS                 0b000000000000000000001001
#define MPIN_ADDSUB_OUT_BITS            0b000000000000000000000010
#define MPIN_F_BUS_OUT_BITS             0b000000000000000000000100
#define MPIN_RAM_OUT_BITS               0b000000000000000000000011
#define MPIN_PC_OUT_BITS                0b000000000000000000000101

#define MUX_LOAD_MASK                   0b000000000000111100000000
#define MPIN_A_LOAD_BITS                0b000000000000000000000000
#define MPIN_B_LOAD_BITS                0b000000000000000100000000
#define MPIN_C_LOAD_BITS                0b000000000000100000000000
#define MPIN_D_LOAD_BITS                0b000000000000100100000000
#define MPIN_F_BUS_LOAD_BITS            0b000000000000011100000000
#define MPIN_MAR_LOAD_BITS              0b000000000000001000000000
#define MPIN_RAM_WRITE_BITS             0b000000000000001100000000
#define MPIN_IR_LOAD_BITS               0b000000000000010000000000
#define MPIN_PC_LOAD_BITS               0b000000000000010100000000
#define MPIN_OUT_LOAD_BITS              0b000000000000011000000000

#define MUX_ALUARGA_MASK                0b000000110000000000000000
#define MPIN_A_ALU_A_BITS               0b000000000000000000000000
#define MPIN_B_ALU_A_BITS               0b000000010000000000000000
#define MPIN_C_ALU_A_BITS               0b000000100000000000000000
#define MPIN_D_ALU_A_BITS               0b000000110000000000000000

#define MUX_ALUARGB_MASK                0b000111000000000000000000
#define MPIN_A_ALU_B_BITS               0b000000000000000000000000
#define MPIN_B_ALU_B_BITS               0b000001000000000000000000
#define MPIN_C_ALU_B_BITS               0b000010000000000000000000
#define MPIN_D_ALU_B_BITS               0b000011000000000000000000

#define HPIN_ADDSUB_ALT_BIT             0b000000000000000000010000
#define LPIN_F_CALC_BIT                 0b000000000000000001000000
#define HPIN_F_CARRY_BIT                0b000000000100000000000000
#define LPIN_CLOCK_HALT_BIT             0b000000000010000000000000
#define LPIN_STEPS_RESET_BIT            0b000000000000000010000000
#define LPIN_IRFETCH_LOAD_BIT           0b000000000001000000000000
#define HPIN_PC_COUNT_BIT               0b000000000000000000100000

#endif /* OP_DEFS_H */
