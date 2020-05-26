/*
  Utility to test functionality of various modules
 */


void setup()
{
    Serial.begin(9600);
    Serial.println(F("Testing utility"));
}

void loop()
{
    String command = Serial.readStringUntil('\n');

    if (command.length() == 0) return;

    if (command.equals("display"))
    {
        display_test();
    }
    if (command.equals("register"))
    {
        register_test();
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
