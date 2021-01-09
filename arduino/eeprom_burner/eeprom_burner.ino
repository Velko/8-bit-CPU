
/*
  Utility to burn various types of EEPROMs
 */

#include "eeprom_hw.h"
#include "eeprom_ops.h"


void display_help();
void burn7seg_digits();
void verify7seg_digits();

void setup()
{
    eeprom_setup();
    Serial.begin(9600);
    Serial.println(F("EEPROM burner utility"));
}

void loop()
{
    String command = Serial.readStringUntil('\n');

    if (command.length() == 0) return;

    if (command.equals("digits"))
    {
        burn7seg_digits();
    }
    else if (command.equals("verify-digits"))
    {
        verify7seg_digits();
    }
    else if (command.equals("read"))
    {
        eeprom_read_contents();
    }
    else if (command.equals("erase"))
    {
        eeprom_erase_all();
    }
    else if (command.equals("addr"))
    {
        test_send_inc();
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
