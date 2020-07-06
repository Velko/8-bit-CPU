/*
    Encode each segment as a bit.

    Please ensure that each bit is mapped to EEPROMs data line connected to the segment.
    The exact wiring sequence is not important, as long as it is accurately described here.
 */
#define SEG_BIT_A       (1 << 5)
#define SEG_BIT_B       (1 << 4)
#define SEG_BIT_C       (1 << 2)
#define SEG_BIT_D       (1 << 1)
#define SEG_BIT_E       (1 << 0)
#define SEG_BIT_F       (1 << 6)
#define SEG_BIT_G       (1 << 7)
#define SEG_BIT_DOT     (1 << 3)

/* Segments:

       +-- a --+
       |       |
       f       b
       |       |
       +-- g --+
       |       |
       e       c
       |       |
       +-- d --+
 */

#define DIGIT_BLANK 0
#define DIGIT_0     (SEG_BIT_A | SEG_BIT_B | SEG_BIT_C | SEG_BIT_D | SEG_BIT_E | SEG_BIT_F)
#define DIGIT_1     (SEG_BIT_B | SEG_BIT_C)
#define DIGIT_2     (SEG_BIT_A | SEG_BIT_B | SEG_BIT_D | SEG_BIT_E | SEG_BIT_G)
#define DIGIT_3     (SEG_BIT_A | SEG_BIT_B | SEG_BIT_C | SEG_BIT_D | SEG_BIT_G)
#define DIGIT_4     (SEG_BIT_B | SEG_BIT_C | SEG_BIT_F | SEG_BIT_G)
#define DIGIT_5     (SEG_BIT_A | SEG_BIT_C | SEG_BIT_D | SEG_BIT_F | SEG_BIT_G)
#define DIGIT_6     (SEG_BIT_A | SEG_BIT_C | SEG_BIT_D | SEG_BIT_E | SEG_BIT_F | SEG_BIT_G)
#define DIGIT_7     (SEG_BIT_A | SEG_BIT_B | SEG_BIT_C)
#define DIGIT_8     (SEG_BIT_A | SEG_BIT_B | SEG_BIT_C | SEG_BIT_D | SEG_BIT_E | SEG_BIT_F | SEG_BIT_G)
#define DIGIT_9     (SEG_BIT_A | SEG_BIT_B | SEG_BIT_C | SEG_BIT_D | SEG_BIT_F | SEG_BIT_G)
#define DIGIT_A     (SEG_BIT_A | SEG_BIT_B | SEG_BIT_C | SEG_BIT_E | SEG_BIT_F | SEG_BIT_G)
#define DIGIT_B     (SEG_BIT_C | SEG_BIT_D | SEG_BIT_E | SEG_BIT_F | SEG_BIT_G)
#define DIGIT_C     (SEG_BIT_A | SEG_BIT_D | SEG_BIT_E | SEG_BIT_F)
#define DIGIT_D     (SEG_BIT_B | SEG_BIT_C | SEG_BIT_D | SEG_BIT_E | SEG_BIT_G)
#define DIGIT_E     (SEG_BIT_A | SEG_BIT_D | SEG_BIT_E | SEG_BIT_F | SEG_BIT_G)
#define DIGIT_F     (SEG_BIT_A | SEG_BIT_E | SEG_BIT_F | SEG_BIT_G)
#define DIGIT_MINUS (SEG_BIT_G)

#define CHAR_h      (SEG_BIT_C | SEG_BIT_E | SEG_BIT_F | SEG_BIT_G)
#define CHAR_o      (SEG_BIT_C | SEG_BIT_D | SEG_BIT_E | SEG_BIT_G)

/* The layout of the EEPROM is as if it was an array similar to:

    uint8_t digitMap[NUM_MODES][256][NUM_DISPLAYS];

    If there are 4 modes and 4 displays, it

    4 x modes (unsigned, signed, hex and oct) = 4K total
        256 x display states for each value in the byte  = 1K in total
            4 x output bytes for each display

    An example for signed value of -42:
    digitMap[1][0xd6] = { DIGIT_2, DIGIT_4, DIGIT_MINUS, DIGIT_BLANK }

*/

uint8_t encode_digit(char c)
{
    /* Unelegant, but will do */
    switch (c) {
        case '0': return DIGIT_0;
        case '1': return DIGIT_1;
        case '2': return DIGIT_2;
        case '3': return DIGIT_3;
        case '4': return DIGIT_4;
        case '5': return DIGIT_5;
        case '6': return DIGIT_6;
        case '7': return DIGIT_7;
        case '8': return DIGIT_8;
        case '9': return DIGIT_9;
        case 'A': return DIGIT_A;
        case 'B': return DIGIT_B;
        case 'C': return DIGIT_C;
        case 'D': return DIGIT_D;
        case 'E': return DIGIT_E;
        case 'F': return DIGIT_F;
        case '-': return DIGIT_MINUS;
        case 'h': return CHAR_h;
        case 'o': return CHAR_o;
        default:  return DIGIT_BLANK;
    }
}


uint16_t output_address;

void write_digit(int value, const char *format)
{
    char output[5]; // 4 digits + \n
    sprintf_P(output, format, value);

    for (int i = 3; i > -1; --i) // 4 digits backwards
    {
        eeprom_write(output_address, encode_digit(output[i]));
        ++output_address;
    }
}


void burn7seg_digits()
{
    Serial.println(F("Burning the digits!"));

    output_address = 0;

    /* Decimal unsigned */
    for (int i = 0; i < 256; ++i)
        write_digit(i, PSTR("%4d"));


    /* Decimal signed - positive part */
    for (int i = 0; i < 128; ++i)
        write_digit(i, PSTR("%4d"));

    /* Decimal signed - negative part */
    for (int i = -128; i < 0; ++i)
        write_digit(i, PSTR("%4d"));


    /* Hex */
    for (int i = 0; i < 256; ++i)
        write_digit(i, PSTR("h %02X"));


    /* Oct */
    for (int i = 0; i < 256; ++i)
        write_digit(i, PSTR("o%3o"));
}
