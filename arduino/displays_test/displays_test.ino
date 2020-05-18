/*
  Test 7-segment displays that are connected directly to Arduino
 */

/* Segments of displays are connected to these pins */
#define SEG_PIN_A   12
#define SEG_PIN_B   13
#define SEG_PIN_C   7
#define SEG_PIN_D   8
#define SEG_PIN_E   6
#define SEG_PIN_F   11
#define SEG_PIN_G   10
#define SEG_PIN_DOT 9

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
#define DIGIT_MINUS (SEG_BIT_G)

#define MODE_DECIMAL_UNSIGNED   0
#define MODE_DECIMAL_SIGNED     1
#define MODE_HEX                2
#define MODE_OCT                3

/* Map display values to digits. Actual digit map should be generated using generate_digitmap.py
   script. Run command in script's directory:

   ./generate_digitmap.py >> zz_digitmap.ino
 */
extern const uint8_t digitMap[4][256][NUM_DISPLAYS] PROGMEM;

void clear_digit()
{
    for (int i = 0; i < NUM_SEG_PINS; ++i)
        digitalWrite(segment_pins[i], LOW);
}

void setup_segments(int segments)
{
    for (int i = 0; i < NUM_SEG_PINS; ++i)
    {
        if (segments & (1 << i))
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
        uint8_t segments = pgm_read_byte(&digitMap[MODE_HEX][i][0]);
        setup_segments(segments);
        delay(500);
    }
}

void count_map(int mode)
{
    for (int count = 0; count < 256; ++count)
    {
        /* Cycling trough digits 25 times gives us nice quick, but visible
           counting: ~5 numbers/sec

           2 ms * 25 * 4 = 0.2 s
           1 num / 0.2 s = 5 num/s
         */
        for (int repeat = 0; repeat < 25; ++repeat)
        {
            for (int d = 0; d < NUM_DISPLAYS; ++d)
            {
                uint8_t segments = pgm_read_byte(&digitMap[mode][count][d]);

                /* Use decimal separator dot to indicate display mode */
                if (mode == d)
                    segments |= SEG_BIT_DOT;

                clear_displays();
                setup_segments(segments);
                enable_display(d);
                delay(2);
            }
        }
    }
}

void loop()
{
    cycle_displays();
    cycle_digits();
    count_map(MODE_DECIMAL_UNSIGNED);
    count_map(MODE_DECIMAL_SIGNED);
    count_map(MODE_HEX);
    count_map(MODE_OCT);
}
