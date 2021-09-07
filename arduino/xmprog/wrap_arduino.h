#ifndef WRAP_ARDUINO_H
#define WRAP_ARDUINO_H

#ifdef __AVR__
#include <Arduino.h>
#else
#include "arduino_string.h"
#include "serial_host.h"

void setup();
void loop();

#endif

#endif /* WRAP_ARDUINO_H */