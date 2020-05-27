/*
  Utility to test functionality of various modules
 */


void setup()
{
    Serial.begin(9600);
}

void loop()
{
    int cmd = Serial.read();

    if (cmd < 0) return;

    switch (cmd)
    {
    case 'I':
          Serial.println(F("MTEST"));
          break;
    case 'd':
        display_test();
        break;
    case 'r':
        register_test();
        break;
    default:
        Serial.println(F("Unknown command!"));
        break;
    }
}
