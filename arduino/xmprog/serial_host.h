#ifndef SERIAL_HOST_H
#define SERIAL_HOST_H

#include <stdint.h>
#include <stddef.h>

#include "arduino_string.h"

class SerialHost
{
    private:
        int fd;
    public:
        void begin(unsigned long baud);
        size_t write(uint8_t byte);
        size_t write(const uint8_t *buffer, size_t size);
        size_t readBytes(uint8_t *buffer, size_t length);
        String readStringUntil(char terminator);
        void print(const char *str);
        void println(const char *str);
        void println(const String &str);
        void setTimeout(size_t delay);
        bool operator!() const;

        int read();
};

typedef SerialHost HardwareSerial;

extern SerialHost Serial;


#endif /* SERIAL_HOST_H */