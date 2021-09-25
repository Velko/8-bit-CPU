#ifndef ARDUINO_STRING_H
#define ARDUINO_STRING_H

#include <string>

class String
{
    private:
        std::string str;
    public:
        String(std::string &&src);
        const char *c_str() const { return str.c_str(); }
        bool startsWith(const char *s) const;
        bool equals(const char *s) const;
        String substring(size_t from) const;
        void trim();
};


#endif /* ARDUINO_STRING_H */
