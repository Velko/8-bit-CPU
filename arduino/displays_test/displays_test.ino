/*
  Test 7-segment displays that are connected directly to Arduino
 */

/* Segments of displays are connected to these pins */
#define SEG_PIN_A   8
#define SEG_PIN_B   9
#define SEG_PIN_C   11
#define SEG_PIN_D   12
#define SEG_PIN_E   10
#define SEG_PIN_F   7
#define SEG_PIN_G   6
#define SEG_PIN_DOT 13

/* Total number of segments */
#define NUM_SEG_PINS    8


/* Common cathodes are connected to these pins */
#define DISPLAY_1      5
#define DISPLAY_10     4
#define DISPLAY_100    3
#define DISPLAY_1000   2

/* Total number of displays */
#define NUM_DISPLAYS   4

/* Encode each segment as a bit */
#define SEG_BIT_A       (1 << 0)
#define SEG_BIT_B       (1 << 1)
#define SEG_BIT_C       (1 << 2)
#define SEG_BIT_D       (1 << 3)
#define SEG_BIT_E       (1 << 4)
#define SEG_BIT_F       (1 << 5)
#define SEG_BIT_G       (1 << 6)
#define SEG_BIT_DOT     (1 << 7)

/* Array of segment and display pins, so that they can be
   switched in loops
*/
const int segment_pins[] = { SEG_PIN_A, SEG_PIN_B, SEG_PIN_C, SEG_PIN_D, SEG_PIN_E, SEG_PIN_F, SEG_PIN_G, SEG_PIN_DOT };
const int displays[] = { DISPLAY_1, DISPLAY_10, DISPLAY_100, DISPLAY_1000 };

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
#define DIGIT_MINUS (SEG_G)

const int digit_segments[] = {
    DIGIT_0, DIGIT_1, DIGIT_2, DIGIT_3,
    DIGIT_4, DIGIT_5, DIGIT_6, DIGIT_7,
    DIGIT_8, DIGIT_9, DIGIT_A, DIGIT_B,
    DIGIT_C, DIGIT_D, DIGIT_E, DIGIT_F,
};


void clear_digit()
{
    for (int i = 0; i < NUM_SEG_PINS; ++i)
        digitalWrite(segment_pins[i], LOW);
}

void setup_digit(int digit)
{
    for (int i = 0; i < NUM_SEG_PINS; ++i)
    {
        if (digit_segments[digit] & (1 << i))
            digitalWrite(segment_pins[i], HIGH);
        else
            digitalWrite(segment_pins[i], LOW);
    }
}

void clear_displays()
{
    for (int i = 0; i < NUM_DISPLAYS; ++i)
        digitalWrite(displays[i], HIGH);
}

void enable_display(int dsp)
{
    digitalWrite(displays[dsp], LOW);
}

unsigned int counter;

void setup()
{
    for (int i = 0; i < NUM_SEG_PINS; ++i)
    {
        digitalWrite(segment_pins[i], LOW);
        pinMode(segment_pins[i], OUTPUT);
    }

    for (int i = 0; i < NUM_DISPLAYS; ++i)
    {
        digitalWrite(displays[i], HIGH);
        pinMode(displays[i], OUTPUT);
    }

    counter = 0;
}

void cycle_displays()
{
    clear_displays();
    clear_digit();

    digitalWrite(SEG_PIN_DOT, HIGH);
    for( int i = 0; i < NUM_DISPLAYS; ++i)
    {

        digitalWrite(displays[i], LOW);
        delay(500);
        digitalWrite(displays[i], HIGH);
    }
}

void cycle_digits()
{
    clear_displays();
    digitalWrite(DISPLAY_1, LOW);
    for (int i = 0; i < 16; ++i) {
        setup_digit(i);
        delay(500);
    }
}

void count_dec_unsigned()
{
    for (int count = 0; count < 256; ++count)
    {
        for (int repeat = 0; repeat < 16; ++repeat)
        {
            int value = count;
            for (int d = 0; d < NUM_DISPLAYS; ++d, value /= 10)
            {
                clear_displays();
                setup_digit( value % 10);
                enable_display(d);
                delay(3);
            }
        }
    }
}

void loop()
{
    cycle_displays();
    cycle_digits();
    count_dec_unsigned();
}
