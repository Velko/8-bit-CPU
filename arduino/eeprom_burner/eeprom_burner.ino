
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

void setup()
{
    Serial.begin(9600);
    Serial.println(F("EEPROM burner utility"));
    eeprom_setup();
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
