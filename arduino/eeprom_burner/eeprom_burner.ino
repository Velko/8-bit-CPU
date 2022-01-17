
/*
  Utility to burn various types of EEPROMs
 */

#include "eeprom_hw.h"
#include "eeprom_ops.h"

extern const unsigned char sieve_bin[] PROGMEM;
extern unsigned int sieve_bin_len;

void display_help();
void burn7seg_digits();
void verify7seg_digits();

void burn_progmem_blob(const unsigned char blob[], unsigned int len);
void verify_progmem_blob(const unsigned char blob[], unsigned int len);
void write_microcode(int rom_idx);
void verify_microcode(int rom_idx);

void eeprom_read_contents(enum eeprom_chip chip);

FILE uart_str;

static int uart_putchar(char c, FILE *stream)
{
    Serial.write(c);
    return 0;
}

void setup()
{
    Serial.begin(115200);
    Serial.println(F("EEPROM burner utility"));
    fdev_setup_stream(&uart_str, uart_putchar, NULL, _FDEV_SETUP_WRITE);
    stdout = &uart_str;
    eeprom_setup();
}

void loop()
{
    String command = Serial.readStringUntil('\n');

    command.trim();

    if (command.length() == 0) return;

    if (command.equals("digits"))
    {
        burn7seg_digits();
    }
    else if (command.equals("verify-digits"))
    {
        verify7seg_digits();
    }
    else if (command.equals("sieve"))
    {
        burn_progmem_blob(sieve_bin, sieve_bin_len);
    }
    else if (command.equals("verify-sieve"))
    {
        verify_progmem_blob(sieve_bin, sieve_bin_len);
    }
    else if (command.equals("control0"))
    {
        write_microcode(0);
    }
    else if (command.equals("verify-control0"))
    {
        verify_microcode(0);
    }
    else if (command.equals("control1"))
    {
        write_microcode(1);
    }
    else if (command.equals("verify-control1"))
    {
        verify_microcode(1);
    }
    else if (command.equals("read"))
    {
        eeprom_read_contents(AT28C64P);
    }
    else if (command.equals("read1"))
    {
        eeprom_read_contents(AT28C64J);
    }
    else if (command.equals("erase"))
    {
        eeprom_erase_all(AT28C64P);
    }
    else if (command.equals("erase1"))
    {
        eeprom_erase_all(AT28C64J);
    }
    else if (command.equals("help"))
    {
        display_help();
    }
    else
    {
        Serial.println(F("Unknown command!"));
        Serial.println(F("help - list available commands"));
    }
}

void eeprom_read_contents(enum eeprom_chip chip)
{
    FILE *fstream = eeprom_open(chip);

    unsigned char buff[16];
    uint16_t addr = 0;

    for (;;)
    {
        fread(buff, sizeof(buff), 1, fstream);

        if (feof(fstream)) break;

        /* Print address, each 16-th byte */
        printf_P(PSTR("%04X  "), addr);
        addr += sizeof(buff);

        uint8_t i;

        /* first 8 bytes */
        for (i = 0; i < 8; ++i)
        {
            /* Output the byte */
            printf_P(PSTR("%02X "), buff[i]);
        }

        /* Add extra space after first 8 bytes */
        printf_P(PSTR(" "));

        /* last 8 bytes */
        for (; i < sizeof(buff); ++i)
        {
            printf_P(PSTR("%02X "), buff[i]);
        }

        /* Newline after 16 bytes */
        printf_P(PSTR("\r\n"));
    }
}
