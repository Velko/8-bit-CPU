#ifndef OP_DEFS_H
#define OP_DEFS_H

/* Opcodes */
#define OP_NOP                 0x00
#define OP_LDI_A_IMM           0x01
#define OP_LDI_B_IMM           0x02
#define OP_LDI_F_IMM           0x03
#define OP_ADD_A_A             0x04
#define OP_ADD_A_B             0x05
#define OP_ADD_B_A             0x06
#define OP_ADD_B_B             0x07
#define OP_ADC_A_A             0x08
#define OP_ADC_A_B             0x09
#define OP_ADC_B_A             0x0a
#define OP_ADC_B_B             0x0b
#define OP_SUB_A_B             0x0c
#define OP_SUB_B_A             0x0d
#define OP_SBB_A_B             0x0e
#define OP_SBB_B_A             0x0f
#define OP_CMP_A_B             0x10
#define OP_CMP_B_A             0x11
#define OP_MOV_A_B             0x12
#define OP_MOV_B_A             0x13
#define OP_OUT_A               0x14
#define OP_OUT_B               0x15
#define OP_ST_ADDR_A           0x16
#define OP_ST_ADDR_B           0x17
#define OP_STABS_A_A           0x18
#define OP_STABS_A_B           0x19
#define OP_STABS_B_A           0x1a
#define OP_STABS_B_B           0x1b
#define OP_LD_A_ADDR           0x1c
#define OP_LD_B_ADDR           0x1d
#define OP_LDABS_A_A           0x1e
#define OP_LDABS_A_B           0x1f
#define OP_LDABS_B_A           0x20
#define OP_LDABS_B_B           0x21
#define OP_TSTABS_A            0x22
#define OP_TSTABS_B            0x23
#define OP_JMP_ADDR            0x24
#define OP_BEQ_ADDR            0x25
#define OP_BNE_ADDR            0x26
#define OP_BCS_ADDR            0x27
#define OP_BCC_ADDR            0x28
#define OP_OUT_F               0x29
#define OP_HLT                 0x2a
#define NUM_OPS                0x2b

/* Fetch */
#define NUM_FETCH_STEPS        2

/* Device setup */
#define CTRL_DEFAULT                    0b0011111111001111

#define MUX_OUT_MASK                    0b0000000000001111
#define MPIN_A_OUT_BITS                 0b0000000000000000
#define MPIN_B_OUT_BITS                 0b0000000000000001
#define MPIN_ADDSUB_OUT_BITS            0b0000000000000010
#define MPIN_F_BUS_OUT_BITS             0b0000000000000100
#define MPIN_RAM_OUT_BITS               0b0000000000000011
#define MPIN_PC_OUT_BITS                0b0000000000000101

#define MUX_LOAD_MASK                   0b0000111100000000
#define MPIN_A_LOAD_BITS                0b0000000000000000
#define MPIN_B_LOAD_BITS                0b0000000100000000
#define MPIN_F_BUS_LOAD_BITS            0b0000011100000000
#define MPIN_MAR_LOAD_BITS              0b0000001000000000
#define MPIN_RAM_WRITE_BITS             0b0000001100000000
#define MPIN_IR_LOAD_BITS               0b0000010000000000
#define MPIN_PC_LOAD_BITS               0b0000010100000000
#define MPIN_OUT_LOAD_BITS              0b0000011000000000

#define HPIN_ADDSUB_SUB_BIT             0b0000000000010000
#define LPIN_F_CALC_BIT                 0b0000000001000000
#define HPIN_F_CARRY_BIT                0b0100000000000000
#define LPIN_CLOCK_HALT_BIT             0b0010000000000000
#define LPIN_STEPS_RESET_BIT            0b0000000010000000
#define LPIN_IRFETCH_LOAD_BIT           0b0001000000000000
#define HPIN_PC_COUNT_BIT               0b0000000000100000

#endif /* OP_DEFS_H */
