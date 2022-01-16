
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
        flash_identify();
    }
    else if (command.equals("read"))
    {
        flash_read_contents();
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
