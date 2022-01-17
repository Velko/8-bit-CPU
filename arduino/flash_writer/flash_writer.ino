
/*
  Utility to burn various types of EEPROMs
 */

#include "flash_hw.h"
#include "flash_ops.h"

void display_help();

FILE uart_str;

static int uart_putchar(char c, FILE *stream)
{
    Serial.write(c);
    return 0;
}

void setup()
{
    Serial.begin(115200);
    Serial.println(F("Flash writer utility"));
    fdev_setup_stream(&uart_str, uart_putchar, NULL, _FDEV_SETUP_WRITE);
    stdout = &uart_str;
    flash_setup();
}

void flash_dump_contents()
{
    FILE *fstream = flash_open();

    unsigned char buff[16];
    uint32_t addr = 0;

    for (;;)
    {
        fread(buff, sizeof(buff), 1, fstream);

        if (feof(fstream)) break;

        /* Print address, each 16-th byte */
        printf_P(PSTR("%05lX  "), addr);
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

void flash_write_test()
{
    printf_P(PSTR("Filling\r\n"));

    char msg[] = "Hello, World!\r\n";

    FILE *fstream = flash_open();

    for (;;)
    {
        size_t n = fwrite(msg, sizeof(msg), 1, fstream);
        if (n != 1) break;
    }

    printf_P(PSTR("Done\r\n"));
}


void loop()
{
    String command = Serial.readStringUntil('\n');

    command.trim();

    if (command.length() == 0) return;

    if (command.equals("help"))
    {
        display_help();
    }
    else if (command.equals("identify"))
    {
        uint16_t m_dev = flash_identify();
        printf_P(PSTR("%04X\r\n"), m_dev);
    }
    else if (command.equals("read"))
    {
        flash_dump_contents();
    }
    else if (command.equals("erase"))
    {
        flash_erase_all();
    }
    else if (command.equals("hello"))
    {
        flash_write_test();
    }
    else
    {
        Serial.println(F("Unknown command!"));
        Serial.println(F("help - list available commands"));
    }
}
