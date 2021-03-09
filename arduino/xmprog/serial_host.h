#ifndef SERIAL_HOST_H
#define SERIAL_HOST_H

#include <stdint.h>
#include <stddef.h>

#include <string>

class String
{
    private:
        std::string str;
    public:
        String(std::string &&src);
        const char *c_str() const { return str.c_str(); }
        bool startsWith(const char *s) const;
};

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

        int read();
};

extern SerialHost Serial;


#endif /* SERIAL_HOST_H */