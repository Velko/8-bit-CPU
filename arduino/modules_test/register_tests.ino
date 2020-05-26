const int REG_DATA_PINS[] = {9, 8, 7, 6, 5, 4, 3, 2};


#define REG_CLK     11
#define REG_LOAD    13
#define REG_OUT     12

void pulse_clock()
{
    digitalWrite(REG_CLK, HIGH);
    delay(100);
    digitalWrite(REG_CLK, LOW);
}

void reg_data_out(uint8_t b)
{
    for (int i = 0; i < 8 ; ++i)
    {
        pinMode(REG_DATA_PINS[i], OUTPUT);
        digitalWrite(REG_DATA_PINS[i], b & 1 ? HIGH : LOW);

        b >>= 1;
    }
}

void reg_prepare_in()
{
    for (int i = 0; i < 8 ; ++i)
    {
        pinMode(REG_DATA_PINS[i], INPUT);
        digitalWrite(REG_DATA_PINS[i], HIGH);
    }
}

uint8_t reg_data_in()
{
    uint8_t res = 0;
    for (int i = 7; i >= 0 ; --i)
    {
        res <<= 1;
        res |= digitalRead(REG_DATA_PINS[i]) == HIGH ? 1 : 0;
    }

    return res;
}

void register_test()
{
    digitalWrite(REG_CLK, LOW);
    pinMode(REG_CLK, OUTPUT);

    digitalWrite(REG_LOAD, HIGH);
    pinMode(REG_LOAD, OUTPUT);

    digitalWrite(REG_OUT, HIGH);
    pinMode(REG_OUT, OUTPUT);

    for (;;)
    {
        for (int i = 1; i < 256; i <<= 1)
        {
            Serial.print(i);
            Serial.print(" ");
            reg_data_out(i);
            digitalWrite(REG_LOAD, LOW);
            pulse_clock();
            digitalWrite(REG_LOAD, HIGH);
            delay(250);

            reg_prepare_in();
            digitalWrite(REG_OUT, LOW);
            delay(250);
            uint8_t readback = reg_data_in();
            digitalWrite(REG_OUT, HIGH);
            Serial.print(readback);
            if (readback == i)
              Serial.println("   OK");
            else
              Serial.println("   ERR");
        }
    }

}
