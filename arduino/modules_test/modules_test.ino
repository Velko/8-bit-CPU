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

    uint8_t val = 0;

    switch (cmd)
    {
    case 'I':
          Serial.println(F("MTEST"));
          break;
    case 'd':
        display_loop();
        break;
    case 'D':
        val = Serial.parseInt();
        display_output(val);
        break;
    case 'm':
        val = Serial.parseInt();
        display_set_mode(val);
        break;
    case 'r':
        register_loop();
        break;
    case 'R':
        val = Serial.parseInt();
        register_setup();
        register_write(val);
        break;
    case 'c':
        counter_loop();
        break;
    default:
        Serial.println(F("Unknown command!"));
        break;
    }
}
