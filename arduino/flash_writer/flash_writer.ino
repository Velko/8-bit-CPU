
/*
  Utility to burn various types of EEPROMs
 */

#include "flash_hw.h"
#include "flash_ops.h"

void display_help();

void setup()
{
    Serial.begin(115200);
    Serial.println(F("Flash writer utility"));
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
