#define EEPROM_SIZE   ( 8 * 1024)   // AT28C64

void eeprom_write(uint16_t addr, uint8_t value)
{
    uint8_t old_value = eeprom_read(addr);

    /* Only if new value differs */
    if (old_value != value)
    {
        eeprom_peform_write(addr, value);

        for (int retry = 0; retry < 5 ; ++retry)
        {
            delay(2);
            uint8_t readback = eeprom_read(addr);

            if (readback == value)
            {
                /* Success. */
                Serial.print('+');
                goto format_line;
            }
        }
        /* Failed */
        Serial.print('!');
        goto format_line;
    }
    /* Same value */
    Serial.print('.');

format_line:
    /* Add newline after writes */
    if ((addr & 0x0F) == 0)
        Serial.println();
}

void eeprom_erase_all()
{
    for (uint16_t addr = 0; addr < EEPROM_SIZE; ++addr)
    {
        eeprom_write(addr, 0xFF);
    }
}

void eeprom_read_contents()
{
    char buff[8];

    for (uint16_t addr = 0; addr < EEPROM_SIZE; ++addr)
    {
        uint8_t value = eeprom_read(addr);

        /* Print address when starting with each 16-th byte */
        if ((addr & 0x0F) == 0)
        {
            sprintf_P(buff, PSTR("%04X  "), addr);
            Serial.print(buff);
        }

        /* Output the byte */
        sprintf_P(buff, PSTR("%02X "), value);
        Serial.print(buff);

        /* Newline after 16 bytes */
        if ((addr & 0x0F) == 0x0F)
        {
            Serial.println();
            continue;
        }

        /* Add extra space after first 8 bytes */
        if ((addr & 0x07) == 0x07)
            Serial.print(F(" "));
    }
}


void test_send_inc()
{
    Serial.println(F("Sending addresses (write):"));
    for (int addr = 0; addr < 16; ++addr)
    {
        Serial.println(addr);
        eeprom_set_address(addr, true);
        delay(500);
    }

    Serial.println(F("Sending addresses (read):"));
    for (int addr = 0; addr < 16; ++addr)
    {
        Serial.println(addr);
        eeprom_set_address(addr, false);
        delay(500);
    }

    Serial.println(F("Done"));
    eeprom_set_address(0, false);
}
