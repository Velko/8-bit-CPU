#include <shiftoutext.h>
#include "device_interface.h"
#include "microcode.h"
#include "op-defs.h"

DeviceInterface dev;

void setup()
{
    Serial.begin(115200);
    dev.setup();
    dev.control.write16(CTRL_DEFAULT);
}


void run_program();

void loop()
{
    int cmd = Serial.read();

    if (cmd < 0) return;

    switch (cmd)
    {
    case 'I':
        Serial.println(F("RunControl"));
        break;
    case 'R':
        run_program();
        break;
    default:
        Serial.println(F("Unknown command!"));
        break;
    }
}
