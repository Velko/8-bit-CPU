const int DATA_PINS[] = {9, 8, 7, 6, 5, 4, 2, 3};
const int MODE_PINS[] = {12, 13};

void display_setup_pins()
{
    for (int i = 0; i < 8; ++i)
    {
        digitalWrite(DATA_PINS[i], LOW);
        pinMode(DATA_PINS[i], OUTPUT);
    }

    for (int i = 0; i < 2; ++i)
    {
        digitalWrite(MODE_PINS[i], LOW);
        pinMode(MODE_PINS[i], OUTPUT);
    }
}

void display_set_mode(int mode)
{
    digitalWrite(MODE_PINS[0], mode & 1 ? HIGH : LOW);
    digitalWrite(MODE_PINS[1], mode & 2 ? HIGH : LOW);
}

void display_output_byte(uint8_t b)
{
    for (int i = 0; i < 8; ++i)
    {
        digitalWrite(DATA_PINS[i], b & 1 ? HIGH : LOW);
        b >>= 1;
    }
}


void display_test()
{
    display_setup_pins();

    for (;;)
    {
      for (int m = 0 ; m < 4 ; ++m)
      {
          display_set_mode(m);
          for (int i = 0 ; i < 256; ++i)
          {
              display_output_byte(i);
              delay(200);
          }
      }
    }
}
